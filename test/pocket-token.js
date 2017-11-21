var PocketToken = artifacts.require('./PocketToken.sol');
var PocketRegistry = artifacts.require('./PocketRegistry.sol');
var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate.sol');
var PocketNodeDelegate = artifacts.require('./PocketNodeDelegate.sol');

contract('PocketToken', function(accounts) {

  var sender = accounts[0];
  var relayer = accounts[1];
  var attacker = accounts[accounts.length - 1];
  var token;
  var registry;

  it("Should check that stake value is greater than 0", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.stake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.isAbove(amount.toNumber(), 0, "greater than zero");

    });
  });

  it("should release stake value", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.releaseStake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.equal(amount.toNumber(),0, "equal to zero");

    });
  });

  it("Should check that stake value is equal", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.stake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.equal(amount.toNumber(), 1, "equal to 1");

    });
  });


});



contract('PocketRegistry', function(accounts) {

  var sender = accounts[0];
  var relayer = accounts[1];
  var attacker = accounts[accounts.length - 1];
  var token;
  var registry;
  var registryDelegate;
  var supply;
  var node;
  var nodeDelegate;

  before(function() {
     return PocketToken.deployed().then(function(instance){
        token = instance;
     });
 });

 before(function() {
    return PocketRegistryDelegate.deployed().then(function(instance){
       registryDelegate = instance;
    });
});

before(function() {
   return PocketNodeDelegate.deployed().then(function(instance){
      nodeDelegate = instance;
   });
});

  it("should burn 1 token", function() {
    PocketRegistry.deployed().then(function(instance) {

      supply = token.totalSupply.call().toNumber();
      registry = instance;
      registry.changeDelegate(registryDelegate.address);
      registry.setNodeDelegateAddress(nodeDelegate.address);

      registry.registerBurn(token.address, "test", {from:sender});
      return token.totalSupply.call().toNumber();
    }).then(function(amount) {
      assert.equal(amount, supply, "supply is 1 less");

    });
  });
});
