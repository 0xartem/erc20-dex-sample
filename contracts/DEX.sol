//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";
import "./OutsourceToken.sol";

contract DEX {
  IERC20 public token;

  event Bought(uint256 amount);
  event Sold(uint256 amount);

  constructor() {
    token = new OutsourceToken(1000000);
  }

  function buy() payable public {
    uint256 amountToBuy = msg.value;
    uint256 dexBalance = token.balanceOf(address(this));
    require(amountToBuy > 0, "DEX::buy: no ether has been sent");
    require(dexBalance > amountToBuy, "DEX::buy: token doesn't have enough balance");
    token.transfer(msg.sender, amountToBuy);
    emit Bought(amountToBuy);
  }

  function sell(uint256 amount) public returns (bool) {
    require(amount > 0, "DEX::sell: You need to send some tokens");
    uint256 allowed = token.allowance(msg.sender, address(this));
    require(allowed >= amount, "DEX::sell: The owner doesn't allow to spend this amount of tokens");
    (bool status, ) = msg.sender.call{ value: amount }("");
    if (status) {
      token.transferFrom(msg.sender, address(this), amount);
      emit Sold(amount);
    }
    return status;
  }
}