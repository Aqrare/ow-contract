import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LockModule = buildModule("LockModule", (m) => {

  const lock = m.contract("YUZUERC1155", [
    "0x65150B5Fa861481651225Ef4412136DCBf696232",
  ]);

  return { lock };
});

export default LockModule;
