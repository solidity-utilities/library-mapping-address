// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

/// @title Organizes methods that may be attached to `mapping(address => address)` type
/// @notice **Warning** any value of `address(0x0)` is treated as _null_ or _undefined_
/// @author S0AndS0
library LibraryMappingAddress {
    /// @notice Retrieves stored value `address` or throws an error if _undefined_
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key `address` to lookup corresponding value `address` for
    /// @return **{address}** Value for given key `address`
    /// @custom:throws **{Error}** `"LibraryMappingAddress.get: value not defined"`
    function get(mapping(address => address) storage _self, address _key)
        external
        view
        returns (address)
    {
        address _value = _self[_key];
        require(
            _value != address(0x0),
            "LibraryMappingAddress.get: value not defined"
        );
        return _value;
    }

    /// @notice Retrieves stored value `address` or provided default `address` if _undefined_
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key `address` to lookup corresponding value `address` for
    /// @param _default **{address}** Value to return if key `address` lookup is _undefined_
    /// @return **{address}** Value `address` for given key `address` or `_default` if _undefined_
    function getOrElse(
        mapping(address => address) storage _self,
        address _key,
        address _default
    ) external view returns (address) {
        address _value = _self[_key];
        return _value != address(0x0) ? _value : _default;
    }

    /// @notice Allows for defining custom error reason if value `address` is _undefined_
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key `address` to lookup corresponding value `address` for
    /// @param _reason **{string}** Custom error message to throw if value `address` is _undefined_
    /// @return **{address}** Value for given key `address`
    /// @custom:throws **{Error}** _reason if value is _undefined_
    function getOrError(
        mapping(address => address) storage _self,
        address _key,
        string memory _reason
    ) external view returns (address) {
        address _value = _self[_key];
        require(_value != address(0x0), _reason);
        return _value;
    }

    /// @notice Check if `address` key has a corresponding value `address` defined
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to check if value `address` is defined
    /// @return **{bool}** true if value `address` is defined, or `false` if _undefined_
    function has(mapping(address => address) storage _self, address _key)
        external
        view
        returns (bool)
    {
        return _self[_key] != address(0x0);
    }

    /// @notice Store `_value` under given `_key` **without** preventing unintentional overwrites
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to set corresponding value `address` for
    /// @param _value **{address}** Mapping value to set
    /// @custom:throws **{Error}** `"LibraryMappingAddress.overwrite: value cannot be 0x0"`
    function overwrite(
        mapping(address => address) storage _self,
        address _key,
        address _value
    ) external {
        require(
            _value != address(0x0),
            "LibraryMappingAddress.overwrite: value cannot be 0x0"
        );
        _self[_key] = _value;
    }

    /// @notice Store `_value` under given `_key` **without** preventing unintentional overwrites
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to set corresponding value `address` for
    /// @param _value **{address}** Mapping value to set
    /// @param _reason **{string}** Custom error message to present if value `address` is `0x0`
    /// @custom:throws **{Error}** `_reason` if value is `0x0`
    function overwriteOrError(
        mapping(address => address) storage _self,
        address _key,
        address _value,
        string memory _reason
    ) external {
        require(_value != address(0x0), _reason);
        _self[_key] = _value;
    }

    /// @notice Delete value `address` for given `_key`
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to delete corresponding value `address` for
    /// @return **{address}** Stored value `address` for given key `address`
    /// @custom:throws **{Error}** `"LibraryMappingAddress.remove: value not defined"`
    function remove(mapping(address => address) storage _self, address _key)
        external
        returns (address)
    {
        address _value = _self[_key];
        require(
            _value != address(0x0),
            "LibraryMappingAddress.remove: value not defined"
        );
        delete _self[_key];
        return _value;
    }

    /// @notice Delete value `address` for given `_key`
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to delete corresponding value `address` for
    /// @param _reason **{string}** Custom error message to throw if value `address` is _undefined_
    /// @return **{address}** Stored value `address` for given key `address`
    /// @custom:throws **{Error}** _reason if value is _undefined_
    function removeOrError(
        mapping(address => address) storage _self,
        address _key,
        string memory _reason
    ) external returns (address) {
        address _value = _self[_key];
        require(_value != address(0x0), _reason);
        delete _self[_key];
        return _value;
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to set corresponding value `address` for
    /// @param _value **{address}** Mapping value to set
    /// @custom:throws **{Error}** `"LibraryMappingAddress.set: value already defined"`
    /// @custom:throws **{Error}** `"LibraryMappingAddress.set: value cannot be 0x0"`
    function set(
        mapping(address => address) storage _self,
        address _key,
        address _value
    ) external {
        require(
            _self[_key] == address(0x0),
            "LibraryMappingAddress.set: value already defined"
        );
        require(
            _value != address(0x0),
            "LibraryMappingAddress.set: value cannot be 0x0"
        );
        _self[_key] = _value;
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to set corresponding value `address` for
    /// @param _value **{address}** Mapping value to set
    /// @param _reason **{string}** Custom error message to present if value `address` is defined
    /// @custom:throws **{Error}** _reason if value is defined
    /// @custom:throws **{Error}** `"LibraryMappingAddress.setOrError: value cannot be 0x0"`
    function setOrError(
        mapping(address => address) storage _self,
        address _key,
        address _value,
        string memory _reason
    ) external {
        require(_self[_key] == address(0x0), _reason);
        require(
            _value != address(0x0),
            "LibraryMappingAddress.setOrError: value cannot be 0x0"
        );
        _self[_key] = _value;
    }
}
