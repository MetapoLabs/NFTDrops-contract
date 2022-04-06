//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract AzukiNFT is ERC721("AzukiNFT", "AZUKI") {

    constructor() {
        
    }

    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId, "");
    }

}
