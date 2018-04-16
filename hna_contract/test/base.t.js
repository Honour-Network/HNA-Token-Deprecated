//


const HNATokenBaseTest = artifacts.require('HNATokenBaseTest')

// const = HNATest = artifacts.require('HNAMathTest')

contract('HNATokenBaseTest', accounts => {

    it('HNATokenBaseTest Test', async function () {
    const owner = accounts[0]
    const user1 = accounts[1]
    const user2 = accounts[2]
    const myHNAMathTest = await HNATokenBaseTest.new({ from: owner })
    // myHNAMathTest.testFail_add()
    myHNAMathTest.setUp()
    // myHNAMathTest.testFail_sub()
    // myHNAMathTest.testFailInsufficientFundsTransfers()
    // myHNAMathTest.test_mul()
    // myHNAMathTest.test_wmul_fractions()
    // myHNAMathTest.test_mul()
    // myHNAMathTest.test_min()
    // myHNAMathTest.test_max()
    // myHNAMathTest.test_imin()
    // myHNAMathTest.test_imax()
    // // myHNAMathTest.testFail_wmul_overflow()
    // myHNAMathTest.test_wmul_trivial()
    // myHNAMathTest.test_wmul_fractions()
    // // myHNAMathTest.testFail_wdiv_zero()
    // myHNAMathTest.test_wdiv_trivial()
    // myHNAMathTest.test_wdiv_fractions()

    // var temp1 = myHNAMathTest.test_wmul_rounding()
    // var temp2 = myHNAMathTest.test_rmul_rounding()
    // setTimeout(() => {
    //     myHNAMathTest.testValidTransfers();
    //     // myHNAMathTest.testFailInsufficientFundsTransfers();
    //     },1000)

    setTimeout(() => {
        // myHNAMathTest.testValidTransfers();
        myHNAMathTest.testFailChargeMoreThanApproved();
        },2000)
    // console.log(temp1)
    // console.log(temp2)
    
    // myHNAMathTest.test_add()

    // let log_bytes32Event = myHNAMathTest.log_bytes32( {fromBlock: 0, toBlock: 'latest'})

    // log_bytes32Event.get((error, logs) => {
    //   // we have the logs, now print them
    //   // console.log(erp.getCompanyName(logs['args']._from)+ ' to ' +erp.getCompanyName(res['args']._to) )
    //   // logs.forEach(log => console.log() )
    //   console.log(logs);
    // })

    })


})
