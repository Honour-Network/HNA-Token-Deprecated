
pragma solidity ^0.4.17;

import "./HNA.sol";

//代币HNA的合约创建（部署）之后，如果需要融资，则部署这个合约，其构造函数的第5个参数是HNA合约的地址，可以操作该合约的代币转移
// 可以设置募资期限，目标资金，兑换ether的价格，受益人，锁定时间。募资结束后，如果达到了目标，则钱给受益人，如果没有，则返回给投资者
// 如果有多次募资，可以多次部署这个智能合约，这样每次都不同

contract Crowdsale {
    address public beneficiary;
    uint public fundingGoal;
    uint public amountRaised;
    uint public deadline; // 募资结束时间
    uint public lockline; // 募资结束后token锁定时间
    uint public price;
    HNA public tokenReward;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public balanceOftoken;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = false;
    bool unlocked = false;

    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    /**
     * Constructor function
     * 设置受益人，目标ether，募资时间，价格，锁定时间，募资的代币合约地址
     */
    function Crowdsale(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint etherCostOfEachToken,
        uint lockedInMinutes,
        address addressOfTokenUsedAsReward
    ) {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        lockline = deadline + lockedInMinutes  * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = HNA(addressOfTokenUsedAsReward);
    }

    /**
     * Fallback function
     * 当有人向智能合约发送资金时都会调用的默认函数
     */
    function () payable {
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount; //充钱（ether）的地址，有ether余额
        amountRaised += amount;
        // tokenReward.transfer(msg.sender, amount / price); // 根据充入的ether，发放HNA代币
        balanceOftoken[msg.sender] += amount / price; // 先将代币余额记录下来，等募集资金结束后，再发放代币，从而实现锁定
        tokenReward.subCurrentSupply(balanceOftoken[msg.sender]);
        FundTransfer(msg.sender, amount, true);
    }

    // 募集期是否结束
    modifier afterDeadline() {
        require (now >= deadline);
        _; 
    }

    // 锁定期是否结束
    modifier afterLockline() { 
        require (now >= lockline); 
        _; 
    }

    /**
     * 检查目标是否达到（或者到期），停止募资
     */
    function checkGoalReached() afterDeadline {
        if (amountRaised >= fundingGoal){
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }

    // 更新锁定状态
    function checkLocked() afterLockline {
        unlocked = true;
    }

    /**
     * Withdraw the funds
     *   检查是否已达到募资目标或时间限制，如果并达到资金目标，则将全部ether发送给受益人（一般为募资人）。 
     *   如果没有达到目标，每个投资者都可以撤回他们的ether。
     */
    function safeWithdrawal() afterDeadline {
        if (!fundingGoalReached) {
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if (amount > 0) {
                if (msg.sender.send(amount)) {
                    tokenReward.addCurrentSupply(amount);
                    FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender] = amount;
                }
            }
        }

        if (fundingGoalReached && unlocked) {
            tokenReward.transfer(msg.sender, balanceOftoken[msg.sender]);
            if (beneficiary == msg.sender){
                if (beneficiary.send(amountRaised)) {
                    FundTransfer(beneficiary, amountRaised, false);
                // } else {
                //     //如果未能将资金发送给受益人，解锁资助方的余额，此时已经到期，所以投资人可以撤回资金
                //     fundingGoalReached = false;
                }
            }
        }
    }
}

