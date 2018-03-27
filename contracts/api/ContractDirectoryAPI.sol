pragma solidity ^0.4.18;

import "../interfaces/ContractDirectory.sol";

contract ContractDirectoryAPI is ContractDirectory {
    /*
     * @dev Sets a contract address for the specified key
     * @param bytes32 _name - Contract name
     * @param address _address - Contract address
     */
    function setContract(bytes32 _name, address _address) public onlyOwner {
        contracts[_name] = _address;
    }

    /*
     * @dev Get contract address for key
     * @param bytes32 _name
     */
    function getContract(bytes32 _name) public returns(address) {
        return contracts[_name];
    }
}
