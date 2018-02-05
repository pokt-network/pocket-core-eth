pragma solidity ^0.4.11;


import 'installed_contracts/zeppelin/contracts/token/StandardToken.sol';
import 'installed_contracts/zeppelin/contracts/ownership/Ownable.sol';




/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */

contract MintableToken is StandardToken, Ownable {

  /** List of agents that are allowed to create new tokens */
  mapping (address => bool) public mintAgents;

  bool public mintingFinished = false;

  event Mint(address indexed to, uint256 amount);
  event MintFinished();
  event MintingAgentChanged(address addr, bool state);


  function MintableToken () {

  }
  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier onlyMintAgent() {
    // Only crowdsale contracts are allowed to mint new tokens
    if(!mintAgents[msg.sender]) {
        throw;
    }
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */

   //onlyMintAgent canMint
  function mint(address _to, uint256 _amount) public returns (bool) {

    // TODO: Mintable token with inflation
    // Check throttle epoch
    // Check relays sent during epoch
    // Mint based on relays sent during epoch
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(0x0, _to, _amount);
    return true;
  }


  function setMintAgent(address addr, bool state) onlyOwner canMint public {
  mintAgents[addr] = state;
  MintingAgentChanged(addr, state);
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}
