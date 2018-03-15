pragma solidity ^0.4.19;

contract PnP {
	mapping (address=>uint256) public allowed;
	address[] public members;

	function PnP(address[] _members) public {
		members = _members;
	}

	function donate() public payable {
		uint256 part = msg.value / members.length;
		for (uint256 i = 0; i < members.length; i++) {
			allowed[members[i]] += part;
		}
	}

	function withdraw(uint256 _amount) public {
		require(allowed[msg.sender] >= _amount);
		allowed[msg.sender] -= _amount;
		msg.sender.transfer(_amount);
	}
}