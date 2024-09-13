// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract NftEventGator{
    address owner;
    struct Event{
        bool isActive;
        address NftAddress; // a specific nft for a specific event
        uint256 id;
        uint256 startTime;
        uint256 endTime;
        uint256 maxParticipants;
        uint256 price;
        string location;
        string name;
        string organizer;
        
    }

    mapping(uint => Event) public eventExists;

    modifier onlyOrganizer {
        require(msg.sender ==owner, "not owner");
        _;
    }

    modifier eventExist(uint256 _id){
        require((eventExists[_id]).id != 0, "event doesnot exist");
        _;
    }

    // modifier isRegistered(uint256 _id){
    //     require
    // }

  

    constructor(){
        owner = msg.sender;
    }

    // mapping(address => Event) public events;

    Event[] public events;

    function createEvent(string memory _name,uint256 _price, uint256 _startTime, uint256 _endTime, uint256 _maxParticipants, string memory _location, address _nftAddress ) external onlyOrganizer {
        // require(owner != 0, "zero address detected");
        require(_startTime < _endTime, "");

        Event memory newEvent = Event({
            name: _name,
            price: _price,
            startTime: _startTime,
            endTime: _endTime,
            maxParticipants: _maxParticipants,
            location: _location,
            NftAddress: _nftAddress,
            isActive: true
        });

        events.push(newEvent);
    }

    //users registering for the event
    function registerForEvent(uint256 eventId) external {
       
    }

    //when users attend the event, we need to verify their nft
    function verifyTicket() public view returns(bool){}

    function getEventDetails() public view returns(Event memory){}
    
    function cancelEvent() external {} 



}