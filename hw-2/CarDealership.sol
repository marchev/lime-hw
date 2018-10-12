pragma solidity ^0.4.25;

contract CarDealership {
    
    address public dealershipOwner;
    
    struct Car {
        string make;
        string model;
    }

    mapping(uint256 => Car) cars;
    
    constructor(address _dealershipOwner) {
        dealershipOwner = _dealershipOwner;
    }
    
    function addCar(string make, string model) {
        Car memory newCar = Car(make, model);
        uint256 newCarKey = uint256(
            keccak256(
                abi.encodePacked(make, model)
            )
        );
        cars[newCarKey] = newCar;
        
    }
    
    //     modifier onlyPositive (uint256 _newPrice) {
    //     require(_newPrice > 0, "The given price must be greater than zero.");
    //     _;
    // }
    
    // function buy(string _slogan) public payable {
    //     require(msg.value >= price, "The given value is too low");
        
    //     slogan = _slogan;
    //     billboardOwner = msg.sender;
    //     historyOwners.push(msg.sender);
    //     moneySpent[msg.sender] += msg.value;
        
    //     emit LogBillboardBought(_slogan, msg.sender);
    // }
    
    // function setNewPrice(uint256 _newPrice) public onlyPositive(_newPrice) onlyOwner() {
    //     price = _newPrice;
    // }
    
    // function withdrawFunds() public returns(bool) {
    //     owner.transfer(address(this).balance);
    
    //     emit LogWithdrawal(address(this).balance);
    // }
}
