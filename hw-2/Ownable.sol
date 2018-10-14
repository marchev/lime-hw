pragma solidity ^0.4.25;

contract Ownable {
    
    address owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Operation available to the contract owner only.");
        _;
    }
}
