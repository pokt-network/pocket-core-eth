pragma solidity ^0.4.11;

import "./StakableToken.sol";
import "installed_contracts/zeppelin/contracts/token/MintableToken.sol";


// To throttle, token must be able to stake
contract ThrottleableToken is StakableToken, MintableToken {

  // Mapping of address staking => count of transactions in current throttle epoch
  mapping (address => uint256) public epochTransactionCount;
  // Throttle epoch state: epochTransactionCount gets reset after end of each epoch
  uint public throttleStartBlock;
  uint public throttleResetBlock;
  uint public throttleEpoch;

  uint public currentBlockEpoch;
  uint public constant EPOCH_HALVING = 1593818;
  uint public mintReward = 2850;
  uint public epochCount = 1;

  function ThrottleableToken () {
    //constructor

  }

  /*
  * Core throttling functions
  */

  function throttle(address _stakerAddress) returns (bool success) {

    // Get current epoch state of staker
    uint256 currentEpochTransactionCount = epochTransactionCount[_stakerAddress];
    uint256 currentStakedAmount = stakedAmount[_stakerAddress];

    // Coefficient is how many transactions per throttle epoch are allowed
    // TODO: dynamic coefficient calculation
    // Use velocity and supply to determine this coefficient
    uint256 throttleCoefficient = currentStakedAmount * 2;

    if (block.number >= throttleResetBlock) {
      epochTransactionCount[_stakerAddress] = 0;
    }
    // Luis: Save gas, just save the coefficient once and reset it when the throttle resets
    if (currentEpochTransactionCount > throttleCoefficient) {
      //resetThrottleEpoch(_stakerAddress);
      return false;
    } else {
      epochTransactionCount[_stakerAddress] += 1;
      return true;
    }

  }

  // TO-DO: Figure out incentives for resetting the epoch
  function resetThrottleEpoch(address _stakerAddress) {
    //Must stake at least 1 PKT
    require(stakedAmount[_stakerAddress] > 0);
    // check if current throttle epoch needs to be reset
    require(block.number >= throttleResetBlock);

    // TODO: DO FUNCTION
    // TODO: Permissions
    uint blockNumber = block.number;

    // TODO: calculate reset dynamically
    throttleResetBlock = blockNumber += 10;
    throttleEpoch += 1;


    if(currentBlockEpoch + EPOCH_HALVING >= block.number) {
      updateMintReward()
    }
  }

  function updateMintReward() private {

    require(epochCount <= 10);
    mintReward = mintReward / 2;
    epochCount += 1;
  }

  function getThrottleStartBlock() constant returns (uint) {
    return throttleStartBlock;
  }

  function getThrottleResetBlock () constant returns (uint) {
    return throttleResetBlock;
  }

  function getThrottleEpoch () constant returns (uint) {
    return throttleEpoch;
  }



}
