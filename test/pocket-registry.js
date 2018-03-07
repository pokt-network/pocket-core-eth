// var PocketToken = artifacts.require('./PocketToken.sol');
// var PocketRegistry = artifacts.require('./PocketRegistry.sol');
// var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate.sol');
// var PocketRegistryState = artifacts.require('./PocketRegistryState.sol');
// var NodeCrud = artifacts.require('./NodeCrud.sol');
//
// contract('PocketRegistry', function(accounts) {
//
//   var sender = accounts[0];
//   var relayer = accounts[1];
//   var token;
//   var registry;
//   var registryDelegate;
//   var nodeCrud;
//   var registryState;
//   var node;
//   var relay;
//
//   describe("Deploy all the contracts", function() {
//
//     it("should initialize Token contract", async function() {
//       token = await PocketToken.new();
//       return token;
//     });
//
//     it("Should initialize Registry contract", async function() {
//       registry = await PocketRegistry.new();
//       return registry;
//     });
//
//     it("should initialize Registry Delegate contract", async function() {
//       registryDelegate = await PocketRegistryDelegate.new();
//       return registryDelegate;
//     });
//
//     it("should initialize Registry NodeCrud contract", async function() {
//       nodeCrud = await NodeCrud.new();
//       return nodeCrud;
//     });
//
//     it("should initialize Registry State contract", async function() {
//       registryState = await PocketRegistryState.new();
//       return registryState;
//     });
//
//   });
//
//   describe("Set delegates", function() {
//
//     it("should set registry delegate", async function() {
//         registry.changeDelegate(registryDelegate.address);
//         var address = await registry.delegateContract.call();
//         assert.equal(address, registryDelegate.address, "addresses should be equal");
//     });
//
//     it("should set token address", async function() {
//       registry.setTokenAddress(token.address);
//       var address = await registry.tokenAddress.call();
//       assert.equal(address, token.address, "addresses should be equal");
//     });
//
//   });
//
//   describe("Create a Relayer Node", function() {
//
//     var registry;
//
//     beforeEach("Setup contract for each test", async function() {
//       var registryContract = await PocketRegistry.deployed();
//       registry = PocketRegistry.at(registryContract.address);
//       console.log("Registry Contract Address: "+registryContract.address);
//     });
//
//     it("should create and register a node as a Relayer", function() {
//       var owner = web3.eth.accounts[0];
//       var supportedTokens = ["ETH","CRC","ZRX"];
//       var url = "www.popeye.com";
//       var path = "/eat";
//       var port = 5453;
//       var isRelayer = true;
//       var isOracle = false;
//
//       registry.createNodeContract(supportedTokens, url, path, port, isRelayer, isOracle);
//       assert.equal(registry.getLiveNodes().length, 1, "Node creation failed.");
//     });
//
//   });
//
//   describe("Create a Oracle Node", function() {
//
//     var registry;
//
//     beforeEach("Setup contract for each test", async function() {
//       var registryContract = await PocketRegistry.deployed();
//       registry = PocketRegistry.at(registryContract.address);
//       console.log("Registry Contract Address: "+registryContract.address);
//     });
//
//     it("should create and register a node as a Oracle", function() {
//       var owner = web3.eth.accounts[0];
//       var supportedTokens = ["ETH","CRC","ZRX"];
//       var url = "www.popeye.com";
//       var path = "/eat";
//       var port = 5453;
//       var isRelayer = false;
//       var isOracle = true;
//
//       registry.createNodeContract(supportedTokens, url, path, port, isRelayer, isOracle);
//       assert.equal(registry.getLiveNodes().length, 1, "Node creation failed.");
//     });
//
//   });
//
//   describe("Create a Multi-Node (Oracle and Relayer)", function() {
//
//     var registry;
//
//     beforeEach("Setup contract for each test", async function() {
//       var registryContract = await PocketRegistry.deployed();
//       registry = PocketRegistry.at(registryContract.address);
//       console.log("Registry Contract Address: "+registryContract.address);
//     });
//
//     it("should create and register a node as a Multi-Node", function() {
//       var owner = web3.eth.accounts[0];
//       var supportedTokens = ["ETH","CRC","ZRX"];
//       var url = "www.popeye.com";
//       var path = "/eat";
//       var port = 5453;
//       var isRelayer = true;
//       var isOracle = true;
//
//       registry.createNodeContract(supportedTokens, url, path, port, isRelayer, isOracle);
//       assert.equal(registry.getLiveNodes().length, 2, "Node creation failed.");
//     });
//
//   });
//
//   describe("Update a Relayer Node", function() {
//
//     var registry;
//
//     beforeEach("Setup contract for each test", async function() {
//       var registryContract = await PocketRegistry.deployed();
//       registry = PocketRegistry.at(registryContract.address);
//       console.log("Registry Contract Address: "+registryContract.address);
//     });
//
//     it("should update node", function() {
//       var owner = web3.eth.accounts[0];
//       var supportedTokens = ["ETH","GNT","ZRX"];
//       var url = "www.popeyeEDITED.com";
//       var path = "/eatEdited";
//       var port = 5400;
//       var isRelayer = false;
//       var isOracle = false;
//
//       registry.updateNodeRecord(owner.address, supportedTokens, url, path, port, isRelayer, isOracle);
//     });
//
//   });
//
//   //
//   // describe("get contracts ready to throttle", function() {
//   //
//   //   it("should stake token", function () {
//   //     //console.log(token);
//   //     token.stake(1, {from:sender});
//   //     return token.stakedAmount.call(sender).then(function(amount) {
//   //       assert.equal(amount.toNumber(), 1, "should be 1");
//   //     });
//   //   });
//   //
//   //   it("should transfer tokens to relayer", function() {
//   //     token.transfer(relayer, 50, {from:sender});
//   //     return token.balanceOf(relayer).then(function(balance) {
//   //       assert.equal(balance.toNumber(), 50, "should be 50");
//   //     });
//   //   });
//   //
//   //   it("should register relayer as a relay node and set node contract", function() {
//   //     registry.registerNode({from:relayer});
//   //     registry.getLiveNodes.call().then(function(nodes) {
//   //       return PocketNode.at(nodes[0]).then(function(instance) {
//   //
//   //         console.log(instance)
//   //         nodeContract = instance;
//   //
//   //       });
//   //     });
//   //   });
//   //
//   //     it("should send 3 transactions but only 2 relay contracts created", function() {
//   //
//   //       nodeContract.checkThrottle(sender, {from:relayer});
//   //       nodeContract.checkThrottle(sender, {from:relayer});
//   //       nodeContract.checkThrottle(sender, {from:relayer});
//   //       nodeContract.checkThrottle(sender, {from:relayer});
//   //       nodeContract.checkThrottle(sender, {from:relayer});
//   //
//   //       return node.getRelays.call().then(function(relays) {
//   //         assert.equal(relays, 3, "should be 3 within 10 blocks");
//   //       });
//   //     });
//   //
//   //
//   // });
// });
