/// token.sol -- ERC20 代币，基本函数都有，还可以mint和burn

pragma solidity ^0.4.17;

import "./stop.sol";

import "./base.sol";

// HNAToken contract, inherited basetoken contract 
contract HNAToken is HNATokenBase(0), HNAStop {

    // token symbol,such as HNA
    bytes32  public  symbol;
    // token's decimal precision, 18
    uint256  public  decimals = 18; // standard token precision. override to customize

    // constructor funciton, initialize token, set symbol
    function HNAToken(bytes32 symbol_) public {
        symbol = symbol_;
    }

    // two events, for mint and burn token, respectively
    event Mint(address indexed guy, uint wad);
    event Burn(address indexed guy, uint wad);

    // ??
    function approve(address guy) public stoppable returns (bool) {
        return super.approve(guy, uint(-1));
    }

    // give guy wad token allowance to transfer
    // Prerequisites: stoppable==false
    function approve(address guy, uint wad) public stoppable returns (bool) {
        return super.approve(guy, wad);
    }

    // transfer from src to dst wad token, needs approve
    function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {
        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
            _approvals[src][msg.sender] = safeSub(_approvals[src][msg.sender], wad);
        }

        _balances[src] = safeSub(_balances[src], wad);
        _balances[dst] = safeAdd(_balances[dst], wad);

        Transfer(src, dst, wad);

        return true;
    }

    // puch wad token to src (transfer wad token from msg.sender to src)
    function push(address dst, uint wad) public {
        transferFrom(msg.sender, dst, wad);
    }

    // pull wad token from src to current account(msg.sender) 
    function pull(address src, uint wad) public {
        transferFrom(src, msg.sender, wad);
    }

    // transfer from src to dst wad token
    function move(address src, address dst, uint wad) public {
        transferFrom(src, dst, wad);
    }

    // mint wad token (the balance of caller(msg.sender) increase wad (total token also increase)
    function mint(uint wad) public {
        mint(msg.sender, wad);
    }

    // burn wad token from msg.sender's account (total token also decrease)
    function burn(uint wad) public {
        burn(msg.sender, wad);
    }

    // mint wad token, and give it to guy
    function mint(address guy, uint wad) public auth stoppable {
        _balances[guy] = safeAdd(_balances[guy], wad);
        _supply = safeAdd(_supply, wad);
        Mint(guy, wad);
    }

    // burn wad token from guy's account
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

    // token's name, can be a little long
    function setName(bytes32 name_) public auth {
        name = name_;
    }
}
