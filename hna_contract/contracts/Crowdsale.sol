
pragma solidity ^0.4.17;

import "./lib/math.sol";
import "./HNA.sol";

// After contract creation (deployment) of  HNAtoken, if financing is required, the contract is deployed.
// The fifth parameter of the constructor is the address of the HNA contract, which can be used to manipulate the token transfer.
// You can set fundraising deadlines, target funds, exchange ether prices, beneficiaries, lockout time.
// After the fund-raising is over, if the target is reached, the money is given to the beneficiary, if not, it is returned to the investor.
// If you have multiple fundraising, you can deploy this smart contract multiple times

contract Crowdsale is DSMath{
    address public beneficiary;
    uint256 public fundingGoal;
    uint256 public amountRaised;
    uint256 public deadline; // Fundraising end time
    uint256 public lockline; // Token locking time after fundraising
    uint256 public price;
    HNA public tokenReward;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public balanceOftoken;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = false;
    bool unlocked = false;

    event GoalReached(address recipient, uint256 totalAmountRaised);
    event FundTransfer(address backer, uint256 amount, bool isContribution);

    /**
     * Constructor function
     * Set beneficiary, target ether, fundraising time, price, lockout time, fundraising token contract address
     */
    function Crowdsale(
        address ifSuccessfulSendTo,
        uint256 fundingGoalInEthers,
        uint256 durationInMinutes,
        uint256 weiCostOfEachToken,
        uint256 lockedInMinutes,
        address addressOfTokenUsedAsReward
    ) public {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        lockline = deadline + lockedInMinutes  * 1 minutes;
        price = weiCostOfEachToken;
        tokenReward = HNA(addressOfTokenUsedAsReward);
    }

    /**
     * Fallback function
     * The default function that is called when someone sends ether to the contract
     */
    function () payable public {
        require(!crowdsaleClosed);
        uint256 amount = msg.value;
        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount); // Address for ether, with ether balance
        amountRaised = safeAdd(amountRaised, amount);
        balanceOftoken[msg.sender] = safeAdd(balanceOftoken[msg.sender], amount / price* 1 ether); 
        // Record the balance of the token first, and after the end of the raised funds, issue tokens to lock
        // tokenReward.subCurrentSupply(balanceOftoken[msg.sender]);
        FundTransfer(msg.sender, amount, true);
    }

    /**
     * Fallback function
     * The default function that is called when someone sends ether to the contract
     */
    function buy() payable public {
        require(!crowdsaleClosed);
        uint256 amount = msg.value;
        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount); // Address for ether, with ether balance
        amountRaised = safeAdd(amountRaised, amount);
        balanceOftoken[msg.sender] = safeAdd(balanceOftoken[msg.sender], amount / price* 1 ether); 
        // Record the balance of the token first, and after the end of the raised funds, issue tokens to lock
        // tokenReward.subCurrentSupply(balanceOftoken[msg.sender]);
        FundTransfer(msg.sender, amount, true);
    }

    // Whether the raise period is over
    modifier afterDeadline() {
        require (now >= deadline);
        _;
    }

    // Whether the lock period is over
    modifier afterLockline() { 
        require (now >= lockline); 
        _; 
    }

    /**
     * Check whether the target is reached (or expires) and stop fundraising
     */
    function checkGoalReached() public afterDeadline {
        if (amountRaised >= fundingGoal){
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }

    // Update lock status
    function checkLocked() public afterLockline {
        unlocked = true;
    }

    /**
     * Withdraw the funds
     * Check whether the fund-raising goal or time limit is reached, and if it meets the fund target, send all ethers to beneficiaries (usually fund raisers).
     * If the goal is not reached, each investor can withdraw their ether.
     */
    function safeWithdrawal() public afterDeadline {
        if (!fundingGoalReached) {
            uint256 amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if (amount > 0) {
                if (msg.sender.send(amount)) {
                    // tokenReward.addCurrentSupply(amount);
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
                }
            }
        }
    }
}

