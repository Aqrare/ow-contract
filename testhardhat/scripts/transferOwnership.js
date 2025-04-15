const hre = require("hardhat");
import "@nomiclabs/hardhat-ethers";

async function main() {
  // コントラクトのデプロイ先アドレスを設定
  const contractAddress = "0x044703b34a19eC87876135ea2681990686c7171A";
  const newOwner = "0x760b76663628B10eDb5f15eF33372095106a07bE"; // NFTを受け取るアドレス

  // コントラクトのABIとアドレスを取得
  const CareerOtomeNFT = await hre.ethers.getContractFactory("CareerOtomeNFT");
  const nftContract = await CareerOtomeNFT.attach(contractAddress);

  const tx = await nftContract.transferOwnership(newOwner);
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
