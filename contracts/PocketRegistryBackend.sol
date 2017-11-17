pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "./PocketToken.sol";
import "./PocketNode.sol";

contract PocketRegistryBackend is BaseRegistry {

  address[] public registeredNodes;

  address public delegateContract;
  address[] public previousDelegates;

  event DelegateChanged(address oldAddress, address newAddress);

  function PocketRegistryBackend() {
    // constructor
  }

  function changeDelegate(address _newDelegate) returns (bool) {

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

  function createNodeContract (address _tokenAddress) private {
    delegateContract.delegatecall(bytes4(sha3("createNodeContract(address)")));
  }

  function getNodes() constant returns (address[]) {
    return registeredNodes;
  }

}
