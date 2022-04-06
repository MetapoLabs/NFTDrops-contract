//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../Drops.sol";
import "hardhat/console.sol";

contract StandarNFT is ERC721("StandarNFT", "NFT721") {

    constructor() {
    }

    function mint(address to, uint tokenId) public {
        _mint(to, tokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "tokenURI:StandarNFT#";
    }

}
