// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalWill {
    address public owner;
    address public beneficiary;
    uint256 public unlockTime;

    mapping(address => uint256) public balances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyAfterUnlock() {
        require(block.timestamp >= unlockTime, "Will is locked");
        _;
    }

    constructor() {
        owner = msg.sender;
        unlockTime = block.timestamp + 365 days; // 1 year lock period
    }

    function setBeneficiary(address _beneficiary) public onlyOwner {
        beneficiary = _beneficiary;
    }

    function deposit() public payable onlyOwner {
        balances[owner] += msg.value;
    }

    function claim() public onlyAfterUnlock {
        require(msg.sender == beneficiary, "Not the beneficiary");
        uint256 amount = balances[owner];
        balances[owner] = 0;
        payable(beneficiary).transfer(amount);
    }
}
