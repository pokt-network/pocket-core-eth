pragma solidity ^0.4.11;

import "./PocketRelay.sol";
import "./PocketToken.sol";
contract PocketNode {
  address[] public activeRelays;
  address public owner;
  function PocketNode() {
    // constructor
    owner = msg.sender;
    // TODO: register node with directory

  }

  function checkThrottle(address _tokenAddress, address _throttleAddress) returns (bool) {
    // if returns true relay transaction

    assert(owner == msg.sender);

    PocketToken token = PocketToken(_tokenAddress);
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
}
