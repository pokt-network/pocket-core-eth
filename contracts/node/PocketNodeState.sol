pragma solidity ^0.4;

import "../interfaces/PocketRegistryInterface.sol";
import "../interfaces/PocketTokenInterface.sol";

contract PocketNodeState {
  /**
   * @dev Attributes
   */
  address public owner;
  bool public isRelayer;
  bool public isOracle;
  address public delegateContract;
  PocketRegistryInterface registryInterface;
  PocketTokenInterface tokenInterface;
  // Approved and Concluded relays count
  uint public aCRelaysCount;
  // Approved and Concluded verified relays count
  uint public aCVRelaysCount;

  /**
   * @dev Modifiers
   */
  modifier onlyOwner {
    if (msg.sender != owner) revert();
    _;
  }
}
