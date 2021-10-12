"use strict";

const LibraryMappingAddress = artifacts.require("LibraryMappingAddress");
const Account = artifacts.require("Account");
const AccountStorage = artifacts.require("AccountStorage");

//
contract("test/examples/AccountStorage.sol", (accounts) => {
  const owner_AccountStorage = accounts[0];
  const owner_Account = accounts[1];
  const owner_Account__name = "Jain";

  //
  afterEach(async () => {
    const instance = await AccountStorage.deployed();
    if (await instance.has(owner_Account)) {
      await instance.remove(owner_Account);
    }
  });

  //
  it("AccountStorage.get allows for contract reconstitution", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    await instance.set(owner_Account, contract.address, {
      from: owner_AccountStorage,
    });

    const got_address = await instance.get(owner_Account);
    const got_contract = await Account.at(got_address);
    const got_name = await got_contract.name();

    assert.equal(got_name, owner_Account__name, "Wat!?");
  });

  //
  it("AccountStorage.has returns true/false where expected", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    assert.isFalse(await instance.has(owner_Account), "Account was detected");

    await instance.set(owner_Account, contract.address, {
      from: owner_AccountStorage,
    });

    return assert.isTrue(
      await instance.has(owner_Account),
      "Account not detected"
    );
  });

  //
  it("AccountStorage.listKeys returns an array of addresses", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    assert.deepEqual([], await instance.listKeys(), "Key list not empty");

    await instance.set(owner_Account, contract.address, {
      from: owner_AccountStorage,
    });

    return assert.deepEqual(
      [owner_Account],
      await instance.listKeys(),
      "Key list is empty"
    );
  });

  //
  it("AccountStorage.remove allowed from owner", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    await instance.set(owner_Account, contract.address, {
      from: owner_AccountStorage,
    });

    await instance.remove(owner_Account, {
      from: owner_AccountStorage,
    });

    const {
      words: [got_size],
    } = await instance.size();
    return assert.equal(got_size, 0, "AccountStorage size did not decrease");
  });

  //
  it("AccountStorage.remove disallowed from non-owner", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    await instance.set(owner_Account, contract.address, {
      from: owner_AccountStorage,
    });

    try {
      await instance.remove(owner_Account, {
        from: accounts[9],
      });
    } catch (error) {
      if (
        error.reason === "AccountStorage.remove: Message sender not an owner"
      ) {
        return assert.isTrue(true, "Wat!?");
      }
      console.error({ error });
    }

    return assert.isTrue(false, "Failed to catch expected error reason");
  });

  //
  it("AccountStorage.set allowed from owner", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    await instance.set(owner_Account, contract.address, {
      from: owner_AccountStorage,
    });

    assert.isTrue(
      await instance.has(owner_Account),
      "Failed to set key/value pair"
    );
  });

  //
  it("AccountStorage.set disallowed from non-owner", async () => {
    const instance = await AccountStorage.deployed();
    const contract = await Account.deployed();

    try {
      await instance.set(owner_Account, contract.address, {
        from: accounts[9],
      });
    } catch (error) {
      if (error.reason === "AccountStorage.set: Message sender not an owner") {
        return assert.isTrue(true, "Wat!?");
      }
      console.error({ error });
    }

    return assert.isTrue(false, "Failed to catch expected error reason");
  });
});
