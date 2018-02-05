pragma solidity ^0.4.11;

import "installed_contracts/zeppelin/contracts/token/StandardToken.sol";
import "installed_contracts/zeppelin/contracts/token/BurnableToken.sol";
import "installed_contracts/zeppelin/contracts/token/MintableToken.sol";
import "./StakableToken.sol";
//is BurnableToken, StakableToken, MintableToken
contract PocketToken is StakableToken, MintableToken, BurnableToken {

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

  /* function mint(address _to, uint256 _amount)  {

    // TODO: Mintable token with inflation
    // Check throttle epoch
    // Check relays sent during epoch
    // Mint based on relays sent during epoch
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(0x0, _to, _amount);
    //return true;
  } */

}
