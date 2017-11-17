pragma solidity ^0.4.11;

import "../relay/PocketRelay.sol";
import "../token/PocketToken.sol";

contract PocketNodeDelegate {
  address[] public activeRelays;
  address public owner;
  address public tokenAddress;

  address public delegateContract;
  address[] public previousDelegates;

  function PocketNodeDelegate() {
  }

  function checkThrottle(address _throttleAddress) {
    // if returns true relay transaction

    //TODO: Permissions
    assert(owner == msg.sender);

    PocketToken token = PocketToken(tokenAddress);
    if (token.throttle(_throttleAddress) == true) {
      createRelay();
    }
  }

  function createRelay() private {
    address relay = new PocketRelay();
    activeRelays.push(relay);
  }

  function getRelays() constant returns (address[]) {
    return activeRelays;
  }

  function setOwner(address _ownerAddress) {
    owner = _ownerAddress;
  }

  function setTokenAddress(address _tokenAddress) {
    tokenAddress = _tokenAddress;
  }

}
