pragma solidity ^0.4.9;

import "./DougEnabled.sol";
import "./ContractProvider.sol";


contract FundManagerEnabled is DougEnabled {

    function isFundManager() public constant returns (bool) {
        if (doug != 0x0) {
            address fm = ContractProvider(doug).contracts("fundsManager");
            return msg.sender == fm;
        }
        return false;
    }
}