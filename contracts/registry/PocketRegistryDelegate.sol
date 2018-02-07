pragma solidity ^0.4.11;

import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate {

  // Attributes
  address public nodeDelegateAddress;

  // Node state
  mapping (address => address) public userNode;

  function PocketRegistryDelegate() {
    owner = msg.sender;
  }

  // This is the function to create a new Node.
  function createNodeContract(string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(_supportedTokens.count > 0);
    require(_url.length > 0);
    require(_port > 0);
    require(_isRelayer);
    require(_isOracle);

    tokenAddress.call(bytes4(sha3("burn(uint256,address)")),1,msg.sender);

    PocketNode newNode = PocketNode(msg.sender, nodeDelegateAddress, tokenAddress, _isRelayer, _isOracle);
    userNode[msg.sender] = newNode;

    registerNode(newNode, _supportedTokens, _url, _port, _isRelayer, _isOracle);

  }

  // This is the function that actually register a Node.
  function registerNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    insertNode(_nodeAddress, _supportedTokens, _url, _port, _isRelayer, _isOracle);
  }

  // Updates the values of the given Node record.
  function updateNodeRecord(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    // Only the owner can update his record.
    PocketNode newNode = PocketNode(_nodeAddress);
    require(newNode.owner == msg.sender);

    updateNode(address _nodeAddress, string8[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle);
  }

  // Transfer ownership of a given record.
  function transferNode(address _nodeAddress, address newOwner) {
    // Only the owner can transfer ownership of his record.
    transfer(_nodeAddress, newOwner);
    }

    function kill() {
      suicide(owner);
    }

    function setTokenAddress(address _tokenAddress) {
      tokenAddress = _tokenAddress;
    }

    function setNodeDelegateAddress(address _nodeDelegateAddress) {
      nodeDelegateAddress = _nodeDelegateAddress;
    }

  }
