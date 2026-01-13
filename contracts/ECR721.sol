// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ERC721 {
    string public name; // e.g CryptoPunks
    string public symbol; // e.gϾ it's a short abbreviation of your collection name

    uint256 public nextTokenIdToMint;
    address public contractOwner;

    // NFTs(token) id => owner
    mapping(uint256 => address) internal _owners;
    // owner => NFTs(token) count
    mapping(address => uint256) internal _balances;
    // token id => approved address(e.g openSea)
    // e.g Who can sell my specific NFT?
    // Imagine you want to let a marketplace (like OpenSea) sell your NFT #3:
    mapping(uint256 => address) internal _tokenApprovals;
    // owner => (operator => yes/no)
    // e.g Who can manage ALL my NFTs?
    // Usage: _operatorApprovals[Ali][OpenSea] = true means "OpenSea can manage ALL of Ali's NFTs"
    mapping(address => mapping(address => bool)) internal _operatorApprovals;
    // token id => token uri
    mapping(uint256 => string) internal _tokenURIs;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool _approved
    );
}
