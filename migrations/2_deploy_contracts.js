var PocketToken = artifacts.require('./PocketToken.sol')
var PocketRegistry = artifacts.require('./PocketRegistry.sol')
var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate.sol')
var PocketNodeDelegate = artifacts.require('./PocketNodeDelegate.sol')
var PocketNode = artifacts.require('./PocketNode.sol')
var PocketRelay = artifacts.require('./PocketRelay.sol')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketRegistry);
  // deployer.deploy(PocketNode);
  deployer.link(PocketRegistryDelegate,PocketToken,PocketNode);
  deployer.deploy(PocketRegistryDelegate);
  deployer.link(PocketNodeDelegate,PocketToken,PocketRelay);
  deployer.deploy(PocketNodeDelegate);
};
