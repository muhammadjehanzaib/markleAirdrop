//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {BananaToken} from "src/BananaToken.sol";
import {DeployMerkleAirdrop} from "../../script/DeployMerkleAirdrop.s.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";

contract MerkleAirdropToken is ZkSyncChainChecker, Test {
    MerkleAirdrop public _airdrop;
    BananaToken public _bananaToken;
    DeployMerkleAirdrop public _deployer;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    uint256 public amountToCollect = 25 * 1e18;
    uint256 public amountToSend = amountToCollect * 4;

    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [proofOne, proofTwo];
    address user;
    uint256 userPrivKey;

    function setUp() external {
        if (!isZkSyncChain()) {
            _deployer = new DeployMerkleAirdrop();
            (_bananaToken, _airdrop) = _deployer.run();
        } else {
            _bananaToken = new BananaToken();
            _airdrop = new MerkleAirdrop(ROOT, _bananaToken);
            _bananaToken.mint(_bananaToken.owner(), amountToSend);
            _bananaToken.transfer(address(_airdrop), amountToSend);
        }
        (user, userPrivKey) = makeAddrAndKey("user");
    }

    function testUserCanClaim() public {
        console.log("User address : ", user);
        uint256 startingBalance = _bananaToken.balanceOf(user);

        vm.prank(user);
        _airdrop.claim(user, amountToCollect, proof);

        uint256 endingBalance = _bananaToken.balanceOf(user);
        console.log("Ending Balance: ", endingBalance);

        assertEq(endingBalance - startingBalance, amountToCollect);
    }
}
