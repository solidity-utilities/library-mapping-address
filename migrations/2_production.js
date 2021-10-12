"use strict";

const LibraryMappingAddress = artifacts.require("LibraryMappingAddress");

module.exports = (deployer, _network, _accounts) => {
  deployer.deploy(LibraryMappingAddress);
};
