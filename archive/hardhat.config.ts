import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const accounts = [process.env.PRIVATE_KEY || ""];
const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      chainId: 11155111,
      url: "https://rpc.sepolia.org",
      accounts,
    },
    mch_testnet: {
      chainId: 420,
      url: `https://rpc.oasys.sand.mchdfgh.xyz/`,
      accounts,
    },
  },
};

export default config;
