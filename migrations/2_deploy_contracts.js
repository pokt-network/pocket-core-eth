var PocketToken = artifacts.require('./PocketToken.sol')
var PocketRegistry = artifacts.require('./PocketRegistry.sol')
var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate')
var PocketNodeDelegate = artifacts.require('./PocketNodeDelegate')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketRegistry);
  deployer.deploy(PocketRegistryDelegate);
  deployer.deploy(PocketNodeDelegate);

};
