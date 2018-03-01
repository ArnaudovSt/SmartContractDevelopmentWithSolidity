const ABI = require('../build/contracts/Core.json')['abi'];
const networks = require('../build/contracts/Core.json')['networks'];
const pattern = /"address":"(.*)"/;
const address = JSON.stringify(networks).match(pattern)[1];
const web3 = require('./web3.service')();

let contract;
let fromOptionSet;
const txConfirmationsCount = 12;

const getContract = () => {
	if (contract) {
		return contract;
	}

	initContract();

	return contract;
}

async function addMember(newMebmer) {
	await checkContract();
	return contract.methods
		.addMember(newMebmer)
		.send()
		.on('transactionHash', (hash) => {
			console.log(`Member ${newMebmer} adding transaction hash is ${hash}.`);
		})
		.on('confirmation', (confirmationNumber, receipt) => {
			if (confirmationNumber === txConfirmationsCount) {
				console.log(`Transaction ${receipt.transactionHash} has reached ${txConfirmationsCount} confirmations!`);
			}
		})
		.on('receipt', (receipt) => {
			console.log(`Successfully added ${newMebmer}! Transaction ${receipt.transactionHash} was mined.`);
		})
		.on('error', (err) => {
			console.error(err);
			throw err;
		});
}

async function removeMember(memberToRemove) {
	await checkContract();
	return contract.methods
		.removeMember(memberToRemove)
		.send()
		.on('transactionHash', (hash) => {
			console.log(`Member ${memberToRemove} removing transaction hash is ${hash}.`);
		})
		.on('confirmation', (confirmationNumber, receipt) => {
			if (confirmationNumber === txConfirmationsCount) {
				console.log(`Transaction ${receipt.transactionHash} has reached ${txConfirmationsCount} confirmations!`);
			}
		})
		.on('receipt', (receipt) => {
			console.log(`Successfully removed ${memberToRemove}! Transaction ${receipt.transactionHash} was mined.`);
		})
		.on('error', (err) => {
			console.error(err);
			throw err;
		});
}

async function checkContract() {
	if (!contract) {
		initContract();
	}

	if (!fromOptionSet) {
		await setFrom();
	}
}

function initContract() {
	const addressChecksum = web3.utils.toChecksumAddress(address);
	contract = new web3.eth.Contract(ABI, address);
}

async function setFrom() {
	let accounts = await web3.eth.getAccounts();
	contract.options.from = accounts[0];
	fromOptionSet = true;
}

module.exports = { getContract, addMember, removeMember }