pragma solidity ^0.4.11;

import "../relay/PocketRelay.sol";
import "../token/PocketToken.sol";

contract PocketNode {

  // TODO: (MINT) only the node pays for gas, which means that the profit should be gas cost + infrastructure cost

  address[] public activeRelays;
  address public owner;
  address public tokenAddress;

  address public delegateContract;
  address[] public previousDelegates;

  event DelegateChanged(address oldAddress, address newAddress);

  function PocketNode() {
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

  // Node contract is the contract that relayers will get assigned when signing up to the registry
  // checkThrottle checks the staked amount of PKT that application has
  // If not throttled, a relay contract will be created
  function checkThrottle(address _throttleAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("checkThrottle(address)")), _throttleAddress));
  }

  function getRelays() constant returns (address[]) {
    return activeRelays;
  }

  function setOwner(address _ownerAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setOwner(address)")), _ownerAddress));
  }

  function setTokenAddress(address _tokenAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress));
  }
}
