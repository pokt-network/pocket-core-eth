module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "127.0.0.1",
      port: 8545,
      network_id: 4,
      from: "0xE1B33AFb88C77E343ECbB9388829eEf6123a980a",
      gas: 7003700
    }
  }
};
