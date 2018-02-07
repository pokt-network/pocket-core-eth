pragma solidity ^0.4.11;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate {

  // Attributes
  address public nodeDelegateAddress;

  // Node state
  mapping (address => address) public userNode;

  function PocketRegistryDelegate() {
    owner = msg.sender;
  }

  // This is the function to create a new Node.
  function createNodeContract(string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(_supportedTokens.count > 0);
    require(_url.length > 0);
    require(_port > 0);
    require(_isRelayer);
    require(_isOracle);

    tokenAddress.call(bytes4(sha3("burn(uint256,address)")),1,msg.sender);

    PocketNode newNode = new PocketNode(msg.sender, nodeDelegateAddress, tokenAddress, _isRelayer, _isOracle);
    userNode[msg.sender] = newNode;

    registerNode(newNode, _supportedTokens, _url, _port, _isRelayer, _isOracle);

  }

  // This is the function that actually register a Node.
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(_nodeAddress);
    insertNode(_nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle);
  }

  // Updates the values of the given Node record.
  function updateNodeRecord(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    // Only the owner can update his record.
    updateNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle);
  }

  // Unregister a given Node record
  function unregisterNodeRecord(address _nodeAddress) {
    // Only the owner can unregister his record.
    unregisterNode(address _nodeAddress);
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) {
    // Only the owner can transfer ownership of his record.
    transfer(_nodeAddress, newOwner);
    }

    // Tells whether a given Node key is registered.
    function isRegisteredNode(address _nodeAddress) returns(bool) {
      return isRegistered(_nodeAddress);
    }

    // Returns the Node record at the especified index.
    function getNodeRecordAtIndex(uint _index) returns(address _nodeAddress) {
      return getNodeAtIndex(_index);
    }

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeOwner(address _nodeAddress) returns(address owner) {
      return getOwner(_nodeAddress);
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeTime(address _nodeAddress) returns(uint time) {
      return getTime(_nodeAddress);
    }

    function kill() {
      suicide(owner);
    }

    // Get list of nodes that are currently relaying transactions
    function getLiveNodes() constant returns (address[]) {
      return getRegisteredNodes();
    }

    function setTokenAddress(address _tokenAddress) {
      tokenAddress = _tokenAddress;
    }

    function setNodeDelegateAddress(address _nodeDelegateAddress) {
      nodeDelegateAddress = _nodeDelegateAddress;
    }

  }
