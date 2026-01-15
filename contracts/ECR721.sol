// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IERC721Receiver.sol";

contract ERC721 {
    string public name; // e.g CryptoPunks
    string public symbol; // e.gϾ it's a short abbreviation of your collection name

    uint256 public nextTokenIdToMint;
    address public contractOwner;

    // NFTs(token) id => owner
    // Who owns which NFT?
    // Usage: _owners[3] = Ali means "Ali owns NFT #3"ß
    mapping(uint256 => address) internal _owners;
    // owner => NFTs(token) count
    // How many NFTs does each owner have?
    // Usage: _balances[Ali] = 5 means "Ali has 5 NFTs"ß
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
    // Where is the NFT's image/data stored?
    // This links to a JSON file with the NFT's name, description, and image URL.
    // uint256(TokenID) => string(URI (link to metadata))
    // 0	                "ipfs://Qm123.../0.json"
    // 1	                "ipfs://Qm123.../1.json"
    mapping(uint256 => string) internal _tokenURIs;

    //📢 "NFT #5 was transferred FROM 0xAli TO 0xSara"
    // Usage: emit Transfer(0xAli, 0xSara, 5);
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed _tokenId
    );

    //📢 "0xAli approved (0xSara or OpenSea) to sell/transfer NFT #5"
    // Usage: emit Approval(0xAli, 0xOpenSea, 3);
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed _tokenId
    );
    //📢 "0xAli gave 0xOpenSea permission to manage ALL their NFTs"
    // Usage: emit ApprovalForAll(0xAli, 0xOpenSea, true);
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool _approved
    );

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        nextTokenIdToMint = 0;
        contractOwner = msg.sender;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return _owners[_tokenId];
    }

    // INTERNAL FUNCTIONS
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        // check if to is an contract, if yes then to.code.length will always > 0
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    // No error message - generic error
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    /// @solidity memory-safe-assembly
                    // Has error message - forward it
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    // unsafe transfer
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "!Owner");
        require(_to != address(0), "!ToAdd0");

        delete _tokenApprovals[_tokenId];
        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId)
    }
}
