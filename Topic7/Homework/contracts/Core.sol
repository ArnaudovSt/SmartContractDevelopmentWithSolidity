pragma solidity ^0.4.18;

import './common/Destructible.sol';
import './libs/MemberOperations.sol';
import './libs/VotingOperations.sol';


contract Core is Destructible {
	using MemberOperations for MemberOperations.Data;
	MemberOperations.Data memberData;

	using VotingOperations for VotingOperations.Data;
	VotingOperations.Data votingData;

	event LogDonation(address member, uint256 time);
	event LogNewMember(address member, uint256 time);
	
	event LogNewVoting(address proposedMember, uint256 votingEnd);
	event LogSuccessfulVoting(address proposedMember);
	
	modifier validAddress(address _adr) {
		require(_adr != address(0));
		_;
	}

	function Core() public {
		memberData.addMember(msg.sender);
	}

	function addMember(address _newMember)
		external
		onlyOwner
		validAddress(_newMember)
	{
		require(!memberData.isMember(_newMember));
		memberData.addMember(_newMember);
	}

	function removeMember(address _memberToRemove)
		external
		onlyOwner
		validAddress(_memberToRemove)
	{
		require(memberData.isMember(_memberToRemove));
		require(!memberData.hasDonatedInTheLastHour(_memberToRemove));
		memberData.removeMember(_memberToRemove);
	}

	function proposeMember(address _proposedMember)
		public
		validAddress(_proposedMember)
	{
		require(memberData.hasDonatedInTheLastHour(msg.sender));
		require(!votingData.hasAlreadyBeenConsidered(_proposedMember));
		votingData.addNewVoting(_proposedMember, memberData.totalMembers);
	}

	function givePermission(address _proposedMember)
		public
		validAddress(_proposedMember)
	{
		require(memberData.isMember(msg.sender));
		require(!votingData.hasGivenPermission(_proposedMember));
		require(!votingData.votingHasEndedFor(_proposedMember));
		require(votingData.permissionsStillNeededFor(_proposedMember) > 0);
		votingData.givePermission(_proposedMember);
	}

	function donate() public payable {
		if (memberData.hasDonatedInTheLastHour(msg.sender)) {
			memberData.addDonation(msg.sender, msg.value);
		}
	}

	function getVotingInfo(address _proposedMember) 
		public
		view
		validAddress(_proposedMember)
		returns (uint256 permissionsStillNeeded, bool votingHasEnded)
	{
		permissionsStillNeeded = votingData.permissionsStillNeededFor(_proposedMember);
		votingHasEnded = votingData.votingHasEndedFor(_proposedMember);
	}
}