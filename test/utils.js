module.exports = {
  expectedEventOcurred: function(transactionResponse, eventFilter) {
    var logs = transactionResponse.logs,
        result = true;

    if (logs) {
      var keys = ['logIndex', 'event'];
      for (var i = 0; i < logs.length; i++) {
        var log = logs[i];
        for (var i = 0; i < keys.length; i++) {
          if(log[keys[i]] != eventFilter[keys[i]]){
            result = false;
            break;
          }
        }
      }
    }

    return result;
  },
  stakePokt: function(pocketTokenContract, stakerAddress, amount) {
    return pocketTokenContract.stake(amount, {from: stakerAddress});
  },
  releasePoktStake: function(pocketTokenContract, stakerAddress, amount) {
    return pocketTokenContract.releaseStake(amount, {from: stakerAddress});
  },
  getPoktStakeBalance: function(pocketTokenContract, stakerAddress) {
    return pocketTokenContract.stakedBalanceOf.call(stakerAddress, {from: stakerAddress});
  }
};
