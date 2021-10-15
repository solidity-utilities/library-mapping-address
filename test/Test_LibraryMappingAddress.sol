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
        string memory _custom_reason = "test_getOrError: customized error";
        try data.getOrError(_key, _custom_reason) returns (address _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
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
    function test_overwrite() public {
        data.set(_key, _value);
        address _got = data.get(_key);
        Assert.equal(_got, _value, "Failed to get expected value");
        data.overwrite(_key, _default_value);
        address _new_got = data.get(_key);
        Assert.equal(_new_got, _default_value, "Failed to get expected value");
    }

    ///
    function test_overwrite_error() public {
        try data.overwrite(_key, address(0x0)) {
            Assert.isTrue(false, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingAddress.overwrite: value cannot be 0x0",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_overwriteOrError() public {
        string
            memory _custom_reason = "test_overwriteOrError: customized error";
        try data.overwriteOrError(_key, address(0x0), _custom_reason) {
            Assert.isTrue(false, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
                "Caught unexpected error reason"
            );
        }
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
        string memory _custom_reason = "test_removeOrError: customized error";
        try data.removeOrError(_key, _custom_reason) returns (address _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
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
        string memory _custom_reason = "test_setOrError: customized error";
        data.set(_key, _value);
        try data.setOrError(_key, _value, _custom_reason) {
            Assert.isTrue(false, "Failed to catch expected error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
                "Caught unexpected error reason"
            );
        }
        data.remove(_key);
        Assert.isFalse(data.has(_key), "Failed to remove value by key");
    }
}
