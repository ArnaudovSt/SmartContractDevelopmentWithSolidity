pragma solidity ^0.4.18;

contract PublicProposal {
    address[] owners;
    bool[] agreed;

    struct Proposal {
        uint256 endTime;
        uint256 funds;
        address beneficient;
    }

    Proposal public currentProposal;
    uint16 public proposalDuration = 5 minutes;
    uint80 public currentOwnerToVote;

    modifier isInTime() {
        require(currentProposal.endTime < now);
        _;
    }

    function PublicProposal(address[] _owners) public {
        owners = _owners;
        agreed = new bool[](owners.length);
    }

    function() public payable {}

    function addProposal(uint256 _funds, address _beneficient) public isInTime {
        require(this.balance >= _funds);
        currentProposal = Proposal(now + proposalDuration, _funds, _beneficient);
        delete agreed;
        delete currentOwnerToVote;
    }

    function acceptProposal() public isInTime {
        require(owners[currentOwnerToVote] == msg.sender);

        if (currentOwnerToVote != 0) {
         require(agreed[currentOwnerToVote - 1]);   
        }

        agreed[currentOwnerToVote] = true;

        if (++currentOwnerToVote == agreed.length) {
            currentProposal.beneficient.transfer(currentProposal.funds);
        }
    }
}