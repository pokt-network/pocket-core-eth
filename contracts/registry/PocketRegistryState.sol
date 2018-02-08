pragma solidity ^0.4;

contract PocketRegistryState {
  // Attributes
  address public owner = msg.sender;
  uint public creationTime = now;
  address public tokenAddress;
  address public delegateContract;
  address[] public previousDelegates;
  mapping (address => address) public userNode;
  address public nodeDelegateAddress;
  // Modifiers
  modifier onlyOwner {
    if (msg.sender != owner) revert();
    _;
  }
  // Events
  event DelegateChanged(address oldAddress, address newAddress);
}
