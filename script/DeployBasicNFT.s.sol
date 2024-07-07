// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract DeployBasicNFT is Script{
    BasicNFT basicNFT;
    function run() external returns(BasicNFT){
        vm.startBroadcast();
        basicNFT = new BasicNFT();
        vm.stopBroadcast();
        return basicNFT;
    }
}