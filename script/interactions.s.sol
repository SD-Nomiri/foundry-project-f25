//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();

        console.log("Funded FundMe contract with %s", SEND_VALUE);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();

        // Check the balance of the contract
        uint256 contractBalance = address(mostRecentlyDeployed).balance;
        console.log("Contract balance before withdrawal: %s", contractBalance);

        // Check the balance of the sender
        uint256 senderBalance = msg.sender.balance;
        console.log("Sender balance before withdrawal: %s", senderBalance);

        // Perform the withdrawal
        FundMe(payable(mostRecentlyDeployed)).withdraw();

        // Check the balance of the contract after withdrawal
        contractBalance = address(mostRecentlyDeployed).balance;
        console.log("Contract balance after withdrawal: %s", contractBalance);

        // Check the balance of the sender after withdrawal
        senderBalance = msg.sender.balance;
        console.log("Sender balance after withdrawal: %s", senderBalance);

        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
