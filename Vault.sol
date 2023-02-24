pragma solidity ^0.8.0;

contract PasswordProtectedVault {
    address payable owner;
    string passwordHash;
    
    event Deposit(address indexed _from, uint256 _value);
    event Withdraw(address indexed _to, uint256 _value);
    
    constructor(string memory _passwordHash) {
        owner = payable(msg.sender);
        passwordHash = _passwordHash;
    }
    
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    
    function depositERC20(address _token, uint256 _amount) external {
        require(IERC20(_token).transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        emit Deposit(msg.sender, _amount);
    }
    
    function depositERC721(address _token, uint256 _tokenId) external {
        IERC721(_token).safeTransferFrom(msg.sender, address(this), _tokenId);
        emit Deposit(msg.sender, 1);
    }
    
    function withdrawETH(address payable _to, string memory _inputPassword) external {
        require(keccak256(bytes(_inputPassword)) == keccak256(bytes(passwordHash)), "Invalid password");
        uint256 balance = address(this).balance;
        require(balance > 0, "Insufficient balance");
        _to.transfer(balance);
        emit Withdraw(_to, balance);
    }
    
    function withdrawERC20(address _token, address payable _to, uint256 _amount, string memory _inputPassword) external {
        require(keccak256(bytes(_inputPassword)) == keccak256(bytes(passwordHash)), "Invalid password");
        require(IERC20(_token).transfer(_to, _amount), "Transfer failed");
        emit Withdraw(_to, _amount);
    }
    
    function withdrawERC721(address _token, address payable _to, uint256 _tokenId, string memory _inputPassword) external {
        require(keccak256(bytes(_inputPassword)) == keccak256(bytes(passwordHash)), "Invalid password");
        IERC721(_token).safeTransferFrom(address(this), _to, _tokenId);
        emit Withdraw(_to, 1);
    }
    
    function changePassword(string memory _newPassword) external {
        require(msg.sender == owner, "Only the owner can change the password");
        passwordHash = keccak256(bytes(_newPassword));
    }
    
    function getVaultBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}
