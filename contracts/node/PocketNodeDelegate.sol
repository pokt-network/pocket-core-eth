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
    relayerNode.updateRelayOracleVote(_relayId, _vote);
    if(relayerNode.isRelayConcludedAndApproved(_relayId)) {
      relayerNode.increaseACRelaysCount();
      increaseACVRelaysCount();
      tokenInterface.increaseCurrentEpochRelayCount();
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
