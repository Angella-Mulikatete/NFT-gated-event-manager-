// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract NftEventGator{

    struct Event{
        bool isActive;
        address NftAddress; // a specific nft for a specific event
        uint256 id;
        uint256 startTime;
        uint256 endTime;
        uint256 maxParticcipants;
        uint256 price;
        string location;
        string name;
        
    }

    function createEvent() external {}

    //users registering for the event
    function claimingTickets() external{}

    //when users attend the event, we need to verify their nft
    function verifyTicket() public view returns(bool){}

    function getEventDetails() public view returns(Event memory){}
    
    function cancelEvent() external {} 



}