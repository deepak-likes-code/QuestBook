//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract SmartBank{

using SafeMath for uint;

uint public totalContractBalance;
mapping(address=>uint) accountBalance;
mapping(address =>uint) depositTimeStamps; 

// Functions

// Add money to account
function addMoneyToAccount()public payable returns(bool){
    accountBalance[msg.sender]= SafeMath.add(accountBalance[msg.sender],msg.value); 
    depositTimeStamps[msg.sender]=block.timestamp;
    totalContractBalance= SafeMath.add(totalContractBalance,msg.value);
    return true;
}


// Withdraw Money 
function withDrawMoney(uint amount)public payable returns (bool){
    uint amountInEther= amount * 1 ether;
    uint currentAccountBalance= checkAccountBalance(msg.sender);
    require(currentAccountBalance>amountInEther,"You're balance is less than the amount you want to withdraw");
    accountBalance[msg.sender]= SafeMath.sub(accountBalance[msg.sender],amountInEther);
    totalContractBalance= SafeMath.sub(totalContractBalance,amountInEther);
    payable(msg.sender).transfer(amountInEther);
    return true;

}


// Check account balance
function checkAccountBalance(address userAddress)public view returns(uint){
uint256 principal = accountBalance[userAddress];
uint256 timeElapsed = SafeMath.sub(block.timestamp,depositTimeStamps[userAddress]);
uint256 interest= SafeMath.div( (principal*7*timeElapsed),(100*365*24*60*60));
 return SafeMath.add( principal,interest);
}


// Deposit money to the bank
function addMoneyToBank() public payable returns (bool){
    totalContractBalance= SafeMath.add(totalContractBalance,msg.value);
    return true;
}


}