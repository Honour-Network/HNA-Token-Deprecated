var HNA = artifacts.require("HNA");

var Crowdsale = artifacts.require("Crowdsale");

// import '../web3.min.js'

module.exports = function(deployer, network, accounts){ 
	const userAddress = accounts[0];
	const fundingGoal = 1000;//new BigNumber(1000); //ether
	const durationInMinutes = 10;//new BigNumber(10); // minute
	const etherCostOfEachToken = 1;//new BigNumber(1); // ether/HNA
	const lockedInMinutes = 2;//new BigNumber(2); // minute
	var tokenAddress = "0x62227531b82259561cc9ad4413188f08e536598a";
	// const tokenAddress = "0x0000000000000000000000000000000000000000";
	// deployer.deploy(Crowdsale, userAddress, fundingGoal, durationInMinutes, etherCostOfEachToken, lockedInMinutes, tokenAddress); 

	// Deploy A, then deploy B, passing in A's newly deployed address
	deployer.deploy(HNA).then(function() {
	  return deployer.deploy(Crowdsale,  userAddress, fundingGoal, durationInMinutes, etherCostOfEachToken, lockedInMinutes, HNA.address);
	});

};

