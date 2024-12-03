// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import "../src/UniqueMonster.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "forge-std/console.sol";

contract UniqueMonsterTest is Test {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;
    uint256 internal ownerPrivateKey;

    UniqueMonster uniqueMonster;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        ownerPrivateKey = 0xa11ce;
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        owner = vm.addr(ownerPrivateKey);
        uniqueMonster = new UniqueMonster(owner);
    }

    function testLaunchUniqueMonster() public {
        uint256 tokenId = 1;
        vm.prank(owner);
        uniqueMonster.launchUniqueMonster(tokenId);
        UniqueMonster.MonsterStatus status = uniqueMonster.getMonsterStatus(tokenId);
        assertEq(uint(status), uint(UniqueMonster.MonsterStatus.Active));
    }

    function testChallengeUniqueMonster() public {
        uint256 tokenId = 1;
        vm.prank(owner);
        uniqueMonster.launchUniqueMonster(tokenId);

        // user1が挑戦
        vm.prank(user1);
        bytes memory signature = _generateSignature(user1, tokenId);
        uniqueMonster.challengeUniqueMonster(signature, tokenId);

        // 挑戦者をチェック
        address challenger = uniqueMonster.getCurrentChallenger(tokenId);
        assertEq(challenger, user1);
    }

    function testGrantReward() public {
        uint256 tokenId = 1;
        vm.prank(owner);
        uniqueMonster.launchUniqueMonster(tokenId);

        // user1が挑戦
        vm.prank(user1);
        bytes memory signature = _generateSignature(user1, tokenId);
        uniqueMonster.challengeUniqueMonster(signature, tokenId);

        // オーナーが報酬を与える
        vm.prank(owner);
        uniqueMonster.grantReward(tokenId);

        // モンスターの状態をチェック
        UniqueMonster.MonsterStatus status = uniqueMonster.getMonsterStatus(tokenId);
        assertEq(uint(status), uint(UniqueMonster.MonsterStatus.Defeated));

        // NFTがuser1にミントされているか確認
        address ownerOfToken = uniqueMonster.ownerOf(tokenId);
        assertEq(ownerOfToken, user1);
    }

    function testChallengerExpired() public {
        uint256 tokenId = 1;
        vm.prank(owner);
        uniqueMonster.launchUniqueMonster(tokenId);

        // user1が挑戦
        vm.prank(user1);
        bytes memory signature = _generateSignature(user1, tokenId);
        uniqueMonster.challengeUniqueMonster(signature, tokenId);

        // 時間を進めて有効期限を過ぎさせる
        vm.warp(block.timestamp + 2 hours);

        // 挑戦者がリセットされているか確認
        address challenger = uniqueMonster.getCurrentChallenger(tokenId);
        assertEq(challenger, address(0));
    }

    function testCannotChallengeWithInvalidSignature() public {
        uint256 tokenId = 1;
        vm.prank(owner);
        uniqueMonster.launchUniqueMonster(tokenId);

        vm.prank(user1);
        bytes memory invalidSignature = hex"123456";
        vm.expectRevert();
        uniqueMonster.challengeUniqueMonster(invalidSignature, tokenId);
    }

    function testDepriveChallenger() public {
        uint256 tokenId = 1;
        vm.prank(owner);
        uniqueMonster.launchUniqueMonster(tokenId);

        vm.prank(user1);
        bytes memory signature = _generateSignature(user1, tokenId);
        uniqueMonster.challengeUniqueMonster(signature, tokenId);

        vm.prank(owner);
        uniqueMonster.depriveChallenger(tokenId);

        address challenger = uniqueMonster.getCurrentChallenger(tokenId);
        assertEq(challenger, address(0));
    }

    function _generateSignature(address challenger, uint256 tokenId) internal view returns (bytes memory) {
        bytes32 messageHash = keccak256(abi.encodePacked(challenger, tokenId));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, ethSignedMessageHash);
        return abi.encodePacked(r, s, v);
    }
}
