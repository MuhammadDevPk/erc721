// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ERC721 {
    string public name; // e.g CryptoPunks
    string public symbol; // e.gϾ it's a short abbreviation of your collection name

    uint256 public nextTokenIdToMint;
    address public contractOwner;

    // token id => owner
    mapping(uint256 => address) internal _owners;
    // owner => token count
    mapping(address => uint256) internal _balances;
    // token id => approved address
    mapping(uint256 => address) internal _tokenApprovals;
    // owner => (operator => yes/no)
    mapping(address => mapping(address => bool)) internal _operatorApprovals;
    // token id => token uri
    mapping(uint256 => string) internal _tokenURIs;
}
