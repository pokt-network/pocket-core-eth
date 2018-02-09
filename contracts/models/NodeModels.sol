pragma solidity ^0.4;

library NodeModels {
  // Structs
  struct Relay {
    bytes32 txHash;
    bytes txTokenId;
    address sender;
    address relayer;
    address[5] oracleAddresses;
    mapping (address => bool) oracles;
    mapping (address => bool) oracleVotes;
    mapping (address => bool) oracleVoted;
    bool approved;
    bool concluded;
    uint votesCasted;
    uint index;
  }
}
