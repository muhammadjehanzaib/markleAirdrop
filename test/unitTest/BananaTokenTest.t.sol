//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {BananaToken} from "../../src/BananaToken.sol";

contract BananaTokenTest is Test {
    BananaToken bananaToken;

    function setUp() external {
        bananaToken = new BananaToken();
        // 100000 * 10 ** 18
        bananaToken.mint(address(this), 100000 * 10 ** 18);
    }

    function testTotalSupply() public view {
        assertEq(bananaToken.totalSupply(), 100000 * 10 ** 18);
    }
}
