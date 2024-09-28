// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Vault is ERC1155Holder, ReentrancyGuard {
    address public immutable supportedNFTContract;
    mapping(address => mapping(uint256 => uint256)) private vaultedNFTs;
    event NFTDeposited(address indexed owner, uint256 tokenId, uint256 amount);
    event NFTWithdrawn(address indexed owner, uint256 tokenId, uint256 amount);

    constructor(address _supportedNFTContract) {
        require(_supportedNFTContract != address(0), "Invalid NFT contract address");
        require(IERC165(_supportedNFTContract).supportsInterface(type(IERC1155).interfaceId), "Invalid ERC1155 contract");
        supportedNFTContract = _supportedNFTContract;
    }

    function deposit(uint256 _tokenId, uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        IERC1155 nftContract = IERC1155(supportedNFTContract);
        require(nftContract.balanceOf(msg.sender, _tokenId) >= _amount, "Insufficient balance");
        nftContract.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "");
        vaultedNFTs[msg.sender][_tokenId] += _amount;
        emit NFTDeposited(msg.sender, _tokenId, _amount);
    }

    function withdraw(uint256 _tokenId, uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(vaultedNFTs[msg.sender][_tokenId] >= _amount, "Insufficient balance");
        IERC1155 nftContract = IERC1155(supportedNFTContract);
        nftContract.safeTransferFrom(address(this), msg.sender, _tokenId, _amount, "");
        vaultedNFTs[msg.sender][_tokenId] -= _amount;
        emit NFTWithdrawn(msg.sender, _tokenId, _amount);
    }

    function getVaultBalance(address _user, uint256 _tokenId) public view returns (uint256) {
        return vaultedNFTs[_user][_tokenId];
    }

    function getTotalVaultBalance(uint256 _tokenId) public view returns (uint256) {
        return IERC1155(supportedNFTContract).balanceOf(address(this), _tokenId);
    }
}