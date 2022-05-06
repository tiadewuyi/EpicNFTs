const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract Address:" , nftContract.address);

    //call the funtion
    let txn = await nftContract.makeAnEpicNFT()
    //wait for it to be mined
    await txn.wait()

    //mint another nft cos you can
    //txn = await nftContract.makeAnEpicNFT()
    //wait for it to be mined
    //await txn.wait()

    // let allMinted = await nftContract.getTotalNFTsMinted();
    // console.log(allMinted);

};



const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log('FUCK UP:', error);
        process.exit(1);
    }
};


runMain();