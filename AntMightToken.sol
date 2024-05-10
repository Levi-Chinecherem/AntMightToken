// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract AntmightToken is ERC20, ERC20Burnable, Ownable, Pausable {
    // Initialize state variables
    mapping(address => uint256) public lastRequestTime;
    address public contractAddress;

    constructor() ERC20("Antmight", "ATM") Ownable(msg.sender) {
        // Mint initial supply (adjust as needed)
        _mint(msg.sender, 12000000000 * 10**decimals());
        contractAddress = address(this);
    }

    // Custom function to mint additional tokens (onlyOwner)
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    // Pause the contract
    function pause() public onlyOwner {
        _pause();
    }

    // Unpause the contract
    function unpause() public onlyOwner {
        _unpause();
    }

    // Function to retrieve the contract address
    function getContractAddress() external view returns (address) {
        return contractAddress;
    }

    // Faucet function: Users can request tokens once every 24 hours
    function requestTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(block.timestamp - lastRequestTime[msg.sender] >= 1 days, "Can request once every 24 hours");
        lastRequestTime[msg.sender] = block.timestamp;
        _mint(msg.sender, amount);
    }
}
