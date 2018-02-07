pragma solidity ^0.4;

import "./RelayCrud.sol";
import "./PocketNodeState.sol";

contract PocketNode is RelayCrud, PocketNodeState {
  // Events
  event LogRelayConcluded(bytes32 _relayId, address _relayer);
  // Functions
  /**
   * Represents a PocketNode.
   * @constructor
   * @param {address} _owner - The owner of this PocketNode
   * @param {address} _delegateContract - The PocketNodeDelegate instance address
   * @param {address} _token - The PocketToken instance address
   * @param {bool} _isRelayer - Determines wheter or not the new node is a Relayer
   * @param {bool} _isOracle - Determines wheter or not the new node is an Oracle
   */
  function PocketNode(address _owner, address _delegateContract, address _token, bool _isRelayer, bool _isOracle) {
    owner = _owner;
    delegateContract = _delegateContract;
    tokenInterface = PocketTokenInterface(_token);
    isRelayer = _isRelayer;
    isOracle = _isOracle;
    registryInterface = PocketRegistryInterface(msg.sender);
  }

  /**
   * Creates a new relay through the delegateContract
   * @param {bytes32} _txHash - The TX hash for the relayed transaction
   * @param {bytes} _txTokenId - The token ID, e.g.: BTC, ETH, etc
   * @param {address} _sender - The sender of the transaction
   * @param {address} _pocketTokenAddress - The address for the PocketToken
   */
  function createRelay(bytes32 _txHash, bytes _txTokenId, address _sender, address _pocketTokenAddress) {
    delegateContract.delegatecall(bytes4(sha3("createRelay(bytes32 _txHash, bytes _txTokenId, address _sender, address _pocketTokenAddress)")), _txHash, _txTokenId, _sender, _pocketTokenAddress);
  }

  /**
   * Submits a relay vote from an oracle
   * @param {bytes32} relayId - The id of the relay to vote on
   * @param {bool} _vote - Whether or not the transaction was succesfully relayed
   */
  function submitRelayVote(address _relayer, bytes32 _relayId, bool _vote) {
    delegateContract.delegatecall(bytes4(sha3("submitRelayVote(address _relayer, bytes32 _relayId, bool _vote)")), _relayer, _relayId, _vote);
  }

  /**
   * @dev Increases the count of approved and concluded relays done by this node
   */
  // TO-DO: Add permissions to this
  function increaseACRelaysCount() public {
    delegateContract.delegateCall(bytes4(sha3('increaseACRelaysCount()')));
  }

  /**
   * @dev Increases the count of approved and concluded relays verified by this node
   */
  // TO-DO: Add permissions to this
  function increaseACVRelaysCount() public {
    delegateContract.delegateCall(bytes4(sha3('increaseACVRelaysCount()')));
  }

  /**
   * Only lets the owner withdraw the balance of the contract
   * @param {address} _to - The destination address of the funds
   * @param {uint} _value - The amount to withdraw
   */
  function withdraw(address _to, uint _value) onlyOwner {
    require(tokenInterface.transfer(_to, _value));
  }

  /**
   * Only lets the owner kill this instance
   */
  function kill() onlyOwner {
    suicide(owner);
  }
}
