pragma solidity ^0.4;

import "../models/NodeModels.sol";

contract PocketNodeInterface {
  // Attributes
  // Approved and Concluded relays count
  uint public aCRelaysCount;
  // Approved and Concluded verified relays count
  uint public aCVRelaysCount;
  bool public isRelayer;
  bool public isOracle;
  // Functions
  function updateRelayOracleVote(bytes32 _relayId, bool _vote) public {}
  function isRelayConcludedAndApproved(bytes32 _relayId) public constant returns(bool isConcludedAndApproved) {}
  function increaseACRelaysCount() public {}
}
