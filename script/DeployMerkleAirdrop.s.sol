// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20, SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract DeployMerkleAirdrop is Script {
    using SafeERC20 for IERC20;

    address public constant TOKEN = 0xBF68a24e5Be60B0c07247f054bb1564E7DC554F8;
    bytes32 public constant s_merkleRootHash = 0x0f6c57ab57c9e81c1bc0c199923fb0eb300c775e342f11eb2764de29b995e509;

    function deployMerkleAirdrop() public returns (MerkleAirdrop) {
        vm.startBroadcast();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRootHash, IERC20(TOKEN));
        vm.stopBroadcast();
        return airdrop;
    }

    function run() external returns (MerkleAirdrop) {
        return deployMerkleAirdrop();
    }
}
