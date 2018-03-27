exports.registerNode = async(nodeRegistry, owner, networks, endpoint) => {
  var txResult = await nodeRegistry.register(networks, endpoint, {from: owner}),
      relayerNonce = txResult.logs[0].args._nonce;
  return relayerNonce;
};

exports.addRelayToCurrentEpoch = async(epochRegistry, nodeAccount, nodeNonce, txHash, token, sender) => {
  var txResult = await epochRegistry.addRelayToCurrentEpoch(token, txHash, sender, nodeNonce, {from: nodeAccount}),
      result = null;
  for (var i = 0; i < txResult.logs.length; i++) {
    var currLog = txResult.logs[i];
    if (currLog.event === 'RelayAddedToEpoch') {
      result = txResult.logs[i].args._relayNonce;
      break;
    }
  }
  return result;
};
