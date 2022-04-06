const { expect, assert } = require('chai')
const { BigNumber, utils } = require('ethers')
const fs = require('fs')
const hre = require('hardhat')
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')


describe('Drops-EventNFT', function () {
	let accounts
	let azukiNFT
	let eventNFT
	let drops

	before(async function () {
		accounts = await ethers.getSigners()
		console.log('account0', accounts[0].address)
		console.log('account1', accounts[1].address)
		console.log('account2', accounts[2].address)
	})

	it('deploy', async function () {
		const Drops = await ethers.getContractFactory('Drops')
		drops = await Drops.deploy()
		await drops.deployed()
		console.log('Drops deployed:', drops.address)

		const EventNFT = await ethers.getContractFactory('EventNFT')
		eventNFT = await EventNFT.deploy(drops.address)
		await eventNFT.deployed()
		console.log('EventNFT deployed:', eventNFT.address)

		const AzukiNFT = await ethers.getContractFactory('AzukiNFT')
		azukiNFT = await AzukiNFT.deploy()
		await azukiNFT.deployed()
		console.log('AzukiNFT deployed:', azukiNFT.address)

		await azukiNFT.mint(accounts[0].address, 1)
		console.log('ownerOf azukiNFT#1', await azukiNFT.ownerOf(1))

		await azukiNFT.mint(accounts[1].address, 2)
		console.log('ownerOf azukiNFT#2', await azukiNFT.ownerOf(2))
	})

	it('rechargeNFT', async function () {
		await eventNFT.saftMint('this is EventNFT#1', azukiNFT.address, 1)
		console.log('EventNFT#1 tokenURI:', await eventNFT.tokenURI(1))
		console.log('ownerOf eventNFT#1', await eventNFT.ownerOf(1), await drops.getNFTOwner(eventNFT.address, 1))
	})

	it('internalTransferNFT', async function () {
		await drops.internalTransferNFT(azukiNFT.address, 2, eventNFT.address, 1)
		console.log('ownerOf eventNFT#1', await drops.getNFTOwner(eventNFT.address, 1))
	})
	
	it('withdrawNFT', async function () {
		await drops.connect(accounts[1]).withdrawNFT(accounts[2].address, eventNFT.address, 1)
		console.log('ownerOf eventNFT#1', await eventNFT.ownerOf(1))
	})

	it('batch', async function () {
		await eventNFT.batchMint([
			'this is EventNFT#2',
			'this is EventNFT#3',
			'this is EventNFT#4',
		], azukiNFT.address, [1,2,3])
		console.log('ownerOf eventNFT#2', await drops.getNFTOwner(eventNFT.address, 2))
		console.log('ownerOf eventNFT#3', await drops.getNFTOwner(eventNFT.address, 3))
		console.log('ownerOf eventNFT#4', await drops.getNFTOwner(eventNFT.address, 4))
	})


	function getAbi(jsonPath) {
		let file = fs.readFileSync(jsonPath)
		let abi = JSON.parse(file.toString()).abi
		return abi
	}

	function m(num) {
		return BigNumber.from('1000000000000000000').mul(num)
	}

	function d(bn) {
		return bn.div('1000000000000000').toNumber() / 1000
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
})