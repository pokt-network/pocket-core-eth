var PocketToken = artifacts.require('./PocketToken.sol')
var PocketNode = artifacts.require('./PocketNode.sol')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  deployer.deploy(PocketNode);
};
