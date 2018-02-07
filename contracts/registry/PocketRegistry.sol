pragma solidity ^0.4.11;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";
import "./NodeCrud.sol";

contract PocketRegistry is NodeCrud {

  // Address state
  address public owner = msg.sender;
  uint public creationTime = now;
  address public tokenAddress;
  address public delegateContract;
  address[] public previousDelegates;

  // List of registered Nodes
  address[] public registeredNodes;

  // This mapping keeps the records of this Registry.
  mapping(address => Node) nodeRecords;

  // Keeps a list of all keys to iterate the Node records.
  address[] public nodeRecordsIndex;

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
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, uint _index) {
    require(delegateContract.delegatecall(bytes4(sha3("registerNode()")), _nodeAddress, _supportedTokens, _url, _port, _index));
  }

  function createNodeContract(string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(delegateContract.delegatecall(bytes4(sha3("createNodeContract()")), _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // Updates the values of the given Node record.
  function updateNode(address _nodeAddress, string url) {
    require(delegateContract.delegatecall(bytes4(sha3("updateNode()")), _nodeAddress, url));
  }

  // Unregister a given Node record
  function unregisterNode(address _nodeAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("unregisterNode()")), _nodeAddress));
  }

  // Transfer ownership of a given record.
  function transfer(address _nodeAddress, address newOwner) {
    require(delegateContract.delegatecall(bytes4(sha3("transfer()")), _nodeAddress, newOwner));
  }

  // Tells whether a given Node key is registered.
  function isRegisteredNode(address _nodeAddress) returns(bool) {
    require(delegateContract.delegatecall(bytes4(sha3("isRegisteredNode()")), _nodeAddress));
  }

  function getNodeRecordAtIndex(uint rindex) returns(address key) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeRecordAtIndex()")), rindex));
  }

  // Returns the owner of the given record. The owner could also be get
  // by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeOwner(address _nodeAddress) returns(address) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeOwner()")), _nodeAddress));
  }

  // Returns the registration time of the given record. The time could also
  // be get by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeTime(address _nodeAddress) returns(uint) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeTime()")), _nodeAddress));
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
