pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "./PocketToken.sol";
import "./PocketNode.sol";
/*import "./PocketNodeBackend.sol";*/

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


  function registerBurn(address _tokenAddress, string _url) {

    // Permissions:
    // Check if address for relay already exists

    PocketToken token = PocketToken(_tokenAddress);
    token.burn(1,msg.sender);
    register(msg.sender, _url);

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
}
