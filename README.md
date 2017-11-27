# Pocket Network Contracts

Pocket Network is a blockchain agnostic, decentralized relay network. Nodes in the network spend compute in the form of running local nodes (geth/parity, bitcoin core, zcash, etc) and hosting standardized REST API endpoints. They relay transactions in return for mint in PKT.

## Token Overview

- ERC20 token
- Tokens burned through registry contract
- Tokens staked by users and relayers
- Transactions throttled based on amount staked
- 4 primary contracts: Token, Relay, Oracle, and Registry


### Missing features
- Infinite mint
- Logarithmic scale minting schedule
- Mint received by relayers and oracles
- Relays throttled based on amount staked

## TODOs

Node creation management and permissions

Staking and slashing functions for nodes

Need to ensure permissions are done for function access

Minting mechanism

Oracles

## Known excessive/high gas costs

changeDelegate called every time for PocketNode contracts

strings should be bytes

Registry too expensive

Relay contract created for each relay

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
```

Check `getThrottleResetBlock` and `getCurrentThrottleBlock` to see when relay will be reset.

The `throttle` coefficient is what determines how many relays a user can create within a given number of blocks.

Using `currentThrottleBlock` and `throttleResetBlock` to reset the `stakerCount`. Hardcoded every 10 blocks for now. Need to figure out a dynamic way to do this.
