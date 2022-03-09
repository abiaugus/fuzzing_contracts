pragma solidity ^0.8.0;

import '../JsmnSolLib.sol';

contract Test {

    uint a = 1;
    uint b = 2;

    bool str_compare_flag = true;
    bool parse_bool_flag = false;
    bool parse_int_flag = true;
    bool get_bytes_flag = true;
    bool parse_flag = true;
    bool primitive_flag = true;
    bool uint2str_flag = true;
    // bool trial_flag = true;

    // function sum () public {
    //     if(a + b == 3){
    //         trial_flag = false;
    //     }
    // }
    // function echidna_test_sum() public view returns (bool) {
    //     return trial_flag;
    // }

    enum JsmnType { UNDEFINED, OBJECT, ARRAY, STRING, PRIMITIVE }

    struct Token {
        JsmnType jsmnType;
        uint start;
        bool startSet;
        uint end;
        bool endSet;
        uint8 size;
    }
    struct Parser {
        uint pos;
        uint toknext;
        int toksuper;
    }

    function test_strCompare(string memory _a, string memory _b) public { //works
        int a;
        int b;

        a = JsmnSolLib.strCompare(_a, _b);
        b = JsmnSolLib.strCompare(_a, _b);

        if(a != b){ // != . works
            str_compare_flag = false;
        }
        if(a > 1){ //a > 1 . works
            str_compare_flag = false;
        }
    }
    function test_parseBool(string memory _a) public {
        if(keccak256(abi.encodePacked(_a)) != keccak256(abi.encodePacked('true'))){ //!= . works
            parse_bool_flag = JsmnSolLib.parseBool(_a);
        }
    }
    function test_parseInt(string memory _a, uint _b) public { //works
        int res1 = JsmnSolLib.parseInt(_a, _b);
        int res2 = JsmnSolLib.parseInt(_a, _b);

        if(res1 != res2){ //!=
            parse_int_flag = false;
        }
    }
    function test_getBytes(string memory json, uint start, uint end) public { // not working
        // string memory res1 = JsmnSolLib.getBytes(json, start, end);
        // string memory res2 = JsmnSolLib.getBytes(json, start, end);

        // if((keccak256(abi.encodePacked(res1)) != keccak256(abi.encodePacked(res2)))){
        //     get_bytes_flag = false;
        // }
        // get_bytes_flag = false;

        // if(bytes(res1).length > ){
        //     get_bytes_flag = false;
        // }
    }
    function test_parse(string memory json, uint numberElements) public { //works
        uint a1;
        uint a2;
        uint b1;
        uint b2;

        (a1, , a2) = JsmnSolLib.parse(json, numberElements);
        (b1, , b2) = JsmnSolLib.parse(json, numberElements);

        if((a1 != b1 || a2 != b2)){ 
            parse_flag = false;
        }
        if( a1 > 3){ // a > 3 . works
            parse_flag = false;
        }
    }
    function test_parsePrimitive(JsmnSolLib.Parser memory parser, JsmnSolLib.Token[] memory tokens, bytes memory s) public { //works with test-limit > 5000
        uint a = JsmnSolLib.parsePrimitive(parser, tokens, s);
        uint b = JsmnSolLib.parsePrimitive(parser, tokens, s);
        uint c = JsmnSolLib.parsePrimitive(parser, tokens, s);

        if(!(a == b && b == c)){
            primitive_flag = false;
        }
    }
    function test_uint2str(uint i) public { //not working, always reverts (except for i = 0)
        string memory res1 = JsmnSolLib.uint2str(1);
        string memory res2 = JsmnSolLib.uint2str(2);
        string memory res3 = JsmnSolLib.uint2str(999);

        if(i == 0){
            if(keccak256(abi.encodePacked(res1)) != keccak256(abi.encodePacked("0"))){
                uint2str_flag = false;
            }
        }
        if(keccak256(abi.encodePacked(res1)) == keccak256(abi.encodePacked(res2))){
                uint2str_flag = false;
        }
        if(keccak256(abi.encodePacked(res3)) != keccak256(abi.encodePacked("999"))){
                uint2str_flag = false;
        }

    }

    function echidna_test_strCompare() public view returns(bool) {
        return str_compare_flag;
    }
    function echidna_test_parseBool() public view returns(bool) {
        return !parse_bool_flag;
    }
    function echidna_test_parseInt() public view returns(bool) {
        return parse_int_flag;
    }
    // function echidna_test_getBytes() public view returns(bool) {
    //     return get_bytes_flag;
    // }
    function echidna_test_parse() public view returns(bool) {
        return parse_flag;        
    }
    function echidna_test_primitive_parse() public view returns(bool) {
        return primitive_flag;
    }
    function echidna_test_uint2str() public view returns(bool) {
        return uint2str_flag;
    }
}