pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/BurnableToken.sol";
import "installed_contracts/zeppelin/contracts/token/MintableToken.sol";
import "./StakableToken.sol";
import "./ThrottleableToken.sol";


contract PocketToken is StakableToken, MintableToken, BurnableToken, ThrottleableToken {

 // Human state
 string public name;
 string public symbol;
 uint8 public decimals;
 string public version;

 event Mint(address indexed to, uint256 amount);

  function PocketToken() {
    // constructor
    totalSupply = 100;
    balances[msg.sender] = totalSupply;

    name = "Pocket Token";
    symbol = "PKT";
    decimals = 18;
    version = "0.1";

    //resetThrottleEpoch(msg.sender);

  }

}
