// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";

const JAN_1ST_2030 = 1893456000;
const ONE_GWEI: bigint = parseEther("0.001");

const MyToken = buildModule("MyToken", (m) => {

  const lock = m.contract("MyToken", [1]);

  return { lock };
});

export default MyToken;
