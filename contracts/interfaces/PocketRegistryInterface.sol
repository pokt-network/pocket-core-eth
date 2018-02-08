pragma solidity ^0.4;

contract PocketRegistryInterface {
  function getRelayOracles() public returns(address[5] oracles) {}
  function getLiveNodesCount() public returns(uint nodesCount) {}
  function getNodeRecordAtIndex(uint _index) public returns(address key) {}
}
