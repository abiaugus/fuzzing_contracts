// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Base64.sol';
import './Strings.sol';
import './JsmnSolLib.sol';
import './LitVerify.sol';
import './IERC721.sol';
import './IERC721Metadata.sol';

contract MirrorNFT is IERC721, IERC721Metadata {
  using Base64 for string;
  using StringUtils for *;
  using JsmnSolLib for string;

  string public override name = 'MirrorNFT - Ethereum';
  string public override symbol = 'ethNFT';

  mapping(uint256 => address) public originalAddress;
  mapping(uint256 => uint256) public originalTokenId;
  mapping(address => mapping(uint256 => uint256)) public lastCheck; // a timestamp always larger than last check when claim
  mapping(address => mapping(uint256 => uint256)) public mapId; // a timestamp always larger than last check when claim

  mapping(address => uint256) public override balanceOf;
  mapping(uint256 => address) public override ownerOf;
  mapping(uint256 => string) public override tokenURI;
  uint256 public totalSupply = 0;

  LitVerify litVerify;

  constructor(LitVerify lit_verify_addr) {
    litVerify = lit_verify_addr;
  }

  // this will verify a cross-chain function call and mint or transfer a token
  // to the claimer
  function claim(
    string memory headerJson,
    string memory payloadJson,
    bytes memory signature
  ) public {
    require(
      litVerify.verify(headerJson, payloadJson, signature),
      'Verify failed'
    );
    // now we can consider the input is honest

    (
      uint256 exitCode,
      JsmnSolLib.Token[] memory tokens,
      uint256 ntokens
    ) = payloadJson.parse(26);
    require(exitCode == 0, 'JSON parse failed');
    require(ntokens == 25, 'Input wrong');

    // check source chain is ethereum
    {
      string memory chain = payloadJson.getBytes(
        tokens[4].start,
        tokens[4].end
      ); // expected at token[4]
      require(chain.strCompare('ethereum') == 0, 'not eth mainnet');
    }

    // check not expired
    {
      string memory exp = payloadJson.getBytes(tokens[8].start, tokens[8].end); // expected at token[8]
      require(exp.parseInt() > int256(block.timestamp), 'expired');
    }
    uint256 iat;
    {
      string memory unparsedIat = payloadJson.getBytes(
        tokens[6].start,
        tokens[6].end
      ); // expected at token[6]
      iat = uint256(unparsedIat.parseInt());
    }

    address tokenAddress;
    {
      string memory addressA = payloadJson.getBytes(
        tokens[13].start,
        tokens[13].end
      );
      string memory addressB = payloadJson.getBytes(
        tokens[18].start,
        tokens[18].end
      );
      require(addressA.strCompare(addressB) == 0, 'Token address not match');
      bytes memory addrInB = fromHex(addressA);
      assembly {
        tokenAddress := mload(add(addrInB, 0x14))
      }
    }

    uint256 tokenId;
    {
      string memory tokenURICallData = payloadJson.getBytes(
        tokens[15].start,
        tokens[15].end
      );
      bytes4 fnSig;
      bytes memory tokenIdB = fromHex(tokenURICallData);
      assembly {
        fnSig := mload(add(tokenIdB, 0x20))
        tokenId := mload(add(tokenIdB, 0x24))
      }
      require(fnSig == '\xc8\x7b\x56\xdd', 'Not a tokenURI call');

      string memory ownerOfCallData = payloadJson.getBytes(
        tokens[20].start,
        tokens[20].end
      );
      tokenIdB = fromHex(ownerOfCallData);
      uint256 tokenId2;
      assembly {
        fnSig := mload(add(tokenIdB, 0x20))
        tokenId2 := mload(add(tokenIdB, 0x24))
      }
      require(fnSig == '\x63\x52\x21\x1e', 'Not a ownerOf call');
      require(tokenId == tokenId2, 'Token Id not Match');
    }

    bytes memory _tokenURI;
    {
      string memory tokenURICallRet = payloadJson.getBytes(
        tokens[23].start + 130,
        tokens[23].end
      );
      _tokenURI = fromHex(tokenURICallRet);
    }

    address _owner;
    {
      string memory ownerOfCallRet = payloadJson.getBytes(
        tokens[24].start,
        tokens[24].end
      );
      bytes memory ownerB = fromHex(ownerOfCallRet);
      assembly {
        _owner := mload(add(ownerB, 0x20))
      }
    }
    // require(_owner == msg.sender, 'Only can claim by owner');
    uint256 mNFTId = mapId[tokenAddress][tokenId];
    if (mNFTId != 0) {
      address from = ownerOf[mNFTId];
      balanceOf[from] -= 1;
      balanceOf[_owner] += 1;
      ownerOf[mNFTId] = _owner;
      emit Transfer(from, _owner, mNFTId);
    } else {
      totalSupply += 1;
      mNFTId = totalSupply;
      originalAddress[mNFTId] = tokenAddress;
      originalTokenId[mNFTId] = tokenId;
      mapId[tokenAddress][tokenId] = mNFTId;
      balanceOf[_owner] += 1;
      ownerOf[mNFTId] = _owner;
      emit Transfer(0x0000000000000000000000000000000000000000, _owner, mNFTId);
    }
    lastCheck[tokenAddress][tokenId] = iat;
    tokenURI[mNFTId] = string(_tokenURI);
  }

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public override {
    revert('Not support');
  }

  function getApproved(uint256 tokenId)
    external
    view
    override
    returns (address operator)
  {
    revert('Not support');
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public virtual override {
    revert('Not support');
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) public virtual override {
    revert('Not support');
  }

  function approve(address to, uint256 tokenId) public override {
    revert('Not support');
  }

  function setApprovalForAll(address operator, bool approved)
    public
    virtual
    override
  {
    revert('Not support');
  }

  function isApprovedForAll(address owner, address operator)
    external
    view
    override
    returns (bool)
  {
    revert('Not support');
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override
    returns (bool)
  {
    return
      interfaceId == type(IERC721).interfaceId ||
      interfaceId == type(IERC721Metadata).interfaceId;
  }

  function fromHexChar(uint8 c) internal pure returns (uint8) {
    if (bytes1(c) >= bytes1('0') && bytes1(c) <= bytes1('9')) {
      return c - uint8(bytes1('0'));
    }
    if (bytes1(c) >= bytes1('a') && bytes1(c) <= bytes1('f')) {
      return 10 + c - uint8(bytes1('a'));
    }
    if (bytes1(c) >= bytes1('A') && bytes1(c) <= bytes1('F')) {
      return 10 + c - uint8(bytes1('A'));
    }
  }

  // Convert an hexadecimal string to raw bytes
  function fromHex(string memory s) public view returns (bytes memory) {
    bytes memory ss = bytes(s);
    uint256 offset = 0;
    if (ss[0] == '0' && ss[1] == 'x') offset = 2;
    require(ss.length % 2 == 0); // length must be even
    bytes memory r = new bytes((ss.length - offset) / 2);
    for (uint256 i = 0; i < (ss.length - offset) / 2; ++i) {
      r[i] = bytes1(
        fromHexChar(uint8(ss[2 * i + offset])) *
          16 +
          fromHexChar(uint8(ss[2 * i + 1 + offset]))
      );
    }
    return r;
  }
}

