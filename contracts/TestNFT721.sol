//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "hardhat/console.sol";

contract TestNFT721 is ERC721("TestNFT721", "NFT721"), Ownable {

    string public baseURI;

    uint256 public dropslength = 0;

    event CreateDrop(uint256 id, string info, bytes32 merkleRoot);

    struct Drop {
        uint256 id;
        string info;
        bytes32 merkleRoot;
        uint256 claimCount;
        bool isOver;
    }

    mapping (uint256 => Drop) public idToDrop;


    constructor() {
        
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    //onlyOwner
    function setBaseURI(string memory newValue) public {
        console.log("Changing baseURI from '%s' to '%s'", baseURI, newValue);
        baseURI = newValue;
    }

    //onlyOwner
    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId, "");
    }

    //onlyOwner
    function createDrop(string memory info, bytes32 merkleRoot) public {
        uint256 id = ++dropslength;
        idToDrop[id] = Drop(id, info, merkleRoot, 0, false);

        emit CreateDrop(id, info, merkleRoot);
    }

    function claim(uint256 dropId, uint256 tokenId, bytes32[] memory proof) public {
        Drop memory drop = idToDrop[dropId];
        require(drop.id > 0, 'Drop not exist');
        require(!drop.isOver, 'Drop is over');

        bytes32 leaf = keccak256(abi.encodePacked(_msgSender(), tokenId));
        bool isValidLeaf = MerkleProof.verify(proof, drop.merkleRoot, leaf);
        require(isValidLeaf, 'merkle verify fail');

        //mint
        _safeMint(_msgSender(), tokenId);

        idToDrop[dropId].claimCount++;
    }

    //onlyOwner
    function cancelDrop(uint256 dropId) public {
        Drop memory drop = idToDrop[dropId];
        require(drop.id > 0, 'Drop not exist');

        idToDrop[dropId].isOver = true;
    }

}
