const SafeMath = artifacts.require("../contracts/common/SafeMath.sol");
const MemberOperations = artifacts.require("../contracts/libs/MemberOperations.sol");
const VotingOperations = artifacts.require("../contracts/libs/VotingOperations.sol");
const Core = artifacts.require("../contracts/Core.sol");
module.exports = (deployer) => {
	deployer.deploy(SafeMath);
	deployer.link(SafeMath, MemberOperations);
	deployer.link(SafeMath, VotingOperations);
	deployer.deploy(MemberOperations);
	deployer.deploy(VotingOperations);
	deployer.link(MemberOperations, Core);
	deployer.link(VotingOperations, Core);
	deployer.deploy(Core);
};
