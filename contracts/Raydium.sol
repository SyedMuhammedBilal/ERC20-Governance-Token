// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../@openzeppelin/contracts/access/Ownable.sol";

contract Raydium is ERC20, Ownable {

    mapping(address => bool) private isMinter;
    mapping(address => bool) private isBurner;

    constructor(address _contractOwner, address _mintingDestination) ERC20("Raydium", "RAY") {
        _mint(_mintingDestination, 500e6 ether);
        transferOwnership(_contractOwner);
    }

    /** @notice Mints tokens
        @param account Address that will receive the minted tokens
        @param amount Amount that will be minted 
    */
    function mint(
        address account,
        uint256 amount
        )
        external
    {
        require(isMinter[msg.sender], "Only minters are allowed to mint");
        _mint(account, amount);
    }

    /** @notice Burns caller's tokens
        @param amount Amount that will be burned
    */
    function burn(uint256 amount)
        external
    {
        require(isBurner[msg.sender], "Only burners are allowed to burn");
        _burn(msg.sender, amount);
    }
}