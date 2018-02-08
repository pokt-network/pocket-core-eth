pragma solidity ^0.4;

contract PocketRegistryInterface {
  function getRelayOracles() returns(address[5] oracles) {}
  function getLiveNodes() constant returns (address[]) {}

}
