pragma solidity ^0.4.18;

import '../common/SafeMath.sol';


library VotingOperations {
	using SafeMath for uint256;

	event LogNewVoting(address proposedMember, uint256 votingEnd);
	event LogSuccessfulVoting(address proposedMember);
	
	struct VotingInfo {
		uint256 permissionsStillNeeded;
		uint256 votingEnd;
		mapping (address=>bool) permissionsGiven;
	}

	struct Data {
		mapping (address=>VotingInfo) votings;
	}

	function addNewVoting(Data storage _self, address _proposedMember, uint256 _totalMembers) internal {
		uint256 permissionsNeeded = _totalMembers
			.div(2)
			.add(_totalMembers & 1);
		/* solium-disable-next-line security/no-block-members */
		uint256 votingEnd = now.add(1 hours);
		_self.votings[_proposedMember] = VotingInfo(permissionsNeeded, votingEnd);
		LogNewVoting(_proposedMember, votingEnd);
	}

	function givePermission(Data storage _self, address _proposedMember) internal {
		_self.votings[_proposedMember].permissionsStillNeeded = _self.votings[_proposedMember].permissionsStillNeeded.sub(1);

		if (_self.votings[_proposedMember].permissionsStillNeeded == 0) {
			LogSuccessfulVoting(_proposedMember);
		}
	}

	function permissionsStillNeededFor(Data storage _self, address _proposedMember) internal view returns (uint256) {
		return _self.votings[_proposedMember].permissionsStillNeeded;
	}

	function votingHasEndedFor(Data storage _self, address _proposedMember) internal view returns (bool) {
		/* solium-disable-next-line security/no-block-members */
		return _self.votings[_proposedMember].votingEnd < now || _self.votings[_proposedMember].permissionsStillNeeded == 0;
	}

	function hasAlreadyBeenConsidered(Data storage _self, address _proposedMember) internal view returns (bool) {
		return _self.votings[_proposedMember].votingEnd != 0;
	}

	function hasGivenPermission(Data storage _self, address _proposedMember) internal view returns (bool) {
		return _self.votings[_proposedMember].permissionsGiven[msg.sender];
	}
}