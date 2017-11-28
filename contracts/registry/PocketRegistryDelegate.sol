pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate is BaseRegistry {

  // Address state
  address public owner;
  address public nodeDelegateAddress;
  address public tokenAddress;
  address public delegateContract;
  address[] public previousDelegates;

  // Node state
  address[] public registeredNodes;
  mapping (address => address) public userNode;

  function PocketRegistryDelegate() {
    owner = msg.sender;
  }

  function registerNode() {

    // TODO: Permissions
    // TODO: Check if address for relay already exists
    // TODO: Dynamic burn amount
    // TODO: Check if address is already registered
    tokenAddress.call(bytes4(sha3("burn(uint256,address)")),1,msg.sender);
    // TODO: instead of using a URL, we need to fetch the node metadata from the node contract
    register(msg.sender, "URL");

    // TODO: Return the newly created Node
    // Cannot return values due to delegatecall limitations. See https://ethereum.stackexchange.com/questions/8099/delegatecall-and-function-return-values
    createNodeContract();
  }

  function createNodeContract () private {

    PocketNode newNode = new PocketNode();
    // TODO: nodeDelegateAddress should only get set once per upgrade
    newNode.changeDelegate(nodeDelegateAddress);
    newNode.setOwner(msg.sender);
    newNode.setTokenAddress(tokenAddress);
    userNode[msg.sender] = newNode;
    registeredNodes.push(newNode);
  }

  function getLiveNodes() constant returns (address[]) {
    return registeredNodes;
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
