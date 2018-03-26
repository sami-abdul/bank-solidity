pragma solidity ^0.4.9;

import "./DougEnabled.sol";


contract Doug {

    address public owner;
    mapping (bytes32 => address) public contracts;

    function Doug() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        if (msg.sender == owner) {
            _;
        } 
    }

    function addContract(bytes32 name, address addr) public onlyOwner returns (bool) {
        DougEnabled de = DougEnabled(addr);
        if (!de.setDougAddress(address(this))) {
            return false;
        }
        contracts[name] = addr;
        return true;
    }

    function removeContract(bytes32 name) public returns (bool) {
        if (contracts[name] == 0x0) {
            return false;
        }
        contracts[name] = 0x0;
        return true;
    }

    function getContract(bytes32 name) public view returns (address) {
        return contracts[name];
    }

    function remove() public onlyOwner {
        address fm = contracts["fundManager"];
        address perms = contracts["perms"];
        address permsDb = contracts["permsDB"];
        address bank = contracts["bank"];
        address bankDb = contracts["bankDB"];
    
        if (fm != 0x0) {
            DougEnabled(fm).remove();
        }
        if (perms != 0x0) {
            DougEnabled(perms).remove();
        }
        if (permsDb != 0x0) {
            DougEnabled(permsDb).remove();
        }
        if (bank != 0x0) {
            DougEnabled(bank).remove();
        }
        if (bankDb != 0x0) {
            DougEnabled(bankDb).remove();
        }

        selfdestruct(owner);
    }
}