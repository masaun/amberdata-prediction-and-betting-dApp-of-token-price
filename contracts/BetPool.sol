pragma solidity 0.4.24;

import "../node_modules/chainlink/contracts/ChainlinkClient.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract BetPool is ChainlinkClient, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private betsTrue;
    mapping(address => uint256) private betsFalse;
    uint256 public totalBetTrue;
    uint256 public totalBetFalse;

    uint256 private oraclePaymentAmount;
    bytes32 private jobId;

    bool public resultReceived;
    bool public result;

    // @dev - Amberdata
    //uint256 constant private ORACLE_PAYMENT = 1 * LINK; // solium-disable-line zeppelin/no-arithmetic-operations
    uint256 public currentTokenPrice;

    uint256 public predictedTokenPrice;


    constructor(
        address _link,
        address _oracle,
        bytes32 _jobId,
        uint256 _oraclePaymentAmount
        )
    Ownable()
    public
    {
        setChainlinkToken(_link);
        setChainlinkOracle(_oracle);
        jobId = _jobId;
        oraclePaymentAmount = _oraclePaymentAmount;

        predictedTokenPrice = 200;
    }

    function bet(bool betOutcome) external payable
    {
        require(!resultReceived, "You cannot bet after the result has been received.");
        if (betOutcome)
        {
            betsTrue[msg.sender] += msg.value;
            totalBetTrue += msg.value;
        }
        else
        {
            betsFalse[msg.sender] += msg.value;
            totalBetFalse += msg.value;
        }
    }

    function withdraw() external
    {
        require(resultReceived, "You cannot withdraw before the result has been received.");
        if (result == true)
        {
            msg.sender.transfer(((totalBetTrue + totalBetFalse) * betsTrue[msg.sender]) / totalBetTrue);
            betsTrue[msg.sender] = 0;
        }
        else
        {
            msg.sender.transfer(((totalBetTrue + totalBetFalse) * betsFalse[msg.sender]) / totalBetFalse);
            betsFalse[msg.sender] = 0;
        }
    }

    // You probably do not want onlyOwner here
    // But then, you need some mechanism to prevent people from spamming this
    // function requestResult() external returns (bytes32 requestId)  // @Notice - Remove a modifier of "onlyOwner"
    // {
    //     require(!resultReceived, "The result has already been received.");
    //     Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
    //     req.add("low", "1");
    //     req.add("high", "6");
    //     req.add("copyPath", "random_number");
    //     requestId = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePaymentAmount);
    // }

    // @dev - Amberdata
    function requestResult() external returns (bytes32 requestId) {
        string memory _tokenAddress = "0x514910771AF9Ca656af840dff83E8264EcF986CA"; // LINK on mainnet

        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("extPath", concat("market/tokens/prices/", _tokenAddress, "/latest"));
        req.add("path", "payload.0.priceUSD");
        req.addInt("times", 100);
        requestId = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePaymentAmount);
    }



    function getBetAmount(bool outcome) external view returns (uint256 betAmount)
    {
        if (outcome)
        {
            betAmount = betsTrue[msg.sender];
        }
        else
        {
            betAmount = betsFalse[msg.sender];
        }
    }

    // function fulfill(bytes32 _requestId, int256 data)
    // public
    // recordChainlinkFulfillment(_requestId)
    // {
    //     resultReceived = true;
    //     if (data == 6)
    //     {
    //         result = true;
    //     }
    //     else
    //     {
    //         result = false;
    //     }
    // }

    function fulfill(bytes32 _requestId, uint256 _price)
    public
    recordChainlinkFulfillment(_requestId)
    {
        currentTokenPrice = _price;

        resultReceived = true;
        
        // if (_price > 0) {
        //     result = true;
        // } else {
        //     result = false;
        // }


        // @dev - The condition of how to judge WIN or LOST
        if (currentTokenPrice > 0) {
            result = true;
        } else {
            result = false;
        }   
    }


    // @dev - Amberdata
    function concat(string memory a, string memory b, string memory c) private pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
}
