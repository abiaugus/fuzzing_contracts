// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILitVerify {
  function verify(bytes memory _msg, bytes memory _sig)
    external
    view
    returns (bool);

  function verify(
    string memory headerJson,
    string memory payloadJson,
    bytes memory signature
  ) external view returns (bool);
}
