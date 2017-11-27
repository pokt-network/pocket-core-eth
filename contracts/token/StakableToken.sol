pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";

contract StakableToken is StandardToken {

  // Mapping of address staking => staked amount
  mapping (address => uint256) public stakedAmount;
  // Mapping of address staking => count of transactions in current throttle epoch
  mapping (address => uint256) public epochTransactionCount;

  // Throttle epoch state: epochTransactionCount gets reset after end of each epoch
  uint public throttleStartBlock;
  uint public throttleResetBlock;

  event Staked(address indexed _from, uint256 _value);
  event StakeReleased(address indexed _from, uint256 _value);

  function StakableToken() {
    // constructor
  }
  // Cannot throttle without first staking PKT
  function stake(uint256 _value) returns (bool success) {
    // TODO: Permissions
    require(_value > 0);
    // TODO: Timelock stake

    balances[msg.sender] -= _value;
    stakedAmount[msg.sender] += _value;
    Staked(msg.sender, _value);
    return true;
  }

  function releaseStake(uint256 _value) returns (bool success) {
    // TODO: Permissions
    // TODO: Timelock stake
    stakedAmount[msg.sender] -= _value;
    balances[msg.sender] += _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

  function throttle(address _stakerAddress) returns (bool success) {

    // TODO: Permissions

    // check if current throttle epoch needs to be reset
    if (block.number >= throttleResetBlock) {
      resetThrottleEpoch(_stakerAddress);
    }

    // Get current epoch state of staker
    uint256 currentEpochTransactionCount = epochTransactionCount[_stakerAddress];
    uint256 currentStakedAmount = stakedAmount[_stakerAddress];

    // Coefficient is how many transactions per throttle epoch are allowed
    // TODO: dynamic coefficient calculation
    // Use velocity and supply to determine this coefficient
    uint256 throttleCoefficient = currentStakedAmount * 2;

    // Luis: Save gas, just save the coefficient once and reset it when the throttle resets
    if (currentEpochTransactionCount >= throttleCoefficient) {
      return false;
    } else {
      epochTransactionCount[_stakerAddress] += 1;
      return true;
    }
  }

  function resetThrottleEpoch(address _stakerAddress) {
    // TODO: Permissions
    // PocketNodes reset when checking throttle
    // assert(currentThrottleBlock > throttleResetBlock);

    uint blockNumber = block.number;

    // TODO: calculate reset dynamically
    throttleResetBlock = blockNumber += 10;

    // Reset count on new epoch
    epochTransactionCount[_stakerAddress] = 0;
  }

  function getThrottleStartBlock() constant returns (uint) {
    return throttleStartBlock;
  }

  function getThrottleResetBlock () constant returns (uint) {
    return throttleResetBlock;
  }


}
