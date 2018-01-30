var PocketToken = artifacts.require('./PocketToken.sol');
var PocketRegistry = artifacts.require('./PocketRegistry.sol');
var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate.sol');
var PocketNodeDelegate = artifacts.require('./PocketNodeDelegate.sol');

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
      return registry.delegate.call().then(function(address) {
      console.log(registryDelegate.address);
      console.log(instance);
        assert.equal(address.delegate, registryDelegate.address, "addresses should be equal");
      });
    });
  });
});
