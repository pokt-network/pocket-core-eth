pragma solidity ^0.4.11;

import "./PocketRelay.sol";
import "./PocketToken.sol";

contract PocketNodeBackend {
  /*
  address[] public activeRelays;
  address public owner;
  address public tokenAddress;

  address public delegateContract;
  address[] public previousDelegates;

  event DelegateChanged(address oldAddress, address newAddress);

  function PocketNodeBackend() {
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

  function checkThrottle(address _throttleAddress) returns (bool) {
    delegateContract.delegatecall(bytes4(sha3("checkThrottle(address)")), _throttleAddress);
  }

  /*function createRelay() private {

  }*/

  /*function getRelays() constant returns (address[]) {
    return activeRelays;
  }

  function setOwner(address _ownerAddress) {
    delegateContract.delegatecall(bytes4(sha3("setOwner(address)")), _ownerAddress);
  }

  function setTokenAddress(address _tokenAddress) {
    delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress);
  }
  */
}
