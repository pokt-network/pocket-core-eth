pragma solidity ^0.4;

import "../token/PocketToken.sol";
import "../interfaces/PocketNodeInterface.sol";
import "./NodeCrud.sol";
import "./PocketRegistryState.sol";

contract PocketRegistryDelegate is NodeCrud, PocketRegistryState {

  function PocketRegistryDelegate() public{
    owner = msg.sender;
  }

  // This is the function to create a new Node.
  function createNodeContract(bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public {
    require(_supportedTokens.length > 0);
    require(_url.length > 0);
    require(_port > 0);
    require(_isRelayer);
    require(_isOracle);

    require(tokenAddress.call(bytes4(keccak256("burn(uint256,address)")),1,msg.sender));

    PocketNodeInterface newNode = new PocketNodeInterface(msg.sender, nodeDelegateAddress, tokenAddress, _isRelayer, _isOracle);
    userNode[msg.sender] = newNode;

    registerNode(newNode, _supportedTokens, _url, _path, _port, _isRelayer, _isOracle);

  }

  // This is the function that actually register a Node.
  function registerNode(address _nodeAddress, bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public {
    insertNode(_nodeAddress, _supportedTokens, _url, _path, _port, _isRelayer, _isOracle);
  }

  // Updates the values of the given Node record.
  function updateNodeRecord(address _nodeAddress, bytes8[] _supportedTokens, bytes32 _url, bytes32 _path, uint8 _port, bool _isRelayer, bool _isOracle) public {
    // Only the owner can update his record.
    PocketNodeInterface newNode = PocketNodeInterface(_nodeAddress);
    require(newNode.owner() == msg.sender);

    updateNode(_nodeAddress, _supportedTokens, _url, _path, _port, _isRelayer, _isOracle);
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) public {
  // Only the owner can transfer ownership of his record.
    transfer(_nodeAddress, newOwner);
  }

  function kill() public {
    selfdestruct(owner);
  }

  function setTokenAddress(address _tokenAddress) public {
    tokenAddress = _tokenAddress;
  }

  function setNodeDelegateAddress(address _nodeDelegateAddress) public {
    nodeDelegateAddress = _nodeDelegateAddress;
  }

}
