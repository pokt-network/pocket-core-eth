pragma solidity ^0.4;

import "installed_contracts/zeppelin/contracts/token/BurnableToken.sol";
import "./StakableToken.sol";
import "../interfaces/PocketNodeInterface.sol";
import "../interfaces/PocketRegistryInterface.sol";

contract PocketToken is StakableToken {

  // Attributes
  string public name;
  string public symbol;
  uint8 public decimals;
  string public version;
  uint public totalMintReward = 2850;
  mapping (uint => uint) public totalRelaysPerEpoch;
  PocketRegistryInterface public registryInterface;
  mapping (address => uint256) public epochTransactionCount;
  uint public currentEpoch = 1;
  uint public currentEpochBlockStart;
  uint public currentEpochBlockEnd;
  uint public constant BLOCKS_PER_EPOCH = 10;
  uint public constant EPOCHS_PER_HALVING = 100;
  // Events
  event Mint(address indexed to, uint amount);
  // Functions
  function PocketToken() {
    // constructor
    totalSupply = 100000000;
    balances[msg.sender] = totalSupply;
    name = "Pocket Token";
    symbol = "PKT";
    decimals = 18;
    version = "0.1";
    currentEpochBlockStart = block.number;
    currentEpochBlockEnd = currentEpochBlockStart + BLOCKS_PER_EPOCH;
  }

  // Base minting function
  function mint(address _to, uint256 _amount) private {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(0x0, _to, _amount);
  }

  // Rewards a node with mint for work done
  function rewardNode(address _node, uint256 _baseReward, uint256 _multiplier) private {
    if (_multiplier > 0) {
      mint(_node, _baseReward * _multiplier);
    }
  }

  // TO-DO: Figure out scalability and permissions
  function calculateNodeRewards() {
    require(totalRelaysPerEpoch[currentEpoch] > 0);
    uint256 nodeMintReward = totalMintReward * 0.8;
    uint256 oracleMintReward = totalMintReward * 0.1;
    uint256 epochMinerReward = totalMintReward * 0.1;
    address[] storage nodes = registryInterface.getLiveNodes();
    uint256 relayReward = totalRelaysPerEpoch[currentEpoch] / nodeMintReward;
    uint256 relayVerificationReward = totalRelaysPerEpoch[currentEpoch] / oracleMintReward;

    for (uint i = 0; i < nodes.length; i++) {
      // Relayer mint
      if(nodes[i].isRelayer){
        rewardNode(nodes[i], relayReward, PocketNodeInterface(nodes[i]).aCRelaysCount.call());
      }

      // Oracle mint
      if(nodes[i].isOracle){
        rewardNode(nodes[i], relayVerificationReward, PocketNodeInterface(nodes[i]).aCVRelaysCount.call());
      }
    }

    // Function caller reward
    mint(msg.sender, epochMinerReward);
  }

  /// @dev Acts as main function to check whether developer account using relay services has reached their maximum amount of relays in allotted amount of blocks
  /// @param _stakerAddress that is being checked if needs to be throttled
  /// @TODO separate check from state change
  function canRelayOrReset(address _senderAddress) returns (bool success) {
    bool result = false;
    if (block.number > currentEpochBlockEnd) {
      epochTransactionCount[_senderAddress] = 0;
      result = true;
    } else {
      // Get current epoch state of staker
      uint256 currentEpochTransactionCount = epochTransactionCount[_senderAddress];
      uint256 currentStakedAmount = stakedAmount[_senderAddress];
      // Coefficient is how many transactions per epoch are allowed
      // TODO: dynamic coefficient calculation
      // Use velocity and supply to determine this coefficient
      uint256 throttleCoefficient = currentStakedAmount * 2;
      // Luis: Save gas, just save the coefficient once and reset it when the throttle resets
      if (currentEpochTransactionCount < throttleCoefficient) {
        epochTransactionCount[_senderAddress] += 1;
        result = true;
      }
    }
    return result;
  }

  /// @dev Separate "mining" function separate from individual throttle counts.
  /// When calculateNodeRewards() gets calculated, first successful caller of this method mints 10%
  /// of token reward. Acts as catalyst for entire network.
  /// TODO figure out a better way to implement this
  function mineCurrentEpoch() {
    require(block.number > currentEpochBlockEnd);
    require(stakedAmount[msg.sender] > 0);
    calculateNodeRewards();
    currentEpoch += 1;
    currentEpochBlockStart = block.number;
    currentEpochBlockEnd = currentEpochBlockStart + BLOCKS_PER_EPOCH;
    if(currentEpoch % EPOCHS_PER_HALVING == 0){
      totalMintReward = totalMintReward / 2;
    }
  }

  // TODO: Permissions
  function increaseCurrentEpochRelayCount() {
    totalRelaysPerEpoch[currentEpoch] = totalRelaysPerEpoch[currentEpoch] += 1;
  }
}
