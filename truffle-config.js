const path = require('path')
const HDWalletProvider = require('@truffle/hdwallet-provider')

module.exports = {
	plugins: ['truffle-plugin-verify', 'truffle-contract-size'],
	api_keys: {
		bscscan: '',
	},
	contracts_build_directory: path.join(__dirname, 'app/src/contracts'),
	networks: {
		bsc_testnet: {
			provider: () =>
				new HDWalletProvider(
					`${process.env.PRIVATE_KEY}``https://data-seed-prebsc-1-s1.binance.org:8545`,
					0
				),
			from: `${process.env.WALLET_ADDRESS}`,
			gas: 600000,
			networks_id: 97,
			confirmations: 4,
			timeoutBlocks: 10000,
		},
	},
	compilers: {
		solc: {
			version: '0.8.0',
			settings: {
				optimizer: {
					enabled: true,
					runs: 200,
				},
			},
		},
	},
}
