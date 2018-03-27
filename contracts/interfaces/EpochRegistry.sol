pragma solidity ^0.4.18;

import "../Models.sol";

contract EpochRegistry {
    // State
    mapping (uint256 => Models.Epoch) public epochs;
    uint256[] public epochsIndex;
    uint256 public currentEpoch;
    uint256 public blocksPerEpoch;

    // Functions
    /*
     * @dev Adds a Relay to the current epoch indicated in the state of this contract.
     * @param bytes32 _txHash - The tx hash of this relay
     * @param address _sender - Sender of the relay
     * @param bytes32 _nodeNonce - The nonce pertaining to the Node doing this relay
     */
    function addRelayToCurrentEpoch(bytes8 _token, bytes32 _txHash, address _sender, bytes32 _nodeNonce) public returns(bytes32) {}
    /*
     * @dev Adds a verification of whether or not a given Relay was succesfully executed or not.
     *      The condition to be able to verify a Relay, is being a Node that executed another Relay
     *      in the same Epoch.
     * @param uint256 _epoch - The epoch where the relay happened.
     * @param bytes32 _relayTx - The relay that was verified
     * @param bytes32 _nodeNonce - The nonce of the node sending the verification result
     * @param bool _verificationResult - The result of this verification
     */
    function verifyRelayInEpoch(uint256 _epoch, bytes32 _relayNonce, bytes32 _nodeNonce, bool _verificationResult) public {}
}
