//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";

contract OutsourceToken is IERC20 {

  string public constant name = 'OutrsourceToken';
  string public constant symbol = 'OST';
  uint8 public constant decimals = 18;
  
  uint256 private totalSupply_;

  mapping(address => uint256) balances;
  mapping(address => mapping(address => uint256)) allowedToSpenders;

  constructor(uint256 _totalSupply) {
    totalSupply_ = _totalSupply;
    balances[msg.sender] += _totalSupply;
  }

  function totalSupply() external view override returns (uint256) {
    return totalSupply_;
  }

  function balanceOf(address account) external view override returns (uint256) {
    return balances[account];
  }

  function allowance(address owner, address spender) external view override returns (uint256) {
    require(owner != address(0), "OutsourceToken::allowance: allow from the zero address");
    require(spender != address(0), "OutsourceToken::allowance: allow to the zero address");
    return allowedToSpenders[owner][spender];
  }

  function transfer(address recipient, uint256 amount) external override returns (bool) {
    require(recipient != address(0), "OutsourceToken::transfer: transfer to the zero address");
    require(balances[msg.sender] >= amount, "OutsourceToken::transfer: The owner doesn't have enough tokens to tranfer");
    balances[msg.sender] -= amount;
    balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function approve(address spender, uint256 amount) external override returns (bool) {
    require(spender != address(0), "OutsourceToken::approve: can't approve to spend from the zero address");
    allowedToSpenders[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(address owner, address recipient, uint256 amount) external override returns (bool) {
    require(owner != address(0), "OutsourceToken::transferFrom: transfer from the zero address");
    require(recipient != address(0), "OutsourceToken::transferFrom: transfer to the zero address");
    require(balances[owner] >= amount, "OutsourceToken::transferFrom: The owner doesn't have enough tokens to transfer");
    require(allowedToSpenders[owner][recipient] >= amount, "OutsourceToken::transferFrom: The recipient is not allowed to receive that amount of tokens");
    balances[owner] -= amount;
    allowedToSpenders[owner][recipient] -= amount;
    balances[recipient] += amount;
    emit Transfer(owner, recipient, amount);
    return true;
  }
}