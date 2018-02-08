pragma solidity ^0.4;

import "../models/NodeModels.sol";
import "../interfaces/PocketTokenInterface.sol";

contract RelayCrud {
  // Attributes
  bytes32 currentRelayId;
  bytes32[] currentACRelays;
  // Relayed transactions
  mapping(bytes32 => NodeModels.Relay) public relays;
  bytes32[] private relayIndex;
  // Events
  event LogRelayInsert(address[5] _oracleAddresses, bytes32 _txHash, bytes _txTokenId, address _sender, address _relayer, bytes32 relayID);
  event LogRelayConcluded(bytes32 _relayId, address _relayer);
  // Functions
  /**
   * Returns wheter or not the relay with this id exists
   * @param {bytes32} _relayId - The id we wanna confirm
   * @return {bool} isIndeed - Whether or not the relay is there
   */
  function isRelay(bytes32 _relayId) public constant returns(bool isIndeed) {
    if(relayIndex.length == 0) return false;
    return (relayIndex[relays[_relayId].index] == _relayId);
  }

  /**
   * Inserts a relay into the relays mapping
   * @param {address[]} _oracleAddresses - Oracle addressses selected for this relay
   * @param {bytes32} _txHash - The serialized hash of the transaction to be relayed
   * @param {bytes} _txTokenId - The tokenID for the transaction being relayed: BTC, ETH, etc.
   * @param {address} _sender - The address of the sender of this transaction
   * @returns {uint} index - The index in which the relay record was inserted
   */
  function insertRelay(address[5] _oracleAddresses, bytes32 _txHash, bytes _txTokenId, address _sender) public returns(uint index) {
    currentRelayId = keccak256(_txHash, _txTokenId);
    if(isRelay(currentRelayId)) revert();
    relays[currentRelayId].oracleAddresses = _oracleAddresses;
    for(uint i = 0; i < _oracleAddresses.length; i++){
      relays[currentRelayId].oracles[_oracleAddresses[i]] = true;
    }
    relays[currentRelayId].txHash = _txHash;
    relays[currentRelayId].txTokenId = _txTokenId;
    relays[currentRelayId].sender = _sender;
    relays[currentRelayId].relayer = msg.sender;
    relays[currentRelayId].approved = false;
    relays[currentRelayId].concluded = false;
    relays[currentRelayId].index = relayIndex.push(currentRelayId) - 1;
    LogRelayInsert(_oracleAddresses, _txHash, _txTokenId, _sender, msg.sender, currentRelayId);
    return relayIndex.length - 1;
  }

  /**
   * Returns the ID of the relay based on the index
   * @params {uint} _index - the index to serch for
   * @returns {bytes32} relayId - the id of the returned relay
   */
  function getRelayIDAtIndex(uint _index) public constant returns(bytes32 relayId) {
    return relayIndex[_index];
  }

  // Getters for relay properties
  // TO-DO: Document all these
  function getRelayVotesCasted(bytes32 _relayId) public returns(uint votesCasted){
    return relays[_relayId].votesCasted;
  }

  function getRelayOracleAddresses(bytes32 _relayId) public returns(address[5] oracleAddresses){
    return relays[_relayId].oracleAddresses;
  }

  function isRelayOracle(bytes32 _relayId, address _potentialOracle) public returns(bool isOracle) {
    return relays[_relayId].oracles[_potentialOracle];
  }

  function updateRelayOracleVote(bytes32 _relayId, bool _vote) public {
    require(relays[_relayId].concluded == false);
    require(isRelayOracle(_relayId, msg.sender));
    require(oracleVoted(_relayId, msg.sender) == false);
    relays[_relayId].oracleVotes[msg.sender] = _vote;
    relays[_relayId].oracleVoted[msg.sender] = true;
    relays[_relayId].votesCasted += 1;
  }

  function oracleVoted(bytes32 _relayId, address _oracle) public returns(bool voted) {
    return relays[_relayId].oracleVoted[_oracle];
  }

  function concludeRelay(bytes32 _relayId) public{
    require(relays[_relayId].concluded == false);
    require(relays[_relayId].votesCasted == relays[_relayId].oracleAddresses.length);
    relays[_relayId].concluded = true;

    // Determines wheter or not the relay was approved by all oracles
    // TO-DO: Determine partial votes
    bool result = true;
    for (uint i = 0; i < relays[_relayId].oracleAddresses.length; i++) {
      if(relays[_relayId].oracleVotes[relays[_relayId].oracleAddresses[i]] == false) {
        result = false;
        return;
      }
    }
    relays[_relayId].approved = result;
    // Emit LogRelayConcluded event
    LogRelayConcluded(_relayId, relays[_relayId].relayer);
  }

  function isRelayConcludedAndApproved(bytes32 _relayId) public constant returns(bool isConcludedAndApproved) {
    return (relays[_relayId].concluded == true && relays[_relayId].approved == true);
  }

}
