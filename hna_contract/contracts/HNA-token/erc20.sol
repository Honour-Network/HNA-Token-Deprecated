/// erc20.sol -- API for the ERC20 token standard
// See <https://github.com/ethereum/EIPs/issues/20>.
// ERC20 代币接口
// totalSupply，返回总的代币金额
// balanceOf, 返回某个地址的余额
// allowance,

// approve,
// transfer, 给地址dst转 wad个代币
// transferFrom,

pragma solidity ^0.4.8;

contract ERC20Events {
    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);
}

contract ERC20 is ERC20Events {
    function totalSupply() public view returns (uint);
    function balanceOf(address guy) public view returns (uint);
    function allowance(address src, address guy) public view returns (uint);

    function approve(address guy, uint wad) public returns (bool);
    function transfer(address dst, uint wad) public returns (bool);
    function transferFrom(address src, address dst, uint wad) public returns (bool);
}
