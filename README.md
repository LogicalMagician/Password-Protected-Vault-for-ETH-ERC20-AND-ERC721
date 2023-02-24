This is a Solidity smart contract that implements a password-protected vault for managing the withdrawal of Ether and ERC20/ERC721 tokens.

Usage
Contract Deployment
The constructor of the contract takes a single parameter: the keccak256 hash of the password that will be used to access the vault. This should be passed in as an argument when deploying the contract.

Password Management
The owner of the contract can change the password at any time by calling the setPassword function, which takes the keccak256 hash of the new password as a parameter.

Withdrawal of Ether
The withdrawETH function can be called by anyone who has the correct password to withdraw Ether from the contract. The function takes the password as a parameter and will transfer all Ether held by the contract to the caller's address.

Withdrawal of ERC20 Tokens
The withdrawERC20 function can be called by anyone who has the correct password to withdraw ERC20 tokens from the contract. The function takes three parameters:

token_: the address of the ERC20 token to withdraw
amount_: the amount of the token to withdraw
password_: the password required to make the withdrawal
The function will transfer the specified amount of the token to the caller's address.

Withdrawal of ERC721 Tokens
The withdrawERC721 function can be called by anyone who has the correct password to withdraw ERC721 tokens from the contract. The function takes three parameters:

token_: the address of the ERC721 token to withdraw
tokenId_: the ID of the token to withdraw
password_: the password required to make the withdrawal
The function will transfer the specified token to the caller's address.

Security
This contract uses the SafeMath library to prevent integer overflow/underflow. It also includes a onlyOwner modifier to restrict certain functions to the contract owner.

The contract's security relies heavily on the strength of the password used to access the vault. It is recommended to use a strong and unique password, and to keep it safe and secure.
