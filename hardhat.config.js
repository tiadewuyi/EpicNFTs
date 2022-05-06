require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: 'https://eth-rinkeby.alchemyapi.io/v2/iL_wJydFpdMag16Y_dQhN5ksPjdHL2q0',
      accounts: ['9841b7536686444dd5b27ed5280cd88738a49e5bb8b9d243ff5c15d23eaf622c'],
    },
  },
  etherscan: {
    apiKey: "KJECU9MCRFI2NP6WIITK5BVPZUMKXQH4RZ",
  }
};