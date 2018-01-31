var PocketToken = artifacts.require('./PocketToken.sol');
var PocketRegistry = artifacts.require('./PocketRegistry.sol');
var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate.sol');
var PocketNodeDelegate = artifacts.require('./PocketNodeDelegate.sol');
var PocketNode = artifacts.require('./PocketNode.sol');

contract('PocketToken', function(accounts) {

  var sender = accounts[0];
  var relayer = accounts[1];
  var token;
  var registry;

  describe("Deploy all the contracts", function() {

      it("should initialize token contract", function() {
        return PocketToken.new().then(function(instance) {
          token = instance;
        });
      });

    it("should initialize registry contract", function() {
      return PocketRegistry.new().then(function(instance) {
        registry = instance;
      });
    });


    it("should initialize registry delegate contract", function() {
      return PocketRegistryDelegate.new().then(function(instance) {
        registryDelegate = instance;
      });
    });

    it("should initialize node delegate contract", function() {
      return PocketNodeDelegate.new().then(function(instance) {
        nodeDelegate = instance;
      });
    });
  });

  describe("Set delegates", function() {

    it("should set registry delegate", function() {
        registry.changeDelegate(registryDelegate.address);
        return registry.delegateContract.call().then(function(address) {
        assert.equal(address, registryDelegate.address, "addresses should be equal");
      });
    });

    it("should set node delegate", function() {
      registry.setNodeDelegateAddress(nodeDelegate.address);
      return registry.nodeDelegateAddress.call().then(function(address) {
        assert.equal(address, nodeDelegate.address, "addresses should be equal");
      });
    });

    it("should set token address", function() {
      registry.setTokenAddress(token.address);
      return registry.tokenAddress.call().then(function(address) {
        assert.equal(address, token.address, "addresses should be equal");
      });
    });
  });

  describe("get contracts ready to throttle", function() {

    it("should stake token", function () {
      //console.log(token);
      token.stake(1, {from:sender});

      return token.stakedAmount.call(sender).then(function(amount) {
        assert.equal(amount.toNumber(), 1, "should be 1");
      });
    });

    it("should transfer tokens to relayer", function() {
      token.transfer(relayer, 50, {from:sender});
      return token.balanceOf(relayer).then(function(balance) {
        assert.equal(balance.toNumber(), 50, "should be 50");
      });
    });

    it("should register relayer as a relay node", function() {
      registry.registerNode({from:relayer});
      registry.getLiveNodes.call().then(function(nodes) {
        assert.equal(nodes[0], relayer, "should be same as relayer");
      });
    });
  });

  describe("initialize node contract", function() {

    it("should initialize node contract", function() {
      return registry.getLiveNodes.call().then(function(nodes) {
        return PocketNode.at(nodes[0]).then(function(instance) {
          console.log(instance);
          node = instance;
        });
      });
    });
  });
});
