// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/TestERC1155.sol";

contract DeployERC1155 is Script {
    function run() public {
        vm.startBroadcast();
        address ADMIN_WALLET_ADDRESS = 0x2C0d48DD817DeEaD079A814A67aF406Bce5B08dc;
        TestERC1155 testERC1155 = new TestERC1155(ADMIN_WALLET_ADDRESS);
        console.log("Showtie ERC20 deployed at:", address(testERC1155));
        vm.stopBroadcast();
    }
}
