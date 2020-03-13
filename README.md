# Prediction and Betting dApp of Token Price（by using Amberdata.io and Chainlink Oracle）
## Introduction of Prediction and Betting dApp of Token Price
- Prediction and Betting dApp of Token Price is a decentrailized application which is created by Amberdata.io and Chainlink Oracle.
- In this dApp, users predict token price of `MKR` token.
  - Token address of MKR： `"0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2"`
  - Metrix of MKR： https://amberdata.io/addresses/0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2/metrics

<br>

- Prediction and Betting dApp of Token Price works on Ropsten Testnet right now.


<br>

## UI and process of Prediction and Betting dApp

Once you follow the previous steps, your browser should display the page below at `http://localhost:3000/`.
If the page is blank, try logging in to your MetaMask add-on.






## Before installation
- Install [npm](https://www.npmjs.com/get-npm)

- Install truffle globally using:

`npm install -g truffle`

- Install the Metamask add-on to your browser and create a wallet.
Note down the mnemonics.
Fund it with [Ropsten ETH](https://faucet.metamask.io/) and [Ropsten LINK](https://ropsten.chain.link/).

- Create an [Infura](https://infura.io/) account, get an endpoint URL for the Ropsten testnet and note it down.

- (Optional) Install [Visual Studio Code](https://code.visualstudio.com/)

<br>

## Installation

- ① Clone this repo using:

`git clone git@github.com:masaun/amberdata_chainlink_oracle_integration.git`

- ② Go to the main directory (`/amberdata_chainlink_oracle_integration`)

- ③ Install the dependencies for the smart contract:

`npm install`

- ④ Create the file that you are going to enter your Infura credentials:

`cp wallet.json.example wallet.json`

- ⑤ Open the newly created `wallet.json` file and enter the mnemonics and the endpoint URL you have noted down earlier, similar to `wallet.json.example`.

- ⑥ Deploy the contract (Ropsten LINK will be transferred from your wallet to the contract automatically during deployment)

`npm run migrate:ropsten`

- ⑦ Go to the front-end project directory (`/amberdata_chainlink_oracle_integration/client`)

- ⑧ Install the dependencies for the front-end project:

`npm install`

- ⑨ Start the server

`npm run start`


<br>

## Recommendation
- After process of ⑥(Deploy the contract) above, it is better to transfer LINK token from Chainlink fancet on ropsten below to deployed contract address.
（Chainlink fancet on ropsten below are able to transfer 100 LINK）  
https://ropsten.chain.link/  


<br>

## References
- Amberdata medium
  - Developer Challenge: Scale DeFi & Digital Assets  
    https://medium.com/amberdata/developer-challenge-scale-defi-digital-assets-d71015200325  

<br>

- Amberdata document
  - Price Token Historical  
    https://docs.amberdata.io/reference#get-historical-token-price  

<br>

- Amberdata Chainlink (Testnet)   
https://docs.chain.link/docs/amberdata-chainlink-testnet#config 

- amberdata/amberdata-example-chainlink   
https://github.com/amberdata/amberdata-example-chainlink   

- honeycomb-wiki  
https://github.com/clc-group/honeycomb-wiki/wiki  

