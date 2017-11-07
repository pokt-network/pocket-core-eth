module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "localhost",
      port: 8545,
      network_id: "4",
      from: "0xfc7846d06fab273c62cda0d29eac0936a22eeca4",
      gas: 2000000
    }
  }
};
