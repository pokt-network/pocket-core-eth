pragma solidity ^0.4;

import "../models/NodeModels.sol";

contract PocketNodeInterface {
  // Attributes
  mapping(bytes32 => NodeModels.Relay) public relays;
  // Approved and Concluded relays count
  uint public aCRelaysCount;
  // Approved and Concluded verified relays count
  uint public aCVRelaysCount;
}
