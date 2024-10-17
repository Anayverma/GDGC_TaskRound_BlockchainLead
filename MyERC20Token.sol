// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MyERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;

    // ii) balanceOf: Indicates the number of tokens an address holds.
    mapping(address => uint256) private _balances;

    // v) approve: Allows a contract to spend a specified number of tokens from an account.
    mapping(address => mapping(address => uint256)) private _allowances;

    // Event declarations for Transfer and Approval
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor to initialize the token
    constructor(string memory tokenName, string memory tokenSymbol, uint256 initialSupply) {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = 18; // Standard for ERC20
        _totalSupply = initialSupply * (10 ** uint256(decimals)); // Convert to the correct decimals
        _balances[msg.sender] = _totalSupply; // Assign the total supply to the creator
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // i) totalSupply
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // ii) balanceOf
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // iii) transfer: Requires that the sender has a sufficient balance to send.
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // v) approve
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // iv) transferFrom: Allows the transfer from an account that is not making the transaction.
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= amount, "ERC20: transfer amount exceeds balance");
        require(_allowances[from][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");

        _balances[from] -= amount;
        _balances[to] += amount;

        _allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // vi) allowance: Returns the amount an approved contract is still allowed to spend or withdraw.
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    // vii) burn: Allows a user to burn tokens, permanently reducing the totalSupply.
    function burn(uint256 amount) public returns (bool) {
        require(_balances[msg.sender] >= amount, "ERC20: burn amount exceeds balance");

        _balances[msg.sender] -= amount;
        _totalSupply -= amount; // Reduce total supply

        emit Transfer(msg.sender, address(0), amount); // Emit transfer to zero address
        return true;
    }
}
