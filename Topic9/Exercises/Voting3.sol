pragma solidity 0.4.21;
pragma experimental ABIEncoderV2; //ignore this for now

//This is hands down the worst voting contract that could ever exist.
//Optimize execution costs
//Fix all compile warnings

contract Voting {
	event LogStartedVote(uint ID);
	event LogEndedVote(uint ID, bool successful);
	
	struct Vote {
		uint votesFor;
		uint votesAgainst;
		bool finished;
	}
	
	Vote[] public votes; // index as ID
	
	mapping(address=>bool) public voters; // O(1);
	
	uint8 majority;
	
	modifier onlyVoter {
		require(voters[msg.sender]);
		_;
	}
	
	function Voting(address[] _voters) public {
		require(_voters.length >= 2 && _voters.length <= 256);
		majority = uint8(_voters.length) / 2;
		for (uint8 i = 0; i < _voters.length; i++) {
			voters[_voters[i]] = true;
		}
	}
	
	function startVote() public onlyVoter returns(uint) {
		uint256 id = votes.push(Vote(0, 0, false)) - 1;
		
		emit LogStartedVote(id);
		
		return id;
	}
	
	function vote(uint8 id, bool voteFor) public onlyVoter {
		require(!votes[id].finished);
		
		if (voteFor) {
			if (votes[id].votesFor + 1 > majority) {
				votes[id].finished = true;
				emit LogEndedVote(id, true);
				return;
			}
			votes[id].votesFor++;
		} else {
			if (votes[id].votesAgainst + 1 >= majority) {
				votes[id].finished = true;
				emit LogEndedVote(id, false);
				return;
			}
			votes[id].votesAgainst++;
		}
	}
}