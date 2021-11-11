const main = async () => {
  const gmContractFactory = await hre.ethers.getContractFactory("GmPortal");
  const gmContract = await gmContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });

  await gmContract.deployed();

  console.log("gmPortal address: ", gmContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
