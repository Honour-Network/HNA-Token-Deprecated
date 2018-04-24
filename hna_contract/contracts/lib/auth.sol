//
pragma solidity ^0.4.17;

// 
contract DSAuthority {
    function canCall(address src, address dst, bytes4 sig) public view returns (bool);
}

//Event Contract for Authority
contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

// Contract for Authority
contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;
    // contract creator (owner)
    address      public  owner;

    // constructor function, owner
    function DSAuth() public {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }

    // set contract owner_
    function setOwner(address owner_) public auth {
        owner = owner_;
        LogSetOwner(owner);
    }

    // return current owner
    function getOwner() public view returns (address) {
        return owner;
    }

    function setAuthority(DSAuthority authority_) public auth {
        authority = authority_;
        LogSetAuthority(authority);
    }

    // if have auth，modifier
    modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    // user defined canCall function fro authority
    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, this, sig);
        }
    }
}
