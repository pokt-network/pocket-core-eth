pragma solidity ^0.4.11;

import "../relay/PocketRelay.sol";
import "../token/PocketToken.sol";
import "./RelayCrud.sol";

contract PocketRegistryInterface {
  function getRelayOracles() returns(address[] oracles);
}

contract PocketNode is RelayCrud {

  // Attributes
  address public ownerAddress;
  bool public isRelayer;
  bool public isOracle;
  address public delegateContractAddress;
  PocketRegistryInterface private registryInterface;
  // Events
  event LogRelayConcluded(bytes32 _relayId, address _relayer);
  // Functions
  /**
   * Represents a PocketNode.
   * @constructor
   * @param {address} _ownerAddress - The owner of this PocketNode
   * @param {bool} _isRelayer - Determines wheter or not the new node is a Relayer
   * @param {bool} _isOracle - Determines wheter or not the new node is an Oracle
   */
  function PocketNode(address _ownerAddress, address _delegateAddress, bool _isRelayer, bool _isOracle) {
    ownerAddress = _ownerAddress;
    isRelayer = _isRelayer;
    isOracle = _isOracle;
    delegateContractAddress = _delegateAddress;
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
    delegateContractAddress.delegatecall(bytes4(sha3("createRelay()")), _txHash, _txTokenId, _sender, _pocketTokenAddress);
  }

  /**
   * Submits a relay vote from an oracle
   * @param {bytes32} relayId - The id of the relay to vote on
   * @param {bool} _vote - Whether or not the transaction was succesfully relayed
   */
  function submitRelayVote(address relayer, bytes32 relayId, bool _vote) {
    delegateContractAddress.delegatecall(bytes4(sha3("submitRelayVote()")), relayer, relayId, _vote);
  }
}
