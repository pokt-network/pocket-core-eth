pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "./PocketToken.sol";

contract PocketNodeRegistry is BaseRegistry {


  function PocketNodeRegistry() {
    // constructor
  }

  function registerBurn(address _tokenAddress, string _url) {

    PocketToken token = PocketToken(_tokenAddress);
    token.burn(1,msg.sender);

    /*_tokenAddress.callcode(bytes4(sha3("burn(uint256)")),1);*/

    register(msg.sender, _url);
  }

}
