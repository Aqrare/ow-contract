const { ethers } = require("hardhat");

async function main() {
    // コントラクトのデプロイ先アドレスを設定
    const contractAddress = "0xd156Df8f882F09Cc76431cd958c364D053B9694c";
    const recipient = "0x2C0d48DD817DeEaD079A814A67aF406Bce5B08dc"; // NFTを受け取るアドレス

    // コントラクトのABIとアドレスを取得
    const CareerOtomeNFT = await ethers.getContractFactory("CareerOtomeNFT");
    const nftContract = await CareerOtomeNFT.attach(contractAddress);

    console.log(`Minting NFT to address: ${recipient}`);
    
    // Mint関数の呼び出し
    const tx = await nftContract.mint(recipient, 10101, 1);
    console.log("Transaction sent. Waiting for confirmation...");
    await tx.wait();

    console.log("NFT Minted successfully!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
