// SPDX License : MIT
pragma solidity 0.8.19;

contract Lottery {
    
    address public manager;
    address payable[] public participants;
    
    constructor(){
        manager=msg.sender;  // msg.sender defines the address who deployed the contract, in this case that address is assigned into manager variable

    }

    receive() external payable{    // this receive function is built in, after deployment it don't appear with a dedicated button, " Transact" button is used to transact Ether to the contract from participant account

        require(msg.value== 1 ether," You are allowed to send only 1 Ether");
        participants.push(payable(msg.sender));  // whoever transact Ether to this contact , his address will store in array as a participant.
    }

    function checkBalance() public view returns(uint){
        require(msg.sender==manager);  // only manager can check the balance
        return address(this).balance;
    }

    function random() public view returns(uint){     // this is a Lottery , so we need to pick a random participant address
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp, participants.length))); // Random number generation

    }

    function selectWinner() public  returns(address){
        require(msg.sender==manager, " Only manager is allowed to access this function");
        require(participants.length>=3, " Minimum 3 participants have to present");

        uint r=random();   // we made this random function before
        //address payable winner;
        uint index = r % participants.length;   // dividing the big random number with the participants array length, it will generate an array index
        address payable winner= payable( participants[index]);  // This declaration is mandatory to run transfer() in newer virsion
        winner.transfer(checkBalance());
        return winner;
       
    }

}

