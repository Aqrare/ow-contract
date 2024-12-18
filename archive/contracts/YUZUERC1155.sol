// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YUZUERC1155 is ERC1155, Ownable {
    uint256 public constant MAX_NFT_ID = 16;
    uint256 public constant MIN_NFT_ID = 1;

    constructor(
        address initialOwner
    )
        ERC1155(
            "https://raw.githubusercontent.com/Aqrare/ow-contract/main/metadata/"
        )
        Ownable(initialOwner)
    {}

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, ids, amounts, data);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
}
