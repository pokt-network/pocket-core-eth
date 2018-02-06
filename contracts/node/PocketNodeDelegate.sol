pragma solidity ^0.4.11;

import "../token/PocketToken.sol";

contract PocketNodeDelegate {
  // Attributes (mimics the attributes on the PocketNode)
  address public ownerAddress;
  bool public isRelayer;
  bool public isOracle;
  address public delegateContractAddress;
  PocketRegistryInterface private registryInterface;
  // Functions
  /**
   * Creates a new relay through the delegateContract
   * @param {bytes32} _txHash - The TX hash for the relayed transaction
   * @param {bytes} _txTokenId - The token ID, e.g.: BTC, ETH, etc
   * @param {address} _sender - The sender of the transaction
   * @param {address} _pocketTokenAddress - The address for the PocketToken
   */
  function createRelay(bytes32 _txHash, bytes _txTokenId, address _sender, address _pocketTokenAddress) {
    // Check the throttling
    PocketToken token = PocketToken(_pocketTokenAddress);
    require(token.throttle(_sender) == true);
    // Insert the relay record
    insertRelay(registryInterface.getRelayOracles(), _txHash, _txTokenId, _sender);
  }

  /**
   * Submits a relay vote from an oracle
   * @param {bytes32} relayId - The id of the relay to vote on
   * @param {bool} _vote - Whether or not the transaction was succesfully relayed
   */
  function submitRelayVote(address relayer, bytes32 relayId, bool _vote) {
    require(relays[relayId].votesCasted < relays[relayId].oracles.length);
    relays[relayId].oracleVotes[msg.sender] = _vote;
    relays[relayId].votesCasted += 1;
    if(relays[relayId].votesCasted == relays[relayId].oracles.length) {
      relays[relayId].concluded = true;
      relays[relayId].approved = true;
      for (uint i = 0; i < relays[relayId].oracles.length; i++) {
        if(relays[relayId].oracleVotes[relays[relayId].oracles[i]] == false) {
          relays[relayId].approved = false;
          return;
        }
      }
      LogRelayConcluded(relayId, relays[relayId].relayer);
    }
  }
}
