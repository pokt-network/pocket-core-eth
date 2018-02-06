pragma solidity ^0.4.11;

contract RelayCrud {
  // Attributes
  bytes32 currentRelayId;
  bytes32[] currentACRelays;
  mapping(bytes32 => Relay) private relays;
  bytes32[] private relayIndex;
  // Structs
  struct Relay {
    address[] oracles;
    bytes32 txHash;
    bytes txTokenId;
    address sender;
    address relayer;
    bool[] oracleVotes;
    bool approved;
    bool concluded;
    uint id;
  }
  // Events
  event LogRelayInsert(address[] _oracles, bytes32 _txHash, bytes _txTokenId, address _sender, address _relayer);
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
   * @param {address[]} _oracles - Oracle addressses selected for this relay
   * @param {bytes32} _txHash - The serialized hash of the transaction to be relayed
   * @param {bytes} _txTokenId - The tokenID for the transaction being relayed: BTC, ETH, etc.
   * @param {address} _sender - The address of the sender of this transaction
   * @returns {uint} index - The index in which the relay record was inserted
   */
  function insertRelay(address[] _oracles, bytes32 _txHash, bytes _txTokenId, address _sender) public returns(uint index) {
    currentRelayId = keccak256(_txHash, _txTokenId);
    if(isRelay(currentRelayId)) throw;
    relays[currentRelayId].oracles = _oracles;
    relays[currentRelayId].txHash = _txHash;
    relays[currentRelayId].tokenId = _txTokenId;
    relays[currentRelayId].sender = _sender;
    relays[currentRelayId].relayer = msg.sender;
    relays[currentRelayId].approved = false;
    relays[currentRelayId].concluded = false;
    relays[currentRelayId].index = relayIndex.push(currentRelayId) - 1;
    LogRelayInsert(_oracles, _txHash, _txTokenId, _sender, msg.sender);
    return relayIndex.length - 1;
  }

  /**
   * Returns a list of all the approved and concluded relays in the relays mapping
   * @returns {Relay[]} acRelays - relay array to return
   */
  function getACRelays() public constant returns(bytes32[] acRelays) {
    currentACRelays = new bytes32[]();
    for (uint i = 0; i < relayIndex.length; i++) {
      if(relays[relayIndex[i]].approved && relays[relayIndex[i]].concluded) {
        currentACRelays.push(relayIndex[i]);
      }
    }
    return currentACRelays;
  }
}
