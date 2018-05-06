var HNA = artifacts.require("HNA");

var HNAContribution = artifacts.require("HNAContribution");


module.exports = function(deployer, network, accounts){ 
	const userAddress = accounts[0];
	const fundingGoal = 350000000;//new BigNumber(1000); //ether
	const durationInMinutes = 30*24*60;//new BigNumber(10); // minute
	const weiCostOfEachToken = 200000000000000;//new BigNumber(1); // ether/HNA
	const lockedInMinutes = 30*24*60;//new BigNumber(2); // minute
	// var tokenAddress = "0x62227531b82259561cc9ad4413188f08e536598a";
	// const tokenAddress = "0x0000000000000000000000000000000000000000";
	// deployer.deploy(HNAContribution, userAddress, fundingGoal, durationInMinutes, etherCostOfEachToken, lockedInMinutes, tokenAddress); 

	// Deploy A, then deploy B, passing in A's newly deployed address
	deployer.deploy(HNA).then(function() {
	  // return deployer.deploy(HNAContribution,  userAddress, fundingGoal, durationInMinutes, weiCostOfEachToken, lockedInMinutes, HNA.address);
	  return deployer.deploy(HNAContribution);
	});

};

