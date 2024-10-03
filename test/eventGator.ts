import {time, loadFixture} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre, { ethers } from "hardhat";

const TicketType = {
  GENERAL: 0,
  VIP: 1,
  VVIP: 2
};

describe("EventManager", function(){
    async function deployNft(){
        const nft = await hre.ethers.getContractFactory("EventNft");
        const maxTickets = ethers.parseUnits("1000");
        const deployedNft = await nft.deploy(maxTickets);
        return {deployedNft};
    }

    async function deployEventManager(){
        const [owner, addr1] = await hre.ethers.getSigners();
        const eventManager = await hre.ethers.getContractFactory("EventManager");
        const deployedEventManager = await eventManager.deploy();
        return {deployedEventManager, owner, addr1};
    }

    describe("deployment", function(){
        it("should deploy EventManager", async function(){
            const {deployedEventManager, owner, addr1} = await loadFixture(deployEventManager);
            expect(await deployedEventManager.owner()).to.equal(owner);
        });
    });

    describe("CreateEvent", function(){
        it("should create an event", async function(){
            const {deployedEventManager, owner, addr1} = await loadFixture(deployEventManager);
            const { deployedNft } = await loadFixture(deployNft);
            const startDate = Math.floor(Date.now() / 1000) + 120; // 2 mins in the future
            const endDate = startDate + 600; // 10 mins event
            const capacity = 10;
            
            // const tx = await 

             await expect(deployedEventManager.createEvent("TestEvent", startDate, endDate, capacity, TicketType.GENERAL,  { value: ethers.parseUnits("0.1", "ether") }))
             .to.emit(deployedEventManager, "EventCreated")
             
        });
        
    });
});