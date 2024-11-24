// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TestERC1155 is ERC1155, Ownable {

    constructor(
        address initialOwner
    )
        ERC1155(
            "https://token-cdn-domain/{id}.json"
            "ipfs://QmbuuftMSt744NeXE2vFiUm9kBb1AUzojMaEJpTRa4Nm69/{id}.json"
        )
        Ownable(initialOwner)
    {}

    function mint(
        address account,
        uint256 id,
        uint256 amount
    ) public onlyOwner {
        _mint(account, id, amount, "");
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
}
