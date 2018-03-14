pragma solidity 0.4.21;


contract Members {
	mapping(address => uint256) public members; // key -> adr, value -> joinedAt
	
	function Members(address[] addresses) public {
		for (uint i = 0; i < addresses.length; i++) {
			members[addresses[i]] = now;
		}
	}
}