pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate is BaseRegistry {
address public owner;
address public nodeDelegateAddress;
address[] public registeredNodes;

address public delegateContract;
address[] public previousDelegates;

  function PocketRegistryDelegate() {
    // constructor
    owner = msg.sender;
  }

  // TODO: instead of using a URL, we need to fetch the node metadata from the node contract
  function registerBurn(address _tokenAddress, string _url) {

    // TODO: Permissions
    // Check if address for relay already exists

    PocketToken token = PocketToken(_tokenAddress);

    // TODO: Figure out burn amount
    // TODO: Check if address is already registered
    token.burn(1,msg.sender);
    register(msg.sender, _url);

    // TODO: Return the newly created Node
    createNodeContract(_tokenAddress);
  }

  function createNodeContract (address _tokenAddress) private {

    PocketNode newNode = new PocketNode();
    newNode.changeDelegate(nodeDelegateAddress);
    newNode.setOwner(msg.sender);
    newNode.setTokenAddress(_tokenAddress);
    registeredNodes.push(newNode);
    /*registeredNodes[msg.sender] = newNode.address;*/
  }

  function getNodes() constant returns (address[]) {
    return registeredNodes;
  }

  function setNodeDelegateAddress(address _nodeDelegateAddress) {
    assert(owner == msg.sender);
    nodeDelegateAddress = _nodeDelegateAddress;
  }

  function foo() {

  }
}
