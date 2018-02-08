pragma solidity ^0.4;

import "../models/NodeModels.sol";

contract PocketNodeInterface {
  // Attributes
  // Approved and Concluded relays count
  uint public aCRelaysCount;
  // Approved and Concluded verified relays count
  uint public aCVRelaysCount;
}
