// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//
// Contract generate by TokenCreator (TCR)
// TokenCreator (TCR) is  just a Token platform creator
// TokenCreator (TCR) is  not the owner of tthis token
// Author: @yasielhp
//
import "./Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Burnable is ERC20, Ownable{
  using Address for address;
  using SafeMath for uint256;
  using SafeMath for int256;
  using SafeMath for uint;

  uint8 private __decimals;

  constructor(
    string memory name,
    string memory symbol,
    uint8 _decimals,
    uint256 supply,
    address owner
  )  ERC20 (name, symbol) {
    __decimals = _decimals;
    _mint(owner, supply * 10**_decimals);
    transferOwnership(owner);
  }

  function decimals() public view override returns (uint8) {
    return __decimals;
  }
  function burn(uint256 amount) public {
    _burn(_msgSender(), amount);
}
}
