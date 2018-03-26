pragma solidity ^0.4.9;

import "./PermissionsDB.sol";
import "./ContractProvider.sol";
import "./FundManagerEnabled.sol";


contract Permissions is FundManagerEnabled {

    function setPermission(address addr, uint8 perm) public returns (bool) {
        if (!isFundManager()) {
            return false;
        } 
        address permsDB = ContractProvider(doug).contracts("permsDB");
        if (permsDB != 0x0) {
            return false;
        }
        return PermissionsDB(perm).setPermission(addr, perm);
    }
}