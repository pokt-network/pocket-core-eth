## truffle testrpc commands

To simulate the throttling of relays.
```
PocketToken.deployed().then(function(instance) {token = instance})
PocketNode.deployed().then(function(instance) {node = instance})
PocketNodeRegistry.deployed().then(function(instance) { registry = instance })
token.stake(1)
sender = web3.eth.accounts[0]
node.checkThrottle(token.address,sender)
registry.registerBurn(token.address,"url")
```

Check `getThrottleResetBlock` and `getCurrentThrottleBlock` to see when relay will be reset.

The `throttle` coefficient is what determines how many relays a user can create within a given number of blocks.

Using `currentThrottleBlock` and `throttleResetBlock` to reset the `stakerCount`. Hardcoded every 10 blocks for now. Need to figure out a dynamic way to do this.


# TODOs

Need to ensure permissions are done for function access

Node Registry

Minting mechanism

Oracles

Upgradeable contracts
