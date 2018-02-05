pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistry is BaseRegistry {

// Address state
address public owner;
address public nodeDelegateAddress;
address public tokenAddress;
address public delegateContract;
address[] public previousDelegates;

// Node state
address[] public registeredNodes;
address[] public registeredOracles;
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
  /* function registerNode() {
    require(delegateContract.delegatecall(bytes4(sha3("registerNode()"))));
  } */

  function createNodeContract () {
    require(delegateContract.delegatecall(bytes4(sha3("createNodeContract()"))));
  }

  // Get list of nodes that are currently relaying transactions
  function getLiveNodes() constant returns (address[]) {
    return registeredNodes;
  }

  function getCurrentNode () constant returns (address) {
    return userNode[msg.sender];
  }

  function setTokenAddress(address _tokenAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress));
  }
  function setNodeDelegateAddress(address _nodeDelegateAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setNodeDelegateAddress(address)")), _nodeDelegateAddress));
  }


}
