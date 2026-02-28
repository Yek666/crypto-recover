// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RecoverableVault {

    address public owner;
    address public recoveryAgent;
    bool public recoveryEnabled;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyRecoveryAgent() {
        require(msg.sender == recoveryAgent, "Not recovery agent");
        _;
    }

    constructor(address _recoveryAgent) {
        owner = msg.sender;
        recoveryAgent = _recoveryAgent;
        recoveryEnabled = true;
    }

    receive() external payable {}

    function withdraw(address payable _to, uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        _to.transfer(_amount);
    }

    function recoverFunds(address payable _to, uint256 _amount) external onlyRecoveryAgent {
        require(recoveryEnabled, "Recovery disabled");
        require(address(this).balance >= _amount, "Insufficient balance");
        _to.transfer(_amount);
    }

    function toggleRecovery(bool _status) external onlyOwner {
        recoveryEnabled = _status;
    }
}
