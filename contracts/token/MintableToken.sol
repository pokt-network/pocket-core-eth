pragma solidity ^0.4.11;

import 'installed_contracts/zeppelin/contracts/token/StandardToken.sol';
import "../interfaces/PocketNodeInterface.sol";
import "../interfaces/PocketRegistryInterface.sol";

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */

contract MintableToken is StandardToken {


  uint public nodeMintReward;
  uint public oracleMintReward;
  uint public totalMintReward = 2850;
  RegistryInterface public registryInterface;
  event Mint(address indexed to, uint256 amount);

  function MintableToken () {

  }


   //onlyMintAgent canMint address _to, uint256 _amount
  function mint() private {
    nodeMintReward = totalMintReward * 0.8;
    oracleMintReward = totalMintReward * 0.1;
    epochResetterReward = totalMintReward * 0.1;
    address[] nodes = registryInterface.getLiveNodes();
    uint256 reward = totalRelaysPerEpoch[currentEpoch] / nodeMintReward;
    uint256 oracleReward = totalRelaysPerEpoch[currentEpoch] / oracleMintReward;


    for (uint i = 0; i < nodes.length; i++) {
      // Relayer mint
      if(nodes[i].isRelayer){
        bytes32[] relays = PocketNodeInterface(nodes[i]).aCRelaysCount.call();

        if (relays.length > 0) {
          totalSupply = totalSupply.add(reward);
          balances[nodes[i]] = balances[i].add(reward);
          Mint(i, reward);
          Transfer(0x0, i, reward);
        }
      }

      // Oracle mint
      if(nodes[i].isOracle){
        bytes32[] oracleConfirmations = PocketNodeInterface(nodes[i]).aCVRelaysCount.call();
        if (oracleConfirmations.length > 0) {
          totalSupply = totalSupply.add(reward);
          balances[nodes[i]] = balances[i].add(reward);
          Mint(i, oracleReward);
          Transfer(0x0, i, reward);
        }
      }
    }

    // Function caller reward
    totalSupply = totalSupply.add(reward);
    balances[msg.sender] = balances[i].add(reward);
    Mint(msg.sender, epochResetterReward);
    Transfer(0x0, msg.sender, epochResetterReward);
  }
}
