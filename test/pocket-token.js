var PocketToken = artifacts.require('./PocketToken.sol');

contract('PocketToken', function(accounts) {

  var sender = accounts[0];
  var relayer = accounts[1];
  var attacker = accounts[accounts.length - 1];
  var token;

  it("Should check that stake value is greater than 0", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.stake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.isAbove(amount.toNumber(), 0, "greater than zero");
    });
  });

  it("should release stake value", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.releaseStake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.equal(amount.toNumber(),0, "equal to zero");
    });
  });

  it("Should check that stake value is equal", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.stake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.equal(amount.toNumber(), 1, "equal to 1");
    });
  });




    it("should assert true", function(done) {
    var pocketToken = PocketToken.deployed();
    assert.isTrue(true);
    done();
  });
});
