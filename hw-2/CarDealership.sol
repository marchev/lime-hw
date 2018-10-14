pragma solidity ^0.4.25;

import './Ownable.sol';

contract CarDealership is Ownable {

    struct Car {
        string make;
        string model;
        uint price;
        address owner;
    }

    mapping(uint256 => Car) public cars;
    
    event CarOwnershipUpdate(string make, string model, address oldOwner, address newOwner);
    event CarPriceUpdate(string make, string model, uint oldPrice, uint newPrice);
    event PaymentTransfer(address addr, uint amount);
    event CommissionWithdrawal(address addr, uint amount);
    
    constructor() public {
        addCar("VW", "Passat", 1 ether, owner);
        addCar("BMW", "330i", 4 ether, owner);
        addCar("Mercedes", "S650", 8 ether, owner);
    }
    
    function buyCar(string make, string model) public payable onlyPositive(msg.value) {
        uint key = hash(make, model);
        Car storage car = cars[key];
        
        require(msg.value >= calcMinNewPrice(car.price), "New price must be at least 2 times current price.");
        require(msg.sender != car.owner, "New owner cannot be the same as current owner.");
        
        address oldOwner = car.owner;
        
        updateCarOwner(car, msg.sender);
        updateCarPrice(car, msg.value);
        transferProfit(oldOwner, car.price);
    }
    
    function updateCarOwner(Car storage car, address newOwner) private {
        address oldOwner = car.owner;
        car.owner = newOwner;
        emit CarOwnershipUpdate(car.make, car.model, oldOwner, newOwner);
    }
    
    function updateCarPrice(Car storage car, uint newPrice) private {
        uint oldPrice = car.price;
        car.price = newPrice;
        emit CarPriceUpdate(car.make, car.model, oldPrice, newPrice);
    }
    
    function transferProfit(address oldOwner, uint price) private {
        uint profit = calcOwnerProfit(price);
        oldOwner.transfer(profit);
        emit PaymentTransfer(oldOwner, profit);
    }
    
    function getCarDetails(string make, string model) public view returns (address, uint) {
        uint key = hash(make, model);
        Car storage car = cars[key];
        return (car.owner, car.price);
    }
    
    function withdrawCommissions() public onlyOwner {
        uint commissionsAmount = address(this).balance;

        require(commissionsAmount > 0, "No commissions have been accumulated so far.");

        owner.transfer(commissionsAmount);
        emit CommissionWithdrawal(owner, commissionsAmount);
    }
    
    function calcMinNewPrice(uint oldPrice) private pure returns (uint) {
        return oldPrice * 2;
    }
    
    function calcOwnerProfit(uint newPrice) private pure returns (uint) {
        return newPrice * 75 / 100;
    }
    
    function addCar(string make, string model, uint price, address owner) private {
        Car memory newCar = Car(make, model, price, owner);
        uint key = hash(make, model);
        cars[key] = newCar;
    }
    
    function hash(string make, string model) private pure returns (uint) {
        return uint(keccak256(abi.encodePacked(make, model)));
    }
    
    modifier onlyPositive (uint price) {
        require(price > 0, "The given price must be greater than zero.");
        _;
    }
}
