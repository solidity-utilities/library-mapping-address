// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

// import {
//     LibraryMappingAddress
// } from "@solidity-utilities/mapped-addresses/contracts/LibraryMappingAddress.sol";
import { LibraryMappingAddress } from "../../contracts/LibraryMappingAddress.sol";

/// @title Example contract to be stored and retrieved by `AccountStorage`
/// @author S0AndS0
contract Account {
    address payable public owner;
    string public name;

    constructor(address payable _owner, string memory _name) {
        owner = _owner;
        name = _name;
    }
}

/// @title Programming interface for storing contracts within custom mapping
/// @author S0AndS0
contract AccountStorage {
    using LibraryMappingAddress for mapping(address => address);
    mapping(address => address) data;
    mapping(address => uint256) indexes;
    address[] public keys;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    /// @notice Requires message sender to be an instance owner
    /// @param _caller {string} Function name that implements this modifier
    modifier onlyOwner(string memory _caller) {
        string memory _message = string(
            abi.encodePacked(
                "AccountStorage.",
                _caller,
                ": Message sender not an owner"
            )
        );
        require(msg.sender == owner, _message);
        _;
    }

    /// @notice Converts `LibraryMappingAddress.get` value `address`
    /// @param _key {address}
    /// @return Account
    /// @custom:throws {Error} `"LibraryMappingAddress.get: value not defined"`
    function get(address _key) public view returns (Account) {
        return Account(data.get(_key));
    }

    /// @notice Presents `LibraryMappingAddress.has` result for stored `data`
    /// @return bool
    function has(address _key) public view returns (bool) {
        return data.has(_key);
    }

    /// @notice Allow full read access to all `keys` stored by `data`
    /// @dev **Warning** Key order is not guarantied
    /// @return address[]
    function listKeys() public view returns (address[] memory) {
        return keys;
    }

    /// @notice Converts `LibraryMappingAddress.remove` value `address`
    /// @dev **Warning** Overwrites current key with last key
    /// @return Account
    /// @custom:javascript Returns transaction object
    /// @custom:throws {Error} `"AccountStorage.remove: Message sender not an owner"`
    /// @custom:throws {Error} `"LibraryMappingAddress.remove: value not defined"`
    function remove(address _key) public onlyOwner("remove") returns (Account) {
        address _value = data.remove(_key);

        uint256 _target_index = indexes[_key];
        uint256 _last_index = keys.length - 1;
        address _last_key = keys[_last_index];
        keys[_target_index] = keys[_last_index];
        indexes[_last_key] = _target_index;

        keys.pop();
        return Account(_value);
    }

    /// @notice Convert `_value` for `LibraryMappingAddress.set`
    /// @param _key {address}
    /// @param _value {Account}
    /// @custom:throws {Error} `"AccountStorage.set: Message sender not an owner"`
    /// @custom:throws {Error} `"LibraryMappingAddress.set: value already defined"`
    function set(address _key, Account _value) public onlyOwner("set") {
        data.set(_key, address(_value));
        keys.push(_key);
    }

    /// @notice Allow callers access to `keys.length`
    /// @return uint256 Length of keys `address` array
    /// @custom:javascript Returns `BN` data object
    function size() public view returns (uint256) {
        return keys.length;
    }
}
