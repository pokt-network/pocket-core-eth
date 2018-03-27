var ContractDirectoryAPI = artifacts.require("ContractDirectoryAPI");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ContractDirectoryAPI);
};
