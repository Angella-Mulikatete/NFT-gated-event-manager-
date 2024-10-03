import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EventManagerModule = buildModule("EventManagerModule", (m) => {

    const manager = m.contract("EventManager");

    return { manager };
});

export default EventManagerModule;
