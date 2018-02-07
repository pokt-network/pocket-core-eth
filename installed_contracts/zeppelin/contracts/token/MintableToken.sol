pragma solidity ^0.4.11;


import 'installed_contracts/zeppelin/contracts/token/StandardToken.sol';
import 'installed_contracts/zeppelin/contracts/ownership/Ownable.sol';


contract RegistryInterface {
  function getLiveNodes() constant returns (address[]);
}

contract NodeInterface {
  mapping(bytes32 => Relay) public relays;
  function getACRelays() public constant returns(bytes32[] acRelays);
}


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
  uint public nodeMintReward;
  uint public totalMintReward = 2850;
  RegistryInterface public registryInterface;


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

   //onlyMintAgent canMint address _to, uint256 _amount
  function mint() private returns (bool) {
    nodeMintReward = totalMintReward * (80 / 100);
    address[] nodes = registryInterface.getLiveNodes();

    for (uint i = 0; i < nodes.length; i++) {
      bytes32[] relays = NodeInterface(nodes[i]).getACRelays();

      if (relays.length > 0) {

        uint256 reward = nodeMintReward / relays.length;
        totalSupply = totalSupply.add(reward);
        balances[i] = balances[i].add(reward);
        Mint(i, reward);
        Transfer(0x0, i, reward);
        return true;
      }
    }
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
