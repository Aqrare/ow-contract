// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract UniqueMonster is ERC721, ERC721Burnable, Ownable, ReentrancyGuard {
    mapping(bytes => bool) private _isExpiredSignature;
    mapping(uint256 => Monster) private _monsters;

    event NewChallenger(address indexed challenger, uint256 tokenId);
    event ChallengerDeprived(address indexed challenger, uint256 tokenId);
    event UniqueMonsterAppeared(uint256 tokenId);
    event UniqueMonsterDisappeared(uint256 tokenId);
    event ChallengerExpired(address indexed challenger, uint256 tokenId);
    event UniqueMonsterDefeated(address indexed winner, uint256 tokenId);

    struct Monster {
        MonsterStatus status;
        address challenger;
        uint256 validUntil;
    }

    enum MonsterStatus {
        NotSpawned,
        Active,
        Defeated
    }

    constructor(
        address initialOwner
    ) ERC721("UniqueMonster", "UNQ") Ownable(initialOwner) {}

    function grantReward(uint256 tokenId) external onlyOwner nonReentrant {
        Monster storage monster = _monsters[tokenId];
        require(
            monster.status == MonsterStatus.Active,
            "Monster is not active"
        );
        require(
            monster.challenger != address(0),
            "No challenger for this monster"
        );

        _safeMint(monster.challenger, tokenId);
        monster.status = MonsterStatus.Defeated;
        monster.challenger = address(0);
        monster.validUntil = 0;

        emit UniqueMonsterDefeated(monster.challenger, tokenId);
    }

    function launchUniqueMonster(uint256 tokenId) public onlyOwner {
        require(
            _monsters[tokenId].status == MonsterStatus.NotSpawned,
            "Monster already spawned or defeated"
        );
        _monsters[tokenId] = Monster({
            status: MonsterStatus.Active,
            challenger: address(0),
            validUntil: 0
        });
        emit UniqueMonsterAppeared(tokenId);
    }

    function challengeUniqueMonster(
        bytes memory signature,
        uint256 tokenId
    ) external nonReentrant {
        Monster storage monster = _monsters[tokenId];

        require(
            monster.status == MonsterStatus.Active,
            "Monster is not active"
        );
        if (
            monster.challenger != address(0) &&
            monster.validUntil < block.timestamp
        ) {
            address expiredChallenger = monster.challenger;
            monster.challenger = address(0);
            monster.validUntil = 0;
            emit ChallengerExpired(expiredChallenger, tokenId);
        }
        require(
            monster.challenger == address(0),
            "Another challenger is active"
        );

        require(
            !_isExpiredSignature[signature],
            "Signature has already been used"
        );
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, tokenId));
        require(_verifyECDSA(messageHash, signature, owner()));

        monster.challenger = msg.sender;
        monster.validUntil = block.timestamp + 1 hours;
        _isExpiredSignature[signature] = true;

        emit NewChallenger(msg.sender, tokenId);
    }

    function depriveChallenger(uint256 tokenId) public onlyOwner {
        Monster storage monster = _monsters[tokenId];
        require(
            monster.status == MonsterStatus.Active,
            "Monster is not active"
        );
        require(monster.challenger != address(0), "No challenger to deprive");

        address previousChallenger = monster.challenger;
        monster.challenger = address(0);
        monster.validUntil = 0;

        emit ChallengerDeprived(previousChallenger, tokenId);
    }

    function getCurrentChallenger(
        uint256 tokenId
    ) public view returns (address) {
        Monster storage monster = _monsters[tokenId];
        if (monster.validUntil < block.timestamp) {
            return address(0);
        }
        return monster.challenger;
    }

    function getMonsterStatus(
        uint256 tokenId
    ) external view returns (MonsterStatus) {
        return _monsters[tokenId].status;
    }

    function verifySignature(
        bytes32 messageHash,
        bytes memory signature
    ) internal pure returns (address) {
        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    function _verifyECDSA(
        bytes32 messageHash,
        bytes memory signature,
        address expectedSigner
    ) internal pure returns (bool) {
        address recoveredSigner = verifySignature(messageHash, signature);
        return recoveredSigner == expectedSigner;
    }
}
