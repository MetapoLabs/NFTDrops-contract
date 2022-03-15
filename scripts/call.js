const hre = require('hardhat')
const fs = require('fs')
const { BigNumber } = require('ethers')

// TestNFT721 deployed: 0x2F7e423eE727aBe5988A92c83722461CbB214DA2

async function deploy() {
    const accounts = await hre.ethers.getSigners()

    const TestNFT721 = await ethers.getContractFactory('TestNFT721')
    const nft721 = await TestNFT721.deploy()
    await nft721.deployed()
    console.log('TestNFT721 deployed:', nft721.address)
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


deploy()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });