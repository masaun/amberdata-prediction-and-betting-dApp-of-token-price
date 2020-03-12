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
    
    bytes32 private jobId_1;  // Job ID - bytes32
    bytes32 private jobId_2;  // Job ID - int256
    bytes32 private jobId_3;  // Job ID - uint256

    bool public resultReceived;
    bool public result;

    // @dev - Amberdata
    //uint256 constant private ORACLE_PAYMENT = 1 * LINK; // solium-disable-line zeppelin/no-arithmetic-operations
    uint256 public currentTokenPrice;

    bool public resultReceivedTimeStampLatest;
    bool public resultTimeStampLatest;
    uint256 public timeStampLatest;


    constructor(
        address _link,
        address _oracle,
        bytes32 _jobId_1,  // Job ID - bytes32
        bytes32 _jobId_2,  // Job ID - int256
        bytes32 _jobId_3,  // Job ID - uint256
        uint256 _oraclePaymentAmount
        )
    Ownable()
    public
    {
        setChainlinkToken(_link);
        setChainlinkOracle(_oracle);
        jobId_1 = _jobId_1;  // Job ID - bytes32
        jobId_2 = _jobId_2;  // Job ID - int256
        jobId_3 = _jobId_3;  // Job ID - uint256
        oraclePaymentAmount = _oraclePaymentAmount;
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
    // @dev - Get timestamp of latest
    function requestResultTimeStampLatest() external returns (bytes32 requestId) {
        string memory _tokenAddress = "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2"; // MKR token on mainnet

        // @dev - Get historical token price data
        Chainlink.Request memory req = buildChainlinkRequest(jobId_3, address(this), this.fulfillTimeStampLatest.selector);
        req.add("extPath", concat("market/tokens/prices/", _tokenAddress, "/historical"));
        req.add("path", "payload.data.30.0");  // Timestamp of Latest
        req.addInt("times", 1000000000);       // Specify getting value of timestamp until 10 digits

        requestId = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePaymentAmount);        
    }
    

    // @dev - Amberdata
    function requestResult() external returns (bytes32 requestId) {
        string memory _tokenAddress = "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2"; // MKR token on mainnet

        // @dev - Using int256 as JobID of data-type  
        // Chainlink.Request memory req = buildChainlinkRequest(jobId_2, address(this), this.fulfill.selector);
        // req.add("extPath", concat("market/tokens/prices/", _tokenAddress, "/latest"));
        // req.add("path", "payload.0.priceUSD");
        // req.addInt("times", 100);
        
        // @dev - Get historical token price data
        Chainlink.Request memory req = buildChainlinkRequest(jobId_2, address(this), this.fulfill.selector);
        req.add("extPath", concat("market/tokens/prices/", _tokenAddress, "/historical"));
        req.add("path", "payload.data.30.1");  // Latest
        req.addInt("times", 100);

        requestId = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePaymentAmount);
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


    function fulfillTimeStampLatest(bytes32 _requestId, uint256 _timestamp)
    public
    recordChainlinkFulfillment(_requestId)
    {
        timeStampLatest = _timestamp;
    }


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


    // @dev - Amberdata
    function concat(string memory a, string memory b, string memory c) private pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
}
