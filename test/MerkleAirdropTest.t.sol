// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20, SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract MerkleAirdropTest is Test {
    using SafeERC20 for IERC20;

    MerkleAirdrop airdrop;
    IERC20 public constant TOKEN = IERC20(0xBF68a24e5Be60B0c07247f054bb1564E7DC554F8);

    bytes32 public constant ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    address user;
    address constant NEMI_TOKEN_OWNER = 0x48CeF35f4aB78D3f24d73E2B158762aCc671302E;
    uint256 userPrivKey;
    uint256 AMOUNT = 25 * 1e18;
    uint256 AMOUNT_TO_SEND = (25 * 1e18) * 4;

    bytes32 proof1 = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proof2 = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;

    bytes32[] proof = [proof1, proof2];

    function setUp() public {
        airdrop = new MerkleAirdrop(ROOT, TOKEN);
        (user, userPrivKey) = makeAddrAndKey("user");
        // TOKEN.transfer(address(airdrop), AMOUNT_TO_SEND);
    }

    function testUsersCanClaim() public {
        uint256 startingBalance = TOKEN.balanceOf(user);
        console.log("start balance:", startingBalance);

        vm.startPrank(NEMI_TOKEN_OWNER);
        // bool allowanceAmount = TOKEN.approve(address(airdrop), AMOUNT);
        TOKEN.transfer(address(airdrop), AMOUNT);
        // console.log("allow", allowanceAmount);
        airdrop.claim(user, AMOUNT, proof);

        uint256 endingBalance = TOKEN.balanceOf(user);
        console.log("end balance:", endingBalance);

        assertEq(endingBalance - startingBalance, AMOUNT);
    }
}
