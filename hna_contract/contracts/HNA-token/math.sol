/// math.sol -- mixin for inline numerical wizardry
pragma solidity ^0.4.17;
// 两个数学函数，防止加减法

contract HNAMath {
    // 安全的加法，计算两个数的加法，同时验证上溢出
    function safeAdd(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }

    // 安全的减法，计算两个数的差，同时验证下溢出
    function safeSub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    // 安全的乘法，计算两个数的乘积，同时验证乘法上溢出
    function safeMul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    // 可以计算ehter的乘法（浮点运算），实际计算的是把ether转换为整数，乘完之后除以1e18，整个过程还是整数运算
    // 注意这里可能有四舍五入
    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, y), WAD / 2) / WAD;
    }

    // 可以计算更大的单位ray的乘法（浮点运算），实际计算的是转换为整数，乘完之后除以1e27，整个过程还是整数运算
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, y), RAY / 2) / RAY;
    }

    // 和前面的特殊乘法相对应的特殊除法
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, WAD), y / 2) / y;
    }
    
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, RAY), y / 2) / y;
    }

}
