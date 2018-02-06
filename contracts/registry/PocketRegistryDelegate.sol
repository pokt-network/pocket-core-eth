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

  function createNodeContract(string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(_supportedTokens.count > 0);
    require(_url.length > 0);
    require(_port > 0);
    require(_isRelayer);
    require(_isOracle);

    tokenAddress.call(bytes4(sha3("burn(uint256,address)")),1,msg.sender);

    PocketNode newNode = new PocketNode();
    // TODO: nodeDelegateAddress should only get set once per upgrade
    newNode.supportedTokens(_supportedTokens);
    newNode.url(_url);
    newNode.port(_port);
    newNode.isRelayer(_isRelayer);
    newNode.isOracle(_isOracle);
    newNode.changeDelegate(nodeDelegateAddress);
    newNode.setOwner(msg.sender);
    newNode.setTokenAddress(tokenAddress);
    userNode[msg.sender] = newNode;

    registeredNodes.push(newNode);
    registerNode(newNode.address, newNode.supportedTokens, newNode.url, newNode.port, newNode.isRelayer, newNode.isOracle);

  }

  // This is the function that actually insert a record.
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    // TODO: Permissions
    // TODO: Dynamic burn amount
    // TODO: Check if address is already registered
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
        // TODO: throw a more distinctive message
        revert();
      }
    }

    // Updates the values of the given Node record.
    function updateNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle, uint _index) {
      // Only the owner can update his record.
      require(nodeRecords[_nodeAddress].owner == msg.sender)
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
      if (nodeRecords[_nodeAddress].owner == msg.sender) {
        nodeRecords[_nodeAddress].owner = newOwner;
        } else {
          revert();
        }
      }

      // Tells whether a given Node key is registered.
      function isRegisteredNode(address _nodeAddress) returns(bool) {
        return nodeRecords[key].time != 0;
      }

      function getNodeRecordAtIndex(uint rindex) returns(address _nodeAddress) {
        Record record = nodeRecords[nodeRecordsIndex[rindex]];
        _nodeAddress = nodeRecordsIndex[rindex];
        owner = record.owner;
        time = record.time;
        url = record.url;
      }

      // Returns the owner of the given record. The owner could also be get
      // by using the function getRecord but in that case all record attributes
      // are returned.
      function getNodeOwner(address _nodeAddress) returns(address owner) {
        return nodeRecords[_nodeAddress].owner;
      }

      // Returns the registration time of the given record. The time could also
      // be get by using the function getRecord but in that case all record attributes
      // are returned.
      function getNodeTime(address _nodeAddress) returns(uint time) {
        return nodeRecords[_nodeAddress].time;
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
        return registeredNodes;
      }

      function getCurrentNode () constant returns (address) {
        return userNode[msg.sender];
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
