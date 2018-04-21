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
