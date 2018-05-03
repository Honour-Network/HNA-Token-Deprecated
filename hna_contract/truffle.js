var HDWalletProvider = require("truffle-hdwallet-provider");

const myModule = require('./mnemonic');
let mnemonic = myModule.mnemonic(); 

// new HDWalletProvider(mnemonic, "https://ropsten.infura.io/<Infura_Access_Token>", 2);

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
      // gas: 30000000
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/3kifGMhZ0pDkt7Dn6Mdz")
      },
      network_id: 3,
      gas: 4000000
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://kovan.infura.io/3kifGMhZ0pDkt7Dn6Mdz")
      },
      network_id: 42,
      gas: 4000000
    }
  }
};

 

// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // for more about customizing your Truffle configuration!
//   networks: {
//     development: {
//       host: "127.0.0.1",
//       port: 7545,
//       network_id: "*" // Match any network id
//       // gas: 30000000
//     },
//     live: {
//       host: "localhost", //本地地址，因为是在本机上建立的节点
//       port: 8545,        //Ethereum的rpc监听的端口号，默认是8545
//       network_id: 999    // 自定义网络号
//     }
//   }
// };