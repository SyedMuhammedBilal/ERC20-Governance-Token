// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IRaydium";

contract Raydium is ERC20, Ownable, IRaydium {

    mapping(address => bool) private isMinter;
    mapping(address => bool) private isBurner;

    constructor(address _contractOwner, address _mintingDestination) ERC20("Raydium", "RAY") {
        _mint(_mintingDestination, 500e6 ether);
        transferOwnership(_contractOwner);
    }

    /** @notice The OpenZeppelin renounceOwnership() implementation is
        overriden to prevent ownership from being renounced accidentally.
    */
    function renounceOwnership()
        public
        override
        onlyOwner
    {
        revert("Ownership cannot be renounced");
    }

    /** @notice Updates if an address is authorized to mint tokens
        @param minterAddress Address whose minter authorization status will beupdated
        @param minterStatus Updated minter authorization status
    */
    function updateMinterStatus(
        address minterAddress,
        bool minterStatus
        )
        external
        override
        onlyOwner
    {
        require(
            isMinter[minterAddress] != minterStatus,
            "Input will not update state"
            );
        isMinter[minterAddress] = minterStatus;
        emit MinterStatusUpdated(minterAddress, minterStatus);
    }

    /** @notice Updates if the caller is authorized to burn tokens
        @param burnerStatus Updated minter authorization status
    */
    function updateBurnerStatus(bool burnerStatus)
        external
        override
    {
        require(
            isBurner[msg.sender] != burnerStatus,
            "Input will not update state"
            );
        isBurner[msg.sender] = burnerStatus;
        emit BurnerStatusUpdated(msg.sender, burnerStatus);
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

    /** @notice Returns if an address is authorized to mint tokens
        @param minterAddress Address whose minter authorization status will be returned
        @return minterStatus Minter authorization status
    */
    function getMinterStatus(address minterAddress)
        external
        view
        override
        returns(bool minterStatus)
    {
        minterStatus = isMinter[minterAddress];
    }

    /** @notice Returns if an address is authorized to burn tokens
        @param burnerAddress Address whose burner authorization status will be returned
        @return burnerStatus Burner authorization status
    */
    function getBurnerStatus(address burnerAddress)
        external
        view
        override
        returns(bool burnerStatus)
    {
        burnerStatus = isBurner[burnerAddress];
    }
}