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
    require(owner == msg.sender);

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
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("registerNode()")), _nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // This is the function to create a new Node.
  function createNodeContract(string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) onlyOwner{
    require(delegateContract.delegatecall(bytes4(sha3("createNodeContract()")), _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // Updates the values of the given Registered Node record.
  function updateNodeRecord(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("updateNodeRecord()")), _nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // Unregister a given Node record
  function unregisterNodeRecord(address _nodeAddress) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("unregisterNodeRecord()")), _nodeAddress));
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("transferNode()")), _nodeAddress, newOwner));
  }

  // Tells whether a given Node key is registered.
  function isRegisteredNode(address _nodeAddress) returns(bool) {
    require(delegateContract.delegatecall(bytes4(sha3("isRegisteredNode()")), _nodeAddress));
  }

  function getNodeRecordAtIndex(uint _index) returns(address key) {
    require(delegateContract.delegatecall(bytes4(sha3("getNodeRecordAtIndex()")), _index));
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

  function kill() onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("kill()"))));
  }

  // Get list of nodes that are currently relaying transactions
  function getLiveNodes() constant returns (address[]) {
    require(delegateContract.delegatecall(bytes4(sha3("getLiveNodes()"))));
  }

  function setTokenAddress(address _tokenAddress) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress));
  }
  function setNodeDelegateAddress(address _nodeDelegateAddress) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("setNodeDelegateAddress(address)")), _nodeDelegateAddress));
  }

}
