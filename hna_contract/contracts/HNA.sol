pragma solidity ^0.4.17;

import "./lib/token.sol";
import './ERC223ReceivingContract.sol';
import './TokenController.sol';
import './Controlled.sol';
import './ApproveAndCallFallBack.sol';
import './ERC223.sol';

contract HNA is DSToken("HNA"), ERC223, Controlled {

    // Contract constructor, setting name, total release, sales volume
    function HNA() public {
        setName("Honour Network Access Token");
 
    }
    
    //  extcodesize: returns the size of the address. If greater than zero, the address is a contract. 
    // Need to write assembly code in the contract to access this operation
    // Determine if the addr is a contract address
    // return: True if `_addr` is a contract
    function isContract(address _addr) constant internal returns(bool) {
        uint256 size;
        if (_addr == 0) return false;
        assembly {
            size := extcodesize(_addr)
        }
        return size>0;
    }

    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        // Alerts the token controller of the transfer
        if (isContract(controller)) {
            require (TokenController(controller).onTransfer(_from, _to, _amount));
        }

        success = super.transferFrom(_from, _to, _amount);

        if (success && isContract(_to)) {
            // Backward compatible ERC20
            if(!_to.call(bytes4(keccak256("tokenFallback(address,uint256)")), _from, _amount)) {
                ReceivingContractTokenFallbackFailed(_from, _to, _amount);
            }
        }
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool success) {
        // Alerts the token controller of the transfer
        if (isContract(controller)) {
            require (TokenController(controller).onTransfer(_from, _to, _amount));  
        }

        require(super.transferFrom(_from, _to, _amount));

        if (isContract(_to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(_from, _amount, _data);
        }

        ERC223Transfer(_from, _to, _amount, _data);
        return true;
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transfer(address _to, uint256 _amount, bytes _data) public returns (bool success) {
        return transferFrom(msg.sender, _to, _amount, _data);
    }


    // give _spender approve _amount
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        // Alerts the token controller of the approve function call
        if (isContract(controller)) {
            require (TokenController(controller).onApprove(msg.sender, _spender, _amount));
        }
        
        return super.approve(_spender, _amount);
    }

    // Generate tokens
    function mint(address _guy, uint256 _wad) auth stoppable public {
        super.mint(_guy, _wad);
        Transfer(0, _guy, _wad);
    }

    // burn tokens
    function burn(address _guy, uint256 _wad) auth stoppable public {
        super.burn(_guy, _wad);
        Transfer(_guy, 0, _wad);
    }

    // give _spender approve _amount
    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
        require (approve(_spender, _amount));

        ApproveAndCallFallBack(_spender).receiveApproval(
            msg.sender,
            _amount,
            this,
            _extraData
        );

        return true;
    }

//////////
// Safety Methods
//////////

    /// @notice Extracting the wrongly sent token back into the contract
    ///  set to 0 if want to get ether.
    function claimTokens(address _token) onlyController public {
        if (_token == 0x0) {
            controller.transfer(this.balance);
            return;
        }

        ERC20 token = ERC20(_token);
        uint256 balance = token.balanceOf(this);
        token.transfer(controller, balance);
        ClaimedTokens(_token, controller, balance);
    }

    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
}