// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract myToken is ERC20 {
    constructor() ERC20 ("ANGIE", "ANG"){
        _mint(msg.sender, 1000000 *(10 ** 18));
    }
}
