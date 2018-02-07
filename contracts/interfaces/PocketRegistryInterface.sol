pragma solidity ^0.4;

contract PocketRegistryInterface {
  function getRelayOracles() returns(address[] oracles) {}
  function getLiveNodes() constant returns (address[]) {}

}
