// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PasswordProtectedVault {
    using SafeMath for uint256;

    address private _owner;
    bytes32 private _passwordHash;

    constructor(bytes32 passwordHash_) {
        _owner = msg.sender;
        _passwordHash = passwordHash_;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not owner");
        _;
    }

    function setPassword(bytes32 passwordHash_) public onlyOwner {
        _passwordHash = passwordHash_;
    }

    function withdrawETH(bytes32 password_) public payable {
        require(keccak256(abi.encodePacked(password_)) == _passwordHash, "Invalid password");

        uint256 balance = address(this).balance;
        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    function withdrawERC20(address token_, uint256 amount_, bytes32 password_) public {
        require(keccak256(abi.encodePacked(password_)) == _passwordHash, "Invalid password");

        require(token_ != address(0), "Invalid token address");

        uint256 balance = IERC20(token_).balanceOf(address(this));
        require(amount_ > 0 && balance >= amount_, "Insufficient balance");

        require(IERC20(token_).transfer(msg.sender, amount_), "Transfer failed");
    }
}
