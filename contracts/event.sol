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
        address payable nftContract;
        address organizer;
        uint256 startdate;
        uint256 enddate;
        uint256 capacity;
        uint256 remainingTickets;
        TicketType ticketType;
        mapping(address => bool) attendees;
    }

    constructor() {
        nextEventId = 1;
    }

    mapping(bytes32 => Event) public events;
    mapping(bytes32 => address[]) public eventNFTs;

    event EventCreated(bytes32 indexed eventId, address nftContract, uint256 startDate, uint256 endDate, uint256 totalCapacity, TicketType ticketType);
    event RegisteredForEvent(bytes32 indexed eventId, address attendee);
    event VerifiedForEvent(bytes32 indexed eventId, address attendee);


//compilation error is encountered when you try to instantiate a struct that contains a mapping as an attribute.
//the solution is to declare the struct in storage before we instantiate a pointer to it.

    function createEvent(string memory _name, uint256 _startdate, uint256 _enddate ,uint256 _capacity, TicketType _ticketType) payable public onlyOwner {
        bytes32 eventId = keccak256(abi.encodePacked(nextEventId++, _name));
        require(_capacity > 0, "Capacity must be greater than 0");

        EventNft nftInstance =  new EventNft(_capacity);

        Event storage newEvent = events[eventId];
            newEvent.id = eventId;
            newEvent.nftContract = payable (address(nftInstance));
            newEvent.organizer = msg.sender;
            newEvent.startdate = _startdate;
            newEvent.enddate = _enddate;
            newEvent.capacity = _capacity;
            newEvent.remainingTickets = _capacity; //at this point no ticket has been sold yet
            newEvent.ticketType = _ticketType;

        //mint nfts basing on the ticket type in the enum
        //The loop ensures that a specific number of NFTs (equal to the event capacity) are minted to the organizer's address when the event is created.
        //The minting process involves calling the mintTicket function of the EventNft contract, which then mints NFTs and assigns them to the organizer (msg.sender).

        for(uint256 i=0; i< newEvent.capacity; i++){
            nftInstance.mintTicket{value:msg.value}(uint256(newEvent.ticketType)); 
            eventNFTs[eventId].push(address(this));
        }

        emit EventCreated(newEvent.id, newEvent.nftContract, newEvent.startdate, newEvent.enddate, newEvent.capacity,newEvent.ticketType);
    }

 //registering for the event
    function registerEvent(bytes32 eventId) external payable{
        Event storage currentEvent = events[eventId];

        require(currentEvent.remainingTickets >0, "Event is already full");
        require(block.timestamp >= currentEvent.startdate && block.timestamp <= currentEvent.enddate, "Event ended");
        require(!currentEvent.attendees[msg.sender], "Already registered");

        //transfer nft to the attendee
        EventNft _nftContract = EventNft(currentEvent.nftContract);
        uint256 ticketId = currentEvent.capacity - currentEvent.remainingTickets + 1;

        require(_nftContract.ownerOf(ticketId) == currentEvent.organizer, "ticket not owned by organizer");
        _nftContract.safeTransferFrom(address(this), msg.sender, ticketId);

        //mark attendee as registered
        currentEvent.attendees[msg.sender] = true;
        currentEvent.remainingTickets --;

        emit RegisteredForEvent(eventId, msg.sender);

    }

    //verify Attendee

    function verifyAttendance(bytes32 eventId, address attenddee) external view returns(bool){
        Event storage currentEvent = events[eventId];

        EventNft nftContract = EventNft(currentEvent.nftContract);

        for(uint i = 0; i< currentEvent.capacity; i++){
            if(nftContract.ownerOf(i + 1) == attenddee && currentEvent.attendees[attenddee]){
                return true;
            }
        }
        return false;
    }

 // Get event details
    function getEventDetails(bytes32 eventId) external view returns (
        bytes32 id,
        address nftContract,
        address organizer,
        uint256 startDate,
        uint256 endDate,
        uint256 totalCapacity,
        uint256 remainingTickets,
        TicketType ticketType
    ) {
        Event storage currentEvent = events[eventId];
        return (
            currentEvent.id,
            currentEvent.nftContract,
            currentEvent.organizer,
            currentEvent.startdate,
            currentEvent.enddate,
            currentEvent.capacity,
            currentEvent.remainingTickets,
            currentEvent.ticketType
        );
    }


   
}
    