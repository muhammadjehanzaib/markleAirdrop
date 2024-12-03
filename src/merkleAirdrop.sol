//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract merkleAirdrop {
    using SafeERC20 for IERC20;
    error merkleProof__InvalidProof();
    error merkleProof__AlreadyClaimed();

    bytes32 public immutable i_merkleRoot;
    IERC20 public immutable i_airdropToken;
    mapping(address user => bool claim) public s_hasClaimed;


    event AmountClaimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    } 

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        if(!s_hasClaimed[account]){
            revert merkleProof__AlreadyClaimed();
        }

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        if(!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert merkleProof__InvalidProof();
        }
        s_hasClaimed[account] = true;
        i_airdropToken.safeTransfer(account, amount);
        emit AmountClaimed(account, amount);
    }
}