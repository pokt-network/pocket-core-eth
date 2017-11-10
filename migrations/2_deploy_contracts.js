var PocketToken = artifacts.require('./PocketToken.sol')
var PocketNode = artifacts.require('./PocketNode.sol')
var PocketNodeRegistry = artifacts.require('./PocketNodeRegistry.sol')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketNode);
  deployer.deploy(PocketNodeRegistry);
};
