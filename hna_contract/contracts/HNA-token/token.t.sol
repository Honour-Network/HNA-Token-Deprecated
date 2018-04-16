/// token.t.sol -- test for token.sol

pragma solidity ^0.4.13;

import "./test.sol";

import "./token.sol";

contract TokenUser {
    HNAToken  token;

    function TokenUser(HNAToken token_) public {
        token = token_;
    }

    function doTransferFrom(address from, address to, uint amount)
        public
        returns (bool)
    {
        return token.transferFrom(from, to, amount);
    }

    function doTransfer(address to, uint amount)
        public
        returns (bool)
    {
        return token.transfer(to, amount);
    }

    function doApprove(address recipient, uint amount)
        public
        returns (bool)
    {
        return token.approve(recipient, amount);
    }

    function doAllowance(address owner, address spender)
        public
        view
        returns (uint)
    {
        return token.allowance(owner, spender);
    }

    function doBalanceOf(address who) public view returns (uint) {
        return token.balanceOf(who);
    }

    function doSetName(bytes32 name) public {
        token.setName(name);
    }

    function doApprove(address guy)
        public
        returns (bool)
    {
        return token.approve(guy);
    }
    function doPush(address who, uint amount) public {
        token.push(who, amount);
    }
    function doPull(address who, uint amount) public {
        token.pull(who, amount);
    }
    function doMove(address src, address dst, uint amount) public {
        token.move(src, dst, amount);
    }
    function doMint(uint wad) public {
        token.mint(wad);
    }
    function doBurn(uint wad) public {
        token.burn(wad);
    }
    function doMint(address guy, uint wad) public {
        token.mint(guy, wad);
    }
    function doBurn(address guy, uint wad) public {
        token.burn(guy, wad);
    }

}

// contract HNATokenTest is HNATest {
//     uint constant initialBalance = 1000;

//     HNAToken token;
//     TokenUser user1;
//     TokenUser user2;

//     // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
//     function setUp() public {
//         token = createToken();
//         token.mint(initialBalance);
//         user1 = new TokenUser(token);
//         user2 = new TokenUser(token);
//     }

//     // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
//     function createToken() internal returns (HNAToken) {
//         return new HNAToken("HNA");
//     }

//     // setUp后运行，检查合约的余额是不是等于初始发行量
//     function testSetupPrecondition() public {
//         assertEq(token.balanceOf(this), initialBalance);
//     }

//     // 代币发送给0地址，logs_gas：计算执行过程中的gas消耗量，并写入log
//     // 发送给0地址的代币无法取回?
//     function testTransferCost() public logs_gas {
//         token.transfer(address(0), 10);
//     }

//     // 检查uer1给user2（这两个都是TokenUser合约（地址））的许可量是否为0
//     function testAllowanceStartsAtZero() public logs_gas {
//         assertEq(token.allowance(user1, user2), 0);
//     }

//     // 给user2转账250
//     function testValidTransfers() public logs_gas {
//         uint sentAmount = 250;
//         log_named_address("token11111", token);
//         token.transfer(user2, sentAmount);
//         assertEq(token.balanceOf(user2), sentAmount);
//         assertEq(token.balanceOf(this), initialBalance - sentAmount);
//     }

//     // user2给this转250，会失败，因为user2没有给this的许可量，即_approval[user2][this] = 0
//     function testFailWrongAccountTransfers() public logs_gas {
//         uint sentAmount = 250;
//         token.transferFrom(user2, this, sentAmount);
//     }

//     // 第二个转账会失败，因为this没有足够的余额了
//     function testFailInsufficientFundsTransfers() public logs_gas {
//         uint sentAmount = 250;
//         token.transfer(user1, initialBalance - sentAmount);
//         token.transfer(user2, sentAmount + 1);
//     }

//     // 测试this给user2许可，之后user2就可以从this转出这些许可了，转给谁都可以
//     function testApproveSetsAllowance() public logs_gas {
//         log_named_address("Test", this);
//         log_named_address("Token", token);
//         log_named_address("Me", this);
//         log_named_address("User 2", user2);
//         token.approve(user2, 25);
//         assertEq(token.allowance(this, user2), 25);
//     }

//     // 测试修改许可量，修改this给user2的许可量，然后user2将这笔许可从this转给了自己（也可以转给别人）
//     function testChargesAmountApproved() public logs_gas {
//         uint amountApproved = 20;
//         token.approve(user2, amountApproved);
//         assertTrue(user2.doTransferFrom(this, user2, amountApproved));
//         assertEq(token.balanceOf(this), initialBalance - amountApproved);
//     }

//     function testFailTransferWithoutApproval() public logs_gas {
//         address self = this;
//         token.transfer(user1, 50);
//         token.transferFrom(user1, self, 1);
//     }

//     function testFailChargeMoreThanApproved() public logs_gas {
//         address self = this;
//         token.transfer(user1, 50);
//         user1.doApprove(self, 20);
//         token.transferFrom(user1, self, 21);
//     }
//     function testTransferFromSelf() public {
//         token.transferFrom(this, user1, 50);
//         assertEq(token.balanceOf(user1), 50);
//     }
//     function testFailTransferFromSelfNonArbitrarySize() public {
//         // you shouldn't be able to evade balance checks by transferring
//         // to yourself
//         token.transferFrom(this, this, token.balanceOf(this) + 1);
//     }

// }

// /**
//  * The contractName contract does this and that...
//  */

// contract HNATokenTest2 is HNATest {
//     uint constant initialBalance = 1000;

//     HNAToken token;
//     TokenUser user1;
//     TokenUser user2;

//     // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
//     function setUp() public {
//         token = createToken();
//         token.mint(initialBalance);
//         user1 = new TokenUser(token);
//         user2 = new TokenUser(token);
//     }

//     // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
//     function createToken() internal returns (HNAToken) {
//         return new HNAToken("HNA");
//     }
  

//     function testMint() public {
//         uint mintAmount = 10;
//         token.mint(mintAmount);
//         assertEq(token.totalSupply(), initialBalance + mintAmount);
//     }
//     function testMintThis() public {
//         uint mintAmount = 10;
//         token.mint(mintAmount);
//         assertEq(token.balanceOf(this), initialBalance + mintAmount);
//     }
//     function testMintGuy() public {
//         uint mintAmount = 10;
//         token.mint(user1, mintAmount);
//         assertEq(token.balanceOf(user1), mintAmount);
//     }
//     function testFailMintNoAuth() public {
//         user1.doMint(10);
//     }
//     function testMintAuth() public {
//         token.setOwner(user1);
//         user1.doMint(10);
//     }
//     function testFailMintGuyNoAuth() public {
//         user1.doMint(user2, 10);
//     }
//     function testMintGuyAuth() public {
//         token.setOwner(user1);
//         user1.doMint(user2, 10);
//     }

//     function testBurn() public {
//         uint burnAmount = 10;
//         token.burn(burnAmount);
//         assertEq(token.totalSupply(), initialBalance - burnAmount);
//     }
//     function testBurnThis() public {
//         uint burnAmount = 10;
//         token.burn(burnAmount);
//         assertEq(token.balanceOf(this), initialBalance - burnAmount);
//     }
//     function testFailBurnGuyWithoutTrust() public {
//         uint burnAmount = 10;
//         token.push(user1, burnAmount);
//         token.burn(user1, burnAmount);
//     }
//     function testBurnGuyWithTrust() public {
//         uint burnAmount = 10;
//         token.push(user1, burnAmount);
//         assertEq(token.balanceOf(user1), burnAmount);

//         user1.doApprove(this);
//         token.burn(user1, burnAmount);
//         assertEq(token.balanceOf(user1), 0);
//     }
//     function testFailBurnNoAuth() public {
//         token.transfer(user1, 10);
//         user1.doBurn(10);
//     }
//     function testBurnAuth() public {
//         token.transfer(user1, 10);
//         token.setOwner(user1);
//         user1.doBurn(10);
//     }
//     function testFailBurnGuyNoAuth() public {
//         token.transfer(user2, 10);
//         user2.doApprove(user1);
//         user1.doBurn(user2, 10);
//     }
//     function testBurnGuyAuth() public {
//         token.transfer(user2, 10);
//         token.setOwner(user1);
//         user2.doApprove(user1);
//         user1.doBurn(user2, 10);
//     }


//     function testFailTransferWhenStopped() public {
//         token.stop();
//         token.transfer(user1, 10);
//     }
//     function testFailTransferFromWhenStopped() public {
//         token.stop();
//         user1.doTransferFrom(this, user2, 10);
//     }
//     function testFailPushWhenStopped() public {
//         token.stop();
//         token.push(user1, 10);
//     }
//     function testFailPullWhenStopped() public {
//         token.approve(user1);
//         token.stop();
//         user1.doPull(this, 10);
//     }
//     function testFailMoveWhenStopped() public {
//         token.approve(user1);
//         token.stop();
//         token.move(this, user2, 10);
//     }
//     function testFailMintWhenStopped() public {
//         token.stop();
//         token.mint(10);
//     }
//     function testFailMintGuyWhenStopped() public {
//         token.stop();
//         token.mint(user1, 10);
//     }
//     function testFailBurnWhenStopped() public {
//         token.stop();
//         token.burn(10);
//     }
//     function testFailTrustWhenStopped() public {
//         token.stop();
//         token.approve(user1);
//     }


// }


// contract HNATokenTest3 is HNATest {
//     uint constant initialBalance = 1000;

//     HNAToken token;
//     TokenUser user1;
//     TokenUser user2;

//     // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
//     function setUp() public {
//         token = createToken();
//         token.mint(initialBalance);
//         user1 = new TokenUser(token);
//         user2 = new TokenUser(token);
//     }

//     // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
//     function createToken() internal returns (HNAToken) {
//         return new HNAToken("HNA");
//     }
//     function testSetName() public logs_gas {
//         assertEq(token.name(), "");
//         token.setName("Test");
//         assertEq(token.name(), "Test");
//     }

//     function testFailSetName() public logs_gas {
//         user1.doSetName("Test");
//     }

//     function testFailUntrustedTransferFrom() public {
//         assertEq(token.allowance(this, user2), 0);
//         user1.doTransferFrom(this, user2, 200);
//     }
//     function testTrusting() public {
//         assertEq(token.allowance(this, user2), 0);
//         token.approve(user2);
//         assertEq(token.allowance(this, user2), uint(-1));
//         token.approve(user2, 0);
//         assertEq(token.allowance(this, user2), 0);
//     }
//     function testTrustedTransferFrom() public {
//         token.approve(user1);
//         user1.doTransferFrom(this, user2, 200);
//         assertEq(token.balanceOf(user2), 200);
//     }

//     function testPush() public {
//         assertEq(token.balanceOf(this), 1000);
//         assertEq(token.balanceOf(user1), 0);
//         token.push(user1, 1000);
//         assertEq(token.balanceOf(this), 0);
//         assertEq(token.balanceOf(user1), 1000);
//         user1.doPush(user2, 200);
//         assertEq(token.balanceOf(this), 0);
//         assertEq(token.balanceOf(user1), 800);
//         assertEq(token.balanceOf(user2), 200);
//     }
//     function testFailPullWithoutTrust() public {
//         user1.doPull(this, 1000);
//     }
//     function testPullWithTrust() public {
//         token.approve(user1);
//         user1.doPull(this, 1000);
//     }
//     function testFailMoveWithoutTrust() public {
//         user1.doMove(this, user2, 1000);
//     }
//     function testMoveWithTrust() public {
//         token.approve(user1);
//         user1.doMove(this, user2, 1000);
//     }
//     function testApproveWillModifyAllowance() public {
//         assertEq(token.allowance(this, user1), 0);
//         assertEq(token.balanceOf(user1), 0);
//         token.approve(user1, 1000);
//         assertEq(token.allowance(this, user1), 1000);
//         user1.doPull(this, 500);
//         assertEq(token.balanceOf(user1), 500);
//         assertEq(token.allowance(this, user1), 500);
//     }
//     function testApproveWillNotModifyAllowance() public {
//         assertEq(token.allowance(this, user1), 0);
//         assertEq(token.balanceOf(user1), 0);
//         token.approve(user1);
//         assertEq(token.allowance(this, user1), uint(-1));
//         user1.doPull(this, 1000);
//         assertEq(token.balanceOf(user1), 1000);
//         assertEq(token.allowance(this, user1), uint(-1));
//     }

//     function testFailTransferOnlyTrustedCaller() public {
//         // only the entity actually trusted should be able to call
//         // and move tokens.
//         token.push(user1, 1);
//         user1.doApprove(user2);
//         token.transferFrom(user1, user2, 1);
//     } 
// }


contract HNATokenTest is HNATest {
    uint constant initialBalance = 1000;

    HNAToken token;
    TokenUser user1;
    TokenUser user2;

    // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
    function setUp() public {
        token = createToken();
        token.mint(initialBalance);
        user1 = new TokenUser(token);
        user2 = new TokenUser(token);
    }

    // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
    function createToken() internal returns (HNAToken) {
        return new HNAToken("HNA");
    }

    // setUp后运行，检查合约的余额是不是等于初始发行量
    function testSetupPrecondition() public {
        assertEq(token.balanceOf(this), initialBalance);
    }

    // 代币发送给0地址，logs_gas：计算执行过程中的gas消耗量，并写入log
    // 发送给0地址的代币无法取回?
    function testTransferCost() public logs_gas {
        token.transfer(address(0), 10);
    }

    // 检查uer1给user2（这两个都是TokenUser合约（地址））的许可量是否为0
    function testAllowanceStartsAtZero() public logs_gas {
        assertEq(token.allowance(user1, user2), 0);
    }

    // 给user2转账250
    function testValidTransfers() public logs_gas {
        uint sentAmount = 250;
        log_named_address("token11111", token);
        token.transfer(user2, sentAmount);
        assertEq(token.balanceOf(user2), sentAmount);
        assertEq(token.balanceOf(this), initialBalance - sentAmount);
    }

    // user2给this转250，会失败，因为user2没有给this的许可量，即_approval[user2][this] = 0
    function testFailWrongAccountTransfers() public logs_gas {
        uint sentAmount = 250;
        token.transferFrom(user2, this, sentAmount);
    }

    // 第二个转账会失败，因为this没有足够的余额了
    function testFailInsufficientFundsTransfers() public logs_gas {
        uint sentAmount = 250;
        token.transfer(user1, initialBalance - sentAmount);
        token.transfer(user2, sentAmount + 1);
    }

    // 测试this给user2许可，之后user2就可以从this转出这些许可了，转给谁都可以
    function testApproveSetsAllowance() public logs_gas {
        log_named_address("Test", this);
        log_named_address("Token", token);
        log_named_address("Me", this);
        log_named_address("User 2", user2);
        token.approve(user2, 25);
        assertEq(token.allowance(this, user2), 25);
    }

    // 测试修改许可量，修改this给user2的许可量，然后user2将这笔许可从this转给了自己（也可以转给别人）
    function testChargesAmountApproved() public logs_gas {
        uint amountApproved = 20;
        token.approve(user2, amountApproved);
        assertTrue(user2.doTransferFrom(this, user2, amountApproved));
        assertEq(token.balanceOf(this), initialBalance - amountApproved);
    }

    function testFailTransferWithoutApproval() public logs_gas {
        address self = this;
        token.transfer(user1, 50);
        token.transferFrom(user1, self, 1);
    }

    function testFailChargeMoreThanApproved() public logs_gas {
        address self = this;
        token.transfer(user1, 50);
        user1.doApprove(self, 20);
        token.transferFrom(user1, self, 21);
    }
    function testTransferFromSelf() public {
        token.transferFrom(this, user1, 50);
        assertEq(token.balanceOf(user1), 50);
    }
    function testFailTransferFromSelfNonArbitrarySize() public {
        // you shouldn't be able to evade balance checks by transferring
        // to yourself
        token.transferFrom(this, this, token.balanceOf(this) + 1);
    }

}

/**
 * The contractName contract does this and that...
 */

contract HNATokenTest2 is HNATest {
    uint constant initialBalance = 1000;

    HNAToken token;
    TokenUser user1;
    TokenUser user2;

    // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
    function setUp() public {
        token = createToken();
        token.mint(initialBalance);
        user1 = new TokenUser(token);
        user2 = new TokenUser(token);
    }

    // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
    function createToken() internal returns (HNAToken) {
        return new HNAToken("HNA");
    }
  
    // 测试生成代币
    function testMint() public {
        uint mintAmount = 10;
        token.mint(mintAmount);
        assertEq(token.totalSupply(), initialBalance + mintAmount);
    }

    // 测试生成代币到了哪个账户，默认this（当前智能合约）账户
    function testMintThis() public {
        uint mintAmount = 10;
        token.mint(mintAmount);
        assertEq(token.balanceOf(this), initialBalance + mintAmount);
    }

    // 测试生成代币给某个账户
    function testMintGuy() public {
        uint mintAmount = 10;
        token.mint(user1, mintAmount);
        assertEq(token.balanceOf(user1), mintAmount);
    }

    // 生成代币需要权限，测试没有权限不能生成代币
    function testFailMintNoAuth() public {
        user1.doMint(10);
    }

    // 给某个user权限后，他就可以生成代币了
    function testMintAuth() public {
        token.setOwner(user1);
        user1.doMint(10);
    }

    // 没有auth权限不能销毁代币
    function testFailMintGuyNoAuth() public {
        user1.doMint(user2, 10);
    }

    // owner 可以销毁代币
    function testMintGuyAuth() public {
        token.setOwner(user1);
        user1.doMint(user2, 10);
    }

    // 测试销毁代币
    function testBurn() public {
        uint burnAmount = 10;
        token.burn(burnAmount);
        assertEq(token.totalSupply(), initialBalance - burnAmount);
    }

    // owner可以销毁自己的代币
    function testBurnThis() public {
        uint burnAmount = 10;
        token.burn(burnAmount);
        assertEq(token.balanceOf(this), initialBalance - burnAmount);
    }

    // owner不能销毁别人的代币，必须得approve
    function testFailBurnGuyWithoutTrust() public {
        uint burnAmount = 10;
        token.push(user1, burnAmount);
        token.burn(user1, burnAmount);
    }

    // approve后，owner就可以销毁代币，这个代币可以表示他的，只要是他有权限的就可以
    function testBurnGuyWithTrust() public {
        uint burnAmount = 10;
        token.push(user1, burnAmount);
        assertEq(token.balanceOf(user1), burnAmount);

        user1.doApprove(this);
        token.burn(user1, burnAmount);
        assertEq(token.balanceOf(user1), 0);
    }

    // 执行代币烧毁需要auth权限
    function testFailBurnNoAuth() public {
        token.transfer(user1, 10);
        user1.doBurn(10);
    }

    // 测试烧毁代币，先设置auth权限，比如owner
    function testBurnAuth() public {
        token.transfer(user1, 10);
        token.setOwner(user1);
        user1.doBurn(10);
    }

    // approve可以获得转出权限，但是不能烧毁，只有owner能销毁
    function testFailBurnGuyNoAuth() public {
        token.transfer(user2, 10);
        user2.doApprove(user1);
        // user2.doTransfer(user1,10);
        // token.setOwner(user1);
        user1.doBurn(user2, 10);
    }
    // user1变为owner后，就可以销毁user2的他有权限的那些代币，没有approve，owner也不能销毁
    function testBurnGuyAuth() public {
        token.transfer(user2, 10);
        token.setOwner(user1);
        user2.doApprove(user1);
        user1.doBurn(user2, 10);
    }

}


contract HNATokenTest3 is HNATest {
    uint constant initialBalance = 1000;

    HNAToken token;
    TokenUser user1;
    TokenUser user2;

    // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
    function setUp() public {
        token = createToken();
        token.mint(initialBalance);
        user1 = new TokenUser(token);
        user2 = new TokenUser(token);
    }

    // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
    function createToken() internal returns (HNAToken) {
        return new HNAToken("HNA");
    }
    

    // stop后不能转账，stop会该笔stoptable值
    function testFailTransferWhenStopped() public {
        token.stop();
        token.transfer(user1, 10);
    }

    // stop后不能transferFrom
    function testFailTransferFromWhenStopped() public {
        token.stop();
        user1.doTransferFrom(this, user2, 10);
    }

    // stop后代币合约不能push
    function testFailPushWhenStopped() public {
        token.stop();
        token.push(user1, 10);
    }

    // stop后user不能push
    function testFailPullWhenStopped() public {
        token.approve(user1);
        token.stop();
        user1.doPull(this, 10);
    }

    // stop后不能move
    function testFailMoveWhenStopped() public {
        token.approve(user1);
        token.stop();
        token.move(this, user2, 10);
    }

    // stop后不能mint，生成代币
    function testFailMintWhenStopped() public {
        token.stop();
        token.mint(10);
    }

    // stop后不能mint代币给user
    function testFailMintGuyWhenStopped() public {
        token.stop();
        token.mint(user1, 10);
    }

    // stop后不能燃烧代币
    function testFailBurnWhenStopped() public {
        token.stop();
        token.burn(10);
    }

    // stop后不能approve
    function testFailTrustWhenStopped() public {
        token.stop();
        token.approve(user1);
    }

    // 设置token的名字（不是符号）
    function testSetName() public logs_gas {
        assertEq(token.name(), "");
        token.setName("Test");
        assertEq(token.name(), "Test");
    }

    // setName需要权限，普通user不能set
    function testFailSetName() public logs_gas {
        user1.doSetName("Test");
    }


    // 没有approve转账失败
    function testFailUntrustedTransferFrom() public {
        assertEq(token.allowance(this, user2), 0);
        user1.doTransferFrom(this, user2, 200);
    }

    // 测试给user aprove
    function testTrusting() public {
        assertEq(token.allowance(this, user2), 0);
        token.approve(user2);
        assertEq(token.allowance(this, user2), uint(-1));
        token.approve(user2, 0);
        assertEq(token.allowance(this, user2), 0);
    }

    // approve后可以转账
    function testTrustedTransferFrom() public {
        token.approve(user1);
        user1.doTransferFrom(this, user2, 200);
        assertEq(token.balanceOf(user2), 200);
    }
}



contract HNATokenTest4 is HNATest {
    uint constant initialBalance = 1000;

    HNAToken token;
    TokenUser user1;
    TokenUser user2;

    // 创建了一个名为HNA的代币,产生总量为1000，创建两个TokenUser
    function setUp() public {
        token = createToken();
        token.mint(initialBalance);
        user1 = new TokenUser(token);
        user2 = new TokenUser(token);
    }

    // 创建了一个名为HNA的代币（智能合约HNAToken实例化）
    function createToken() internal returns (HNAToken) {
        return new HNAToken("HNA");
    }
    


    // 测试push（即转账），push不需要approve，因为push的人就是msg.sender,但是push余额必须够
    function testPush() public {
        assertEq(token.balanceOf(this), 1000);
        assertEq(token.balanceOf(user1), 0);
        token.push(user1, 1000);
        assertEq(token.balanceOf(this), 0);
        assertEq(token.balanceOf(user1), 1000);
        user1.doPush(user2, 200);
        assertEq(token.balanceOf(this), 0);
        assertEq(token.balanceOf(user1), 800);
        assertEq(token.balanceOf(user2), 200);
    }

    // 测试pull，需要aprove才能拉取
    function testFailPullWithoutTrust() public {
        user1.doPull(this, 1000);
    }

    // 测试有了approve后可以拉取成功
    function testPullWithTrust() public {
        token.approve(user1);
        user1.doPull(this, 1000);
    }

    // move 需要approve
    function testFailMoveWithoutTrust() public {
        user1.doMove(this, user2, 1000);
    }

    // 测试有了approve后的move
    function testMoveWithTrust() public {
        token.approve(user1);
        user1.doMove(this, user2, 1000);
    }

    // 测试approve改变allowance
    function testApproveWillModifyAllowance() public {
        assertEq(token.allowance(this, user1), 0);
        assertEq(token.balanceOf(user1), 0);
        token.approve(user1, 1000);
        assertEq(token.allowance(this, user1), 1000);
        user1.doPull(this, 500);
        assertEq(token.balanceOf(user1), 500);
        assertEq(token.allowance(this, user1), 500);
    }

    // 和上面的测试一样？
    function testApproveWillNotModifyAllowance() public {
        assertEq(token.allowance(this, user1), 0);
        assertEq(token.balanceOf(user1), 0);
        token.approve(user1);
        assertEq(token.allowance(this, user1), uint(-1));
        user1.doPull(this, 1000);
        assertEq(token.balanceOf(user1), 1000);
        assertEq(token.allowance(this, user1), uint(-1));
    }

    // 只有被信任的（approve后）人才能转账，如下面注释的那句可以
    function testFailTransferOnlyTrustedCaller() public {
        // only the entity actually trusted should be able to call
        // and move tokens.
        token.push(user1, 1);
        user1.doApprove(user2);
        token.transferFrom(user1, user2, 1);
        // user2.doTransferFrom(user1, user2, 1);
    } 
}
