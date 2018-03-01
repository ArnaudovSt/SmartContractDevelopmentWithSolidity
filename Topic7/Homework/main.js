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
		addMember(m);
	});
}

function removeInactiveMembers() {
	if (!hasOngoingVotings()) {
		const membersToRemove = queryInactiveMembers();
		
		membersToRemove.forEach((el) => {
			removeMember(el.member);
		});
	}
}