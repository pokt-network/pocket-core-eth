pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistry is BaseRegistry {
  address public owner;
  address public nodeDelegateAddress;
  address[] public registeredNodes;

  address public delegateContract;
  address[] public previousDelegates;

  event DelegateChanged(address oldAddress, address newAddress);

  function PocketRegistry() {
    // constructor
    owner = msg.sender;
  }

  function changeDelegate(address _newDelegate) returns (bool) {
    assert(owner == msg.sender);

    if (_newDelegate != delegateContract) {

        previousDelegates.push(delegateContract);
        var oldDelegate = delegateContract;
        delegateContract = _newDelegate;
        DelegateChanged(oldDelegate, _newDelegate);
        return true;
      }
    return false;

}

  function registerBurn(address _tokenAddress, string _url) {
    delegateContract.delegatecall(bytes4(sha3("registerBurn(address,string)")), _tokenAddress, _url);
  }

  /*function createNodeContract (address _tokenAddress) private {
    delegateContract.delegatecall(bytes4(sha3("createNodeContract(address)")),);
  }*/

  function getNodes() constant returns (address[]) {
    return registeredNodes;
  }

  function setNodeDelegateAddress(address _nodeDelegateAddress) {
    delegateContract.delegatecall(bytes4(sha3("setNodeDelegateAddress(address)")), _nodeDelegateAddress);
  }



}
