var NodeRegistryAPI = artifacts.require('./api/NodeRegistryAPI.sol'),
    Utils = require('./utils.js');

contract('NodeRegistryAPI', (accounts) => {
  var nodeRegistry;

  before(async() => {
    nodeRegistry = await NodeRegistryAPI.deployed();
  });

  // Test Deployment
  it('should have NodeRegistryAPI deployed', async() => {
    assert.notEqual(nodeRegistry, undefined, 'NodeRegistryAPI is deployed');
  });

  // Test contractDirectory
  it('should have contract directory set', async() => {
    const contractDirectoryAddress = await nodeRegistry.contractDirectory.call();
    assert.notEqual(contractDirectoryAddress, undefined, 'contractDirectory is set');
  });

  // Test registration of a new node
  it('should register a new node', async() => {
    var relayerNonce = await Utils.registerNode(nodeRegistry, accounts[0], ['BTC', 'ETH'], '/ip4/127.0.0.1/tcp/90/http/pocket/relays');
    assert.notEqual(relayerNonce, undefined, 'node registered succesfully');
  });
});
