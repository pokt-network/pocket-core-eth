pragma solidity ^0.4;

contract PocketTokenInterface {
  // Attributes
  mapping (uint => uint) public totalRelaysPerEpoch;
  uint public globalEpochCount = 1;
  // Functions
  function transfer(address _recipient, uint256 _value) returns (bool success) {}
  function throttle(address _stakerAddress) returns (bool success) {}
  function increaseEpochCount(uint _epoch) {}
}
