//


// const HNATokenTest = artifacts.require('HNATokenTest')

// // const = HNATest = artifacts.require('HNAMathTest')

// contract('HNATokenTest', accounts => {

//     it('HNATokenTest Test', async function () {
//     const owner = accounts[0]
//     const user1 = accounts[1]
//     const user2 = accounts[2]
//     const myHNAMathTest = await HNATokenTest.new({ from: owner})
//     // myHNAMathTest.testFail_add()
//     myHNAMathTest.setUp()
//     // myHNAMathTest.testFail_sub()
//     // myHNAMathTest.testFailInsufficientFundsTransfers()
//     // myHNAMathTest.test_mul()
//     // myHNAMathTest.test_wmul_fractions()
//     // myHNAMathTest.test_mul()
//     // myHNAMathTest.test_min()
//     // myHNAMathTest.test_max()
//     // myHNAMathTest.test_imin()
//     // myHNAMathTest.test_imax()
//     // // myHNAMathTest.testFail_wmul_overflow()
//     // myHNAMathTest.test_wmul_trivial()
//     // myHNAMathTest.test_wmul_fractions()
//     // // myHNAMathTest.testFail_wdiv_zero()
//     // myHNAMathTest.test_wdiv_trivial()
//     // myHNAMathTest.test_wdiv_fractions()

//     // var temp1 = myHNAMathTest.test_wmul_rounding()
//     // var temp2 = myHNAMathTest.test_rmul_rounding()
//     setTimeout(() => {
//         myHNAMathTest.testValidTransfers();
//         // myHNAMathTest.testFailTransferWithoutApproval();
//         },1000)

//     // setTimeout(() => {
//     //     // myHNAMathTest.testValidTransfers();
//     //     myHNAMathTest.testChargesAmountApproved();
//     //     },2000)
//     // console.log(temp1)
//     // console.log(temp2)
    
//     // myHNAMathTest.test_add()

//     // let log_bytes32Event = myHNAMathTest.log_bytes32( {fromBlock: 0, toBlock: 'latest'})

//     // log_bytes32Event.get((error, logs) => {
//     //   // we have the logs, now print them
//     //   // console.log(erp.getCompanyName(logs['args']._from)+ ' to ' +erp.getCompanyName(res['args']._to) )
//     //   // logs.forEach(log => console.log() )
//     //   console.log(logs);
//     // })

//     })


// })



// const HNATokenTest2 = artifacts.require('HNATokenTest2')

// // const = HNATest = artifacts.require('HNAMathTest')

// contract('HNATokenTest2', accounts => {

//     it('HNATokenTest2 Test', async function () {
//     const owner = accounts[0]
//     // const user1 = accounts[1]
//     // const user2 = accounts[2]
//     const myHNAMathTest = await HNATokenTest2.new({ from: owner})
//     // myHNAMathTest.testFail_add()
//     myHNAMathTest.setUp()

//     setTimeout(() => {
//         myHNAMathTest.testFailBurnGuyWithoutTrust();
//         // myHNAMathTest.testFailMintNoAuth();
//         },1000)

//     })

// })

// const HNATokenTest3 = artifacts.require('HNATokenTest3')

// // const = HNATest = artifacts.require('HNAMathTest')

// contract('HNATokenTest3', accounts => {

//     it('HNATokenTest3 Test', async function () {
//     const owner = accounts[0]
//     const user1 = accounts[1]
//     const user2 = accounts[2]
//     const myHNAMathTest = await HNATokenTest3.new({ from: owner})
//     // myHNAMathTest.testFail_add()
//     myHNAMathTest.setUp()

//     setTimeout(() => {
//         // myHNAMathTest.testFailMoveWhenStopped();
//         // myHNAMathTest.testFailTransferWithoutApproval();
//         },1000)

//     })

// })


const HNATokenTest4 = artifacts.require('HNATokenTest4')

// const = HNATest = artifacts.require('HNAMathTest')

contract('HNATokenTest4', accounts => {

    it('HNATokenTest3 Test', async function () {
    const owner = accounts[0]
    const user1 = accounts[1]
    const user2 = accounts[2]
    const myHNAMathTest = await HNATokenTest4.new({ from: owner})
    // myHNAMathTest.testFail_add()
    myHNAMathTest.setUp()

    setTimeout(() => {
        myHNAMathTest.testFailTransferOnlyTrustedCaller();
        // myHNAMathTest.testFailTransferWithoutApproval();
        },1000)

    })

})