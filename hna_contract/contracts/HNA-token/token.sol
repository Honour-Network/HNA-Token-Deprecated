/// token.sol -- ERC20 代币，基本函数都有，还可以mint和burn

pragma solidity ^0.4.17;

import "./stop.sol";

import "./base.sol";

// HNAToken 智能合约，继承了基本的basetoken合约
contract HNAToken is HNATokenBase(0), HNAStop {

    // token 符号，例如HNA
    bytes32  public  symbol;
    // token的小数点精度，18
    uint256  public  decimals = 18; // standard token precision. override to customize

    // 构造函数，初始化token，给予符号
    function HNAToken(bytes32 symbol_) public {
        symbol = symbol_;
    }

    // 两个事件，分别是产生代币和销毁代币
    event Mint(address indexed guy, uint wad);
    event Burn(address indexed guy, uint wad);

    // ??
    function approve(address guy) public stoppable returns (bool) {
        return super.approve(guy, uint(-1));
    }

    // 给guy地址wad的许可代币量
    // stoppable==false才可以，否则会抛出异常,如果在执行前先执行了stop方法，stopable会变成true
    function approve(address guy, uint wad) public stoppable returns (bool) {
        return super.approve(guy, wad);
    }

    // 从src转到dst，转wad的代币，需要许可
    function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {
        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
            _approvals[src][msg.sender] = safeSub(_approvals[src][msg.sender], wad);
        }

        _balances[src] = safeSub(_balances[src], wad);
        _balances[dst] = safeAdd(_balances[dst], wad);

        Transfer(src, dst, wad);

        return true;
    }

    // 推送给src代币（即从msg.sender转wad的代币给src）
    function push(address dst, uint wad) public {
        transferFrom(msg.sender, dst, wad);
    }

    // 从src拉取wad的代币到当前账户（即src转给msg.sender）
    function pull(address src, uint wad) public {
        transferFrom(src, msg.sender, wad);
    }

    // 从src转移wad的代币到dst账户
    function move(address src, address dst, uint wad) public {
        transferFrom(src, dst, wad);
    }

    // 合约调用者产生wad的代币（合约调用者账户增加wad代币，总代币数增加wad）
    function mint(uint wad) public {
        mint(msg.sender, wad);
    }

    // 合约调用者烧毁wad的代币（合约调用者账户减少wad代币，总代币数减少wad）
    function burn(uint wad) public {
        burn(msg.sender, wad);
    }

    // 产生wad的代币，给guy，即guy的余额增加wad，同时总代币数增加wad,需要权限
    function mint(address guy, uint wad) public auth stoppable {
        _balances[guy] = safeAdd(_balances[guy], wad);
        _supply = safeAdd(_supply, wad);
        Mint(guy, wad);
    }

    // 从guy的账户烧毁wad的代币（即guy余额减少wad，总代币数减少wad），需要权限
    function burn(address guy, uint wad) public auth stoppable {
        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
            _approvals[guy][msg.sender] = safeSub(_approvals[guy][msg.sender], wad);
        }

        _balances[guy] = safeSub(_balances[guy], wad);
        _supply = safeSub(_supply, wad);
        Burn(guy, wad);
    }

    // Optional token name
    bytes32 public  name = "";

    // 代币的名称，可以比较长，和HNA可以不一样
    function setName(bytes32 name_) public auth {
        name = name_;
    }
}
