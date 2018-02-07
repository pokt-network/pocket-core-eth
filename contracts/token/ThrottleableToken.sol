pragma solidity ^0.4.11;

import "./StakableToken.sol";
import "installed_contracts/zeppelin/contracts/token/MintableToken.sol";


// To throttle, token must be able to stake
contract ThrottleableToken is StakableToken, MintableToken {

  // Mapping of address staking => count of transactions in current throttle epoch

  // should be epochRelayCount
  mapping (address => uint256) public epochTransactionCount;
  // Throttle epoch state: epochTransactionCount gets reset after end of each epoch
  uint public throttleStartBlock;
  uint public throttleResetBlock;
  uint public throttleEpoch;
  mapping (uint => uint) public totalRelaysPerEpoch;
  uint public currentEpochBlockStart;
  uint public constant EPOCH_HALVING = 1593818;
  uint public globalEpochCount = 1;

  function ThrottleableToken () {
    //constructor

  }

  /*
  * Core throttling functions
  */

  /// @dev Acts as main function to check whether developer account using relay services has reached their maximum amount of relays in allotted amount of blocks
  /// @param _stakerAddress that is being checked if needs to be throttled
  function throttle(address _stakerAddress) returns (bool success) {


    // separate checking and state change
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
      return false;
    } else {
      epochTransactionCount[_stakerAddress] += 1;
      return true;
    }

  }

  /// @dev Separate "mining" function separate from individual throttle counts.
  /// When mint() gets calculated, first successful caller of this method mints 10%
  /// of token reward. Acts as catalyst for entire network.
  function resetThrottleEpoch() {

    // check if current throttle epoch needs to be reset
    require(block.number >= throttleResetBlock);
    //Need to figure out how much to stake to call this function.
    require(stakedAmount[_stakerAddress] > 0);

    mint();

    uint blockNumber = block.number;
    throttleResetBlock = blockNumber += 10;
    throttleEpoch += 1;


    if(currentEpochBlockStart + EPOCH_HALVING >= block.number) {
      updateMintReward()
    }
  }

  function updateMintReward() private {
    require(globalEpochCount <= 10);
    mintReward = mintReward / 2;
    globalEpochCount += 1;
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

  function increaseEpochCount(uint _epoch) {
    // TODO: Permissions
    totalReplaysPerEpoch[_epoch] = totalReplaysPerEpoch[_epoch] += 1;
  }

}
