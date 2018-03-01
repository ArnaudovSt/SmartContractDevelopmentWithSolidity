const contract = require('./contract.service').getContract();
const cron = require('node-cron');
const getTimeNow = require('./util.service').getTimeNow;

const memberToIndex = new Map();
const currentVotings = [];
const membersToAdd = [];
let voteOngoing;
const hasOngoingVotings = () => { return voteOngoing; }

cron.schedule("* * * * * *", () => { removeOutdatedVotings() });

contract.events.LogNewVoting({}, (err, ev) => {
	if (err) {
		throw err;
	}

	const currentProposedMember = ev.returnValues.proposedMember;
	const currentVotingEndTime = Number(ev.returnValues.votingEnd);
	const voting = {
		proposedMember: currentProposedMember,
		votingEndTime: currentVotingEndTime
	}

	const currentIndex = currentVotings.push(voting) - 1;
	voteOngoing = true;
	memberToIndex.set(currentProposedMember, currentIndex);
});

contract.events.LogSuccessfulVoting({}, (err, ev) => {
	if (err) {
		throw err;
	}
	const currentProposedMember = ev.returnValues.proposedMember;

	const currentMemberIndex = memberToIndex.get(currentProposedMember);

	currentVotings.splice(currentMemberIndex, 1);

	voteOngoing = currentVotings.length != 0;

	membersToAdd.push(currentProposedMember);
});

function queryNewMembers() {
	return membersToAdd.splice(0);
}

function removeOutdatedVotings() {
	if (currentVotings) {
		let outdatedLength;
		for (outdatedLength = 0; outdatedLength < currentVotings.length; outdatedLength += 1) {
			const currentEndTime = currentVotings[outdatedLength].votingEndTime;
			if (currentEndTime > getTimeNow()) {
				break;
			}

			memberToIndex.delete(currentVotings[outdatedLength].proposedMember);
		}

		if (outdatedLength) {
			currentVotings.splice(0, outdatedLength);
			voteOngoing = currentVotings.length != 0;
		}
	}
}

module.exports = { hasOngoingVotings, queryNewMembers }