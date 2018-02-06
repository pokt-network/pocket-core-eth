pragma solidity ^0.4.11;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate is PocketRegistry {

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
    registerNode(newNode.address, newNode.supportedTokens, newNode.url, newNode.port, newNode.isRelayer, newNode.isOracle, registeredNodes.length);

  }

  // This is the function that actually insert a record.
  function registerNode(address key, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle, uint _index) {
    // TODO: Permissions
    // TODO: Dynamic burn amount
    // TODO: Check if address is already registered
    if (nodeRecords[key].time == 0) {
      nodeRecords[key].time = now;
      nodeRecords[key].owner = msg.sender;
      nodeRecords[key].keysIndex = nodeKeys.length;
      nodeKeys.length++;
      nodeKeys[nodeKeys.length - 1] = nodeKeys;
      nodeRecords[key].supportedTokens = _supportedTokens;
      nodeRecords[key].url = _url;
      nodeRecords[key].port = _port;
      nodeRecords[key].isRelayer = _isRelayer;
      nodeRecords[key].isOracle = _isOracle;
      numNodeRecords++;
      } else {
        delete registeredNodes[_index];
        // TODO: throw a more distinctive message
        revert();
      }
    }

    // Updates the values of the given Node record.
    function updateNode(address key, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle, uint _index) {
      // Only the owner can update his record.
      require(nodeRecords[key].owner == msg.sender)
      nodeRecords[key].supportedTokens = _supportedTokens;
      nodeRecords[key].url = _url;
      nodeRecords[key].port = _port;
      nodeRecords[key].isRelayer = _isRelayer;
      nodeRecords[key].isOracle = _isOracle;
      numNodeRecords++;
    }

    // Unregister a given Node record
    function unregisterNode(address key) {
      if (nodeRecords[key].owner == msg.sender) {
        uint keysIndex = nodeRecords[key].keysIndex;
        delete nodeRecords[key];
        numNodeRecords--;
        nodeKeys[keysIndex] = nodeKeys[nodeKeys.length - 1];
        nodeRecords[nodeKeys[keysIndex]].keysIndex = keysIndex;
        nodeKeys.length--;
      }
    }

    // Transfer ownership of a given record.
    function transfer(address key, address newOwner) {
      if (nodeRecords[key].owner == msg.sender) {
        nodeRecords[key].owner = newOwner;
        } else {
          revert();
        }
      }

      // Tells whether a given Node key is registered.
      function isRegisteredNode(address key) returns(bool) {
        return nodeRecords[key].time != 0;
      }

      function getNodeRecordAtIndex(uint rindex) returns(address key, address owner, uint time, string url) {
        Record record = nodeRecords[nodeKeys[rindex]];
        key = nodeKeys[rindex];
        owner = record.owner;
        time = record.time;
        url = record.url;
      }

      function getNodeRecord(address key) returns(address owner, uint time, string url) {
        Record record = nodeRecords[key];
        owner = record.owner;
        time = record.time;
        url = record.url;
      }

      // Returns the owner of the given record. The owner could also be get
      // by using the function getRecord but in that case all record attributes
      // are returned.
      function getNodeOwner(address key) returns(address) {
        return nodeRecords[key].owner;
      }

      // Returns the registration time of the given record. The time could also
      // be get by using the function getRecord but in that case all record attributes
      // are returned.
      function getNodeTime(address key) returns(uint) {
        return nodeRecords[key].time;
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
