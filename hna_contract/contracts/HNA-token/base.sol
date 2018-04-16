/// base.sol -- basic ERC20 implementation

pragma solidity ^0.4.17;

import "./erc20.sol";
import "./math.sol";

// 把erc20的接口都实现了
contract HNATokenBase is ERC20, HNAMath {
    // 发币总量
    uint256                                            _supply;
    // 每个地址的余额
    mapping (address => uint256)                       _balances;
    // 地址对地址的许可
    mapping (address => mapping (address => uint256))  _approvals;

    // 构造函数, 输入发行总量，全部给合约的创建者
    function HNATokenBase(uint supply) public {
        _balances[msg.sender] = supply;
        _supply = supply;
    }

    // 返回发币的总量
    function totalSupply() public view returns (uint) {
        return _supply;
    }

    // 返回地址的余额
    function balanceOf(address src) public view returns (uint) {
        return _balances[src];
    }

    // 返回地址src对地址guy的许可量
    function allowance(address src, address guy) public view returns (uint) {
        return _approvals[src][guy];
    }

    // 向目标地址dst转wad个代币
    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    // 从第一个人转wad个币到第二个人
    function transferFrom(address src, address dst, uint wad) public returns (bool) {
        // 如果第一个人不是合约调用者，从第一个人向合约调用者的许可量减少（如无法减会抛出异常）
        if (src != msg.sender) {
            _approvals[src][msg.sender] = safeSub(_approvals[src][msg.sender], wad);
        }

        _balances[src] = safeSub(_balances[src], wad);
        _balances[dst] = safeAdd(_balances[dst], wad);

        Transfer(src, dst, wad);

        return true;
    }

    // 调用者给guy一个许可量wad
    function approve(address guy, uint wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;

        Approval(msg.sender, guy, wad);

        return true;
    }
}
