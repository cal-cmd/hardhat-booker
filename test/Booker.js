const { expect } = require("chai");

describe("Booker contract", function () {
  it("should allow only booking one reservation", async function () {
    const [owner] = await ethers.getSigners();

    const Booker = await ethers.getContractFactory("Booker");

    const booker = await Booker.deploy("COKE", "PEPSI");
    
    await expect(booker.book(1, 12, "COKE"))
    .to.emit(booker, 'Booked')
    .withArgs(owner.address, 1, 12, "COKE");

    await expect(booker.book(1, 13, "PEPSI")
    ).to.be.revertedWith("Already booked for another room");
  });

  it("shouldn't allow booking a reservation outside of certain hours or using the wrong company", async function () {
    const [owner] = await ethers.getSigners();

    const Booker = await ethers.getContractFactory("Booker");

    const booker = await Booker.deploy("COKE", "PEPSI");

    await expect(booker.book(10, 21, "PEPSI")
    ).to.be.revertedWith("Please book between the hours of: 8-20");

    await expect(booker.book(10, 20, "JONES")
    ).to.be.revertedWith("Company/room not found");
  });
  
  it("should cancel a reservation", async function () {
    const [owner] = await ethers.getSigners();

    const Booker = await ethers.getContractFactory("Booker");

    const booker = await Booker.deploy("COKE", "PEPSI");
    
    await expect(booker.book(1, 12, "COKE"))
    .to.emit(booker, 'Booked')
    .withArgs(owner.address, 1, 12, "COKE");

    await expect(booker.cancel())
    .to.emit(booker, 'Cancelled')
    .withArgs(owner.address, "COKE");
  });

  it("should check if the room is available", async function () {
    const [owner] = await ethers.getSigners();

    const Booker = await ethers.getContractFactory("Booker");

    const booker = await Booker.deploy("COKE", "PEPSI");
    
    expect(await booker.isRoomAvailable(1, 12, "COKE")).to.equal(true);
  });
});
