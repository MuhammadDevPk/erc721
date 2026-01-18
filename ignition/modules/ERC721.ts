import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ERC721Module", (m) => {
    const erc721 = m.contract("ERC721", ["MyNFT", "MNFT"]);
    return { erc721 };
});