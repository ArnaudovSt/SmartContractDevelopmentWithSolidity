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
	
	struct ContractInfo {
		address owner;
		uint96 majority;
	}
	
	Vote[] public votes; // index as ID
	
	mapping(address=>bool) public voters; // O(1);
	
	ContractInfo public info; // 1 slot;
	
	modifier onlyVoter {
		require(voters[msg.sender]);
		_;
	}
	
	modifier onlyOwner {
		require(info.owner == msg.sender);
		_;
	}
	
	function Voting() public {
		info.owner = msg.sender;
	}
	
	function init(address[] _voters) public onlyOwner {
		require(_voters.length >= 2 && _voters.length <= 256);
		info.majority = uint96(_voters.length) / 2;
		for (uint8 i = 0; i < _voters.length; i++) {
			voters[_voters[i]] = true;
		}
	}
	
	function startVote() public onlyVoter returns(uint) {
		votes.push(Vote(0, 0, false));
		
		emit LogStartedVote(votes.length - 1);
		
		return votes.length - 1;
	}
	
	function vote(uint8 id, bool voteFor) public onlyVoter {
		require(!votes[id].finished);
		
		if (voteFor) {
			if (votes[id].votesFor + 1 > info.majority) {
				votes[id].finished = true;
				emit LogEndedVote(id, true);
				return;
			}
			votes[id].votesFor++;
		} else {
			if (votes[id].votesAgainst + 1 >= info.majority) {
				votes[id].finished = true;
				emit LogEndedVote(id, false);
				return;
			}
			votes[id].votesAgainst++;
		}
	}
}