pragma solidity ^0.4;

import "./NodeStructs.sol";

contract RelayCrud {
  // Attributes
  bytes32 currentRelayId;
  bytes32[] currentACRelays;
  // Relayed transactions
  mapping(bytes32 => NodeStructs.Relay) public relays;
  bytes32[] private relayIndex;
  // Events
  event LogRelayInsert(address[] _oracleAddresses, bytes32 _txHash, bytes _txTokenId, address _sender, address _relayer, bytes32 relayID);
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
  function insertRelay(address[] _oracleAddresses, bytes32 _txHash, bytes _txTokenId, address _sender) public returns(uint index) {
    currentRelayId = keccak256(_txHash, _txTokenId);
    if(isRelay(currentRelayId)) revert();
    relays[currentRelayId].oracles = _oracleAddresses;
    for(uint i = 0; i < _oracleAddresses.length; i++){
      relays[currentRelayId].oracles[_oracleAddresses[i]] = true;
    }
    relays[currentRelayId].txHash = _txHash;
    relays[currentRelayId].tokenId = _txTokenId;
    relays[currentRelayId].sender = _sender;
    relays[currentRelayId].relayer = msg.sender;
    relays[currentRelayId].approved = false;
    relays[currentRelayId].concluded = false;
    relays[currentRelayId].index = relayIndex.push(currentRelayId) - 1;
    LogRelayInsert(_oracles, _txHash, _txTokenId, _sender, msg.sender, currentRelayId);
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
}
