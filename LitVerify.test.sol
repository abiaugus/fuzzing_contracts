pragma solidity ^0.8.0;

import './LitVerify.sol';
//incomplete
contract Test {
    
    bool verify_flag = false;
    
    LitVerify L = new LitVerify();

    function test_verify(bytes memory _msg, bytes memory _sig) public {
        verify_flag = L.verify(_msg, _sig);
    }

    function echidna_test_verify() public view returns (bool) {
        return !verify_flag;
    }
}
