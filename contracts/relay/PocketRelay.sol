pragma solidity ^0.4.11;

//import "../token/PocketToken.sol";
/*import "./PocketMint.sol";*/

contract PocketRelay {

  address public tokenAddress;
  uint256 public approvalCount;
  address public nodeAddress;

  address[] public senderAddresses;

  function PocketRelay() {
    // constructor

  }


  /*modifier onlyOwner {
    if (msg.sender != owner) revert();
    _;
  }*/

  function approveTransaction() {
    approvalCount += 1;
    //if (approvalCount == 3) {
    //senderAddresses.push(msg.sender);
      //PocketToken token = PocketToken.at();
      //nodeAddress.push(token);
      //senderAddresses.push(token);
      //token.mint(nodeAddress, 10);

      //tokenAddress.call(bytes4(sha3("mint(address,uint256)")), nodeAddress, 10);

      /*kill();*/
    //}
  }

  function setTokenAddress(address _tokenAddress) {
    tokenAddress = _tokenAddress;
  }

  function setNodeAddress(address _nodeAddress) {
    nodeAddress = _nodeAddress;
  }

  function getSenders() constant returns (address[]) {
    return senderAddresses;
  }

/*
  function kill() onlyOwner() {
    selfdestruct(owner);
  }*/
}
