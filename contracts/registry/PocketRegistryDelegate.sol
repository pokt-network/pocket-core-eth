pragma solidity ^0.4.11;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate {

  // Address state
  address public owner;
  address public nodeDelegateAddress;
  address public tokenAddress;
  address public delegateContract;
  address[] public previousDelegates;

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

    registerNode(newNode.address, _supportedTokens, _url, _port, _isRelayer, _isOracle);

  }

  // This is the function that actually register a Node.
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(_nodeAddress);
    insertRelay(_nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle);
  }

  // Updates the values of the given Node record.
  function updateNodeRecord(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle, uint _index) {
    // Only the owner can update his record.
    require(nodeRecords[_nodeAddress].owner == msg.sender);
    updateNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle, uint _index);
  }

  // Unregister a given Node record
  function unregisterNodeRecord(address _nodeAddress) {
    // Only the owner can unregister his record.
    require(nodeRecords[_nodeAddress].owner == msg.sender);
    unregisterNode(address _nodeAddress);
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) {
    // Only the owner can transfer ownership of his record.
    require(nodeRecords[_nodeAddress].owner == msg.sender);
    transfer(_nodeAddress, newOwner);
    }

    // Tells whether a given Node key is registered.
    function isRegisteredNode(address _nodeAddress) returns(bool) {
      require(_nodeAddress);
      return isRegistered(_nodeAddress);
    }

    // Returns the Node record at the especified index.
    function getNodeRecordAtIndex(uint rindex) returns(address _nodeAddress) {
      require(rindex);
      return getNodeAtIndex(rindex);
    }

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeOwner(address _nodeAddress) returns(address owner) {
      require(_nodeAddress);
      return getOwner(_nodeAddress);
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeTime(address _nodeAddress) returns(uint time) {
      require(_nodeAddress);
      return getTime(_nodeAddress);
    }

    // Registry owner can use this function to withdraw any value owned by
    // the registry.
    function withdraw(address to, uint value) onlyOwner {
      if (!to.send(value)) revert();
    }

    function kill() onlyOwner {
      suicide(owner);
    }

    // Get list of nodes that are currently relaying transactions
    function getLiveNodes() constant returns (address[]) {
      return getRegisteredNodes();
    }

    function getCurrentNode() constant returns (address) {
      return getCurrent();
    }

    function setTokenAddress(address _tokenAddress) {
      assert(owner == msg.sender);
      tokenAddress = _tokenAddress;
    }

    function setNodeDelegateAddress(address _nodeDelegateAddress) {
      assert(owner == msg.sender);
      nodeDelegateAddress = _nodeDelegateAddress;
    }

  }
