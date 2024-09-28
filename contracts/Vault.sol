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
    event NFTBatchDeposited(
        address indexed owner,
        uint256[] tokenIds,
        uint256[] amounts
    );
    event NFTBatchWithdrawn(
        address indexed owner,
        uint256[] tokenIds,
        uint256[] amounts
    );
    IERC1155 public immutable nftContract;

    constructor(address _supportedNFTContract) {
        require(
            _supportedNFTContract != address(0),
            "Invalid NFT contract address"
        );
        require(
            IERC165(_supportedNFTContract).supportsInterface(
                type(IERC1155).interfaceId
            ),
            "Invalid ERC1155 contract"
        );
        supportedNFTContract = _supportedNFTContract;
        nftContract = IERC1155(_supportedNFTContract);
    }

    function deposit(uint256 _tokenId, uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        nftContract.safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId,
            _amount,
            ""
        );
        vaultedNFTs[msg.sender][_tokenId] += _amount;
        emit NFTDeposited(msg.sender, _tokenId, _amount);
    }

    function withdraw(uint256 _tokenId, uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            vaultedNFTs[msg.sender][_tokenId] >= _amount,
            "Insufficient balance"
        );
        nftContract.safeTransferFrom(
            address(this),
            msg.sender,
            _tokenId,
            _amount,
            ""
        );
        vaultedNFTs[msg.sender][_tokenId] -= _amount;
        emit NFTWithdrawn(msg.sender, _tokenId, _amount);
    }

    function depositBatch(
        uint256[] calldata _tokenIds,
        uint256[] calldata _amounts
    ) external nonReentrant {
        require(
            _tokenIds.length == _amounts.length,
            "Token IDs and amounts length mismatch"
        );
        require(_tokenIds.length > 0, "Must provide at least one token ID");
        nftContract.safeBatchTransferFrom(
            msg.sender,
            address(this),
            _tokenIds,
            _amounts,
            ""
        );
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            vaultedNFTs[msg.sender][_tokenIds[i]] += _amounts[i];
        }
        emit NFTBatchDeposited(msg.sender, _tokenIds, _amounts);
    }

    function withdrawBatch(
        uint256[] calldata _tokenIds,
        uint256[] calldata _amounts
    ) external nonReentrant {
        require(
            _tokenIds.length == _amounts.length,
            "Token IDs and amounts length mismatch"
        );
        require(_tokenIds.length > 0, "Must provide at least one token ID");
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            uint256 amount = _amounts[i];
            require(amount > 0, "Amount must be greater than 0");
            require(
                vaultedNFTs[msg.sender][tokenId] >= amount,
                "Insufficient vault balance for token ID"
            );
            vaultedNFTs[msg.sender][tokenId] -= amount;
        }
        nftContract.safeBatchTransferFrom(
            address(this),
            msg.sender,
            _tokenIds,
            _amounts,
            ""
        );
        emit NFTBatchWithdrawn(msg.sender, _tokenIds, _amounts);
    }

    function getVaultBalance(
        address _user,
        uint256 _tokenId
    ) external view returns (uint256) {
        return vaultedNFTs[_user][_tokenId];
    }

    function getTotalVaultBalance(
        uint256 _tokenId
    ) external view returns (uint256) {
        return
            IERC1155(supportedNFTContract).balanceOf(address(this), _tokenId);
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override returns (bytes4) {
        require(msg.sender == address(nftContract), "Unsupported token contract");
        vaultedNFTs[from][id] += value;
        emit NFTDeposited(from, id, value);
        return super.onERC1155Received(operator, from, id, value, data);
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override returns (bytes4) {
        require(msg.sender == address(nftContract), "Unsupported token contract");
        require(ids.length == values.length, "IDs and values length mismatch");
        for (uint256 i = 0; i < ids.length; i++) {
            vaultedNFTs[from][ids[i]] += values[i];
        }
        emit NFTBatchDeposited(from, ids, values);
        return super.onERC1155BatchReceived(operator, from, ids, values, data);
    }
}
