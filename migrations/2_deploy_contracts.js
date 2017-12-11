var PocketToken = artifacts.require('./PocketToken.sol')
//var PocketRegistry = artifacts.require('./PocketRegistry.sol')
//var PocketRegistryDelegate = artifacts.require('./PocketRegistryDelegate.sol')
//var PocketNodeDelegate = artifacts.require('./PocketNodeDelegate.sol')
//var PocketRelay = artifacts.require('./PocketRelay.sol')

module.exports = function(deployer) {
  deployer.deploy(PocketToken);
  //deployer.deploy(PocketRegistry);
  //deployer.deploy(PocketRegistryDelegate);
  //deployer.deploy(PocketNodeDelegate);
  //deployer.deploy(PocketRelay);

};
