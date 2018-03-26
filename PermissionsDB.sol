pragma solidity ^0.4.9;

import "./DougEnabled.sol";
import "./ContractProvider.sol";


contract PermissionsDB is DougEnabled {

    mapping (address => uint8) public perms;

    function setPermission(address addr, uint8 perm) public returns (bool) {
        if (doug != 0x0) {
            address permC = ContractProvider(doug).contracts("perms");
            if (msg.sender == permC) {
                perms[addr] = perm;
                return true;
            }
            return false;
        } else {
            return false;
        }
    }
}