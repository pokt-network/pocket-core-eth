pragma solidity ^0.4;

contract PocketTokenInterface {
  // Attributes
  mapping (uint => uint) public totalRelaysPerEpoch;
  uint public globalEpochCount = 1;
  // Functions
  function transfer(address _recipient, uint256 _value) public returns (bool success) {}
  function canRelayOrReset(address _senderAddress) public returns (bool success) {}
  function increaseCurrentEpochRelayCount() public {}
  function balanceOf(address who) public constant returns (uint256) {}
}
