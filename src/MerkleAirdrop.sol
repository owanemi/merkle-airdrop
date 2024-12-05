// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20, SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @title airdrop contract using merkle proofs
 * @author owanemi
 * @notice This contract enables token distribution (airdrop) to multiple users using a Merkle tree for efficient verification.
 */
contract MerkleAirdrop {
    using SafeERC20 for IERC20;
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__UserAlredyClaimed();

    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_tokenToAirdrop;

    mapping(address claimer => bool claimed) private s_alreadyClaimed;

    address[] public s_claimers;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Claim(address indexed addressAirdropped, uint256 indexed amountAirdropped);

    /*//////////////////////////////////////////////////////////////
                     EXTERNAL AND PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(bytes32 merkleRoot, IERC20 tokenToAirdrop) {
        i_merkleRoot = merkleRoot;
        i_tokenToAirdrop = tokenToAirdrop;
    }

    function claim(address user, uint256 amount, bytes32[] calldata merkleProof) external {
        // checks
        if (s_alreadyClaimed[user]) {
            revert MerkleAirdrop__UserAlredyClaimed();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(user, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        // effects
        s_alreadyClaimed[user] = true;
        // interactions
        emit Claim(user, amount);
        i_tokenToAirdrop.safeTransfer(user, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_tokenToAirdrop;
    }
}
