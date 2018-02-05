pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";

contract StakableToken is StandardToken {

  // Mapping of address staking => staked amount
  mapping (address => uint256) public stakedAmount;

  event Staked(address indexed _from, uint256 _value);
  event StakeReleased(address indexed _from, uint256 _value);

  function StakableToken() {
  }

  /*
  * Core staking functions
  */

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

}
