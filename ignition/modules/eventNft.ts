import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EventNftModule = buildModule("EventNftModule", (m) => {
    const maxTickets = 100;

    const nft = m.contract("EventNft", [maxTickets]);

    return { nft };
});

export default EventNftModule;
