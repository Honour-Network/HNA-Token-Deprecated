//
pragma solidity ^0.4.17;

// 
contract HNAAuthority {
    function canCall(address src, address dst, bytes4 sig) public view returns (bool);
}

// 权限管理的事件智能合约
contract HNAAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

// 权限管理的智能合约
contract HNAAuth is HNAAuthEvents {
    HNAAuthority  public  authority;
    // 合约创建者（拥有者）
    address      public  owner;

    // 构造函数，合约创建者owner
    function HNAAuth() public {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }

    // 设置新的合约拥有者给owner_
    function setOwner(address owner_) public auth {
        owner = owner_;
        LogSetOwner(owner);
    }

    // 返回当前的合约拥有者
    function getOwner() public view returns (address) {
        return owner;
    }

    function setAuthority(HNAAuthority authority_) public auth {
        authority = authority_;
        LogSetAuthority(authority);
    }

    // 是否有权限，modifier
    modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    // 权限管理，智能合约的地址，拥有者，以及自定的canCall函数定义的权限
    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == HNAAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, this, sig);
        }
    }
}
