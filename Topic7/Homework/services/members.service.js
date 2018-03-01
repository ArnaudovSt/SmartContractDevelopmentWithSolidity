const contract = require('./contract.service').getContract();
const getTimeNow = require('./util.service').getTimeNow;
const convertTimeToHourAhead = require('./util.service').convertTimeToHourAhead;

const memberToIndex = new Map();
const membersLastDonations = [];

contract.events.LogDonation({}, (err, ev) => {
	if (err) {
		throw err;
	}

	const currentMember = ev.returnValues.member;
	const currentMemberIndex = memberToIndex.get(currentMember);

	if (currentMemberIndex) {
		membersLastDonations.splice(currentMemberIndex, 1);
	}

	const time = Number(ev.returnValues.time);
	const deadline = convertTimeToHourAhead(time);

	const donation = {
		member: currentMember,
		deadline: deadline
	}

	console.log(donation.deadline);
	console.log(getTimeNow());

	const newIndex = membersLastDonations.push(donation);
	memberToIndex.set(currentMember, newIndex);
});

function queryInactiveMembers() {
	let inactiveLength;
	for (inactiveLength = 0; inactiveLength < membersLastDonations.length; inactiveLength += 1) {
		const currentDeadline = membersLastDonations[inactiveLength].deadline;
		if (currentDeadline > getTimeNow()) {
			break;
		}

		memberToIndex.delete(membersLastDonations[inactiveLength].member);
	}

	if (!inactiveLength) {
		return [];
	}

	return membersLastDonations.splice(0, inactiveLength);
}

module.exports = queryInactiveMembers;