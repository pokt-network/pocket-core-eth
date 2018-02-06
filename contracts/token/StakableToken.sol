pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";

contract RegistryInterface {
  function isOracleRegistered(address _key) returns (bool);
  function isNodeRegistered(address _key) returns (bool);
}

contract StakableToken is StandardToken {

  // Mapping of address staking => staked amount
  mapping (address => uint256) public stakedAmount;
  mapping (address => uint256) public nodeStakedAmount;
  mapping (address => uint256) public oracleStakedAmount;
  mapping (address => uint256) public investorStakedAmount;

  // Interface for checking whether stakers are registeredNodes or registeredOracles
  RegistryInterface public registry;

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

  function nodeStake(uint256 _value) returns (bool success) {
    // TODO: Permissions
    if (registry.isNodeRegistered(msg.sender) == true) revert();
    require(_value > 0);
    // TODO: Timelock stake

    balances[msg.sender] -= _value;
    nodeStakedAmount[msg.sender] += _value;
    Staked(msg.sender, _value);
    return true;
  }

  function releaseNodeStake(uint256 _value) returns (bool success) {
    require(_value <= nodeStakedAmount);
    // TODO: Permissions
    // TODO: Timelock stake
    nodeStakedAmount[msg.sender] -= _value;
    balances[msg.sender] += _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

  function oracleStake(uint256 _value) returns (bool success) {
    // TODO: Permissions
    require(registry.isOracleRegistered(msg.sender));
    require(_value > 0);
    // TODO: Timelock stake

    balances[msg.sender] -= _value;
    oracleStakedAmount[msg.sender] += _value;
    Staked(msg.sender, _value);
    return true;
  }

  function releaseOracleStake(uint256 _value) returns (bool success) {
    require(_value <= nodeStakedAmount);
    // TODO: Permissions
    // TODO: Timelock stake
    oracleStakedAmount[msg.sender] -= _value;
    balances[msg.sender] += _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

  function stakeOnBehalf(uint256 _value, bool _isRelayer, bool _isOracle, bool _isDeveloper) returns (bool success) {
    // Stake on behalf one person at a time
      if(_isRelayer == true && _isOracle == false && _isDeveloper == false) {
        require(_value > 0);
        // TODO: Timelock stake

        balances[msg.sender] -= _value;
        nodeStakedAmount[msg.sender] += _value;
        investorStakedAmount[msg.sender] += _value;
        Staked(msg.sender, _value);
        return true;
      }
      if (_isRelayer == false && _isOracle == true && _isDeveloper == false) {
        require(_value > 0);
        // TODO: Timelock stake
        balances[msg.sender] -= _value;
        oracleStakedAmount[msg.sender] += _value;
        investorStakedAmount[msg.sender] += _value;
        Staked(msg.sender, _value);
        return true;
      }
      if (_isRelayer == false && _isOracle == false && _isDeveloper == true) {
        require(_value > 0);
        // TODO: Timelock stake
        balances[msg.sender] -= _value;
        stakedAmount[msg.sender] += _value;
        investorStakedAmount[msg.sender] += _value;
        Staked(msg.sender, _value);
        return true;
          }
  }

}
