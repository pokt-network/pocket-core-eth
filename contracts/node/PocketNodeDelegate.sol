pragma solidity ^0.4;

import "./PocketNodeState.sol";
import "./RelayCrud.sol";
import "../interfaces/PocketNodeInterface.sol";

contract PocketNodeDelegate is RelayCrud, PocketNodeState {
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
    require(PocketTokenInterface(_pocketTokenAddress).canRelayOrReset(_sender) == true);
    // Insert the relay record
    insertRelay(registryInterface.getRelayOracles(), _txHash, _txTokenId, _sender);
  }

  /**
   * Submits a relay vote from an oracle
   * @param {address} _relayer - The address of the relayer of the transaction
   * @param {bytes32} _relayId - The id of the relay to vote on
   * @param {bool} _vote - Whether or not the transaction was succesfully relayed
   */
  function submitRelayVote(address _relayer, bytes32 _relayId, bool _vote) {
    PocketNodeInterface relayerNode = PocketNodeInterface(_relayer);
    NodeModels.Relay storage relay = relayerNode.getRelay(_relayId);

    // Requirements to vote
    require(relays[_relayId].votesCasted < relays[_relayId].oracleAddresses.length);
    require(relays[_relayId].oracles[msg.sender] == true);

    // Update votes
    relays[_relayId].oracleVotes[msg.sender] = _vote;
    relays[_relayId].votesCasted += 1;

    // If this is the final vote to be casted, then mark the relay as concluded
    if(relays[_relayId].votesCasted == relays[_relayId].oracleAddresses.length) {
      relays[_relayId].concluded = true;

      // Determines wheter or not the relay was approved by all oracles
      // TO-DO: Determine partial votes
      relays[_relayId].approved = true;
      for (uint i = 0; i < relays[_relayId].oracleAddresses.length; i++) {
        if(relays[_relayId].oracleVotes[relays[_relayId].oracleAddresses[i]] == false) {
          relays[_relayId].approved = false;
          return;
        }
      }

      // Increases counts
      if(relays[_relayId].concluded == true && relays[_relayId].approved == true) {
        relayerNode.increaseACRelaysCount();
        increaseACVRelaysCount();
      }

      // Increase the global count of relays in the current epoch
      tokenInterface.increaseEpochCount(tokenInterface.globalEpochCount);

      // Emit LogRelayConcluded event
      LogRelayConcluded(_relayId, relays[_relayId]._relayer);
    }
  }

  /**
   * @dev Increases the count of approved and concluded relays done by this node
   */
  // TO-DO: Add permissions to this
  function increaseACRelaysCount() public {
    aCRelaysCount += 1;
  }

  /**
   * @dev Increases the count of approved and concluded relays verified by this node
   */
  // TO-DO: Add permissions to this
  function increaseACVRelaysCount() public {
    aCVRelaysCount += 1;
  }
}
