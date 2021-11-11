const main = async () => {
  const gmContractFactory = await hre.ethers.getContractFactory("GmPortal");
  const gmContract = await gmContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await gmContract.deployed();
  console.log("Contract addy:", gmContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    gmContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  /*
   * Let's try two gms now
   */
  const gmTxn = await gmContract.gm("This is gm #1");
  await gmTxn.wait();

  const gmTxn2 = await gmContract.gm("This is gm #2");
  await gmTxn2.wait();

  contractBalance = await hre.ethers.provider.getBalance(gmContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allGms = await gmContract.getAllGms();
  console.log(allGms);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
