pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";

contract StakableToken is StandardToken {
  mapping (address => uint256) public stakerAmount;
  mapping (address => uint256) public stakerCount;
  uint public currentThrottleBlock;
  uint public throttleResetBlock;

  event Staked(address indexed _from, uint256 _value);
  event StakeReleased(address indexed _from, uint256 _value);

  function StakableToken() {
    // constructor
  }

  function stake(uint256 _value) returns (bool success) {
    // TODO: Permissions
    assert(_value > 0);
    // TODO: Timelock stake

    balances[msg.sender] -= _value;
    stakerAmount[msg.sender] += _value;
    Staked(msg.sender, _value);
    return true;
  }

  function releaseStake(uint256 _value) returns (bool success) {
    // TODO: Permissions

    // TODO: Timelock stake
    stakerAmount[msg.sender] -= _value;
    balances[msg.sender] += _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

  function throttle(address _address) returns (bool success) {

    // TODO: Permissions

    // check if throttle needs to be reset
    if (block.number >= throttleResetBlock) {
      resetThrottle(_address);
    }

    uint256 newCount = stakerCount[_address];
    uint256 stakedAmount = stakerAmount[_address];

    // TODO: dynamic coefficient calculation
    uint256 coefficient = stakedAmount * 2;

    if (newCount >= coefficient) {
      return false;
    } else {
      stakerCount[_address] += 1;
      return true;
    }
  }

  function resetThrottle(address _stakerAddress) {
    // TODO: Permissions

    /*assert(currentThrottleBlock > throttleResetBlock);*/
    currentThrottleBlock = block.number;
    uint blockNumber = currentThrottleBlock;
    throttleResetBlock = blockNumber += 10; // TODO: calculate reset dynamically
    stakerCount[_stakerAddress] = 0;
  }

  function getCurrentThrottleBlock() constant returns (uint) {
    return currentThrottleBlock;
  }

  function getThrottleResetBlock () constant returns (uint) {
    return throttleResetBlock;
  }


}
