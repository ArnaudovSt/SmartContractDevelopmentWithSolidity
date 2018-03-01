pragma solidity ^0.4.18;

import '../common/SafeMath.sol';


library MemberOperations {
	using SafeMath for uint256;

	event LogDonation(address member, uint256 time);
	event LogNewMember(address member, uint256 time);

	struct MemberDetails {
		uint256 totalDonations;
		uint256 lastDonationTime;
		uint256 lastDonationAmount;
	}

	struct Data {
		uint256 totalMembers;
		mapping (address=>MemberDetails) members;
	}

	function addMember(Data storage _self, address _newMember) internal {
		/* solium-disable-next-line security/no-block-members */
		_self.members[_newMember] = MemberDetails(0, now, 0);
		_self.totalMembers++;
		/* solium-disable-next-line security/no-block-members */
		LogNewMember(_newMember, now);
	}

	function removeMember(Data storage _self, address _memberToRemove) internal {
		delete _self.members[_memberToRemove];
		_self.totalMembers--;
	}

	function addDonation(Data storage _self, address _member, uint256 _donationAmount) internal {
		_self.members[_member] = MemberDetails
		(
			{ totalDonations: _self.members[_member].totalDonations.add(_donationAmount),
			/* solium-disable-next-line security/no-block-members */
			lastDonationTime: now,
			lastDonationAmount: _donationAmount }
		);
		/* solium-disable-next-line security/no-block-members */
		LogDonation(_member, now);
	}

	function isMember(Data storage _self, address _memberToCheck) internal view returns (bool) {
		return _self.members[_memberToCheck].lastDonationTime != 0;
	}

	function hasDonatedInTheLastHour(Data storage _self, address _memberToCheck) internal view returns (bool) {
		/* solium-disable-next-line security/no-block-members */
		return (_self.members[_memberToCheck].lastDonationTime + 1 hours) >= now;
	}
}