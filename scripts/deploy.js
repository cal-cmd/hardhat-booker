async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Booker = await ethers.getContractFactory("Booker");
  const booker = await Booker.deploy("COKE", "PEPSI", { gasLimit: 4000000});

  console.log("Booker address:", booker.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
