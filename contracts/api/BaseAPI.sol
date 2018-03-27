pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract BaseAPI is Ownable {
    // State
    address public contractDirectory;

    // Functions
    /*
     * @dev Sets contract directory
     * @param address _contractDirectory;
     */
    function setContractDirectory(address _contractDirectory) public onlyOwner {
        contractDirectory = _contractDirectory;
    }

    /*
     * @dev Gets the contract directory
     */
    function getContractDirectory() public returns(address) {
        return contractDirectory;
    }
}
