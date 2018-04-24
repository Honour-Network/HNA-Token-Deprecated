/// math.sol -- mixin for inline numerical wizardry
pragma solidity ^0.4.17;

contract DSMath {
    // safe add method, check up overflow
    function safeAdd(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }

    // safe sub method, check up downward
    function safeSub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    // safe multiple method, check up overflow
    function safeMul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    // can caluculate multiple with ehter (float), the actual calculation is based on integer (10^18)
    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, y), WAD / 2) / WAD;
    }

    // can caluculate multiple (float), the actual calculation is based on integer, base unit is larger(10^27)
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, y), RAY / 2) / RAY;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, WAD), y / 2) / y;
    }
    
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = safeAdd(safeMul(x, RAY), y / 2) / y;
    }

}
