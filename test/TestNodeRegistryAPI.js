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

  // Test getting owner nodes
  it('should return a paginated list of owner nodes', async() => {
    var nodes = [];

    // Register nodes
    for (var i = 0; i < 10; i++) {
      var nodeNonce = await Utils.registerNode(nodeRegistry, accounts[1], ['BTC', 'ETH'], '/ip4/127.0.0.1/tcp/90/http/pocket/relays2');
      nodes.push(nodeNonce);
    }

    // Fetch owner nodes
    var ownerNodes = await nodeRegistry.getOwnerNodes(accounts[1], 1);

    // Assert results
    assert.deepEqual(nodes, ownerNodes, 'Node list matches registered node response');
  });

  // Test getting a specific node information
  it('should return node data', async() => {
    var endpoint = '/ip4/127.0.0.1/tcp/90/http/pocket/relays',
        networks = ['BTC', 'ETH'],
        nodeNonce = await Utils.registerNode(nodeRegistry, accounts[2], networks, endpoint),
        node = await nodeRegistry.getNode(nodeNonce);

    assert.equal(nodeNonce, node[0], 'Node has the correct nonce');
    assert.equal(accounts[2], node[1], 'Node has the correct owner');
    assert.equal(networks[0], web3.toUtf8(node[2][0]), 'Node has the correct networks BTC');
    assert.equal(networks[1], web3.toUtf8(node[2][1]), 'Node has the correct networks ETH');
    assert.equal(endpoint, node[3], 'Node has the correct endpoint');
  });
});
