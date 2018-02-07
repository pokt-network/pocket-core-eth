pragma solidity ^0.4;

library NodeModels {
  // Structs
  struct Relay {
    bytes32 txHash;
    bytes txTokenId;
    address sender;
    address relayer;
    address[] oracleAddresses;
    mapping (address => bool) oracles;
    mapping (address => bool) oracleVotes;
    bool approved;
    bool concluded;
    uint id;
    uint votesCasted;
  }
}
