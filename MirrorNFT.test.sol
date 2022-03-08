pragma solidity ^0.8.0;

import './MirrorNFT.sol';

//incomplete

contract Test {
    
    LitVerify litVerify; //have to figure out.

    MirrorNFT M = new MirrorNFT(litVerify);

    bool flag = true;
    bool compare_flag = true;
    
    function fromHexTest (string memory s) public {
        bytes memory ss = bytes(s);
        uint256 offset = 0;
        if (ss[0] == '0' && ss[1] == 'x') offset = 2;
        require(ss.length % 2 == 0);
        bytes memory r = new bytes((ss.length - offset) / 2);
        r = M.fromHex(s);
        if(keccak256(abi.encodePacked(r)) == keccak256(abi.encodePacked(" "))){
            flag = false;
        }
    }
    function fromHexTest_2 (string memory s) public returns(bytes memory) {
        bytes memory ss = bytes(s);
        uint256 offset = 0;
        if (ss[0] == '0' && ss[1] == 'x') offset = 2;
        require(ss.length % 2 == 0);
        bytes memory r = new bytes((ss.length - offset) / 2);
        r = M.fromHex(s);
        return r;
    }
    function fromHexTest_3 (string memory s) public returns(bytes memory) {
        bytes memory ss = bytes(s);
        uint256 offset = 0;
        if (ss[0] == '0' && ss[1] == 'x') offset = 2;
        require(ss.length % 2 == 0);
        bytes memory r = new bytes((ss.length - offset) / 2);
        r = M.fromHex(s);
        return r;
    }
    function compare_fromHex (string memory _s) public returns (bool){
        bytes memory r2 = fromHexTest_2(_s);
        bytes memory r3 = fromHexTest_3(_s);
        if((keccak256(abi.encodePacked(r2))) != keccak256(abi.encodePacked(r3))){
            compare_flag == false;
        }
    }

    //echidna_tests
    function echidna_test_hex() public view returns(bool){
        return flag;
    }
    function echidna_test_hex_compare() public view returns(bool) {
        return flag;
    }

}