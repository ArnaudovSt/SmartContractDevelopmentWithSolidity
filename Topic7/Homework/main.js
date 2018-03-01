const cron = require('node-cron');
const queryInactiveMembers = require('./services/members.service');
const hasOngoingVotings = require('./services/voting.service').hasOngoingVotings;
const queryNewMembers = require('./services/voting.service').queryNewMembers;
const addMember = require('./services/contract.service').addMember;
const removeMember = require('./services/contract.service').removeMember;

cron.schedule("* * * * * *", () => { addNewMembers() });

cron.schedule("* * * * * *", () => { removeInactiveMembers() });

function addNewMembers() {
	const membersToAdd = queryNewMembers();

	membersToAdd.forEach((m) => {
		console.log(`Member to add ${m}`);
		addMember(m);
	});
}

function removeInactiveMembers() {
	if (!hasOngoingVotings()) {
		console.log("removeInactiveMembers");
		const membersToRemove = queryInactiveMembers();

		membersToRemove.forEach((el) => {
		console.log(`Member to remove ${el.member}`);
			removeMember(el.member);
		});
	}
}