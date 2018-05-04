
var Web3 = require('web3');

if (typeof web3 !== 'undefined') {
    // Set web3 through existed provider e.g. MetaMask
    web3 = new Web3(web3.currentProvider);
} else {
    // Set web3 through provider of Infura
    web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/3kifGMhZ0pDkt7Dn6Mdz"));
}

async function getUser(){

	var functionSig = await web3.utils.sha3("symbol()").substr(2,8)
	var result = await web3.eth.call({
	    to: "0x77c3097d38585bd586b13bb5c63a2b4a4037edb3", 
	    data: "0x" + functionSig
	});
	await console.log("symbol:"+result);


	var functionSig1 = await web3.utils.sha3("getOwner()").substr(2,8)
	var owner = await web3.eth.call({
	    to: "0x77c3097d38585bd586b13bb5c63a2b4a4037edb3", 
	    data: "0x" + functionSig1
	});
	await console.log("owner:"+owner);
	await console.log("0x" + functionSig1 + owner.substr(2,))

	var functionSig2 = await web3.utils.sha3("balanceOf(address)").substr(2,8)
	var balanceOfowner = await web3.eth.call({
	    to: "0x77c3097d38585bd586b13bb5c63a2b4a4037edb3", 
	    data: "0x" + functionSig2 + owner.substr(2,)
	});
	await console.log("balanceOfowner:"+balanceOfowner);


	var functionSig3 = await web3.utils.sha3("mint(address,uint256)").substr(2,8)
	var rawTx = await {
	    nonce: '0x50',
	    gasPrice: '0x3B9ACA00', 
	    gasLimit: '0xAC20A',
	    to: '0x77c3097d38585bd586b13bb5c63a2b4a4037edb3', 
	    value: '0x00', 
	    data: "0x" + functionSig3 + owner.substr(2,) + '0000000000000000000000000000000000000000000000000000000000999999'
	}

	await console.log(rawTx);

	var Tx = await require('ethereumjs-tx');
	var tx = await new Tx(tx);

	await console.log(tx);

	var myprivkey = "20FF0E7F3725F5F5CD124DD7DF50E402A40AAAB0242CBF50453F15A100C70C0B";
	const privateKey = await new Buffer(myprivkey, 'hex'); 
	await tx.sign(privateKey);

	
	await console.log("hello");

	var serializedTx = await tx.serialize();

	await console.log(serializedTx);
	await web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'), function(err, hash) {
	    if (!err) {
	        console.log(hash);
	    } else {
	        console.log(err)
	    }
	});

	// owner = await allAccounts[0];
	// user1 = await allAccounts[1];
	// user2 = await allAccounts[2];
	// await console.log('owner:'+owner);
	// await console.log('user1:'+user2);
	// await console.log('user2:'+user2);
}

getUser();