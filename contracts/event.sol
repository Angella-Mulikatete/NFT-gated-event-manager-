// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import  './eventNft.sol';

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventManager is Ownable(msg.sender){ //this inherits from Ownable so that only the contract owner can perform certain actions.
    uint256 public nextEventId;

   enum TicketType {GENERAL, VIP, VVIP}

    struct Event{
        bytes32 id;
        address nftContract;
        uint256 startdate;
        uint256 enddate;
        uint256 capacity;
        uint256 remainingTickets;
        TicketType ticketType;
        mapping(address => bool) attendees;
    }

    mapping(bytes32 => Event) public events;
    mapping(bytes32 => address[]) public eventNFTs;

    event EventCreated(bytes32 indexed eventId, address nftContract, uint256 startDate, uint256 endDate, uint256 totalCapacity, TicketType ticketType);

//compilation error is encountered when you try to instantiate a struct that contains a mapping as an attribute.
//the solution is to declare the struct in storage before we instantiate a pointer to it.

    function createEvent(string memory _name, uint256 _startdate, uint256 _enddate ,uint256 _capacity, TicketType _ticketType) public onlyOwner {
        bytes32 eventId = keccak256(abi.encodePacked(nextEventId++, _name));
        require(_capacity > 0, "Capacity must be greater than 0");

        EventNft nftInstance =  new EventNft(_capacity);

        Event storage newEvent = events[eventId];
            newEvent.id = eventId;
            newEvent.nftContract = address(nftInstance);
            newEvent.startdate = _startdate;
            newEvent.enddate = _enddate;
            newEvent.capacity = _capacity;
            newEvent.remainingTickets = _capacity; //at this point no ticket has been sold yet
            newEvent.ticketType = _ticketType;

        //mint nfts basing on the ticket type in the enum
        //The loop ensures that a specific number of NFTs (equal to the event capacity) are minted to the organizer's address when the event is created.
        //The minting process involves calling the mintTicket function of the EventNft contract, which then mints NFTs and assigns them to the organizer (msg.sender).

        for(uint256 i=0; i< newEvent.capacity; i++){
            nftInstance.mintTicket{value:0}(uint256(newEvent.ticketType)); 
            eventNFTs[eventId].push(address(this));
        }

        emit EventCreated(newEvent.id, newEvent.nftContract, newEvent.startdate, newEvent.enddate, newEvent.capacity,newEvent.ticketType);
    }

   
}
    