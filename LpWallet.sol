// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.5.0;
import "./lib/math/SafeMath.sol";
import "./lib/utils/TransferHelper.sol";
import "./lib/token/BEP20/IBEP20.sol";

contract LpWallet //EMPTY CONTRACT TO HOLD THE USERS assetS
{
    address lptoken;
    address liztoken;
    address _MainContract;
    address _feeowner;
    address _owner;

    mapping(address=>uint256) _balancesa;
    mapping(address=>uint256) _balancesb;

    using TransferHelper for address;
    using SafeMath for uint256;

    event eventWithDraw(address indexed to,uint256 indexed  amounta,uint256 indexed amountb);

    constructor(address tokena,address tokenb,address feeowner,address owner) //Create by lizmain 
    {
        _MainContract=msg.sender;// The lizmain CONTRACT
        lptoken =tokena;
        liztoken=tokenb;
        _feeowner=feeowner;
        _owner=owner;
    }

    function getBalance(address user,bool isa) public view returns(uint256)
    {
        if(isa)
            return _balancesa[user];
       else
           return _balancesb[user];
    }
 
    function addBalance(address user,uint256 amounta,uint256 amountb) public
    {
        require(_MainContract==msg.sender);//Only lizmain can do this
        _balancesa[user] = _balancesa[user].add(amounta);
        _balancesb[user] = _balancesb[user].add(amountb);
    }


    function decBalance(address user,uint256 amounta,uint256 amountb ) public 
    {
        require(_MainContract==msg.sender);//Only lizmain can do this
        _balancesa[user] = _balancesa[user].sub(amounta);
        _balancesb[user] = _balancesb[user].sub(amountb);
    }
 
    function TakeBack(address to,uint256 amounta,uint256 amountb) public 
    {
        require(_MainContract==msg.sender);//Only lizmain can do this
        _balancesa[to]= _balancesa[to].sub(amounta);
        _balancesb[to]= _balancesb[to].sub(amountb);
        if(lptoken!= address(2))//BNB
        {
            uint256 mainfee= amounta.div(100);
           lptoken.safeTransfer(to, amounta.sub(mainfee));
           lptoken.safeTransfer(_feeowner, mainfee);
           if(amountb>=100)
           {
               uint256 fee = amountb.div(100);//fee 1%
               liztoken.safeTransfer(to, amountb.sub(fee));
               IBEP20(liztoken).burn(fee);
           }
           else
           {
               liztoken.safeTransfer(to, amountb);
           }
        }
    }
}