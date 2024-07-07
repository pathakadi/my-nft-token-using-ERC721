// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721{
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood{ HAPPY , SAD}

    mapping (uint256 => Mood) private s_tokenIdToMood;
    
    constructor(string memory sadSvgImageUri , string memory happySvgImageUri) ERC721("Mood NFT","MN"){
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }
    function mintNFT() public{
        _safeMint(msg.sender,s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }
    function flipMood(uint256 tokenId) public{
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) revert MoodNft__CantFlipMoodIfNotOwner();
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY) s_tokenIdToMood[tokenId] = Mood.SAD;
        else s_tokenIdToMood[tokenId] = Mood.HAPPY;
    }
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }
    function tokenURI(uint256 tokenId) public view override returns(string memory){
        string memory imageURI = s_happySvgImageUri;
        if(s_tokenIdToMood[tokenId] == Mood.SAD) imageURI = s_sadSvgImageUri;
        // string.concat() == abi.encodePacked()  Works Same!
        return string(string.concat(_baseURI() , Base64.encode(abi.encodePacked('{"name":"',name(),
            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", '
            ,'"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',imageURI,'"}'))));
    }
    // Getter Function
    function getMoodByTokenID(uint256 tokenId) public view returns(Mood){
        return s_tokenIdToMood[tokenId];
    }
}