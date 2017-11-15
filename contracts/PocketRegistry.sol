pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "./PocketToken.sol";
import "./PocketNode.sol";

contract PocketRegistry is BaseRegistry {

  /*mapping (address => address) registeredNodes;*/
  address[] public registeredNodes;
  function PocketRegistry() {
    // constructor
  }

  function registerBurn(address _tokenAddress, string _url) {
    PocketToken token = PocketToken(_tokenAddress);
    token.burn(1,msg.sender);
    register(msg.sender, _url);

    createNodeContract();
  }

  function createNodeContract () private {

    PocketNode newNode = new PocketNode();
    newNode.setOwner(msg.sender);
    registeredNodes.push(newNode);
    /*registeredNodes[msg.sender] = newNode.address;*/
  }

  function getNodes() constant returns (address[]) {
    return registeredNodes;
  }
}
