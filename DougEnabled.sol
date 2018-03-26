pragma solidity ^0.4.9;


contract DougEnabled {

    address public doug;

    function setDougAddress(address dougAddr) public onlyDoug returns (bool) {
        if (doug != 0x0) {
            return false;
        }
        doug = dougAddr;
        return true;
    }

    function remove() public onlyDoug {
        selfdestruct(doug);
    }

    modifier onlyDoug {
        require(msg.sender == doug);
        _;
    }
}