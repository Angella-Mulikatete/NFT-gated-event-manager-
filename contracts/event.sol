// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import  './eventNft.sol';

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventManager is Ownable(msg.sender){ //this inherits from Ownable so that only the contract owner can perform certain actions.
    uint256 public nextEventId;

    struct Event{
        bytes32 id;
        address nftContract;
        uint256 startdate;
        uint256 enddate;
        uint256 capacity;
        uint256 remainingTickets;
        mapping(address => bool) attendees;
    }

    mapping(bytes32 => Event) public events;
    event createEventSuccessfully(bytes32 indexed eventId, uint256 startdate, uint256 enddate);

    function createEvent(string memory _name, address _nftContract, uint256 _startdate, uint256 _enddate ,uint256 _capacity) public onlyOwner {
        bytes32 eventId = keccak256(abi.encodePacked(nextEventId++, _name)); //Creates a unique event ID by hashing the event name and the incremented nextEventId

       Event storage newEvent = events[eventId] ;
       newEvent.id = eventId;
       newEvent.nftContract = _nftContract;
       newEvent.startdate = _startdate;
       newEvent.enddate = _enddate;
       newEvent.capacity = _capacity;
       newEvent.remainingTickets = 0;
       

        emit createEventSuccessfully(newEvent.id, newEvent.startdate, newEvent.enddate);

    }


}
    //     events[eventId] = Event({
    //         id: eventId,
    //         nftContract: _nftContract,
    //         startdate: _startdate,
    //         enddate: _enddate,
    //         capacity: _capacity,
    //         remainingTickets: 0,
    //    });