var PocketToken = artifacts.require('./PocketToken.sol');

contract('PocketToken', function(accounts) {

  var sender = accounts[0];
  var token;

  it("Should check that stake value is greater than 0", function() {
    return PocketToken.deployed().then(function(instance) {
      token = instance;
      token.stake(1, {from:sender});
      return token.stakerAmount.call(sender);
    }).then(function(amount) {
      assert.isAbove(amount, 0, "greater than zero");
    });
  });

    it("should assert true", function(done) {
    var pocketToken = PocketToken.deployed();
    assert.isTrue(true);
    done();
  });
});
