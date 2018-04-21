/// base.sol -- basic ERC20 implementation

pragma solidity ^0.4.17;

import "./erc20.sol";
import "./math.sol";

//token based on erc20
contract HNATokenBase is ERC20, HNAMath {
    // total supply of token
    uint256                                            _supply;
    // balance of each address (account)
    mapping (address => uint256)                       _balances;
    // approve (address to address)
    mapping (address => mapping (address => uint256))  _approvals;

    // constructor function, inut: totla supply,given to contract creator
    function HNATokenBase(uint supply) public {
        _balances[msg.sender] = supply;
        _supply = supply;
    }

    // return the total supply
    function totalSupply() public view returns (uint) {
        return _supply;
    }

    // return balance of user (address)
    function balanceOf(address src) public view returns (uint) {
        return _balances[src];
    }

    // return the approve from src to guy
    function allowance(address src, address guy) public view returns (uint) {
        return _approvals[src][guy];
    }

    // tranfer wad token from caller to user(dst)
    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    // tranfer wad token from user(src) to another user(dst), caller needs approve from user(src)
    function transferFrom(address src, address dst, uint wad) public returns (bool) {
        if (src != msg.sender) {
            _approvals[src][msg.sender] = safeSub(_approvals[src][msg.sender], wad);
        }

        _balances[src] = safeSub(_balances[src], wad);
        _balances[dst] = safeAdd(_balances[dst], wad);

        Transfer(src, dst, wad);

        return true;
    }

    // caller give user(guy) wad allowance
    function approve(address guy, uint wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;

        Approval(msg.sender, guy, wad);

        return true;
    }
}
