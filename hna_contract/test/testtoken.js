const HNA = artifacts.require('HNA')

contract('HNA', accounts => {

  it('Honour Netwrok Access Token Test', async function () {
    const owner = accounts[0]
    const user1 = accounts[1]
    const user2 = accounts[2]
    const myToken = await HNA.new({ from: owner })

    // const creator = await myToken.creator()
    // const totalSupply = await myToken.totalSupply()

    // await console.log(totalSupply.toNumber())

    // const addSupply = await myToken.mint(10,{from:owner})
    // const addSupply2 = await myToken.mint(10)

    // const newtotalSupply = await myToken.totalSupply()

    // const ownerBalance = await myToken.balanceOf(owner)

    // await myToken.transfer(user1, 10)

    // await myToken.transfer(user2, 5, {from:user1})

    // const userBalance = await myToken.balanceOf(user1)

    // // assert(creator === owner)
    // // assert(totalSupply.eq(10000))
    // await console.log(newtotalSupply.toNumber())
    // await console.log(ownerBalance.toNumber())
    // await console.log(userBalance.toNumber())

    setTimeout(() => {
        myToken.startFunding();
        // myHNAMathTest.testFailTransferWithoutApproval();
        console.log(1000)
        },1000)

    setTimeout(() => {
        myToken.buy({from:user1, value:200000000000000});
        // myHNAMathTest.testFailTransferWithoutApproval();
        console.log(2000)
        },2000)

    // setTimeout(() => {
    //     myToken.drawbackETH({from:owner});
    //     // myHNAMathTest.testFailTransferWithoutApproval();
    //     console.log(3000)
    //     },3000)

    //测试冻结账户
   setTimeout(() => {
        myToken.freezeAccount(user1, {from:owner});
        // myHNAMathTest.testFailTransferWithoutApproval();
        console.log(3000-2)
        },3000)

   setTimeout(() => {
        myToken.defreezeAccount(user1, {from:owner});
        // myHNAMathTest.testFailTransferWithoutApproval();
        console.log(3500)
        },3500)

    setTimeout(() => {
	    temp =  myToken.sell(1000000000000000000, {from:user1})
	    console.log(temp)
	    console.log(4000)
        },4000)
    setTimeout(() => {
	    // temp =  myToken.sell(1000000000000000000, {from:user1})
	    console.log(temp)
	    console.log(5000)
        },5000)

    // myToken.startFunding(1,1000)
    // myToken.buy({from:user1, value:1000000000000000000})
    // myToken.drawbackETH({from:owner})
    // temp =  myToken.sell(1000000000000000000, {from:user1})
    // await console.log(temp)

  })
})


// const MyToken = artifacts.require('HNAToken')

// contract('HNAToken', accounts => {

//   it('Honour Netwrok Access Token Test', async function () {
//     const owner = accounts[0]
//     const user1 = accounts[1]
//     const user2 = accounts[2]
//     const myToken = await MyToken.new("HNA-Token", { from: owner })

//     // const creator = await myToken.creator()
//     const totalSupply = await myToken.totalSupply()

//     await console.log(totalSupply.toNumber())

//     const addSupply = await myToken.mint(10,{from:owner})
//     const addSupply2 = await myToken.mint(10)

//     const newtotalSupply = await myToken.totalSupply()

//     const ownerBalance = await myToken.balanceOf(owner)

//     await myToken.transfer(user1, 10)

//     await myToken.transfer(user2, 5, {from:user1})

//     const userBalance = await myToken.balanceOf(user1)

//     // assert(creator === owner)
//     // assert(totalSupply.eq(10000))
//     await console.log(newtotalSupply.toNumber())
//     await console.log(ownerBalance.toNumber())
//     await console.log(userBalance.toNumber())
//   })
// })

// const MyBaseToken = artifacts.require('HNATokenBase')

// contract('HNATokenBase', accounts => {

//   it('Honour Netwrok Access Token Test', async function () {
//     const owner = accounts[0]
//     const user1 = accounts[1]
//     const user2 = accounts[2]
//     const myToken = await MyBaseToken.new(100, { from: owner })

//     // const creator = await myToken.creator()
//     const totalSupply = await myToken.totalSupply()

//     await console.log(totalSupply.toNumber())

//     // const addSupply = await myToken.mint(10,{from:owner})
//     // const addSupply2 = await myToken.mint(10)

//     const newtotalSupply = await myToken.totalSupply()

//     const ownerBalance = await myToken.balanceOf(owner)

//     await myToken.transfer(user1, 10)

//     await myToken.transfer(user2, 5, {from:user1})

//     const userBalance = await myToken.balanceOf(user1)

//     // assert(creator === owner)
//     // assert(totalSupply.eq(10000))
//     await console.log(newtotalSupply.toNumber())
//     await console.log(ownerBalance.toNumber())
//     await console.log(userBalance.toNumber())
//   })
// })

// const HNAAuthority = artifacts.require('HNAAuthority')

// contract('HNAAuthority', accounts => {

//   it('Honour Netwrok Access Token Test', async function () {
//     const owner = accounts[0]
//     const user1 = accounts[1]
//     const user2 = accounts[2]
//     const myHNAAuthority = await HNAAuthority.new({ from: owner })
//     myHNAAuthority.canCall(owner, user, '1')
//   })
// })
