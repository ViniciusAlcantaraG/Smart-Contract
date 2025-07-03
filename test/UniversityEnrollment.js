const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("UniversityEnrollment", function () {
  let contract;
  let owner;
  let student1;
  let student2;

  beforeEach(async function () {
    [owner, student1, student2] = await ethers.getSigners();
    const UniversityEnrollment = await ethers.getContractFactory("UniversityEnrollment");
    contract = await UniversityEnrollment.deploy();
  });

  it("should create a course", async function () {
    await contract.createCourse("Calculo", "MAE128", 2);
    const course = await contract.courses(0);
    expect(course.name).to.equal("Math");
    expect(course.maxStudents).to.equal(2);
    expect(course.code).to.equal("MAE128");
    expect(course.enrolledCount).to.equal(0);
  });

  it("should enroll students", async function () {
    await contract.createCourse("Fisica", "FIS101",1);
    await contract.connect(student1).enroll(0);
    expect(await contract.isEnrolled(0, student1.address)).to.be.true;
    await expect(contract.connect(student2).enroll(0)).to.be.revertedWith("Course is full");
  });

  it("should not enroll twice", async function () {
    await contract.createCourse("Quimica", "IQQ101", 2);
    await contract.connect(student1).enroll(0);
    await expect(contract.connect(student1).enroll(0)).to.be.revertedWith("Already enrolled");
  });
});
