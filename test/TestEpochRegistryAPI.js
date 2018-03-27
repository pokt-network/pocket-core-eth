var EpochRegistryAPI = artifacts.require('./api/EpochRegistryAPI.sol'),
    NodeRegistryAPI = artifacts.require('./api/NodeRegistryAPI.sol'),
    Utils = require('./utils.js');

contract('EpochRegistryAPI', function(accounts) {
  var epochRegistry, nodeRegistry;

  before(async function(){
    epochRegistry = await EpochRegistryAPI.deployed();
    nodeRegistry = await NodeRegistryAPI.deployed();
  });

  it('should have EpochRegistryAPI deployed', async() => {
    assert.notEqual(epochRegistry, undefined, 'EpochRegistryAPI is deployed');
  });

  it('should have contract directory set', async() => {
    const contractDirectoryAddress = epochRegistry.contractDirectory.call();
    assert.notEqual(contractDirectoryAddress, undefined, 'contractDirectory is set');
  });

  it('should add relay to current epoch', async() => {
    var relayerNonce = await Utils.registerNode(nodeRegistry, accounts[0], ['BTC', 'ETH'], '/ip4/127.0.0.1/tcp/90/http/pocket/relays1'),
        relayNonce = await Utils.addRelayToCurrentEpoch(epochRegistry, accounts[0], relayerNonce, 'ABCD', 'BTC', accounts[1]);

    assert.notEqual(relayNonce, undefined, 'added relay succesfully');
  });

  it('should verify existing relay', async() => {
    var relayerNonce = await Utils.registerNode(nodeRegistry, accounts[0], ['BTC', 'ETH'], '/ip4/127.0.0.1/tcp/90/http/pocket/relays2'),
        verifierNonce = await Utils.registerNode(nodeRegistry, accounts[1], ['BTC', 'ETH'], '/ip4/127.0.0.1/tcp/90/http/pocket/relays3'),
        relayerRelay = await Utils.addRelayToCurrentEpoch(epochRegistry, accounts[0], relayerNonce, 'ABCDE', 'BTC', accounts[1]),
        verifierRelay = await Utils.addRelayToCurrentEpoch(epochRegistry, accounts[1], verifierNonce, 'ABCD', 'BTC', accounts[0]),
        currentEpoch = await epochRegistry.currentEpoch.call(),
        verificationTx = await epochRegistry.verifyRelayInEpoch(currentEpoch, relayerRelay, verifierNonce, true, {from: accounts[1]}),
        verifiedRelayNonce = verificationTx.logs[0].args._relayNonce;

    assert.equal(relayerRelay, verifiedRelayNonce, 'relay verification submitted succesfully');
  });
});
