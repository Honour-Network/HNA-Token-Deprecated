/// stop.t.sol -- test for stop.sol

pragma solidity ^0.4.17;

import "./test.sol";

import "./stop.sol";

contract User {

    TestThing thing;

    function User(TestThing thing_) public {
        thing = thing_;
    }

    function doToggle() public {
        thing.toggle();
    }

    function doStop() public {
        thing.stop();
    }

    function doStart() public {
        thing.start();
    }
}

contract TestThing is HNAStop {

    bool public x;

    function toggle() public stoppable {
        x = x ? false : true;
    }
}

contract HNAStopTest is HNATest {

    TestThing thing;
    User user;

    function setUp() public {
        thing = new TestThing();
        user = new User(thing);
    }

    function testSanity() public {
        thing.toggle();
        assertTrue(thing.x());
    }

    function testFailStop() public {
        thing.stop();
        thing.toggle();
    }

    function testFailStopUser() public {
        thing.stop();
        user.doToggle();
    }

    function testStart() public {
        thing.stop();
        thing.start();
        thing.toggle();
        assertTrue(thing.x());
    }

    function testStartUser() public {
        thing.stop();
        thing.start();
        user.doToggle();
        assertTrue(thing.x());
    }

    function testFailStopAuth() public {
        user.doStop();
    }

    function testFailStartAuth() public {
        user.doStart();
    }
}
