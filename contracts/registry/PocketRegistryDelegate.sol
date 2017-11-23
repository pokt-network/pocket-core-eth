pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "../token/PocketToken.sol";
import "../node/PocketNode.sol";


contract PocketRegistryDelegate {

//address public owner;
address public nodeDelegateAddress;
address[] public registeredNodes;

address public delegateContract;
address[] public previousDelegates;
uint256 public count;
address public tokenAddress;
string[] public strings;

  function PocketRegistryDelegate() {
    // constructor
  }

  // TODO: instead of using a URL, we need to fetch the node metadata from the node contract
  function registerNode() {

    // TODO: Permissions
    // Check if address for relay already exists

    count += 1;



    //PocketToken token = PocketToken(tokenAddress);
    // address newTokenAddress = tokenAddress;
    //tokenAddress.call(bytes4(sha3("burn(uint256,address)")),1,msg.sender);
    // TODO: Figure out burn amount
    // TODO: Check if address is already registered

    //token.burn(1,msg.sender);
    //register(msg.sender, "string");

    // TODO: Return the newly created Node
    //createNodeContract();
  }

  function createNodeContract () {

    PocketNode newNode = new PocketNode();
    /*newNode.changeDelegate(nodeDelegateAddress);
    newNode.setOwner(msg.sender);
    newNode.setTokenAddress(tokenAddress);
    registeredNodes.push(newNode);*/

    /*newNode.call(bytes4(sha3("changeDelegate(address)")), nodeDelegateAddress);
    newNode.call(bytes4(sha3("setOwner(address)")), msg.sender);
    newNode.call(bytes4(sha3("changeDelegate(address)")), tokenAddress);*/

    registeredNodes.push(newNode);
  }

  function getNodes() constant returns (address[]) {
    return registeredNodes;
  }

  function setTokenAddress(address _tokenAddress) {
    tokenAddress = _tokenAddress;
  }

  function setNodeDelegateAddress(address _nodeDelegateAddress) {
    /*assert(owner == msg.sender);*/
    nodeDelegateAddress = _nodeDelegateAddress;
  }

}
