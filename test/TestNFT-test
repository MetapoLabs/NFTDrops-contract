const { expect, assert } = require('chai')
const { BigNumber, utils } = require('ethers')
const fs = require('fs')
const hre = require('hardhat')
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')


describe('TestNFT-test', function () {
	let accounts
	let airdrops
	let nft721
	let leaves
	let tree

	before(async function () {
		accounts = await ethers.getSigners()

		airdrops = [
			{address:accounts[1].address, tokenId:1},
			{address:accounts[2].address, tokenId:2},
			{address:accounts[3].address, tokenId:3},
			{address:accounts[4].address, tokenId:4},
			{address:accounts[5].address, tokenId:5},
			{address:accounts[6].address, tokenId:6},
			{address:accounts[7].address, tokenId:7},
			{address:accounts[8].address, tokenId:8},
			{address:accounts[9].address, tokenId:9},
		]
	})

	it('deploy', async function () {
		const TestNFT721 = await ethers.getContractFactory('TestNFT721')
		nft721 = await TestNFT721.deploy()
		await nft721.deployed()
		console.log('TestNFT721 deployed to:', nft721.address)
	})

	it('safeMint', async function () {
		await nft721.setBaseURI('http://xxxx.com/')
		console.log('setBaseURI done')

		await nft721.safeMint(accounts[0].address, 0)
		console.log('safeMint done')

		console.log('balanceOf', n(await nft721.balanceOf(accounts[0].address)))
		console.log('ownerOf', await nft721.ownerOf(0))
		console.log('tokenURI', await nft721.tokenURI(0))

		//tokenURI returns JSON, https://docs.opensea.io/docs/metadata-standards
	})

	it('createDrop', async function () {
		leaves = []
        for ({address, tokenId} of airdrops) {
            let l = utils.solidityKeccak256(["address", "uint256"], [address, tokenId])
            leaves.push(l)
        }
        tree = new MerkleTree(leaves, keccak256, {sortPairs: true})
        let merkleRoot = tree.getHexRoot()
        console.log('merkleRoot', merkleRoot.toString())

        // let leaf = leaves[2]
        // let proof = tree.getProof(leaf)
		// console.log('verify', tree.verify(proof, leaf, merkleRoot)) // true
        // console.log(tree.toString())

		await nft721.createDrop('{"desc":"这是一次空投活动","total":9}', merkleRoot)
		console.log('createDrop done')
	})

	it('claim', async function () {
        let dropId = 1
        let drop = await nft721.idToDrop(dropId)
        console.log(drop)

        for (let i=1; i<10; i++) {
            let leaf = leaves[i-1]
            let proof = tree.getProof(leaf)
            let proof2 = []
            for ({position, data} of proof) {
                proof2.push('0x' + data.toString('hex'))
            }
            await nft721.connect(accounts[i]).claim(dropId, airdrops[i-1].tokenId, proof2)
        }

        drop = await nft721.idToDrop(dropId)
        console.log(drop)
        
		for (let i=0; i<10; i++) {
            console.log('account'+i+' nft:', s(await nft721.balanceOf(accounts[i].address)))
        }
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