// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {
    mapping(address => uint256) private balances;
    mapping(address => bool) public enrolled;

    address public owner = msg.sender;

    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint256 amount);
    event LogWithdrawal(
        address accountAddress,
        uint256 withdrawAmount,
        uint256 newBalance
    );

    /// @notice Get balance
    /// @return balance The balance of the user
    function getBalance() external view returns (uint256 balance) {
        balance = balances[msg.sender];
    }

    function enroll() external returns (bool success) {
        require(enrolled[msg.sender] == false, "Already enrolled");
        // 1. enroll of the sender of this transaction
        enrolled[msg.sender] = success = true;
        emit LogEnrolled(msg.sender);
    }

    /// @notice Deposit ether into bank
    /// @return balance The balance of the user after the deposit is made
    function deposit() external payable returns (uint256 balance) {
        require(enrolled[msg.sender] == true, "You need to be enrolled");

        balances[msg.sender] += msg.value;
        balance = balances[msg.sender];
        emit LogDepositMade(msg.sender, msg.value);
    }

    modifier canWithdraw(uint256 amount) {
        require(enrolled[msg.sender] == true, "Must be enrolled");
        uint256 balance = balances[msg.sender];
        if (amount > balance) {
            revert();
        }
        _;
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return balance The balance remaining for the user

    function withdraw(uint256 withdrawAmount)
        external
        canWithdraw(withdrawAmount)
        returns (uint256 balance)
    {
        balances[msg.sender] -= withdrawAmount;
        bool sent = sendFunds(msg.sender, withdrawAmount);
        balance = this.getBalance();
        emit LogWithdrawal(msg.sender, withdrawAmount, balance);
        require(sent, "Withdraw not executed");
    }

    function sendFunds(address recipient, uint256 funds)
        private
        returns (bool sent)
    {
        (sent, ) = payable(recipient).call{value: funds}("");
    }

    receive() external payable {}

    fallback() external {}
}
