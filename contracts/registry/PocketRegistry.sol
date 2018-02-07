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

  function changeDelegate(address _newDelegate) returns (bool) onlyOwner {
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
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(delegateContract.delegatecall(bytes4(sha3("registerNode(address,string8[],string,uint8,bool,bool)")), _nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // This is the function to create a new Node.
  function createNodeContract(string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(delegateContract.delegatecall(bytes4(sha3("createNodeContract(string8[],string,uint8,bool,bool)")), _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // Updates the values of the given Registered Node record.
  function updateNodeRecord(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(delegateContract.delegatecall(bytes4(sha3("updateNodeRecord(address,string8[],string,uint8,bool,bool)")), _nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle));
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) {
    require(delegateContract.delegatecall(bytes4(sha3("transferNode(address,address)")), _nodeAddress, newOwner));
  }

  // Tells whether a given Node key is registered.
  function isRegisteredNode(address _nodeAddress) returns(bool bool) {
    return nodeRecords[key].time != 0;
  }

  function getNodeRecordAtIndex(uint _index) returns(address key) {
    return nodeRecordsIndex[_index];
  }

  // Returns the owner of the given record. The owner could also be get
  // by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeOwner(address _nodeAddress) returns(address) {
    return nodeRecords[_nodeAddress].owner;
  }

  // Returns the registration time of the given record. The time could also
  // be get by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeTime(address _nodeAddress) returns(uint) {
    return nodeRecords[_nodeAddress].time;
  }

  function kill() onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("kill()"))));
  }

  // Get list of nodes that are currently relaying transactions
  function getLiveNodes() constant returns (address[]) {
    return nodeRecordsIndex;
  }

  function setTokenAddress(address _tokenAddress) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress));
  }
  function setNodeDelegateAddress(address _nodeDelegateAddress) onlyOwner {
    require(delegateContract.delegatecall(bytes4(sha3("setNodeDelegateAddress(address)")), _nodeDelegateAddress));
  }

}
