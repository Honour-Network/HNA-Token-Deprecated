/// stop.sol -- mixin for enable/disable functionality

pragma solidity ^0.4.13;

import "./auth.sol";
// import "./note.sol";

contract DSStop is DSAuth {

    bool public stopped;

    modifier stoppable {
        require(!stopped);
        _;
    }

    function stop() public auth {
        stopped = true;
    }
    
    function start() public auth {
        stopped = false;
    }

}
