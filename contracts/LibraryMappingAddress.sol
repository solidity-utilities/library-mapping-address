// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

/// @title Organizes methods that may be attached to `mapping(address => address)` type
/// @notice **Warning** any value of `address(0x0)` is treated as _null_ or _undefined_
/// @author S0AndS0
library LibraryMappingAddress {
    /// @notice Retrieves stored value `address` or throws an error if _undefined_
    /// @dev Passes parameters to `getOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key `address` to lookup corresponding value `address` for
    /// @return **{address}** Value for given key `address`
    /// @custom:throws **{Error}** `"LibraryMappingAddress.get: value not defined"`
    function get(mapping(address => address) storage _self, address _key)
        public
        view
        returns (address)
    {
        return
            getOrError(
                _self,
                _key,
                "LibraryMappingAddress.get: value not defined"
            );
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
    ) public view returns (address) {
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
    ) public view returns (address) {
        address _value = _self[_key];
        require(_value != address(0x0), _reason);
        return _value;
    }

    /// @notice Check if `address` key has a corresponding value `address` defined
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to check if value `address` is defined
    /// @return **{bool}** true if value `address` is defined, or `false` if _undefined_
    function has(mapping(address => address) storage _self, address _key)
        public
        view
        returns (bool)
    {
        return _self[_key] != address(0x0);
    }

    /// @notice Delete value `address` for given `_key`
    /// @dev Passes parameters to `removeOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to delete corresponding value `address` for
    /// @return **{address}** Stored value `address` for given key `address`
    /// @custom:throws **{Error}** `"LibraryMappingAddress.remove: value not defined"`
    function remove(mapping(address => address) storage _self, address _key)
        public
        returns (address)
    {
        return
            removeOrError(
                _self,
                _key,
                "LibraryMappingAddress.remove: value not defined"
            );
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
    ) public returns (address) {
        address _value = _self[_key];
        require(_value != address(0x0), _reason);
        delete _self[_key];
        return _value;
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @dev Passes parameters to `setOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to set corresponding value `address` for
    /// @param _value **{address}** Mapping value to set
    /// @custom:throws **{Error}** `"LibraryMappingAddress.set: value already defined"`
    function set(
        mapping(address => address) storage _self,
        address _key,
        address _value
    ) public {
        setOrError(
            _self,
            _key,
            _value,
            "LibraryMappingAddress.set: value already defined"
        );
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @param _self **{mapping(address => address)}** Mapping of key/value `address` pairs
    /// @param _key **{address}** Mapping key to set corresponding value `address` for
    /// @param _value **{address}** Mapping value to set
    /// @param _reason **{string}** Custom error message to present if value `address` is defined
    /// @custom:throws **{Error}** _reason if value is defined
    function setOrError(
        mapping(address => address) storage _self,
        address _key,
        address _value,
        string memory _reason
    ) public {
        require(_self[_key] == address(0x0), _reason);
        _self[_key] = _value;
    }
}
