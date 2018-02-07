pragma solidity ^0.4.11;

// This is the Node Create, Updated, Delete contract.
contract NodeCrud {

  // TODO: Update both record structures with the new properties
  // This struct keeps all data for a Node Record.
  struct Node {
      // Keeps the address of this record creator.
      address owner;
      // Keeps the time when this record was created.
      uint time;
      // Keeps the index of the keys array for fast lookup.
      uint keysIndex;
      // Keeps the node supported Tokens
      string8[] supportedTokens;
      // Keeps the url of the node.
      string url;
      // Keeps the port of the node.
      uint8 port;
      // Keeps the boolean for the node preference if is a relayer or not.
      bool isRelayer;
      // Keeps the boolean for the node preference if is a oracle or not.
      bool isOracle;
  }


}
