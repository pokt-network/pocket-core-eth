## truffle testrpc commands

To simulate the throttling of relays.
```
PocketToken.deployed().then(function(instance) {token = instance})
PocketRegistry.deployed().then(function(instance) { registry = instance })
token.stake(1)
sender = web3.eth.accounts[0]
relayer = web3.eth.accounts[1]
token.transfer(relayer,50)
node.checkThrottle(token.address,sender)
registry.registerBurn(token.address,"url")
registry.registerBurn(token.address,"url", {from:relayer})
registry.getNodes()
node = PocketNode.at("address")
node.checkThrottle(token.address, sender,{from:relayer})
```

Check `getThrottleResetBlock` and `getCurrentThrottleBlock` to see when relay will be reset.

The `throttle` coefficient is what determines how many relays a user can create within a given number of blocks.

Using `currentThrottleBlock` and `throttleResetBlock` to reset the `stakerCount`. Hardcoded every 10 blocks for now. Need to figure out a dynamic way to do this.


# TODOs

Node Factory Management and permissions

Slashing functions for nodes

Need to ensure permissions are done for function access

Minting mechanism

Oracles

Upgradeable contracts

Reduce gas costs
