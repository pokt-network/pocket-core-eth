pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";

contract StakableToken is StandardToken {

  // Mapping of address staking => staked amount
  mapping (address => uint256) public stakedAmount;
  mapping (address => mapping (address => uint256)) public investorStakedAmount;

  // Interface for checking whether stakers are registeredNodes or registeredOracles
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


  function stakeOnBehalf(address _investee, uint256 _value) returns (bool success) {

    // Stake on behalf one person at a time
    balances[msg.sender] -= _value;
    stakedAmount[_investee] += _value;
    investorStakedAmount[msg.sender][_investee] += _value;
    Staked(msg.sender, _value)
    return true;

  }

  function releaseStakeOnBehalf(address _investee, uint256 _value) returns (bool success) {

    balances[msg.sender] += _value;
    stakedAmount[_investee] -= _value;
    investorStakedAmount[msg.sender][_investee] -= _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

}
