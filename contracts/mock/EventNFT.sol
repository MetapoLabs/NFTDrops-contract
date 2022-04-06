//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../Drops.sol";
import "hardhat/console.sol";

contract EventNFT is ERC721("EventNFT", "EVENT") {

    address public dropsAddress;

    uint public totalMinted = 0;

    mapping(uint => string) idToInfo;

    constructor(address _dropsAddress) {
        dropsAddress = _dropsAddress;
    }

    function saftMint(string memory info, address toContract, uint toTokenId) public returns (uint) {
        uint tokenId = ++totalMinted;
        idToInfo[tokenId] = info;
        bytes memory data = abi.encode(toContract, toTokenId);

        console.log("EventNFT::saftMint:", dropsAddress, tokenId);
        _safeMint(dropsAddress, tokenId, data);
        return totalMinted;
    }

    function batchMint(string[] memory infos, address toContract, uint[] memory toTokenIds) public returns (uint) {
        for (uint i=0; i<infos.length; i++) {
            string memory info = infos[i];
            uint toTokenId = toTokenIds[i];
            saftMint(info, toContract, toTokenId);
        }
        return totalMinted;
    }

    function tokenURI(uint tokenId) public view virtual override returns (string memory) {
        return idToInfo[tokenId];
    }

}
