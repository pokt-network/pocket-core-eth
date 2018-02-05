pragma solidity ^0.4.11;

import "./BaseRegistry.sol";
import "../token/PocketToken.sol";
import "../node/PocketNode.sol";

contract PocketRegistryDelegate is BaseRegistry {

  // Address state
  address public owner;
  address public nodeDelegateAddress;
  address public tokenAddress;
  address public delegateContract;
  address[] public previousDelegates;

  // Node state
  mapping (address => address) public userNode;

  function PocketRegistryDelegate() {
    owner = msg.sender;
  }

  function registerNode(address _nodeAddress, string[] _supportedTokens, string _url, uint8 _port, uint _index) private{

    // TODO: Permissions
    // TODO: Check if address for relay already exists
    // TODO: Dynamic burn amount
    // TODO: Check if address is already registered

    registerNodeRecord(_nodeAddress, _supportedTokens, _url, _port, _index);

    // Cannot return values due to delegatecall limitations. See https://ethereum.stackexchange.com/questions/8099/delegatecall-and-function-return-values
    /* createNodeContract(); */
  }

  function registerOracle(address _nodeAddress, string[] _supportedTokens, string _url, uint8 _port, uint _index) private{

    registerOracleRecord(_nodeAddress, _supportedTokens, _url, _port, _index);

  }

  function createNodeOracle(string[] _supportedTokens, string _url, uint8 _port, bool _isRelayer, bool _isOracle) {
    require(_supportedTokens.count > 0)
    require(_url.length > 0)
    require(_port > 0)
    require(_isRelayer)
    require(_isOracle)
    
    tokenAddress.call(bytes4(sha3("burn(uint256,address)")),1,msg.sender);

    PocketNode newNode = new PocketNode();
    // TODO: nodeDelegateAddress should only get set once per upgrade
    newNode.supportedTokens(_supportedTokens)
    newNode.url(_url)
    newNode.port(_port)
    newNode.isRelayer(_isRelayer)
    newNode.isOracle(_isOracle)
    newNode.changeDelegate(nodeDelegateAddress);
    newNode.setOwner(msg.sender);
    newNode.setTokenAddress(tokenAddress);
    userNode[msg.sender] = newNode;

    if newNode.isRelayer {
      registeredNodes.push(newNode)
      registerNodeRecord(newNode.address, newNode.supportedTokens, newNode.url, newNode.port, registeredNodes.length);
    }

    if newNode.isOracle {
      registeredOracles.push(newNode)
      registerOracleRecord(newNode.address, newNode.supportedTokens, newNode.url, newNode.port, registeredNodes.length);
    }

  }

  function getLiveNodes() constant returns (address[]) {
    return registeredNodes;
  }

  function getLiveOracles() constant returns (address[]) {
    return registeredOracles;
  }

  function setTokenAddress(address _tokenAddress) {
    assert(owner == msg.sender);
    tokenAddress = _tokenAddress;
  }

  function setNodeDelegateAddress(address _nodeDelegateAddress) {
    assert(owner == msg.sender);
    nodeDelegateAddress = _nodeDelegateAddress;
  }

}
