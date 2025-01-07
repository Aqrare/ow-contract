import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    mch_testnet: {
      url: "https://rpc.oasys.sand.mchdfgh.xyz/",
      accounts: ["0xf78262271606e508ac56fed4de4a6222c1069c03b93ff6259018bad5c83794e2"],
    },
    mch_mainnet: {
      url: "https://rpc.oasys.mycryptoheroes.net/",
      accounts: ["0x756b7b732f038f80a3575f455adc79755c72e0003ec9c9c29e729eed919e0454"],
    },

  },
};

export default config;
