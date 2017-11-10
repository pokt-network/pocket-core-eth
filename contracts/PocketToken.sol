pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";
import "installed_contracts/zeppelin/contracts/token/BurnableToken.sol";
import "installed_contracts/zeppelin/contracts/token/MintableToken.sol";
import "./StakableToken.sol";

contract PocketToken is StandardToken, MintableToken, StakableToken, BurnableToken {

 // Human state
 string public name;
 string public symbol;
 uint8 public decimals;
 string public version;

  function PocketToken() {
    // constructor
    totalSupply = 100;
    balances[msg.sender] = totalSupply;

    name = "Pocket Token";
    symbol = "PKT";
    decimals = 18;
    version = "0.1";

    resetThrottle(msg.sender);

  }

}
