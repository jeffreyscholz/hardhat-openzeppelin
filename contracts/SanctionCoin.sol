// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts@4.7.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";

contract SanctionCoin is ERC20, Ownable {
    mapping(address=>bool) private _sanctionedAddresses;

    constructor() ERC20("SanctionCoin", "SNC") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    modifier onlyAllowed {
        require(_sanctionedAddresses[msg.sender] == false, "Your account is sanctioned!");
        _;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) override internal onlyAllowed {
        require(_sanctionedAddresses[from] == false, "Your account is sanctioned!");
        require(_sanctionedAddresses[to]   == false, "Recepient address is sanctioned!");
        super._beforeTokenTransfer(from, to, amount);
    }

    function lockAddress(address account) external onlyOwner {
        _sanctionedAddresses[account] = true;
    }
    function unlockAddress(address account) external onlyOwner {
        _sanctionedAddresses[account] = false;
    }
    function viewAddressStatus(address account) external view {
        return _sanctionedAddresses[account];
    }
}
