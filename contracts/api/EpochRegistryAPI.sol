pragma solidity ^0.4.18;

import "./BaseAPI.sol";
import "../interfaces/EpochRegistry.sol";
import "../interfaces/ContractDirectory.sol";
import "../interfaces/NodeRegistry.sol";

contract EpochRegistryAPI is EpochRegistry, BaseAPI {
    // Events
    event EpochStarted(uint256 _nonce, uint256 _blockStart, uint256 _blockEnd);
    event RelayAddedToEpoch(bytes32 _relayNonce, bytes8 _token, bytes32 _txHash, address _sender, bytes32 _nodeNonce, uint256 _epoch);
    event RelayVerified(uint256 _epoch, bytes32 _relayNonce, bytes32 _nodeNonce, bool _verificationResult);

    // Functions
    /*
     * @dev Adds a Relay to the current epoch indicated in the state of this contract.
     * @param bytes8 _token - The token id of the transaction (BTC, ETH, LTC, etc).
     * @param bytes32 _txHash - The tx hash of this relay
     * @param address _sender - Sender of the relay
     * @param bytes32 _nodeNonce - The nonce pertaining to the Node doing this relay
     */
    function addRelayToCurrentEpoch(bytes8 _token, bytes32 _txHash, address _sender, bytes32 _nodeNonce) public returns(bytes32) {
        require(_sender != address(0x0));
        NodeRegistry nodeRegistry = NodeRegistry(ContractDirectory(contractDirectory).getContract("NodeRegistry"));
        require(nodeRegistry.getNodeOwner(_nodeNonce) == msg.sender);
        Models.Epoch storage currentEpochInstance = epochs[currentEpoch];
        if(epochsIndex.length == 0 || block.number > currentEpochInstance.blockEnd) {
            insertEpoch();
            currentEpochInstance = epochs[currentEpoch];
        }
        Models.Relay memory relay = Models.Relay(_token, _txHash, _sender, _nodeNonce);
        bytes32 relayNonce = keccak256(_token, _txHash, _sender);
        currentEpochInstance.relays[relayNonce] = relay;
        currentEpochInstance.relaysPerNode[_nodeNonce].push(relayNonce);
        RelayAddedToEpoch(relayNonce, _token, _txHash, _sender, _nodeNonce, currentEpoch);
        return relayNonce;
    }
    /*
     * @dev Adds a verification of whether or not a given Relay was succesfully executed or not.
     *      The condition to be able to verify a Relay, is being a Node that executed another Relay
     *      in the same Epoch.
     * @param uint256 _epoch - The epoch where the relay happened.
     * @param bytes32 _relayNonce - The nonce of the relay being verified
     * @param bytes32 _nodeNonce - The nonce of the node submitting the verification
     * @param bool _verificationResult - The result of this verification
     */
    function verifyRelayInEpoch(uint256 _epoch, bytes32 _relayNonce, bytes32 _nodeNonce, bool _verificationResult) public {
        Models.Epoch storage epoch = epochs[_epoch];
        require(epoch.relays[_relayNonce].txHash != bytes32(0));
        NodeRegistry nodeRegistry = NodeRegistry(ContractDirectory(contractDirectory).getContract("NodeRegistry"));
        require(nodeRegistry.getNodeOwner(_nodeNonce) == msg.sender);
        uint256 verifierRelayCount = epoch.relaysPerNode[_nodeNonce].length;
        require(verifierRelayCount > 0);
        epoch.relays[_relayNonce].verifications[_nodeNonce] = _verificationResult;
        RelayVerified(_epoch, _relayNonce, _nodeNonce, _verificationResult);
    }

    /*
     * @dev Registers the next epoch
     */
    function insertEpoch() internal {
        epochs[epochsIndex.length] = Models.Epoch(epochsIndex.length, block.number, block.number + blocksPerEpoch);
        epochsIndex.push(epochs[epochsIndex.length].nonce);
        currentEpoch = epochs[epochsIndex.length - 1].nonce;
        EpochStarted(epochs[currentEpoch].nonce, epochs[currentEpoch].blockStart, epochs[currentEpoch].blockEnd);
    }

    /*
     * @dev Sets the blocksPerEpoch state variable
     */
    function setBlocksPerEpoch(uint256 _blocksPerEpoch) public onlyOwner {
        blocksPerEpoch = _blocksPerEpoch;
    }

    /*
     * @dev Checks wheter or not a relay exists with the given nonce at the given Epoch
     * @param bytes32 _relayNonce
     * @param uint256 _epochNonce
     */
     function isRelayAtEpoch(bytes32 _relayNonce, uint256 _epochNonce) public view returns(bool) {
        Models.Epoch storage epochInstance = epochs[_epochNonce];
        return epochInstance.relays[_relayNonce].txHash != 0;
     }
}
