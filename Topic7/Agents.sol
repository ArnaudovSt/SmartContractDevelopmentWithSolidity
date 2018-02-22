pragma solidity ^0.4.18;

import './modifiers/Owned.sol';

contract Agent {
    address public master;
    uint256 public lastOrderTime;

    modifier onlyMaster() {
        require(msg.sender == master);
        _;
    }

    function Agent(address _master) public {
        require(_master != address(0));
        master = _master;
    }

    function processOrder() public onlyMaster {
        require(lastOrderTime + 15 < now);
        lastOrderTime = now;
    }

    function isOrderComplete() public view returns (bool) {
        return (lastOrderTime + 15) < now;
    }
}

interface IAgent {
    function processOrder() public;

    function isOrderComplete() public view returns (bool);
}

contract Master is Owned {
    mapping (address=>bool) approvedAgents;

    function issueOrder(address _agent) public onlyOwner {
        require(approvedAgents[_agent]);
        IAgent(_agent).processOrder();
    }

    function isOrderComplete(address _agent) public view returns (bool) {
        require(_agent != address(0));
        return IAgent(_agent).isOrderComplete();
    }

    function approveAgent(address _agent) public onlyOwner {
        require(_agent != address(0));
        approvedAgents[_agent] = true;
    }

    function addAgent() public onlyOwner {
        Agent newAgent = new Agent(this);
        approvedAgents[newAgent] = true;
    }
}