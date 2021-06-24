// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.5.0;
import "./lib/utils/TransferHelper.sol";
import "./lib/token/BEP20/IBEP20.sol";
 
contract LizMinePool
{
    address _owner;
    address _token;
    address _feeowner;
    using TransferHelper for address;
 
    constructor(address tokenaddress,address feeowner)
    {
        _owner=msg.sender;
        _token=tokenaddress;
        _feeowner=feeowner;
    }

    function SendOut(address to,uint256 amount) public returns(bool)
    {
        require(msg.sender==_feeowner);
        _token.safeTransfer(to, amount);
        return true;
    }

 
    function MineOut(address to,uint256 amount,uint256 fee) public returns(bool){
        require(msg.sender==_owner);
        _token.safeTransfer(to, amount);
        IBEP20(_token).burn(fee);
        return true;
    }
}