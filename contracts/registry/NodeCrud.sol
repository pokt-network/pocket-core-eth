pragma solidity ^0.4.11;

// This is the Node Create, Updated, Delete contract.
contract NodeCrud {

  // This mapping keeps the records of this Registry.
  mapping(address => Node) nodeRecords;

  // Keeps a list of all keys to iterate the Node records.
  address[] public nodeRecordsIndex;

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
    bytes8[] supportedTokens;
    // Keeps the url of the node.
    bytes32 url;
    // Keeps the url path of the node.
    bytes32 path;
    // Keeps the port of the node.
    uint8 port;
    // Keeps the boolean for the node preference if is a relayer or not.
    bool isRelayer;
    // Keeps the boolean for the node preference if is a oracle or not.
    bool isOracle;
  }

  // This is the function that actually inserts a record.
  function insertNode(address _nodeAddress, bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public{
    // TODO: Permissions
    // TODO: Dynamic burn amount

    require(nodeRecords[_nodeAddress].time == 0);
    nodeRecords[_nodeAddress].time = now;
    nodeRecords[_nodeAddress].owner = msg.sender;
    nodeRecords[_nodeAddress].keysIndex = nodeRecordsIndex.push(_nodeAddress) - 1;
    nodeRecords[_nodeAddress].supportedTokens = _supportedTokens;
    nodeRecords[_nodeAddress].url = _url;
    nodeRecords[_nodeAddress].path = _path;
    nodeRecords[_nodeAddress].port = _port;
    nodeRecords[_nodeAddress].isRelayer = _isRelayer;
    nodeRecords[_nodeAddress].isOracle = _isOracle;

  }

  // Updates the values of the given Node record.
  function updateNode(address _nodeAddress, bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public{
    nodeRecords[_nodeAddress].supportedTokens = _supportedTokens;
    nodeRecords[_nodeAddress].url = _url;
    nodeRecords[_nodeAddress].path = _path;
    nodeRecords[_nodeAddress].port = _port;
    nodeRecords[_nodeAddress].isRelayer = _isRelayer;
    nodeRecords[_nodeAddress].isOracle = _isOracle;
  }

  // Transfer ownership of a given record.
  function transfer(address _nodeAddress, address newOwner) public{
    nodeRecords[_nodeAddress].owner = newOwner;
  }

}
