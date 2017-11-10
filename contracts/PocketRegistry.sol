pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "./PocketToken.sol";

contract PocketRegistry is BaseRegistry {
  function PocketRegistry() {
    // constructor
  }

  function registerBurn(address _tokenAddress, string _url) {

    PocketToken token = PocketToken(_tokenAddress);
    token.burn(1,msg.sender);
    register(msg.sender, _url);
  }
}
