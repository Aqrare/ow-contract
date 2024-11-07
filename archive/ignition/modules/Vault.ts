import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const VaultModule = buildModule("VaultModule", (m) => {

  const vault = m.contract("Vault", [
    "0xE6b9b3D79C85dcC038eA81A8Fc420bbd34C75445",
  ]);

  return { vault };
});

export default VaultModule;
