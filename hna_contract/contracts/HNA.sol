pragma solidity ^0.4.17;

import "./HNA-token/token.sol";
import './ERC223ReceivingContract.sol';
import './TokenController.sol';
import './Controlled.sol';
import './ApproveAndCallFallBack.sol';
import './ERC223.sol';

contract HNA is HNAToken("HNA"), ERC223, Controlled {

    // using HNAMath for uint256; // HNA 必须是library，而非contract 

    // contracts  
    address public ethFundDeposit;          // ETH存放地址  
    address public newContractAddr;         // token更新地址  

    bool    public isFunding;                // 状态切换到true  
    uint256 public currentSupply;           // 可以售卖的tokens数量  
    uint256 public tokenRaised = 0;         // 总的售卖数量token  
    uint256 public tokenMigrated = 0;     // 总的已经交易的 token  
    uint256 public tokenExchangeRate = 5000;             // 5000 HNA 兑换 1 ETH (约为1 HNA=0.1 ETH)

    // 账户是否被冻结
    mapping (address => bool) public frozenAccount;
    event FrozenFunds(address target, bool frozen);

    // 转换
    function formatDecimals(uint256 _value) internal returns (uint256 ) {
        return _value * 10 ** decimals;
    } 

    // 合约构造函数，设置名称，发行总量，出售量
    function HNA() public {
        setName("Honour Network Access Token");

        ethFundDeposit = msg.sender;  
        isFunding = false;                           //控制Sale状态
        currentSupply = 35000000000000000000000000;
        uint256 totalSupply = 70000000000000000000000000;  
        mint(msg.sender, totalSupply);  
        require (currentSupply <= totalSupply); 
    }

    // 冻结账户
    function freezeAccount(address target) auth {
        frozenAccount[target] = true;
        FrozenFunds(target, true);
    }

    // 解冻账户
    function defreezeAccount(address target) auth {
        frozenAccount[target] = false;
        FrozenFunds(target, false);
    }

    // 判断账户是否被冻结
    modifier isFrozen { 
        require (!frozenAccount[msg.sender]);
        _; 
    }

    // 如果代币被Buy，则减少供应量
    function subCurrentSupply (uint256 _haveArised) public {
        tokenRaised = safeAdd(tokenRaised, _haveArised);
        currentSupply = safeSub(currentSupply, _haveArised);
    }
    
    // 如果代币被Sell，则增加供应量
    function addCurrentSupply (uint256 _haveDearised) public {
        tokenRaised = safeSub(tokenRaised, _haveDearised);
        currentSupply = safeAdd(currentSupply, _haveDearised);
    }
    
    /// @dev 判断地址是不是合约地址
    /// @return True 如果`_addr`是一个合约
    //  extcodesize操作码返回地址上代码的大小。如果大于零，则地址是合约。需要在合约中编写汇编代码来访问此操作
    function isContract(address _addr) constant internal returns(bool) {
        uint size;
        if (_addr == 0) return false;
        assembly {
            size := extcodesize(_addr)
        }
        return size>0;
    }

    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        // Alerts the token controller of the transfer
        if (isContract(controller)) {
            require (TokenController(controller).onTransfer(_from, _to, _amount));
        }

        success = super.transferFrom(_from, _to, _amount);

        if (success && isContract(_to)) {
            // 向后兼容ERC20
            if(!_to.call(bytes4(keccak256("tokenFallback(address,uint256)")), _from, _amount)) {
                ReceivingContractTokenFallbackFailed(_from, _to, _amount);
            }
        }
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool success){
        // Alerts the token controller of the transfer
        if (isContract(controller)) {
            require (TokenController(controller).onTransfer(_from, _to, _amount));  
        }

        require(super.transferFrom(_from, _to, _amount));

        if (isContract(_to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(_from, _amount, _data);
        }

        ERC223Transfer(_from, _to, _amount, _data);
        return true;
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transfer(address _to, uint256 _amount, bytes _data) public returns (bool success) {
        return transferFrom(msg.sender, _to, _amount, _data);
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transferFrom(address _from, address _to, uint256 _amount, bytes _data, string _custom_fallback) public returns (bool success) {
        // Alerts the token controller of the transfer
        if (isContract(controller)) {
            require (TokenController(controller).onTransfer(_from, _to, _amount));     
        }

        require(super.transferFrom(_from, _to, _amount));

        if (isContract(_to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), _from, _amount, _data);
        }

        ERC223Transfer(_from, _to, _amount, _data);
        return true;
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transfer(address _to, uint _amount, bytes _data, string _custom_fallback) public returns (bool success) {
        return transferFrom(msg.sender, _to, _amount, _data, _custom_fallback);
    }

    // 给地址_spender许可量_amount
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        // Alerts the token controller of the approve function call
        if (isContract(controller)) {
            require (TokenController(controller).onApprove(msg.sender, _spender, _amount));
        }
        
        return super.approve(_spender, _amount);
    }

    // 产生代币
    function mint(address _guy, uint _wad) auth stoppable public {
        super.mint(_guy, _wad);
        Transfer(0, _guy, _wad);
    }

    // 烧毁代币
    function burn(address _guy, uint _wad) auth stoppable public {
        super.burn(_guy, _wad);
        Transfer(_guy, 0, _wad);
    }

    // 给地址_spender许可量_amount
    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
        require (approve(_spender, _amount));

        ApproveAndCallFallBack(_spender).receiveApproval(
            msg.sender,
            _amount,
            this,
            _extraData
        );

        return true;
    }

    /// 购买token  
    function buy() payable { 
        require (isFunding);
        require (msg.value > 0);

        uint256 tokens = safeMul(msg.value, tokenExchangeRate);       
        require (safeAdd(tokens, tokenRaised) <= currentSupply); 
        subCurrentSupply(tokens);
        _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);
        ethFundDeposit.send(this.balance);
    }
    
    // 出售token，即用token换回ether
    function sell(uint amount) isFrozen returns (uint revenue){
        // checks if the sender has enough to sell
        transfer(this,amount);

        // TODO:这里除法可能有问题
        revenue = amount/ tokenExchangeRate;
        // amount是用户数输入的出售代币的数量
        msg.sender.send(revenue);
        // 用户获得因为输出代币得到的以太币
        addCurrentSupply(amount);
    }

    // 合约受益取回以太坊
    function drawbackETH() auth {
        ethFundDeposit.send(this.balance);
    }


    // 开始出售代币
    function startFunding () auth external {  
        require (!isFunding); 
        isFunding = true;  
    }

    ///  停止出售代币
    function stopFunding() auth external {  
        require (isFunding);
        isFunding = false;  
    }
    
    ///  设置token汇率  
    function setTokenExchangeRate(uint256 _tokenExchangeRate) auth external {  
        require(_tokenExchangeRate > 0); 
        require(_tokenExchangeRate != tokenExchangeRate);  
        tokenExchangeRate = _tokenExchangeRate;  
    } 

//////////
// Safety Methods
//////////

    /// @notice 将错误发送的token提取到合约中
    ///  set to 0 如果想取回ether.
    function claimTokens(address _token) onlyController public {
        if (_token == 0x0) {
            controller.transfer(this.balance);
            return;
        }

        ERC20 token = ERC20(_token);
        uint balance = token.balanceOf(this);
        token.transfer(controller, balance);
        ClaimedTokens(_token, controller, balance);
    }

    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
}