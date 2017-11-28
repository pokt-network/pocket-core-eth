# Pocket Network Contracts

Pocket Network is a blockchain agnostic, decentralized relay network. Nodes in the network spend compute in the form of running local nodes (geth/parity, bitcoin core, zcash, etc) and hosting standardized REST API endpoints. Nodes relay transactions for users in return for mint in PKT.

Users must stake PKT in order to use Node services. User transactions are throttled based on the amount of PKT staked in the PocketToken contract. Users must stake more PKT to send more transactions.

## Overview

- ERC20 token
- Tokens burned through registry contract
- Tokens staked by users and relayers
- Transactions throttled based on amount staked
- 4 primary contracts: Token, Relay, Oracle, and Registry

## TODOs

- Node creation management and permissions
- Staking and slashing functions for nodes
- Minting mechanism
- Oracles
- Mint
- Logarithmic scale minting schedule
- Relays throttled based on Node amount staked
- Relay/Node Slashing

## Known excessive/high gas costs

- changeDelegate called every time for PocketNode contracts
- strings should be bytes
- Registry too expensive
- Relay contract created for each relay

## truffle testrpc commands

To simulate the throttling of relays.
```
PocketToken.deployed().then(function(instance) {token = instance})
PocketRegistry.deployed().then(function(instance) { registry = instance })
PocketRegistryDelegate.deployed().then(function(instance) { registryDelegate = instance })
PocketNodeDelegate.deployed().then(function(instance) { nodeDelegate = instance })
registry.changeDelegate(registryDelegate.address)
registry.setNodeDelegateAddress(nodeDelegate.address)
registry.setTokenAddress(token.address)
token.stake(1)
sender = web3.eth.accounts[0]
relayer = web3.eth.accounts[1]
token.transfer(relayer,50)
registry.registerNode()
registry.registerBurn({from:relayer})
registry.getLiveNodes()
node = PocketNode.at("address")
node.checkThrottle(sender)
node.getRelays()
relay = PocketRelay.at("address")
relay.approveTransaction()
```
