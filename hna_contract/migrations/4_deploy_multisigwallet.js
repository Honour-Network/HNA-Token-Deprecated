
var MultiSigWallet = artifacts.require("MultiSigWallet");


module.exports = function(deployer, network, accounts){ 
	const userAddress = accounts.slice(0,5);
	const requires = 3;

	deployer.deploy(MultiSigWallet,  userAddress, requires);
};

