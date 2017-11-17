pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "./PocketToken.sol";
import "./PocketNode.sol";

contract PocketRegistry is BaseRegistry {

address[] public registeredNodes;

address public delegateContract;
address[] public previousDelegates;

  function PocketRegistry() {
    // constructor
  }


  function registerBurn(address _tokenAddress, string _url) {

    // Permissions
    PocketToken token = PocketToken(_tokenAddress);
    token.burn(1,msg.sender);
    register(msg.sender, _url);

    createNodeContract(_tokenAddress);
  }

  function createNodeContract (address _tokenAddress) private {

    PocketNode newNode = new PocketNode();
    newNode.setOwner(msg.sender);
    newNode.setTokenAddress(_tokenAddress);
    registeredNodes.push(newNode);
    /*registeredNodes[msg.sender] = newNode.address;*/
  }

  function getNodes() constant returns (address[]) {
    return registeredNodes;
  }
}
