"use strict";

module.exports = (deployer, network, accounts) => {
  if (network !== "development") {
    return;
  }

  console.log("Notice: detected network of development kind ->", { network });

  const owner_AccountStorage = accounts[0];
  const owner_Account = accounts[1];
  const owner_Account__name = "Jain";

  const LibraryMappingAddress = artifacts.require("LibraryMappingAddress");
  deployer.deploy(LibraryMappingAddress);

  const Account = artifacts.require("Account");
  const AccountStorage = artifacts.require("AccountStorage");

  deployer.link(LibraryMappingAddress, AccountStorage);

  deployer.deploy(Account, owner_Account, owner_Account__name);
  deployer.deploy(AccountStorage, owner_AccountStorage);
};
