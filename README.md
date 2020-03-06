# Honeycomb Example Project

*This project is under development, so make sure to follow it if you are participating in the hackathon/developing actively.*

## Before installation
- Install [npm](https://www.npmjs.com/get-npm)

- Install truffle globally using:

`npm install -g truffle`

- Install the Metamask add-on to your browser and create a wallet.
Note down the mnemonics.
Fund it with [Ropsten ETH](https://faucet.metamask.io/) and [Ropsten LINK](https://ropsten.chain.link/).

- Create an [Infura](https://infura.io/) account, get an endpoint URL for the Ropsten testnet and note it down.

- (Optional) Install [Visual Studio Code](https://code.visualstudio.com/)

## Installation

- Clone this repo using:

`git clone`

- Go to the main directory (`/honeycomb-example-project`)

- Install the dependencies for the smart contract:

`npm install`

- Create the file that you are going to enter your Infura credentials:

`cp wallet.json.example wallet.json`

- Open the newly created `wallet.json` file and enter the mnemonics and the endpoint URL you have noted down earlier, similar to `wallet.json.example`.

- Deploy the contract (Ropsten LINK will be transferred from your wallet to the contract automatically during deployment)

`npm run deploy-ropsten`

- Go to the front-end project directory (`/honeycomb-example-project/client`)

- Install the dependencies for the front-end project:

`npm install`

- Start the server

`npm run start`

## Example project

Once you follow the previous steps, your browser should display the page below at `http://localhost:3000/`.
If the page is blank, try logging in to your MetaMask add-on.

<p align="center">
  <img src="https://user-images.githubusercontent.com/19530665/69197786-7b043400-0b00-11ea-8f08-210577380f0d.png"/>
</p>

This is the most basic example of an oracle-connected dapp.
The oracle returns a number between 1 and 6 with equal probability.
The users bet on the returned number being 6 or lower.
The winners get paid out proportional to their wager.

To bet, fill in the bet amount in (Ropsten) ETH and click on either *Bet on 6* or *Bet on not 6*.
Once the betting is done, the contract deployer can click on *Request Result*, which creates a Chainlink request for a random number between 1 and 6.
After the Chainlink request is fulfilled, the dapp displays the winning side.
If you have guessed the outcome correctly, you can click *Withdraw Winnings*, which sends you your reward.

## Replace the random number generator with a Honeycomb API

See how the JobID is set in `migrations/2_deploy_contracts.js`:

`const jobId = web3.utils.toHex("d02b14632b6141ec90bb8b2b9b937848");`

The `honeycomb.market` Ropsten node serves a random `int256` between two limits with this JobID.
To develop a smart contract that depends on another type of call, you are going to need to change it.

First, see [this article](https://medium.com/clc-group/honeycomb-marketplace-101-for-ethereum-developers-c7c63c2d3049) that gives a general overview of Honeycomb Marketplace.
Then, follow these steps:
- Go to [Honeycomb Marketplace](https://honeycomb.market), log in
- Click on the *Browse APIs* tab
- Click on an API
- Click on the *Connect* button of one of the paths
- Select *Ropsten Test Network* as the network
- Select [the data type you want](https://medium.com/clc-group/how-to-choose-the-data-type-on-honeycomb-marketplace-f77552099a1f)

As a result, you are going to see the Ropsten listing for that endpoint.
Replace the JobID in `migrations/2_deploy_contracts.js` with the new JobID.

Note that you are also going to have to modify the smart contract based on the API you have used.
See this article for an example.
