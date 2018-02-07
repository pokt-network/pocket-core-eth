pragma solidity ^0.4.11;

// This is the Node Create, Updated, Delete contract.
contract NodeCrud {

  // List of registered Nodes
  address[] public registeredNodes;

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

  // This is the function that actually inserts a record.
  function insertNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle){
    // TODO: Permissions
    // TODO: Dynamic burn amount

    if (nodeRecords[_nodeAddress].time == 0) {
      nodeRecords[_nodeAddress].time = now;
      nodeRecords[_nodeAddress].owner = msg.sender;
      nodeRecords[_nodeAddress].keysIndex = nodeRecordsIndex.length;
      nodeRecordsIndex.length++;
      nodeRecordsIndex[nodeRecordsIndex.length - 1] = nodeRecordsIndex;
      nodeRecords[_nodeAddress].supportedTokens = _supportedTokens;
      nodeRecords[_nodeAddress].url = _url;
      nodeRecords[_nodeAddress].port = _port;
      nodeRecords[_nodeAddress].isRelayer = _isRelayer;
      nodeRecords[_nodeAddress].isOracle = _isOracle;
      } else {
        delete registeredNodes[registeredNodes.length - 1];
      }
    }

    // Updates the values of the given Node record.
    function updateNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle, uint _index) {
      nodeRecords[_nodeAddress].supportedTokens = _supportedTokens;
      nodeRecords[_nodeAddress].url = _url;
      nodeRecords[_nodeAddress].port = _port;
      nodeRecords[_nodeAddress].isRelayer = _isRelayer;
      nodeRecords[_nodeAddress].isOracle = _isOracle;
    }

    // Unregister a given Node record
    function unregisterNode(address _nodeAddress) {
      if (nodeRecords[_nodeAddress].owner == msg.sender) {
        uint keysIndex = nodeRecords[_nodeAddress].keysIndex;
        delete nodeRecords[_nodeAddress];
        nodeRecordsIndex[keysIndex] = nodeRecordsIndex[nodeRecordsIndex.length - 1];
        nodeRecords[nodeRecordsIndex[keysIndex]].keysIndex = keysIndex;
        nodeRecordsIndex.length--;
      }
    }

    // Transfer ownership of a given record.
    function transfer(address _nodeAddress, address newOwner) {
        nodeRecords[_nodeAddress].owner = newOwner;
    }

    // Tells whether a given Node key is registered.
    function isRegistered(address _nodeAddress) constant returns(bool) {
      return nodeRecords[key].time != 0;
    }

    // Returns the Node record at the especified index.
    function getNodeAtIndex(uint rindex) constant returns(address _nodeAddress) {
      return nodeRecordsIndex[rindex];
    }

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getOwner(address _nodeAddress) constant returns(address owner) {
      return nodeRecords[_nodeAddress].owner;
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getTime(address _nodeAddress) returns(uint time) {
      return nodeRecords[_nodeAddress].time;
    }

    // Get list of nodes that are currently relaying transactions
    function getRegisteredNodes() constant returns (address[]) {
      return registeredNodes;
    }
    // Get Current Node
    function getCurrent() constant returns (address) {
      return userNode[msg.sender];
    }

  }
