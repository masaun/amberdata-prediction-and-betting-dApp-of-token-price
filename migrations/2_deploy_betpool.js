const BetPool = artifacts.require("BetPool");
const LinkTokenInterface = artifacts.require("LinkTokenInterface");

const linkTokenAddress = "0x20fE562d797A42Dcb3399062AE9546cd06f63280";
const oracle = "0xc99B3D447826532722E41bc36e644ba3479E4365";         // Oracle address of Amberdata Chainlink (Testnet) on Ropsten
//const oracle = "0x4a3fbbb385b5efeb4bc84a25aaadcd644bd09721";

const jobId = web3.utils.toHex("447f3b6fac1240ab91d3679fba00baf6");    // Job ID of Amberdata Chainlink (Testnet) on Ropsten / Old
//const jobId = web3.utils.toHex("6b0a1ab2ce554465930aceaa79bb4346");  // Job ID of Amberdata Chainlink (Testnet) on Ropsten / New
//const jobId = web3.utils.toHex("d02b14632b6141ec90bb8b2b9b937848");


/***
 * @notice - Contract pay fee for sending request / getting response with LINK（ERC20）. 
 * @dev - In case of below, contract pay 0.1LINK every sending request / getting response.
 */
const paymentAmount = web3.utils.toWei("0.1");


module.exports = async function (deployer) {
    await deployer.deploy(BetPool, linkTokenAddress, oracle, jobId, paymentAmount);
    const betPool = await BetPool.deployed();

    const linkToken = await LinkTokenInterface.at(linkTokenAddress);
    await linkToken.transfer(betPool.address, paymentAmount);
};
