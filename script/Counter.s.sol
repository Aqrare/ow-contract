// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TestMCHCoin} from "../src/TestMCHCoin.sol";

contract CounterScript is Script {
    TestMCHCoin public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new TestMCHCoin();

        vm.stopBroadcast();
    }
}
