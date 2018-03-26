pragma solidity ^0.4.9;

import "./DougEnabled.sol";
import "./ContractProvider.sol";


contract BankDB is DougEnabled {

    mapping (address => uint) public balances;

    function deposit(address addr) public payable returns (bool) {
        if (doug != 0x0) {
            address bank = ContractProvider(doug).contracts("bank");
            if (msg.sender == bank) {
                balances[addr] += msg.value;
                return true;
            }
            msg.sender.transfer(msg.value);
            return false;
        }
    }

    function withdraw(address addr, uint amount) public returns (bool) {
        if (doug != 0x0) {
            address bank = ContractProvider(doug).contracts("bank");
            if (msg.sender == bank) {
                uint oldBalance = balances[addr];
                if (oldBalance >= amount) {
                    msg.sender.transfer(amount);
                    balances[addr] = oldBalance - amount;
                    return true;
                }
            }
        }
        return false;
    }
}