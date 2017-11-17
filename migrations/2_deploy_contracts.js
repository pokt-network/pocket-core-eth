var PocketToken = artifacts.require('./PocketToken.sol')
var PocketRegistry = artifacts.require('./PocketRegistry.sol')
var PocketRegistryBackend = artifacts.require('./PocketRegistryBackend')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketRegistryBackend);
  deployer.deploy(PocketRegistry);
};
