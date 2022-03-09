pragma solidity ^0.8.0;

import './Base64.sol';

//incomplete

contract Test {

    bool flag = true;
    bool compare_flag = true;

    function test_encode (string memory _str) public {
        bytes memory _bs = bytes(_str);
        uint256 rem = _bs.length % 3;
        uint256 res_length = (_bs.length + 2) / 3 * 4 - ((3 - rem) % 3);
        string memory res1 = new string(res_length);
        res1 = Base64.encode(_str);
        string memory test_string = "";
        if((keccak256(abi.encodePacked(res1))) == keccak256(abi.encodePacked(test_string))){
            flag = false;
        }
    }
    function test_encode_2(string memory _str) public returns (string memory) {
        bytes memory _bs = bytes(_str);
        uint256 rem = _bs.length % 3;
        uint256 res_length = (_bs.length + 2) / 3 * 4 - ((3 - rem) % 3);
        string memory res2 = new string(res_length);
        res2 = Base64.encode(_str);
        return res2;
    }
    function test_encode_3(string memory _str) public returns(string memory) {
        bytes memory _bs = bytes(_str);
        uint256 rem = _bs.length % 3;
        uint256 res_length = (_bs.length + 2) / 3 * 4 - ((3 - rem) % 3);
        string memory res3 = new string(res_length);
        res3 = Base64.encode(_str);
        return res3;
    }
    function compare_encodes(string memory _s) public {
        bytes memory _bs = bytes(_s);
        uint256 rem = _bs.length % 3;
        uint256 res_length = (_bs.length + 2) / 3 * 4 - ((3 - rem) % 3);
        string memory r2 = new string(res_length);
        string memory r3 = new string(res_length);
        r2 = test_encode_2(_s);
        r3 = test_encode_3(_s);
        if((keccak256(abi.encodePacked(r2))) != keccak256(abi.encodePacked(r3))){
            compare_flag = false;
        }
    }

    function echidna_test_encode() public view returns (bool){
        return flag;
    }
    function echidna_test_compare_encodes() public view returns (bool){
        return compare_flag;
    }
    function echidna_alwaystrue() public returns (bool){
        return(true);
  }
}
