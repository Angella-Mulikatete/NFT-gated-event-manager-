// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventNft is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {

    uint256 nextTicketId;
    uint maxTotalTickets; //total number of tickets that we want to sell
    uint maxTotalMintedTickets; //tracking the number of tickets that will be minted
    bool saleIsActive; //tracks if we are selling the tickest
    uint256 totalTickets;

    struct TicketType{
        string name;
        uint capacity;
        uint256 ticketPrice;
        bool isGeneralAdmission;
    }

    string private baseURI;

    mapping(address => uint256) private ownedTickets; 
    mapping (uint256 => TicketType) public ticketTypes;
    mapping(address => mapping(uint256 => uint256)) public userTickets;


    constructor(uint256 _maxTotalTickets) ERC721("eventNFT", "ENT") Ownable(msg.sender){
        maxTotalTickets = _maxTotalTickets;
        nextTicketId = 1;
    }
    
    // //setting the base URI for the token metadata
    // function setBaseURI(string memory _baseURI) public {
    //     baseURI = _baseURI;
    // }

    function _baseURI() internal view override returns (string memory ){
        return baseURI;
    }

    //toggle the sale state

    function toggleSaleState() public onlyOwner{
        saleIsActive = !saleIsActive;
    }

    // function createTicket(string memory _name, uint256 _capacity, uint256 _ticketPrice) public onlyOwner {
    //     ticketTypes[maxTotalTickets] = TicketType({
    //         name : _name,
    //         capacity : _capacity,
    //         ticketPrice: _ticketPrice,
    //         isGeneralAdmission: true
    //     });

    //     totalTickets++;
    // }


    function mintTicket(uint256 ticketTypeId) public payable {
        // require(saleIsActive, "sale is not active");
        require(ticketTypes[ticketTypeId].capacity > 0, "invalid ticket");
        require(totalTickets < maxTotalTickets, "tickets already sold out");

        //mint the NFT(ticket)
        _safeMint(msg.sender,totalTickets);

        //track tickets owned by this address
        userTickets[msg.sender][ticketTypeId]++;
        ticketTypes[ticketTypeId].capacity--;

    }

    // function checkTicketOwnership(address account, uint256 ticketTypeId) public view returns (bool) {
    //     return userTickets[account][ticketTypeId] > 0;
    // }

    function burnTicket(uint256 ticketTypeId) public {
        require(userTickets[msg.sender][ticketTypeId] > 0, "User does not own this ticket type");
        userTickets[msg.sender][ticketTypeId]--;
        // if (userTickets[msg.sender][ticketTypeId] == 0) {
        //     delete userTickets[msg.sender];
        // }
    }

    // function getOwnedTickets(address owner) public view returns(uint256[] memory){
    //     return ownedTickets[owner];
    // }

    //withdraw funds by the owner
    function withdrawFunds() public onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable{}


    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}