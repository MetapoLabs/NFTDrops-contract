const hre = require('hardhat')
const fs = require('fs')
const { BigNumber } = require('ethers')

const TestNFT721Addr = '0x2F7e423eE727aBe5988A92c83722461CbB214DA2'

async function deploy() {
    const accounts = await hre.ethers.getSigners()

    const TestNFT721 = await ethers.getContractFactory('TestNFT721')
    const nft721 = await TestNFT721.deploy()
    await nft721.deployed()
    console.log('TestNFT721 deployed:', nft721.address)
}

async function view() {
    const accounts = await hre.ethers.getSigners()

    const TestNFT721 = await ethers.getContractFactory('TestNFT721')
    const nft721 = await TestNFT721.attach(TestNFT721Addr)

    console.log('baseURI', await nft721.baseURI())
    console.log('ownerOf', await nft721.ownerOf(20))
	console.log('tokenURI', await nft721.tokenURI(20))
}

async function mint() {
    const accounts = await hre.ethers.getSigners()

    const TestNFT721 = await ethers.getContractFactory('TestNFT721')
    const nft721 = await TestNFT721.attach(TestNFT721Addr)
    await nft721.setBaseURI('http://nftdrop.aibyb.com.cn/airdrops/metadatastructure?tokenId=')
    console.log('setBaseURI done')

    // await nft721.safeMint(accounts[0].address, 20)
    // console.log('safeMint done')
}


async function delay(sec) {
    return new Promise((resolve, reject) => {
        setTimeout(resolve, sec * 1000);
    })
}

function m(num, decimals) {
    return BigNumber.from(num).mul(BigNumber.from(10).pow(decimals))
}

function d(bn, decimals) {
    return bn.mul(BigNumber.from(100)).div(BigNumber.from(10).pow(decimals)).toNumber() / 100
}

function b(num) {
    return BigNumber.from(num)
}

function n(bn) {
    return bn.toNumber()
}

function s(bn) {
    return bn.toString()
}


view()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });