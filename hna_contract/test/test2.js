const HNAAuth = artifacts.require('HNAAuth')

contract('HNAAuth', accounts => {

  it('Honour Netwrok Access Token Test', async function () {
    const owner = accounts[0]
    const user1 = accounts[1]
    const user2 = accounts[2]
    const myHNAAuth = await HNAAuth.new({ from: owner })
    await myHNAAuth.setOwner(user1)
    const newOwner = await myHNAAuth.getOwner()
    console.log(newOwner)
  })
})