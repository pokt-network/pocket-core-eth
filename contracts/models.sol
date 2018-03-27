pragma solidity ^0.4.18;

library Models {

    struct Relay {
        bytes8 token;
        bytes32 txHash;
        address sender;
        bytes32 nodeNonce;
        mapping (bytes32 => bool) verifications;
    }

    struct Epoch {
        uint256 nonce;
        uint256 blockStart;
        uint256 blockEnd;
        mapping (bytes32 => Relay) relays;
        mapping (bytes32 => bytes32[]) relaysPerNode;
    }

    struct Node {
        bytes32 nonce;
        address owner;
        bytes8[] networks;
        string endpoint;
    }

}
