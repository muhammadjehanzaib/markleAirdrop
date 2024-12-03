//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {BananaToken} from "../src/BananaToken.sol";
import {MerkleAirdrop, IERC20} from "../src/MerkleAirdrop.sol";
import {Script} from "forge-std/Script.sol";

contract DeployMerkleAirdrop is Script {
    BananaToken token;
    MerkleAirdrop airdrop;
    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 amountToTransfer = 4 * (25 * 1e18);

    function run() external returns (BananaToken, MerkleAirdrop) {
        // Deploy BananaToken
        vm.startBroadcast();
        token = new BananaToken();
        // Deploy MerkleAirdrop
        airdrop = new MerkleAirdrop(ROOT, IERC20(token));
        token.mint(token.owner(), amountToTransfer);
        token.transfer(address(airdrop), amountToTransfer);
        vm.stopBroadcast();
        return (token, airdrop);
    }
}
