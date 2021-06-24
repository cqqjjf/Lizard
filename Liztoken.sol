// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.5.0;

import "./lib/token/BEP20/BEP20.sol";

// ABCToken with Governance.
contract LIZToken is BEP20('LIZ', 'Lizard',8) {

    // /// @notice Creates `_amount` token to `_to`. Must only be called by the owner 
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}