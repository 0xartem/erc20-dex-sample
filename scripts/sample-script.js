// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Greeter = await hre.ethers.getContractFactory("Greeter");
  // const OutsourceToken = await hre.ethers.getContractFactory("OutrourceToken");
  const DEX = await hre.ethers.getContractFactory("DEX");

  const greeter = await Greeter.deploy("Hello, Hardhat!");
  // const outsourceToken = await OutsourceToken.deploy(1000000);
  const dex = await DEX.deploy();

  await greeter.deployed();
  await dex.deployed();

  console.log("Greeter deployed to:", greeter.address);
  console.log("DEX deployed to:", dex.address);
  // console.log("Token in the DEX deployed to: ", dex.token);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
