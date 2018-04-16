// var HDWalletProvider = require("truffle-hdwallet-provider");


// var mnemonic = "timber festival vivid nothing guide dismiss woman drastic rubber blame kitchen purchase";

// new HDWalletProvider(mnemonic, "https://ropsten.infura.io/<Infura_Access_Token>", 2);

// module.exports = {
//   networks: {
//     development: {
//       host: "127.0.0.1",
//       port: 7545,
//       network_id: "*" // Match any network id
//       // gas: 30000000
//     },
//     ropsten: {
//       provider: function() {
//         return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/3kifGMhZ0pDkt7Dn6Mdz")
//       },
//       network_id: 3,
//       gas: 5000000
//     }   
//   }
// };

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
      // gas: 30000000
    }
  }
};