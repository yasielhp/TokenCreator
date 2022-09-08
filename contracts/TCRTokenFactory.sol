// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./ERC20Free.sol";
import "./ERC20Standard.sol";
import "./ERC20Burnable.sol";
import "./ERC20Mintable.sol";

contract TCRTokenFactory is Ownable {
    using Address for address;
    using SafeMath for uint256;
    using SafeMath for uint8;
    using SafeMath for uint;

   IERC20Metadata private tcr;
   uint256 private deployPriceBNB = 100000000000000000; // 0.1 BNB
   uint256 private deployPriceTCR = 69548299999999990000; // 696 TCR => 0.08 BNB

   constructor(address _tcr){
    tcr = IERC20Metadata(_tcr);
   }

   function deployFree(
    string memory name,
    string memory symbol,
    uint256 supply
   ) external returns(address){
        address token = address(new ERC20Free(name,symbol,supply,_msgSender()));
        return token;
   }

   function _deploy(
    string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 supply,
    uint tokenType
    ) private returns(address) {
    if(tokenType==1)
            return address(
                new ERC20Standard(name,symbol,decimals,supply,_msgSender()));
        if(tokenType==2)
            return address(
                new ERC20Burnable(name,symbol,decimals,supply,_msgSender()));
        if(tokenType==3)
            return address(
                new ERC20Mintable(name,symbol,decimals,supply,_msgSender()));
        return address(0);
   }

    function deployPainBNB(
    string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 supply,
    uint tokenType
   ) external payable returns(address){
        require(msg.value == deployPriceBNB);

        return _deploy(name, symbol, decimals, supply, tokenType);
   }

   function deployPainTCR(
    string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 supply,
    uint tokenType
   ) external returns(address){
        require(tcr.balanceOf(_msgSender()) >= deployPriceTCR);
        require(tcr.allowance(_msgSender(), address(this)) >= deployPriceTCR);
        require(tcr.transferFrom(_msgSender(), address(this), deployPriceTCR));

        return _deploy(name, symbol, decimals, supply, tokenType);
   }

   function getDeployPriceTCR() external view returns(uint256){
    return deployPriceTCR;
   }
   function getDeployPriceBNB() external view returns(uint256){
    return deployPriceTCR;
   }
    function getPaidTokenAddress() external view returns(address){
    return address(tcr);
   }
   function getPaidTokenDecimals() external view returns(uint8){
    return tcr.decimals();
   }
   function updateDeployPriceTCR(uint256 newPrice) external onlyOwner{
    deployPriceTCR = newPrice;
   }
   function updateDeployPriceBNB(uint256 newPrice) external onlyOwner{
    deployPriceBNB = newPrice;
   }
   function withdrawBNB(address payable account) external onlyOwner {
    (bool success,) = account.call{value: address(this).balance}("");
    require(success);
   }
   function withdrawToken(address account, uint256 amount) external onlyOwner {
    require(tcr.transfer(account, amount));
   }
   function withdrawTokenAll(address account) external onlyOwner {
    require(tcr.transfer(account, tcr.balanceOf(address(this))));
   }

   receive() external payable {}
   fallback() external payable {}
}
