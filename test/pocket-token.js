var PocketToken = artifacts.require('./PocketToken.sol'),
    chai = require('chai'),
    expect = chai.expect,
    should = chai.should(),
    utils = require("./utils.js");

const run = exports.run = function(accounts) {
  let pocket_token;

  before(async function(){
    console.log('Pocket Token Contract address: ' + PocketToken.address);
    pocket_token = await PocketToken.at(PocketToken.address);
  });

  describe('Standalone contract functionality', async function(){
    it('should deploy to the network', async function(){
      pocket_token.should.be.ok;
    });

    it('should allow an address to stake POKT', async function(){
      var stakedBalance = (await utils.getPoktStakeBalance(pocket_token, accounts[0])).toNumber(),
          amountToStake = 100,
          txResponse = await utils.stakePokt(pocket_token, accounts[0], amountToStake),
          stakedEventTriggered = utils.expectedEventOcurred(txResponse, {logIndex: 0, event: 'Staked'}),
          newStakedBalance = (await utils.getPoktStakeBalance(pocket_token, accounts[0])).toNumber();
      // Assertions
      stakedEventTriggered.should.be.true;
      newStakedBalance.should.equal(stakedBalance + amountToStake);
    });

    it('should allow an address to release POKT', async function(){
      var stakedBalance = (await utils.getPoktStakeBalance(pocket_token, accounts[0])).toNumber(),
          amountToStake = 100,
          amountToRelease = 50,
          stakeTxResponse = await utils.stakePokt(pocket_token, accounts[0], amountToStake),
          releaseTxResponse = await utils.releasePoktStake(pocket_token, accounts[0], amountToRelease),
          releaseEventTriggered = utils.expectedEventOcurred(releaseTxResponse, {logIndex: 0, event: 'StakeReleased'}),
          newStakedBalance = (await utils.getPoktStakeBalance(pocket_token, accounts[0])).toNumber();
      // Assertions
      releaseEventTriggered.should.be.true;
      newStakedBalance.should.equal((stakedBalance + amountToStake) - amountToRelease);
    });
  });

  describe('Epoch functionality', async function(){
    it('should mine the current epoch', async function() {
      var miner = accounts[0],
          blocksPerEpoch = 10,
          currentEpoch = await pocket_token.currentEpoch.call(),
          currentEpochBlockStart = await pocket_token.currentEpochBlockStart.call(),
          currentEpochBlockEnd = await pocket_token.currentEpochBlockEnd.call();

      console.log(currentEpoch.toNumber());
      console.log(currentEpochBlockStart.toNumber());
      console.log(currentEpochBlockEnd.toNumber());
      // Simulate 10 transactions, which equates to 10 blocks in a test blockchain
      for (var i = 0; i < blocksPerEpoch; i++) {
        minerStakedTx = await utils.stakePokt(pocket_token, miner, 10);
      }

      // Mine the epoch
      var epochMinedTx = await pocket_token.mineCurrentEpoch({from: miner}),
          epochMinedEventTriggered = utils.expectedEventOcurred(epochMinedTx, {logIndex: 0, event: 'EpochMined'});

      epochMinedEventTriggered.should.be.true;
    });
  });
  return { pocket_token };
};

contract('PocketToken', run);
