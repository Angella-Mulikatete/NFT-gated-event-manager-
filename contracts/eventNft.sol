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
    uint256 ticketPrice;
    bool saleIsActive; //tracks if we are selling the tickest

    string private baseURI;

    mapping(address => uint256[]) private ownedTickets; 


    constructor(uint256 _maxTotalTickets, uint256 _ticketPrice) ERC721("eventNFT", "ENT") Ownable(msg.sender){
        maxTotalTickets = _maxTotalTickets;
        ticketPrice = _ticketPrice;
        nextTicketId = 1;
    }
    
    //setting the base URI for the token metadata
    function setBaseURI(string memory _baseURI) public {
        baseURI = _baseURI;
    }

    function _baseURI() internal view override returns (string memory ){
        return baseURI;
    }

    //toggle the sale state

    function toggleSaleState() public onlyOwner{
        saleIsActive = !saleIsActive;
    }

    function mintTicket() public payable {
        require(saleIsActive, "sale is not active");
        require(nextTicketId <= maxTotalTickets, "tickets already sold out");
        require(msg.value == ticketPrice, "Incorrect ticket price");

        //mint the NFT(ticket)
        _safeMint(msg.sender,nextTicketId);

        //track tickets owned by this address
        ownedTickets[msg.sender].push(nextTicketId);

    }

    function getOwnedTickets(address owner) public view returns(uint256[] memory){
        return ownedTickets[owner];
    }

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