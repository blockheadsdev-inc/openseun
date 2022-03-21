// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "./HederaTokenService.sol";
import "./HederaResponseCodes.sol";

contract SeunSwap is HederaTokenService {

    address payable public controller;

    mapping(address => uint) tokenBalances;

    mapping(address => uint) tokenPrices;

    mapping(address => bool) tokenAssociations;

    constructor(address payable _controller){
        controller = _controller;
    }

    modifier onlyController() {
        require(msg.sender == controller);
        _;
    }

    function associateControllerWithToken(address _tokenId) public onlyController() {

        int response = HederaTokenService.associateToken(controller, _tokenId);

        if (response == HederaResponseCodes.SUCCESS){
            tokenBalances[_tokenId] = 0;
            tokenPrices[_tokenId] = 0;
            tokenAssociations[_tokenId] = true;
        }

        if (response == HederaResponseCodes.TOKEN_ALREADY_ASSOCIATED_TO_ACCOUNT) {
            tokenBalances[_tokenId] = 0;
            tokenPrices[_tokenId] = 0;
            tokenAssociations[_tokenId] = true;
        }

    }

    function listToken(address _tokenId, uint _amount, uint _price) public {

        require(tokenAssociations[_tokenId]);

        tokenBalances[_tokenId] += _amount;

        tokenPrices[_tokenId] = _price;

    }

    function tokenPurchase(address _tokenId, uint _amount) public {

        require(tokenBalances[_tokenId] > 0);

        require(tokenAssociations[_tokenId]);

        uint currentTokenBalance = tokenBalances[_tokenId];

        tokenBalances[_tokenId] += _amount;

        int64 amount64 = int64(uint64(_amount));

        int response = HederaTokenService.transferToken(_tokenId, msg.sender, controller, amount64);

        if (response != HederaResponseCodes.SUCCESS){
            tokenBalances[_tokenId] = currentTokenBalance;
        }

    }

    function tokenSale(address _tokenId) public payable onlyController() {

        require(tokenBalances[_tokenId] > 0);
        require(tokenAssociations[_tokenId]);

        require(msg.value >= tokenPrices[_tokenId]);

        uint currentTokenBalance = tokenBalances[_tokenId];

        int64 currentTokenBalance64 = int64(uint64(tokenBalances[_tokenId]));

        tokenBalances[_tokenId] -= (msg.value * tokenPrices[_tokenId]);

        int response = HederaTokenService.transferToken(_tokenId, controller, msg.sender, currentTokenBalance64);

        if (response != HederaResponseCodes.SUCCESS){
            tokenBalances[_tokenId] = currentTokenBalance;
        }

    }

    function changeTokenPrice(address _tokenId, uint _amount) public onlyController() {

        require(tokenAssociations[_tokenId]);
        require(tokenBalances[_tokenId] > 0);

        tokenPrices[_tokenId] = _amount;

    }

    function getTokenPrice(address _tokenId) public view returns(uint256 price){
        return tokenPrices[_tokenId];
    }

    function getTokenBalance(address _tokenId) public view returns(uint256 balance) {
        return tokenBalances[_tokenId];
    }

}