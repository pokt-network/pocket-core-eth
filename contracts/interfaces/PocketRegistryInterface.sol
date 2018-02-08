pragma solidity ^0.4;

contract PocketRegistryInterface {
  function getRelayOracles() public returns(address[5] oracles) {}
  function getLiveNodes() public constant returns (address[]) {}

}
