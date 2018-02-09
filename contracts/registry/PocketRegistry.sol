pragma solidity ^0.4;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";
import "./NodeCrud.sol";
import "./PocketRegistryState.sol";

contract PocketRegistry is NodeCrud, PocketRegistryState {

  // Funtions
  function PocketRegistry() public{
    owner = msg.sender;
  }

  function changeDelegate(address _newDelegate) public onlyOwner returns (bool) {
    if (_newDelegate != delegateContract) {
      previousDelegates.push(delegateContract);
      var oldDelegate = delegateContract;
      delegateContract = _newDelegate;
      DelegateChanged(oldDelegate, _newDelegate);
      return true;
    }
    return false;
  }


  // This is the function to create a new Node.
  function createNodeContract(bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public{
    require(delegateContract.delegatecall(bytes4(keccak256("createNodeContract(bytes8[],bytes32,bytes32,uint8,bool,bool)")), _supportedTokens, _url, _path, _port, _isRelayer, _isOracle));
  }
  
  // By registering a Node, you are agreeing to be a relayer in the Pocket Network.
  // Three actions happen - you burn some PKT, register in the registry, and a Node contract gets created and assigned to your address
  // Registry allows network to keep track of current live nodes
  function registerNode(address _nodeAddress, bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public{
    require(delegateContract.delegatecall(bytes4(keccak256("registerNode(address,bytes8[],bytes32,bytes32,uint8,bool,bool)")), _nodeAddress, _supportedTokens, _url, _path, _port, _isRelayer, _isOracle));
  }



  // Updates the values of the given Registered Node record.
  function updateNodeRecord(address _nodeAddress, bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public{
    require(delegateContract.delegatecall(bytes4(keccak256("updateNodeRecord(address,bytes8[],bytes32,bytes32,uint8,bool,bool)")), _nodeAddress, _supportedTokens, _url, _path, _port, _isRelayer, _isOracle));
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) public{
    require(delegateContract.delegatecall(bytes4(keccak256("transferNode(address,address)")), _nodeAddress, newOwner));
  }

  // Tells whether a given Node key is registered.
  function isRegisteredNode(address _nodeAddress) public returns(bool result) {
    return nodeRecords[_nodeAddress].time != 0;
  }

  function getNodeRecordAtIndex(uint _index) public returns(address key) {
    return nodeRecordsIndex[_index];
  }

  // Returns the owner of the given record. The owner could also be get
  // by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeOwner(address _nodeAddress) public returns(address) {
    return nodeRecords[_nodeAddress].owner;
  }

  // Returns the registration time of the given record. The time could also
  // be get by using the function getRecord but in that case all record attributes
  // are returned.
  function getNodeTime(address _nodeAddress) public returns(uint) {
    return nodeRecords[_nodeAddress].time;
  }

  function kill() onlyOwner public{
    require(delegateContract.delegatecall(bytes4(keccak256("kill()"))));
  }

  // Get list of nodes that are currently relaying transactions
  function getLiveNodes() public constant returns (address[]) {
    return nodeRecordsIndex;
  }

  function setTokenAddress(address _tokenAddress) public onlyOwner {
    tokenAddress = _tokenAddress;
  }

  function setNodeDelegateAddress(address _nodeDelegateAddress) public onlyOwner {
    nodeDelegateAddress = _nodeDelegateAddress;
  }

  // TODO: Define a new way to retrieve Oracles
  // This needs to return a fixed length array
  function getRelayOracles() public returns(address[] oracles) {
    address[] memory oracleRecords = new address[](5);

    for(uint i;i < 5;i++){
      oracleRecords[i] = (nodeRecordsIndex[i]);
    }
    return oracleRecords;
  }

}
