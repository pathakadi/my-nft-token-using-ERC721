// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract BasicNFTTest is Test{
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;
    address public USER = makeAddr("user");
    string public constant PUG_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    function setUp() public{
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }
    function testNameIsCorrect() public view{
        string memory expectedName = "Doggie";
        string memory actualName = basicNFT.name();
        // assert(keccak256(bytes(expectedName)) == keccak256(bytes(actualName)));
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }
    function testSymbolIsCorrect() public view{
        string memory expectedSymbol = "DAWG";
        string memory actualSymbol = basicNFT.symbol();
        // assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
        assert(keccak256(bytes(expectedSymbol)) == keccak256(bytes(actualSymbol)));
    }
    function testCanMintAndHaveABalance() public{
        vm.prank(USER);
        basicNFT.mintNFT(PUG_URI);
        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(PUG_URI)) == keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
    }
}

// forge test --match-contract BasicNFTTest --match-test 