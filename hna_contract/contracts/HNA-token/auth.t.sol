/// base.t.sol -- test for base.sol

pragma solidity ^0.4.13;

import "./test.sol";

import "./auth.sol";

contract FakeVault is HNAAuth {
    function access() public view auth {}
}

contract BooleanAuthority is HNAAuthority {
    bool yes;

    function BooleanAuthority(bool _yes) public {
        yes = _yes;
    }

    function canCall(address src, address dst, bytes4 sig) public constant returns (bool) {
        src; dst; sig; // silence warnings
        return yes;
    }
}

contract HNAAuthTest is HNATest, HNAAuthEvents {
    FakeVault vault = new FakeVault();
    BooleanAuthority rejector = new BooleanAuthority(false);

    function test_owner() public {
        expectEventsExact(vault);
        vault.access();
        vault.setOwner(0);
        LogSetOwner(0);
    }

    function testFail_non_owner_1() public {
        vault.setOwner(0);
        vault.access();
    }

    function testFail_non_owner_2() public {
        vault.setOwner(0);
        vault.setOwner(0);
    }

    function test_accepting_authority() public {
        vault.setAuthority(new BooleanAuthority(true));
        vault.setOwner(0);
        vault.access();
    }

    function testFail_rejecting_authority_1() public {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(0);
        vault.access();
    }

    function testFail_rejecting_authority_2() public {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(0);
        vault.setOwner(0);
    }
}
