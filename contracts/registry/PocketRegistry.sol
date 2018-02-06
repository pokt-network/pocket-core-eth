pragma solidity ^0.4.11;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";
import "./NodeCrud.sol";

contract PocketRegistry is NodeCrud {

  // Address state
  address public owner = msg.sender;
  uint public creationTime = now;
  address public nodeDelegateAddress;
  address public tokenAddress;
  address public delegateContract;
  address[] public previousDelegates;

  // List of registered Nodes
  address[] public registeredNodes;

  // This mapping keeps the records of this Registry.
  mapping(address => Node) nodeRecords;

  // Keeps the total numbers of Node records in this Registry.
  uint public numNodeRecords;

  // Keeps a list of all keys to iterate the Node records.
  address[] public nodeKeys;

  modifier onlyOwner {
    if (msg.sender != owner) revert();
    _;
  }

  // Node state
  mapping (address => address) public userNode;

  event DelegateChanged(address oldAddress, address newAddress);

  function PocketRegistry() {
    // constructor
    owner = msg.sender;
  }

  function changeDelegate(address _newDelegate) returns (bool) {
    //assert(owner == msg.sender);

    if (_newDelegate != delegateContract) {
      previousDelegates.push(delegateContract);
      var oldDelegate = delegateContract;
      delegateContract = _newDelegate;
      DelegateChanged(oldDelegate, _newDelegate);
      return true;
    }
    return false;

  }

  // By registering a Node, you are agreeing to be a relayer in the Pocket Network.
  // Three actions happen - you burn some PKT, register in the registry, and a Node contract gets created and assigned to your address
  // Registry allows network to keep track of current live nodes
  function registerNode(address _key, string[] _supportedTokens, string _url, uint8 _port, uint _index) {
    require(delegateContract.delegatecall(bytes4(sha3("registerNode()")), _key, _supportedTokens, _url, _port, _index));
  }

  function createNodeContract(string[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(delegateContract.delegatecall(bytes4(sha3("createNodeContract()")), _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // Updates the values of the given Node record.
  function updateNode(address key, string url) {
    require(delegateContract.delegatecall(bytes4(sha3("updateNode()")), key, url));
  }

  // Unregister a given Node record
  function unregisterNode(address key) {
    require(delegateContract.delegatecall(bytes4(sha3("unregisterNode()")), key));
  }

  // Transfer ownership of a given record.
  function transfer(address key, address newOwner) {
    require(delegateContract.delegatecall(bytes4(sha3("transfer()")), key, newOwner));
  }

  // Tells whether a given Node key is registered.
  function isRegisteredNode(address key) returns(bool) {
    require(delegateContract.delegatecall(bytes4(sha3("isRegisteredNode()")), key));
  }

  function getNodeRecordAtIndex(uint rindex) returns(address key, address owner, uint time, string url) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeRecordAtIndex()")), rindex));
  }

  function getNodeRecord(address key) returns(address owner, uint time, string url) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeRecord()")), key));
  }

  // Returns the owner of the given record. The owner could also be get
  // by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeOwner(address key) returns(address) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeOwner()")), key));
  }

  // Returns the registration time of the given record. The time could also
  // be get by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeTime(address key) returns(uint) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeTime()")), key));
  }

  // Registry owner can use this function to withdraw any value owned by
  // the registry.
  function withdraw(address to, uint value) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("withdraw()")), to, value));
  }

  function kill() onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("kill()"))));
  }

  // Get list of nodes that are currently relaying transactions
  function getLiveNodes() constant returns (address[]) {
    require(delegateContract.delegatecall(bytes4(sha3("getLiveNodes()"))));
  }

  function getCurrentNode() constant returns (address) {
    require(delegateContract.delegatecall(bytes4(sha3("getCurrentNode()"))));
  }

  function setTokenAddress(address _tokenAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress));
  }
  function setNodeDelegateAddress(address _nodeDelegateAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setNodeDelegateAddress(address)")), _nodeDelegateAddress));
  }

}
