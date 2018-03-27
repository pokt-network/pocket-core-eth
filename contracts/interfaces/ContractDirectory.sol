pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract ContractDirectory is Ownable {
    // State
    mapping (bytes32 => address) public contracts;

    /*
     * @dev Sets a contract address for the specified key
     * @param bytes32 _name - Contract name
     * @param address _address - Contract address
     */
    function setContract(bytes32 _name, address _address) public onlyOwner {}

    /*
     * @dev Get contract address for key
     * @param bytes32 _name
     */
    function getContract(bytes32 _name) public returns(address) {}
}
