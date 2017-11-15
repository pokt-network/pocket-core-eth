var PocketToken = artifacts.require('./PocketToken.sol')
var PocketRegistry = artifacts.require('./PocketRegistry.sol')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketRegistry);
};
