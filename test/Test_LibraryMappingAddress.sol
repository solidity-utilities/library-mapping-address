// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import { LibraryMappingAddress } from "../contracts/LibraryMappingAddress.sol";

///
contract Test_LibraryMappingAddress {
    using LibraryMappingAddress for mapping(address => address);
    mapping(address => address) public data;

    address _key = address(0x1);
    address _value = address(0x2);
    address _default_value = address(0x3);

    ///
    function afterEach() public {
        if (data.has(_key)) {
            data.remove(_key);
        }
    }

    ///
    function test_get_error() public {
        try data.get(_key) returns (address _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingAddress.get: value not defined",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_getOrElse() public {
        address _got = data.getOrElse(_key, _default_value);
        Assert.equal(_got, _default_value, "Failed to get default value");
    }

    ///
    function test_getOrError() public {
        try
            data.getOrError(
                _key,
                "Test_LibraryMappingAddress.test_getOrError: value not defined"
            )
        returns (address _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "Test_LibraryMappingAddress.test_getOrError: value not defined",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_has() public {
        Assert.isFalse(data.has(_key), "Somehow key/value was defined");
        data.set(_key, _value);
        Assert.isTrue(data.has(_key), "Failed to define key/value pair");
    }

    ///
    function test_remove_error() public {
        try data.remove(_key) returns (address _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingAddress.remove: value not defined",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_removeOrError() public {
        try
            data.removeOrError(
                _key,
                "Test_LibraryMappingAddress.test_removeOrError: value not defined"
            )
        returns (address _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "Test_LibraryMappingAddress.test_removeOrError: value not defined",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_set() public {
        data.set(_key, _value);
        address _got = data.get(_key);
        Assert.equal(_got, _value, "Failed to get expected value");
    }

    ///
    function test_set_error() public {
        data.set(_key, _value);
        try data.set(_key, _value) {
            Assert.isTrue(false, "Failed to catch expected error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingAddress.set: value already defined",
                "Caught unexpected error reason"
            );
        }
        data.remove(_key);
        Assert.isFalse(data.has(_key), "Failed to remove value by key");
    }

    ///
    function test_setOrError() public {
        data.set(_key, _value);
        try
            data.setOrError(
                _key,
                _value,
                "Test_LibraryMappingAddress.test_setOrError: value already defined"
            )
        {
            Assert.isTrue(false, "Failed to catch expected error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "Test_LibraryMappingAddress.test_setOrError: value already defined",
                "Caught unexpected error reason"
            );
        }
        data.remove(_key);
        Assert.isFalse(data.has(_key), "Failed to remove value by key");
    }
}
