function getTimeNow() {
	return Math.round(Date.now() / 1000);
}

function convertTimeToHourAhead(time) {
	return time + 3600;
}

module.exports = { getTimeNow, convertTimeToHourAhead }