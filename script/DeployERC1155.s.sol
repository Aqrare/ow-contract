// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/CareerOtomeNFT.sol";
import "../src/TestERC1155.sol";
import "../src/MyToken.sol";

contract DeployERC1155 is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address ADMIN_WALLET_ADDRESS = 0x2C0d48DD817DeEaD079A814A67aF406Bce5B08dc;
        string memory top = "ipfs://";
        string memory newQID = "bafybeigenxfzce5dqyqu753g4cghgjv4pwovtwutpwg67zo6ge76xir55u";
        string memory suffix = "/{id}.json";
        string memory initialUri = string(abi.encodePacked(top, newQID, suffix));
        vm.startBroadcast(privateKey);
        CareerOtomeNFT testERC1155 = new CareerOtomeNFT(ADMIN_WALLET_ADDRESS, initialUri);
        console.log("ERC1155 deployed at:", address(testERC1155));
        vm.stopBroadcast();
    }
}

contract DeployTestERC1155 is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast();
        address ADMIN_WALLET_ADDRESS = 0x2C0d48DD817DeEaD079A814A67aF406Bce5B08dc;
        TestERC1155 testERC1155 = new TestERC1155(ADMIN_WALLET_ADDRESS);
        console.log("ERC1155 deployed at:", address(testERC1155));
        vm.stopBroadcast();
    }
}

contract DeployMyToken is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        Counter testERC1155 = new Counter(1);
        console.log("ERC1155 deployed at:", address(testERC1155));
        vm.stopBroadcast();
    }
}

contract MintERC1155 is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address recipient = 0x90F7D01EB77494027d7923E0675cf5D6dB015bF6;
        address me = 0x65150B5Fa861481651225Ef4412136DCBf696232;

        address tokenAddress = 0x1A4D66E4b1Cdc802414591F4902e3d8B5cF0Fa02;
        address sepoiaAddress = 0x9e3eaDaCEe6c5D85f7Bb33BA42c05e390126A933;
        CareerOtomeNFT token = CareerOtomeNFT(tokenAddress);
        CareerOtomeNFT sepoliaToken = CareerOtomeNFT(sepoiaAddress);

        vm.startBroadcast(privateKey);
        uint256 tokenId = 91000;
        uint256 amount = 10;

        // token.mint(me, tokenId, amount);
        sepoliaToken.mint(me, tokenId, amount);

        vm.stopBroadcast();
    }
}

contract BalanceOfERC1155 is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address tokenAddress = 0xBA4CD2a4c6B87BA9D245b0c8824c77f263807f68;
        vm.startBroadcast(privateKey);

        CareerOtomeNFT token = CareerOtomeNFT(tokenAddress);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 10101;
        address[] memory accounts = new address[](1);
        accounts[0] = 0x65150B5Fa861481651225Ef4412136DCBf696232;
        uint256[] memory balances = token.balanceOfBatch(accounts, tokenIds);
        console.log(balances[0]);
        vm.stopBroadcast();
    }
}


contract SetURI is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        string memory top = "ipfs://";
        string memory newQID = "bafybeigenxfzce5dqyqu753g4cghgjv4pwovtwutpwg67zo6ge76xir55u";
        string memory suffix = "/{id}.json";
        string memory newUri = string(abi.encodePacked(top, newQID, suffix));

        address tokenAddress = 0x1A4D66E4b1Cdc802414591F4902e3d8B5cF0Fa02;
        CareerOtomeNFT token = CareerOtomeNFT(tokenAddress);

        vm.startBroadcast(privateKey);

        // token.setURI(newUri);
        token.setURI(newUri);

        vm.stopBroadcast();
    }
}

