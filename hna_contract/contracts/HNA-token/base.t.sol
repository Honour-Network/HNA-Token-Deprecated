/// base.t.sol -- test for base.sol

pragma solidity ^0.4.13;

import "./test.sol";

import "./base.sol";

contract TokenUser {
    ERC20  token;

    function TokenUser(ERC20 token_) public {
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
}

contract HNATokenBaseTest is HNATest {
    uint constant initialBalance = 1000;

    ERC20 token;
    TokenUser user1;
    TokenUser user2;

    // 创建了一个发行总量为1000的erc20代币token,创建了两个tokenuser（智能合约TokenUser实例化）
    function setUp() public {
        token = createToken();
        user1 = new TokenUser(token);
        user2 = new TokenUser(token);
    }

    // 创建了一个发行总量为1000的erc20代币（智能合约HNATokenBase实例化）
    function createToken() internal returns (ERC20) {
        return new HNATokenBase(initialBalance);
    }

    // 检查token是不是刚刚创建（没有转账），即检查智能合约的地址的代币余额是不是等于初始的代币发行量
    // this是智能合约的地址
    function testSetupPrecondition() public {
        assertEq(token.balanceOf(this), initialBalance);
    }

    // 代币发送给0地址，logs_gas：计算执行过程中的gas消耗量，并写入log
    // 发送给0地址的代币无法取回
    function testTransferCost() public logs_gas() {
        token.transfer(address(0), 10);
    }

    // 检查uer1给user2（这两个都是TokenUser合约（地址））的许可量是否为0
    function testAllowanceStartsAtZero() public logs_gas {
        assertEq(token.allowance(user1, user2), 0);
    }

    // 测试交易，合约发给给user2转250代币，检查user2的账户余额，检查合约的余额
    function testValidTransfers() public logs_gas {
        uint sentAmount = 250;
        log_named_address("token11111", token);
        token.transfer(user2, sentAmount);
        assertEq(token.balanceOf(user2), sentAmount);
        assertEq(token.balanceOf(this), initialBalance - sentAmount);
    }

    // 测试从错误账户转账，从user2转给智能合约250代币
    // 因为user2是TokenUser合约地址，调用人和它不等，所以需要user2给调用者许可
    function testFailWrongAccountTransfers() public logs_gas {
        uint sentAmount = 250;
        token.transferFrom(user2, this, sentAmount);
    }

    // 测试余额不足的转账失败,第二次转账失败
    function testFailInsufficientFundsTransfers() public logs_gas {
        uint sentAmount = 250;
        token.transfer(user1, initialBalance - sentAmount);
        token.transfer(user2, sentAmount+1);
    }

    // 测试从this转账总能成功（不超过this余额），不需要许可
    // issue：岂不是谁都可以从this转出？
    function testTransferFromSelf() public {
        // you always approve yourself
        assertEq(token.allowance(this, this), 0);
        token.transferFrom(this, user1, 50);
        assertEq(token.balanceOf(user1), 50);
    }

    // this转账仍然需要检查余额（不检查许可，或者说许可==余额）
    function testFailTransferFromSelfNonArbitrarySize() public {
        // you shouldn't be able to evade balance checks by transferring
        // to yourself
        token.transferFrom(this, this, token.balanceOf(this) + 1);
    }

    // 测试给user2设置25的许可量，这样user2可以转this的25个代币
    function testApproveSetsAllowance() public logs_gas {
        log_named_address("Test", this);
        log_named_address("Token", token);
        log_named_address("Me", this);
        log_named_address("User 2", user2);
        token.approve(user2, 25);
        assertEq(token.allowance(this, user2), 25);
    }

    // 测试更改许可量，this给了user2一定的许可量，这样user2可以将这么多许可量从user2转出，接下来他转给了自己
    function testChargesAmountApproved() public logs_gas {
        uint amountApproved = 20;
        token.approve(user2, amountApproved);
        assertTrue(user2.doTransferFrom(this, user2, amountApproved));
        assertEq(token.balanceOf(this), initialBalance - amountApproved);
    }

    // 测试没有许可转账失败，第二次转账，this没有user1的许可，不能从user1转走钱
    // 可以在前面加一句：user1.doApprove(this, 50);
    function testFailTransferWithoutApproval() public logs_gas {
        address self = this;
        token.transfer(user1, 50);
        token.transferFrom(user1, self, 1);
    }

    // 转账超过approve，第三句失败
    function testFailChargeMoreThanApproved() public logs_gas {
        address self = this;
        token.transfer(user1, 50);
        user1.doApprove(self, 20);
        token.transferFrom(user1, self, 2);
    }
}

