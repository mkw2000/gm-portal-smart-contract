// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract GmPortal {
    uint256 totalGms;

    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    event NewGm(address indexed from, uint256 timestamp, string message);

    struct Gm {
        address gmer;
        string message;
        uint256 timestamp;
    }

    Gm[] gms;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastGmedAt;


    constructor() payable {
        console.log("We have been constructed!");
        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function gm(string memory _message) public {

        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastGmedAt[msg.sender] + 24 hours < block.timestamp,
            "You can only say GM once per day"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastGmedAt[msg.sender] = block.timestamp;


        totalGms += 1;
        console.log("%s has said gm!", msg.sender);

        gms.push(Gm(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewGm(msg.sender, block.timestamp, _message);
    }

    function getAllGms() public view returns (Gm[] memory) {
        return gms;
    }

    function getTotalGms() public view returns (uint256) {
        return totalGms;
    }
}