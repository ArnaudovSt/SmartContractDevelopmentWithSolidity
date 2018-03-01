const Web3 = require('web3');
const currentProvider = 'ws://localhost:8545';

let web3;

module.exports = () => {
	if (web3) {
		return web3;
	}

	web3 = new Web3(new Web3.providers.WebsocketProvider(currentProvider));
	
	return web3;
};