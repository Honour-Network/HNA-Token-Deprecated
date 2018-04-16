/// math.t.sol -- test for math.sol
pragma solidity ^0.4.13;

import "./test.sol";
import "./math.sol";

contract HNAMathTest is HNATest, HNAMath {
    function testFail_add() public pure {
        safeAdd(2 ** 256 - 1, 1);
    }
    function test_add() public {
        assertEq(safeAdd(0, 0), 0);
        assertEq(safeAdd(0, 1), 1);
        assertEq(safeAdd(1, 1), 2);
    }

    function testFail_sub() public pure {
        safeSub(0, 1);
    }
    function test_sub() public {
        assertEq(safeSub(0, 0), 0);
        assertEq(safeSub(1, 1), 0);
        assertEq(safeSub(2, 1), 1);
    }

    function testFail_mul() public pure {
        safeMul(2 ** 254, 6);
    }

    function test_mul() public {
        assertEq(safeMul(0, 1), 0);
        assertEq(safeMul(1, 1), 1);
        assertEq(safeMul(2, 1), 2);
    }

    function testFail_wmul_overflow() public pure {
        wmul(2 ** 128, 2 ** 128);
    }
    function test_wmul_trivial() public {
        assertEq(wmul(2 ** 128 - 1, 1.0 ether), 2 ** 128 - 1);
        assertEq(wmul(0.0 ether, 0.0 ether), 0.0 ether);
        assertEq(wmul(0.0 ether, 1.0 ether), 0.0 ether);
        assertEq(wmul(1.0 ether, 0.0 ether), 0.0 ether);
        assertEq(wmul(1.0 ether, 1.0 ether), 1.0 ether);
    }
    function test_wmul_fractions() public {
        assertEq(wmul(1.0 ether, 0.2 ether), 0.2 ether);
        assertEq(wmul(2.0 ether, 0.2 ether), 0.4 ether);
    }

    function testFail_wdiv_zero() public pure {
        wdiv(1.0 ether, 0.0 ether);
    }
    function test_wdiv_trivial() public {
        assertEq(wdiv(0.0 ether, 1.0 ether), 0.0 ether);
        assertEq(wdiv(1.0 ether, 1.0 ether), 1.0 ether);
    }
    function test_wdiv_fractions() public {
        assertEq(wdiv(1.0 ether, 2.0 ether), 0.5 ether);
        assertEq(wdiv(2.0 ether, 2.0 ether), 1.0 ether);
    }

    function test_wmul_rounding() public {
        uint a = .950000000000005647 ether;
        uint b = .000000001 ether;
        uint c = .00000000095 ether;
        assertEq(wmul(a, b), c);
        assertEq(wmul(b, a), c);
    }
    function test_rmul_rounding() public {
        uint a = 1 ether;
        uint b = .95 ether * 10**9 + 5647;
        uint c = .95 ether;
        assertEq(rmul(a, b), c);
        assertEq(rmul(b, a), c);
    }
}
