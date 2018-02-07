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

  /// @dev Cannot use the network without first staking PKT.
  /// @param _value of stake
  function stake(uint256 _value) returns (bool success) {
    require(_value > 0);

    // TODO: Timelock stake

    balances[msg.sender] -= _value;
    stakedAmount[msg.sender] += _value;
    Staked(msg.sender, _value);
    return true;
  }

  /// @dev Release stake to use Pocket Network. Will have a minimum time before removing.
  /// @param _value of stake removed.
  function releaseStake(uint256 _value) returns (bool success) {
    // TODO: Timelock stake
    stakedAmount[msg.sender] -= _value;
    balances[msg.sender] += _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

  /// @dev PKT holders and investors can stake on behalf of developers, nodes, and oracles they wish to support
  /// @param _investee is address that msg.sender is investing on behalf of
  /// @param _value of stake being invested
  function stakeOnBehalf(address _investee, uint256 _value) returns (bool success) {

    // Stake on behalf one person at a time
    balances[msg.sender] -= _value;
    stakedAmount[_investee] += _value;
    investorStakedAmount[msg.sender][_investee] += _value;
    Staked(msg.sender, _value)
    return true;

  }
  /// @dev PKT holders and investors can remove stake on behalf of developers, nodes, and oracles they wish to
  /// stop giving support to
  /// @param _investee is address that msg.sender is removing investment on behalf of
  /// @param _value of stake being invested
  function releaseStakeOnBehalf(address _investee, uint256 _value) returns (bool success) {

    balances[msg.sender] += _value;
    stakedAmount[_investee] -= _value;
    investorStakedAmount[msg.sender][_investee] -= _value;
    StakeReleased(msg.sender, _value);
    return true;
  }

}
