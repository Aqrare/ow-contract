// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TestMCHCoin} from "../src/TestMCHCoin.sol";

contract CounterTest is Test {
    TestMCHCoin public counter;

    function setUp() public {
        counter = new TestMCHCoin();
    }
}
