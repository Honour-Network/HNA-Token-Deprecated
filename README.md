# HNA-Token
Honour NetWork Access Token

## Prerequisites:
1. Truffle: correctly installed, Refer to the following URL: [Truffle installation](http://truffleframework.com/docs/getting_started/installation)
2. Ganache or ganache-cli: installed correctly to start a private chain, Refer to: [Ganache installation](http://truffleframework.com/ganache/)

## Compiling, deploying, and testing the contract:
### 1. compile
In the hna_contract directory, run the command line:

    `truffle compile`

At this point, the build folder and the compiled json files for each smart contract will be generated. Copy the abi of the *HNA.json* file into the [abi_hna.js](/hna_contract/abi_hna.js) file, replacing the original abi; copy the abi of the *Crowdsale.json* file into the [abi_crowdsale.js](/hna_contract/abi_crowdsale.js) file, replacing the original abi.

### 2. Deployment
In the hna_contract directory, run the command line:

    `truffle migrate`
You can deploy successfully. At this time, the command line will have the address of the HNA contract and the address of the Crowdsale contract. Copy them into
*Web3_test_contract_hna.html* and *Web3_test_contract_crowdsale.html* files, and used as the arguments for functions that are instantiated as smart contracts .at("contract address")

### 3. Test
Open *Web3_test_contract_hna.html* or *Web3_test_contract_crowdsale.html* in browser, press F12 to test various functions of smart contracts in the test interface