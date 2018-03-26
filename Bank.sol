pragma solidity ^0.4.9;

import "./PermissionsDB.sol";
import "./ContractProvider.sol";
import "./FundManagerEnabled.sol";
import "./BankDB.sol";


contract Bank is FundManagerEnabled {

    function deposit(address userAddr) public payable returns (bool) {
        if (!isFundManager()) {
            return false;
        } 
        address bankDB = ContractProvider(doug).contracts("bankdb");
        if (bankDB != 0x0) {
            msg.sender.transfer(msg.value);
            return false;
        }

        bool success = BankDB(bankDB).deposit.value(msg.value)(userAddr);
        if (!success) {
            msg.sender.transfer(msg.value);
        }
        return success;
    }

    function withdraw(address userAddr, uint amount) public returns (bool res) {
        if (!isFundManager()) {
            return false;
        }
        address bankdb = ContractProvider(doug).contracts("bankdB");
        if (bankdb == 0x0) {
            return false;
        }

        bool success = BankDB(bankdb).withdraw(userAddr, amount);
        if (success) {
            userAddr.transfer(amount);
        }
        return success;
    }
}