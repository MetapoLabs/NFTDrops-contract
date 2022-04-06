//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./Drops.sol";
import "hardhat/console.sol";

contract Batch1 {

    address public dropsAddress;

    constructor(address _dropsAddress) {
        dropsAddress = _dropsAddress;
    }

    function run(address toContract, uint[] memory toIds, address nftContract, uint[] memory nftIds) public {
        IERC721(nftContract).setApprovalForAll(dropsAddress, true);
        for (uint i=0; i<toIds.length; i++) {
            uint toId = toIds[i];
            uint nftId = nftIds[i];
            console.log("Batch1::run:", toIds.length, toId, nftId);
            IERC721(nftContract).transferFrom(msg.sender, address(this), nftId);
            Drops(dropsAddress).rechargeNFT(toContract, toId, nftContract, nftId);
        }
    }

}