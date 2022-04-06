//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "hardhat/console.sol";

contract Drops is IERC721Receiver, Ownable {

    event RechargeNFT(address fromUser, address toContract, uint toTokenId, address nftContract, uint nftTokenId);

    event InternalTransferNFT(address fromContract, uint fromTokenId, address toContract, uint toTokenId, address nftContract, uint nftTokenId);

    event WithdrawNFT(address fromContract, uint fromTokenId, address toUser, address nftContract, uint nftTokenId);


    struct NFTOwner {
        address ownerContract;
        uint ownerTokenId;
    }

    mapping (address => mapping (uint => NFTOwner)) public getNFTOwner;


    constructor() {
        
    }

    function rechargeNFT(address toContract, uint toTokenId, address nftContract, uint nftTokenId) public {
        // console.log("[Drops][rechargeNFT]", _msgSender(), IERC721(nftContract).getApproved(nftTokenId));
        IERC721(nftContract).transferFrom(_msgSender(), address(this), nftTokenId);
        getNFTOwner[nftContract][nftTokenId] = NFTOwner(toContract, toTokenId);

        emit RechargeNFT(_msgSender(), toContract, toTokenId, nftContract, nftTokenId);
    }

    function internalTransferNFT(address toContract, uint toTokenId, address nftContract, uint nftTokenId) public {
        NFTOwner storage nftOwner = getNFTOwner[nftContract][nftTokenId];
        require(IERC721(nftOwner.ownerContract).ownerOf(nftOwner.ownerTokenId) == _msgSender(), "Drops::internalTransferNFT: incorrect owner");
            
        emit InternalTransferNFT(nftOwner.ownerContract, nftOwner.ownerTokenId, toContract, toTokenId, nftContract, nftTokenId);

        nftOwner.ownerContract = toContract;
        nftOwner.ownerTokenId = toTokenId;
    }

    function withdrawNFT(address toUser, address nftContract, uint nftTokenId) public {
        NFTOwner storage nftOwner = getNFTOwner[nftContract][nftTokenId];
        require(IERC721(nftOwner.ownerContract).ownerOf(nftOwner.ownerTokenId) == _msgSender(), "Drops::withdrawNFT: incorrect owner");

        emit WithdrawNFT(nftOwner.ownerContract, nftOwner.ownerTokenId, toUser, nftContract, nftTokenId);

        delete getNFTOwner[nftContract][nftTokenId];
        IERC721(nftContract).transferFrom(address(this), toUser, nftTokenId);
    }

    function onERC721Received(address, address from, uint nftTokenId, bytes calldata data) external override returns (bytes4) {
        address nftContract = _msgSender();
        address toContract = abi.decode(data, (address));
        uint toTokenId = abi.decode(data[32:], (uint));

        getNFTOwner[nftContract][nftTokenId] = NFTOwner(toContract, toTokenId);

        emit RechargeNFT(from, toContract, toTokenId, nftContract, nftTokenId);
        return this.onERC721Received.selector;
    }

}
