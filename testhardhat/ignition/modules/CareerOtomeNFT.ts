import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";



const CareerOtomeNFT = buildModule("CareerOtomeNFT", (m) => {
    const ADMIN_WALLET_ADDRESS = "0x2C0d48DD817DeEaD079A814A67aF406Bce5B08dc";
    const top = "ipfs://";
    const newQID = "bafybeigenxfzce5dqyqu753g4cghgjv4pwovtwutpwg67zo6ge76xir55u";
    const suffix = "/{id}.json";
    const initialUri = top + newQID + suffix;

  const careerOtomeNFT = m.contract("CareerOtomeNFT", [ADMIN_WALLET_ADDRESS, initialUri]);
  return { careerOtomeNFT };
});

export default CareerOtomeNFT;
