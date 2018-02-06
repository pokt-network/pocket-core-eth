pragma solidity ^0.4.11;

contract RelayCrud {
  // Attributes
  mapping(bytes32 => Relay) private relays;
  bytes32[] private relayIndex;
  // Structs
  struct Relay {
    address[] oracles;
    bytes32 txHash;
    bytes txTokenId;
    address sender;
    address node;
    mapping(address => bool) oracleVotes;
    uint epoch;
  }
  // Events
  event LogNewRelay();
  //  Functions
}
