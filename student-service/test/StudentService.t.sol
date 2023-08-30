// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {StudentService} from "../src/StudentService.sol";

contract StudentServiceTest is Test {
    StudentService public studentService;

    function setUp() public {
        address[] memory professors = new address[](2);
        address[] memory students = new address[](2);
        string[] memory exams = new string[](1);

        professors[0] = 0x58dD43990a27e09E6CD800C978727508Ef170557;
        professors[1] = 0xf16b5D1B3Eb6cb36571f917B976cE0E32B7d1EcD;

        studentService = new StudentService(professors, students, exams);
    }

    function test_GetUser() public {
        assertTrue(
            studentService.getUser(0x58dD43990a27e09E6CD800C978727508Ef170557)
        );
    }
}
