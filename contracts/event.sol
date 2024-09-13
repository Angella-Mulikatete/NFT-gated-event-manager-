// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import {MyNft} from  './nft.sol';

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NftEventGator{
    address owner;
    IERC721  NFTAddress;
    address participantAddress;
    uint256 eventidCount;
    string url;
    uint256 tokenId;

    constructor(address _nftAddress){
        NFTAddress = IERC721(_nftAddress);
    }

    struct Event{
        bool isActive;
        address NFTAddress; 
        uint256 startTime;
        uint256 endTime;
        uint256 maxParticipants;
        uint256 price;
        uint256 registeredCount;
        string location;
        string name;
        string organizer;
        
    }


    // uint256 nextEventId;

    mapping(uint256 => Event) public events;
    // mapping(address => uint256) public participants; //mapping address to id of participants
    mapping(uint256 => mapping(address => bool)) registeredParticipants; //eventId => participantAddress => boolean

    modifier onlyOrganizer {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier canRegister(uint256 eventId){
        require(events[eventId].registeredCount < events[eventId].maxParticipants, "Event is full"); //checking if the event is not full
        require(!registeredParticipants[eventId][msg.sender], "Already Registered");
        _;
    }

    modifier eventExists(uint256 eventId){
        require(!events[eventId].isActive, "Event doesnot exist");
        _;
    }

    modifier hasNft(uint256 eventId){
        require(IERC721(events[eventId].NFTAddress).balanceOf(msg.sender) > 0, "There is no Nft yet");
        _;
    }

    function createEvent(string memory _name, uint256 _price, uint256 _startTime, uint256 _endTime,  string memory _location, address _nftAddress, string memory _organizer ) external onlyOrganizer {
        // require(owner != 0, "zero address detected");
        require(_startTime < _endTime, "");

        eventidCount++; //the event Id is incremented so as we dont have the same ids, initiall the id is 0

        events[eventidCount]= Event({
            name: _name,
            price: _price,
            startTime: _startTime,
            endTime: _endTime,
            NFTAddress: _nftAddress,
            maxParticipants: 0,
            location: _location,
            isActive: true,
            organizer: _organizer,
            registeredCount: 0
        });


        
    }

    //users registering for the event
    function registerParticipants(uint256 eventId) external  canRegister(eventId) eventExists(eventId) hasNft(eventId){
       events[eventId].registeredCount ++;
       registeredParticipants[eventId][msg.sender] == true;
    }

    function mintNft(address _participantAddress) internal onlyOrganizer returns(uint256){
      tokenId =   NFTAddress.mint(_participantAddress);
      tokenId++;
      return tokenId;
    }

    //when users attend the event, we need to verify their nft
    function verifyTicket() public view returns(bool){}

    function getEventDetails() public view returns(Event memory){}
    
    function cancelEvent() external {} 



}