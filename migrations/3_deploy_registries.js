var EpochRegistryAPI = artifacts.require("EpochRegistryAPI"),
    NodeRegistryAPI = artifacts.require("NodeRegistryAPI"),
    ContractDirectoryAPI = artifacts.require("ContractDirectoryAPI");

module.exports = function(deployer, network, accounts) {
  var contractDirectoryAddress = ContractDirectoryAPI.address;
  deployer.deploy(EpochRegistryAPI).then(function(){
    EpochRegistryAPI.at(EpochRegistryAPI.address).then(function(instance){
      instance.setContractDirectory(contractDirectoryAddress);
      instance.setBlocksPerEpoch(10);
    });
    ContractDirectoryAPI.at(contractDirectoryAddress).then(function(instance){
      instance.setContract("EpochRegistry", EpochRegistryAPI.address);
    });
  });
  deployer.deploy(NodeRegistryAPI).then(function(){
    NodeRegistryAPI.at(NodeRegistryAPI.address).then(function(instance){
      instance.setContractDirectory(contractDirectoryAddress);
    });
    ContractDirectoryAPI.at(contractDirectoryAddress).then(function(instance){
      instance.setContract("NodeRegistry", NodeRegistryAPI.address);
    });
  });
}
