const web3 = new Web3('https://ropsten.infura.io/v3/494fdf9c55be4bfc995f0eaa02a4c698');

let latestKnownBlockNumber = -1;
let blockTime = 1000;

// Our function that will triggered for every block
async function processBlock(blockNumber) {
    console.log("We process block: " + blockNumber);
    let block = await web3.eth.getBlock(blockNumber);
    console.log("new block: ", block);
    for (const txHash of block.transactions) {
        console.log(`tx hash: ${txHash}`);
        web3.eth.getTransaction(txHash).then(console.log);
        web3.eth.getTransactionReceipt(txHash).then(console.log);
        // const transaction = Object.assign(tx, txRect);
        // console.log(`tx: ${transaction}`);
    }
    latestKnownBlockNumber = blockNumber;
}

// This function is called every blockTime, check the current block number and order the processing of the new block(s)
async function checkCurrentBlock() {
    const currentBlockNumber = await web3.eth.getBlockNumber()
    console.log("Current blockchain top: " + currentBlockNumber, " | Script is at: " + latestKnownBlockNumber);
    while (latestKnownBlockNumber == -1 || currentBlockNumber > latestKnownBlockNumber) {
        await processBlock(latestKnownBlockNumber == -1 ? currentBlockNumber : latestKnownBlockNumber + 1);
    }
    setTimeout(checkCurrentBlock, blockTime);
}

checkCurrentBlock()