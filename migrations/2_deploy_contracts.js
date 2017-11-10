var PocketToken = artifacts.require('./PocketToken.sol')
var PocketNode = artifacts.require('./PocketNode.sol')
var PocketRegistry = artifacts.require('./PocketRegistry.sol')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketNode);
  deployer.deploy(PocketRegistry);
};
