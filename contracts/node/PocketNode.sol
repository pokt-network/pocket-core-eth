pragma solidity ^0.4.11;

import "../relay/PocketRelay.sol";
import "../token/PocketToken.sol";
import "./RelayCrud.sol";

contract PocketNode is RelayCrud {

  // Public attributes
  address public ownerAddress;
  bool public isRelayer;
  bool public isOracle;
  address public delegateContract;
  address[] public previousDelegates;

  /*
   * Contract Events
   */
  event DelegateChanged(address oldAddress, address newAddress);

  /*
   * Contract functions
   */

  // TO-DO: Implement this
  /**
   * Represents a PocketNode.
   * @constructor
   * @param {address} _ownerAddress - The owner of this PocketNode
   * @param {bool} _isRelayer - Determines wheter or not the new node is a Relayer
   * @param {bool} _isOracle - Determines wheter or not the new node is an Oracle
   */
  function PocketNode(address _ownerAddress, address _delegateAddress, bool _isRelayer, bool _isOracle) {
    ownerAddress = _ownerAddress;
    isRelayer = _isRelayer;
    isOracle = _isOracle;
    changeDelegate(_delegateAddress);
  }

  // TO-DO: Implement this
  function createRelay() {

  }

  // TO-DO: Implement this
  function submitRelayVote() {

  }

  /**
   * Allows to change the PocketNodeDelegate contract that this PocketNode uses
   * @param {address} _newDelegate - The address for the new delegate PocketNodeDelegate
   */
  function changeDelegate(address _newDelegate) {
    // Avoid setting up the same contract as delegate twice
    require(_newDelegate != delegateContract);

    // Registers new delegate
    previousDelegates.push(delegateContract);
    var oldDelegate = delegateContract;
    delegateContract = _newDelegate;
    DelegateChanged(oldDelegate, _newDelegate);
  }



  /*

  // Node contract is the contract that relayers will get assigned when signing up to the registry
  // checkThrottle checks the staked amount of PKT that application has
  // If not throttled, a relay contract will be created
  function checkThrottle(address _throttleAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("checkThrottle(address)")), _throttleAddress));
  }

  function getRelays() constant returns (address[]) {
    return activeRelays;
  }

  function setOwner(address _ownerAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setOwner(address)")), _ownerAddress));
  }

  function setTokenAddress(address _tokenAddress) {
    require(delegateContract.delegatecall(bytes4(sha3("setTokenAddress(address)")), _tokenAddress));
  } */
}
