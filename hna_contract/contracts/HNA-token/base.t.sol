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

    // create erc20 token, whose total supply is 1000, create two tokenuser( instance of contract TokenUser)
    function setUp() public {
        token = createToken();
        user1 = new TokenUser(token);
        user2 = new TokenUser(token);
    }

    // create erc20 token, whose total supply is 1000 (instance of HNATokenBase)
    function createToken() internal returns (ERC20) {
        return new HNATokenBase(initialBalance);
    }

    // test if token have just been created (no transfer), this balance equals to the initial supply
    // this is the contract address
    function testSetupPrecondition() public {
        assertEq(token.balanceOf(this), initialBalance);
    }

    // token transfer to address(0). logs_gas: the gas used in this function
    // the token transfer to address(0) can not get back
    function testTransferCost() public logs_gas() {
        token.transfer(address(0), 10);
    }

    // check if the allowance from user1 to user2 is 0
    function testAllowanceStartsAtZero() public logs_gas {
        assertEq(token.allowance(user1, user2), 0);
    }

    // test transfer, transfer 250 token to user2,check the balance of contract
    function testValidTransfers() public logs_gas {
        uint sentAmount = 250;
        log_named_address("token11111", token);
        token.transfer(user2, sentAmount);
        assertEq(token.balanceOf(user2), sentAmount);
        assertEq(token.balanceOf(this), initialBalance - sentAmount);
    }

    // test transfer from false account: transfer 250 token from user2 to contract
    // user2 have no token and allowance, so he can not transfer
    function testFailWrongAccountTransfers() public logs_gas {
        uint sentAmount = 250;
        token.transferFrom(user2, this, sentAmount);
    }

    // test transfer failure if the balance is not enough at the second transfer
    function testFailInsufficientFundsTransfers() public logs_gas {
        uint sentAmount = 250;
        token.transfer(user1, initialBalance - sentAmount);
        token.transfer(user2, sentAmount+1);
    }

    // test transfer from this can always successed (not over the balance of this), no need allowance
    // issue: any user can transfer this's token
    function testTransferFromSelf() public {
        // you always approve yourself
        assertEq(token.allowance(this, this), 0);
        token.transferFrom(this, user1, 50);
        assertEq(token.balanceOf(user1), 50);
    }

    // transfer from this also needs to check balance (no need allowance)
    function testFailTransferFromSelfNonArbitrarySize() public {
        // you shouldn't be able to evade balance checks by transferring to yourself
        token.transferFrom(this, this, token.balanceOf(this) + 1);
    }

    // test approve, this give user2 25 token allowance, then user2 can transfer 25 token from this
    function testApproveSetsAllowance() public logs_gas {
        log_named_address("Test", this);
        log_named_address("Token", token);
        log_named_address("Me", this);
        log_named_address("User 2", user2);
        token.approve(user2, 25);
        assertEq(token.allowance(this, user2), 25);
    }

    // test change allowance, this give user2 some allowance, then user2 can transfer the approved token from this.
    function testChargesAmountApproved() public logs_gas {
        uint amountApproved = 20;
        token.approve(user2, amountApproved);
        assertTrue(user2.doTransferFrom(this, user2, amountApproved));
        assertEq(token.balanceOf(this), initialBalance - amountApproved);
    }

    // test transfer without allowance will lead to failure, this can not tranfer from user1 without user1 (the second transfer)
    // can add this sentensce before second transfer, then can success:user1.doApprove(this, 50);
    function testFailTransferWithoutApproval() public logs_gas {
        address self = this;
        token.transfer(user1, 50);
        token.transferFrom(user1, self, 1);
    }

    // the transfer amout beyond allowance, failed (the 3rd)
    function testFailChargeMoreThanApproved() public logs_gas {
        address self = this;
        token.transfer(user1, 50);
        user1.doApprove(self, 20);
        token.transferFrom(user1, self, 2);
    }
}

