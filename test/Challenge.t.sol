// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { Challenge } from "../src/Challenge.sol";
import { Exploit } from "../src/Exploit.sol";

contract ChallengeTest is Test {
    using stdStorage for StdStorage;

    address constant CHALLENGE_DEPLOYER = address(0xdefa);
    address constant ATTACKER = address(0xdead);
    Exploit exploit;
    Challenge challenge;

    function setUp() public {
        bytes memory code = vm.getCode("Challenge.sol:Challenge");
        address targetAddr = address(0xcD7AB80Da7C893f86fA8deDDf862b74D94f4478E);
        address deployedChallenge;

        assembly {
            deployedChallenge := create(0, add(code, 0x20), mload(code))
        }

        vm.etch(targetAddr, deployedChallenge.code);

        challenge = Challenge(targetAddr);
        exploit = new Exploit();
    }

    function test_pwnd() public {
        vm.prank(ATTACKER);
        exploit.callExploitMe();

        assertEq(challenge.winners(0), ATTACKER);
        console.logAddress(challenge.winners(0));
    }
}
