pragma solidity ^0.4.9;

import "./PermissionsDB.sol";
import "./Permissions.sol";
import "./ContractProvider.sol";
import "./DougEnabled.sol";
import "./Bank.sol";


contract FundManager is DougEnabled {

    address public owner;

    function FundManager() public {
        owner = msg.sender;
    }

    // Attempt to withdraw the given 'amount' of Ether from the account.
    function deposit() public payable returns (bool res) {
        if (msg.value == 0) {
            return false;
        }
        address bank = ContractProvider(doug).contracts("bank");
        address permsdb = ContractProvider(doug).contracts("permsdb");
        if (bank == 0x0 || permsdb == 0x0 || PermissionsDB(permsdb).perms(msg.sender) < 1) {
            // If the user sent money, we should return it if we can't deposit.
            msg.sender.transfer(msg.value);
            return false;
        }

        // Use the interface to call on the bank contract. We pass msg.value along as well.
        bool success = Bank(bank).deposit.value(msg.value)(msg.sender);

        // If the transaction failed, return the Ether to the caller.
        if (!success) {
            msg.sender.transfer(msg.value);
        }
        return success;
    }

    // Attempt to withdraw the given 'amount' of Ether from the account.
    function withdraw(uint amount) public returns (bool res) {
        if (amount == 0) {
            return false;
        }
        address bank = ContractProvider(doug).contracts("bank");
        address permsdb = ContractProvider(doug).contracts("permsdb");
        if (bank == 0x0 || permsdb == 0x0 || PermissionsDB(permsdb).perms(msg.sender) < 1) {
            // If the user sent money, we should return it if we can't deposit.
            msg.sender.transfer(msg.value);
            return false;
        }

        // Use the interface to call on the bank contract.
        bool success = Bank(bank).withdraw(msg.sender, amount);

        // If the transaction succeeded, pass the Ether on to the caller.
        if (success) {
            msg.sender.transfer(amount);
        }
        return success;
    }

    // Set the permissions for a given address.
    function setPermission(address addr, uint8 permLvl) public returns (bool res) {
        if (msg.sender != owner) {
            return false;
        }
        address perms = ContractProvider(doug).contracts("perms");
        if (perms == 0x0) {
            return false;
        }
        return Permissions(perms).setPermission(addr, permLvl);
    }
}