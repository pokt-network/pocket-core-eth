pragma solidity ^0.4.11;

import "./PocketRelay.sol";
import "./PocketToken.sol";
contract PocketNode {
  address[] public activeRelays;
  address public owner;
  address public tokenAddress;

  function PocketNode() {
  }

  function checkThrottle(address _throttleAddress) returns (bool) {
    // if returns true relay transaction

    //TODO: Permissions
    assert(owner == msg.sender);

    PocketToken token = PocketToken(tokenAddress);
    if (token.throttle(_throttleAddress) == true) {
      createRelay();
      return true;
    } else {
      return false;
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
