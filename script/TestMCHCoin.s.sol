// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/TestMCHCoin.sol";

contract ScriptTestMCHCoin is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address recipient = 0x23De67865ff34f7D775b1A1b15441EAf706D20e0; // トークンを受け取るアドレス
        uint256 amount = 1000 * (10 ** 18); // ミントする量（18桁対応）

        address tokenAddress = 0x47E220a0BF081564d2C2Ce33F9F5EAFB00c0a0fA;
        TestMCHCoin token = TestMCHCoin(tokenAddress);

        vm.startBroadcast(privateKey);

        // mint関数を呼び出す
        token.mint(recipient, amount);

        vm.stopBroadcast();
    }
}
