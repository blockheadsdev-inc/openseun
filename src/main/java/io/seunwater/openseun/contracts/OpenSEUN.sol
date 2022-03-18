// SPDX-Licence-Identifier: GPL-v3

pragma solidity ^0.8.0;

import "/HederaResponseCodes.sol";
import "/HederaTokenService.sol";

contract OpenSEUN is HederaTokenService {

    address[] public projects;

    address[] public investors;

    mapping(address => uint) projectBalances;

    mapping(address => address) investorCertificates;

    function addProject(address _project) public {}

    function addInvestor(address _investor) public {
        investors.push(_investor);
    }

    function associateProjectWithBond(address _project) public {}

    function transferCertificateToInvestor(address _investor, address _certificate) public {

        require(investors[_investor] == _investor, "Investor can not be Recognized! ");

        investorCertificates[_investor] = _certificate;

        HederaTokenService.transferNFT();

    }

    function getProjectBondBalance(address _project) public view returns(uint balance){}

    function getContractBalance(){}

    function purchaseCarbonCredits(address _investor, address _project) public payable {

    }

}
