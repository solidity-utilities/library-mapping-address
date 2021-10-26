# Library Mapping Address
[heading__library_mapping_address]:
  #library-mapping-address
  "&#x2B06; Solidity library for mapping addresses"


Solidity library for mapping addresses


## [![Byte size of Library Mapping Address][badge__main__library_mapping_address__source_code]][library_mapping_address__main__source_code] [![Open Issues][badge__issues__library_mapping_address]][issues__library_mapping_address] [![Open Pull Requests][badge__pull_requests__library_mapping_address]][pull_requests__library_mapping_address] [![Latest commits][badge__commits__library_mapping_address__main]][commits__library_mapping_address__main]  [![Build Status][badge__github_actions]][activity_log__github_actions]


---


- [:arrow_up: Top of Document][heading__library_mapping_address]

- [:building_construction: Requirements][heading__requirements]

- [:zap: Quick Start][heading__quick_start]

- [&#x1F9F0; Usage][heading__usage]

- [&#x1F523; API][heading__api]
  - [Library `LibraryMappingAddress`][heading__library_librarymappingaddress]
    - [Method `get`][heading__method_get]
    - [Method `getOrElse`][heading__method_getorelse]
    - [Method `getOrError`][heading__method_getorerror]
    - [Method `has`][heading__method_has]
    - [Method `overwrite`][heading__method_overwrite]
    - [Method `overwriteOrError`][heading__method_overwriteorerror]
    - [Method `remove`][heading__method_remove]
    - [Method `removeOrError`][heading__method_removeorerror]
    - [Method `set`][heading__method_set]
    - [Method `setOrError`][heading__method_setorerror]

- [&#x1F5D2; Notes][heading__notes]

- [:chart_with_upwards_trend: Contributing][heading__contributing]
  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]

- [:card_index: Attribution][heading__attribution]

- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


> Prerequisites and/or dependencies that this project needs to function properly


This project utilizes Truffle for organization of source code and tests, thus
it is recommended to install Truffle _globally_ to your current user account


```Bash
npm install -g truffle
```


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


> Perhaps as easy as one, 2.0,...


NPM and Truffle are recommended for importing and managing project dependencies


```Bash
cd your_project

npm install @solidity-utilities/library-mapping-address
```


> Note, source code for this library will be located within the
> `node_modules/@solidity-utilities/library-mapping-address` directory of
> _`your_project`_ root


Solidity contracts may then import code via similar syntax as shown


```Solidity
import {
    LibraryMappingAddress
} from "@solidity-utilities/library-mapping-address/contracts/LibraryMappingAddress.sol";
```


> Note, above path is **not** relative (ie. there's no `./` preceding the file
> path) which causes Truffle to search the `node_modules` sub-directories


Review the
[Truffle -- Package Management via NPM][truffle__package_management_via_npm]
documentation for more installation details.


---


Alternatively this library may be installed via Truffle, eg...


```Bash
cd your_project

truffle install library-mapping-address
```

... However, if utilizing Truffle for dependency management Solidity contracts
must import code via a slightly different path


```Solidity
import {
    LibraryMappingAddress
} from "library-mapping-address/contracts/LibraryMappingAddress.sol";
```


---


> In the future, after beta testers have reported bugs and feature requests, it
> should be possible to link the deployed `LibraryMappingAddress` via Truffle
> migration similar to the following.
>
>
> **`migrations/2_your_contract.js`**
>
>
>     const LibraryMappingAddress = artifacts.require("LibraryMappingAddress");
>     const YourContract = artifacts.require("YourContract");
>
>     module.exports = (deployer, _network, _accounts) {
>       LibraryMappingAddress.address = "0x0...";
>       // deployer.deploy(LibraryMappingAddress, { overwrite: false });
>       deployer.link(LibraryMappingAddress, YourContract);
>       deployer.deploy(YourContract);
>     };


______


## Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


> How to utilize this repository


Write a set of contracts that make use of, and extend, `LibraryMappingAddress` features.


```solidity
// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

import {
    LibraryMappingAddress
} from "@solidity-utilities/mapped-addresses/contracts/LibraryMappingAddress.sol";

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
```


Above the `AccountStorage` contract;


- maintains a list of keys

- restricts mutation to owner only

- converts between references (address) and references from/to `Account`


There is likely much that can be accomplished by leveraging these abstractions,
check the [API][heading__api] section for full set of features available.  And
review the
[`test/test__examples__AccountStorage.js`][source__test__test__examples__accountstorage_js]
file for inspiration on how to use this library within projects.


______


## API
[heading__api]:
  #api
  "Application Programming Interfaces for Solidity smart contracts"


> Application Programming Interfaces for Solidity smart contracts


**Developer note** -> Check the [`test/`][source__test] directory for
JavaScript and Solidity usage examples


---


### Library `LibraryMappingAddress`
[heading__library_librarymappingaddress]:
  #library-librarymappingaddress
  "Organizes methods that may be attached to `mapping(address => address)` type"


> Organizes methods that may be attached to `mapping(address => address)` type


**Warning** any value of `address(0x0)` is treated as _null_ or _undefined_


**Source** [`contracts/LibraryMappingAddress.sol`][source__contracts__librarymappingaddress_sol]


---


#### Method `get`
[heading__method_get]:
  #method-get
  "Retrieves stored value `address` or throws an error if _undefined_"


> Retrieves stored value `address` or throws an error if _undefined_


[**Source**][source__contracts__librarymappingaddress_sol__get] `get(mapping(address => address) _self, address _key)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key `address` to lookup corresponding value `address` for


**Returns** -> **{address}** Value for given key `address`


**Throws** -> **{Error}** `"LibraryMappingAddress.get: value not defined"`


**Developer note** -> Passes parameters to `getOrError` with default Error
`_reason` to throw


---


#### Method `getOrElse`
[heading__method_getorelse]:
  #method-getorelse
  "Retrieves stored value `address` or provided default `address` if _undefined_"


> Retrieves stored value `address` or provided default `address` if _undefined_


[**Source**][source__contracts__librarymappingaddress_sol__getorelse] `getOrElse(mapping(address => address) _self, address _key, address _default)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key `address` to lookup corresponding value `address` for

- `_default` **{address}** Value to return if key `address` lookup is _undefined_


**Returns** -> **{address}** Value `address` for given key `address` or `_default` if _undefined_


---


#### Method `getOrError`
[heading__method_getorerror]:
  #method-getorerror
  "Allows for defining custom error reason if value `address` is _undefined_"


> Allows for defining custom error reason if value `address` is _undefined_


[**Source**][source__contracts__librarymappingaddress_sol__getorerror] `getOrError(mapping(address => address) _self, address _key, string _reason)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key `address` to lookup corresponding value `address` for

- `_reason` **{string}** Custom error message to throw if value `address` is _undefined_


**Returns** -> **{address}** Value for given key `address`


**Throws** -> **{Error}** `_reason` if value is _undefined_


---


#### Method `has`
[heading__method_has]:
  #method-has
  "Check if `address` key has a corresponding value `address` defined"


> Check if `address` key has a corresponding value `address` defined


[**Source**][source__contracts__librarymappingaddress_sol__has] `has(mapping(address => address) _self, address _key)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to check if value `address` is defined


**Returns** -> **{bool}** `true` if value `address` is defined, or `false` if _undefined_


---


#### Method `overwrite`
[heading__method_overwrite]:
  #method-overwrite
  "Store `_value` under given `_key` **without** preventing unintentional overwrites"


> Store `_value` under given `_key` **without** preventing unintentional overwrites


[**Source**][source__contracts__librarymappingaddress_sol__overwrite] `overwrite(mapping(address => address) _self, address _key, address _value)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to set corresponding value `address` for

- `_value` **{address}** Mapping value to set


**Throws** ->  **{Error}** `"LibraryMappingAddress.overwrite: value cannot be 0x0"`


**Developer note** -> Passes parameters to `overwriteOrError` with default
Error `_reason` to throw


---


#### Method `overwriteOrError`
[heading__method_overwriteorerror]:
  #method-overwriteorerror
  "Store `_value` under given `_key` **without** preventing unintentional overwrites"


> Store `_value` under given `_key` **without** preventing unintentional overwrites


[**Source**][source__contracts__librarymappingaddress_sol__overwriteorerror] `overwriteOrError(mapping(address => address) _self, address _key, address _value, string _reason)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to set corresponding value `address` for

- `_value` **{address}** Mapping value to set

- `_reason` **{string}** Custom error message to present if value `address` is `0x0`


**Throws** -> **{Error}** `_reason` if value is `0x0`


---


#### Method `remove`
[heading__method_remove]:
  #method-remove
  "Delete value `address` for given `_key`"


> Delete value `address` for given `_key`


[**Source**][source__contracts__librarymappingaddress_sol__remove] `remove(mapping(address => address) _self, address _key)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to delete corresponding value `address` for


**Returns** -> **{address}** Value for given key `address`


**Throws** -> **{Error}** `"LibraryMappingAddress.remove: value not defined"`


**Developer note** -> Passes parameters to `removeOrError` with default Error
`_reason` to throw


---


#### Method `removeOrError`
[heading__method_removeorerror]:
  #method-removeorerror
  "Delete value `address` for given `_key`"


> Delete value `address` for given `_key`


[**Source**][source__contracts__librarymappingaddress_sol__removeorerror] `removeOrError(mapping(address => address) _self, address _key, string _reason)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to delete corresponding value `address` for

- `_reason` **{string}** Custom error message to throw if value `address` is _undefined_


**Returns** -> {address} Stored value `address` for given key `address`


**Throws** -> **{Error}** `_reason` if value is _undefined_


---


#### Method `set`
[heading__method_set]:
  #method-set
  "Store `_value` under given `_key` while preventing unintentional overwrites"


> Store `_value` under given `_key` while preventing unintentional overwrites


[**Source**][source__contracts__librarymappingaddress_sol__set] `set(mapping(address => address) _self, address _key, address _value)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to set corresponding value `address` for

- `_value` **{address}** Mapping value to set


**Throws** -> **{Error}** `"LibraryMappingAddress.set: value already defined"`


**Developer note** -> Passes parameters to `setOrError` with default Error
`_reason` to throw


---


#### Method `setOrError`
[heading__method_setorerror]:
  #method-setorerror
  "Store `_value` under given `_key` while preventing unintentional overwrites"


> Stores `_value` under given `_key` while preventing unintentional overwrites


[**Source**][source__contracts__librarymappingaddress_sol__setorerror] `setOrError(mapping(address => address) _self, address _key, address _value, string _reason)`


**Parameters**


- `_self` **{mapping(address => address)}** Mapping of key/value `address` pairs

- `_key` **{address}** Mapping key to set corresponding value `address` for

- `_value` **{address}** Mapping value to set

- `_reason` **{string}** Custom error message to present if value `address` is defined


**Throws** -> **{Error}**  `_reason` if value is defined


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


> Additional things to keep in mind when developing


Solidity libraries provide methods for a given type **only** for the `contract`
that is _`using`_ the library, review the [Usage][heading__usage] example for
details on how to _forward_ library features to external consumers.


---


This repository may not be feature complete and/or fully functional, Pull
Requests that add features or fix bugs are certainly welcomed.


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to library-mapping-address and solidity-utilities"


Options for contributing to library-mapping-address and solidity-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking `library-mapping-address`"


> Tips for forking `library-mapping-address`


Make a [Fork][library_mapping_address__fork_it] of this repository to an
account that you have write permissions for.


- Clone fork URL. The URL syntax is _`git@github.com:<NAME>/<REPO>.git`_, then add this repository as a remote...


```Bash
mkdir -p ~/git/hub/solidity-utilities

cd ~/git/hub/solidity-utilities

git clone --origin fork git@github.com:<NAME>/library-mapping-address.git

git remote add origin git@github.com:solidity-utilities/library-mapping-address.git
```


- Install development dependencies


```Bash
cd ~/git/hub/solidity-utilities/library-mapping-address

npm ci
```


> Note, the `ci` option above is recommended instead of `install` to avoid
> mutating the `package.json`, and/or `package-lock.json`, file(s) implicitly


- Commit your changes and push to your fork, eg. to fix an issue...


```Bash
cd ~/git/hub/solidity-utilities/library-mapping-address


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```


- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_


> Note; to decrease the chances of your Pull Request needing modifications
> before being accepted, please check the
> [dot-github](https://github.com/solidity-utilities/.github) repository for
> detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting `solidity-utilities` that maintains `library-mapping-address`"


> Methods for financially supporting `solidity-utilities` that maintains
> `library-mapping-address`


Thanks for even considering it!


Via Liberapay you may
<sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a
repeating basis.


For non-repeating contributions Ethereum is accepted via the following public address;


    0x5F3567160FF38edD5F32235812503CA179eaCbca


Regardless of if you're able to financially support projects such as
`library-mapping-address` that `solidity-utilities` maintains, please consider
sharing projects that are useful with others, because one of the goals of
maintaining Open Source repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


> Resources that where helpful in building this project so far.


- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)

- [Husky Docs](https://typicode.github.io/husky/#/)

- [NPM -- Creating and Publishing an Organization Scoped Package](https://docs.npmjs.com/creating-and-publishing-an-organization-scoped-package)

- [Solidity Docs -- Compiler Input and Output JSON Description](https://docs.soliditylang.org/en/develop/using-the-compiler.html#compiler-input-and-output-json-description)

- [Solidity Docs -- Error handling: Assert, Require, Revert and Exceptions](https://docs.soliditylang.org/en/develop/control-structures.html?highlight=require#error-handling-assert-require-revert-and-exceptions)

- [Solidity Docs -- NatSpec Format](https://docs.soliditylang.org/en/v0.8.9/natspec-format.html)

- [Solidity Docs -- Using the Compiler -- Linking Libraries](https://docs.soliditylang.org/en/latest/using-the-compiler.html#index-2)

- [StackExchange Ethereum -- How can I reference a deployed library in my solidity contract](https://ethereum.stackexchange.com/questions/107891/)

- [StackExchange Ethereum -- Start up ganache-cli ethereum client in travis CI for testing](https://ethereum.stackexchange.com/questions/42648/)

- [Truffle -- Package Managment via NPM](https://www.trufflesuite.com/docs/truffle/getting-started/package-management-via-npm)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


> Legal side of Open Source


```
Solidity library for mapping addresses
Copyright (C) 2021 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of
[AGPL-3.0][branch__current__license] License.



[branch__current__license]:
  LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"


[badge__commits__library_mapping_address__main]:
  https://img.shields.io/github/last-commit/solidity-utilities/library-mapping-address/main.svg

[commits__library_mapping_address__main]:
  https://github.com/solidity-utilities/library-mapping-address/commits/main
  "&#x1F4DD; History of changes on this branch"


[library_mapping_address__community]:
  https://github.com/solidity-utilities/library-mapping-address/community
  "&#x1F331; Dedicated to functioning code"


[issues__library_mapping_address]:
  https://github.com/solidity-utilities/library-mapping-address/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[library_mapping_address__fork_it]:
  https://github.com/solidity-utilities/library-mapping-address/fork
  "&#x1F531; Fork it!"

[pull_requests__library_mapping_address]:
  https://github.com/solidity-utilities/library-mapping-address/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[library_mapping_address__main__source_code]:
  https://github.com/solidity-utilities/library-mapping-address/
  "&#x2328; Project source!"

[badge__issues__library_mapping_address]:
  https://img.shields.io/github/issues/solidity-utilities/library-mapping-address.svg

[badge__pull_requests__library_mapping_address]:
  https://img.shields.io/github/issues-pr/solidity-utilities/library-mapping-address.svg

[badge__main__library_mapping_address__source_code]:
  https://img.shields.io/github/repo-size/solidity-utilities/library-mapping-address


[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=solidity-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/solidity-utilities
  "&#x1F4B1; Sponsor developments and projects that solidity-utilities maintains via Liberapay"


[badge__github_actions]:
  https://img.shields.io/github/workflow/status/solidity-utilities/address-storage/test?event=push

[activity_log__github_actions]:
  https://github.com/solidity-utilities/address-storage/deployments/activity_log


[truffle__package_management_via_npm]:
  https://www.trufflesuite.com/docs/truffle/getting-started/package-management-via-npm
  "Documentation on how to install, import, and interact with Solidity packages"


[source__test]:
  test
  "CI/CD (Continuous Integration/Deployment) tests and examples"

[source__test__test__examples__accountstorage_js]:
  test/test__examples__AccountStorage.js
  "JavaScript code for testing test/examples/AccountStorage.sol"

[source__contracts__librarymappingaddress_sol]:
  contracts/LibraryMappingAddress.sol
  "Solidity code for LibraryMappingAddress"

[source__contracts__librarymappingaddress_sol__get]:
  contracts/LibraryMappingAddress.sol#L8
  "Solidity code for LibraryMappingAddress.get function"

[source__contracts__librarymappingaddress_sol__getorelse]:
  contracts/LibraryMappingAddress.sol#L27
  "Solidity code for LibraryMappingAddress.getOrElse function"

[source__contracts__librarymappingaddress_sol__getorerror]:
  contracts/LibraryMappingAddress.sol#L41
  "Solidity code for LibraryMappingAddress.getOrError function"

[source__contracts__librarymappingaddress_sol__has]:
  contracts/LibraryMappingAddress.sol#L57
  "Solidity code for LibraryMappingAddress.has function"

[source__contracts__librarymappingaddress_sol__overwrite]:
  contracts/LibraryMappingAddress.sol#L69
  "Solidity code for LibraryMappingAddress.overwrite function"

[source__contracts__librarymappingaddress_sol__overwriteorerror]:
  contracts/LibraryMappingAddress.sol#L88
  "Solidity code for LibraryMappingAddress.overwriteOrError function"

[source__contracts__librarymappingaddress_sol__remove]:
  contracts/LibraryMappingAddress.sol#L104
  "Solidity code for LibraryMappingAddress.remove function"

[source__contracts__librarymappingaddress_sol__removeorerror]:
  contracts/LibraryMappingAddress.sol#L122
  "Solidity code for LibraryMappingAddress.removeOrError function"

[source__contracts__librarymappingaddress_sol__set]:
  contracts/LibraryMappingAddress.sol#L139
  "Solidity code for LibraryMappingAddress.set function"

[source__contracts__librarymappingaddress_sol__setorerror]:
  contracts/LibraryMappingAddress.sol#L158
  "Solidity code for LibraryMappingAddress.setOrError function"

