pragma solidity ^0.4.18;

library SafeMath {
    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
        if (_a == 0) {
            return 0;
        }
        uint256 c = _a * _b;
        assert(c / _a == _b);
        return c;
    }

    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
        uint256 c = _a / _b;
        return c;
    }

    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
        assert(_b <= _a);
        return _a - _b;
    }

    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
        uint256 c = _a + _b;
        assert(c >= _a);
        return c;
    }
}

contract Owned {
    event OwnerChanged(address indexed _oldOwner, address _newOwner);

    address public owner;

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setOwner(address _newOwner) public {
        require(_newOwner != address(0));
        OwnerChanged(owner, _newOwner);
        owner = _newOwner;
    }
}

contract TimeLocked is Owned {
    uint256 public period = 15 seconds;
    uint256 public lastInvocation;

    modifier timeLock() {
        require((lastInvocation + period) < now);
        lastInvocation = now;
        _;
    }

    function setPeriod(uint256 _period) public onlyOwner {
        period = _period;
    }
}

contract Destroyable is Owned {
    function Destroyable() public payable { }

    function destroy() onlyOwner public {
        selfdestruct(msg.sender);
    }

    function destroyAndSend(address _recipient) onlyOwner public {
        require(_recipient != address(0));
        selfdestruct(_recipient);
    }
}

contract Exercise is TimeLocked {
    using SafeMath for uint256;
    uint256 public stateVariable;

    function Exercise(uint256 _stateVariableValue) public {
        stateVariable = _stateVariableValue;
    }

    function increment() public onlyOwner timeLock {
        stateVariable.add(1);
    }
}

contract Faucet is TimeLocked, Destroyable {
    event Withdraw(address indexed _recipient, uint256 _amount);

    uint256 public sendAmount = 1 ether;

    function () public payable {}

    function changeSendAmount(uint256 _newSendAmount) public onlyOwner {
        sendAmount = _newSendAmount;
    }

    function send(address _recipient) public timeLock {
        require(_recipient != address(0));
        require(this.balance >= sendAmount);
        _recipient.transfer(sendAmount);
    }

    function withdraw() public timeLock {
        _withdraw(msg.sender, sendAmount);
    }

    function ownerWithdraw(uint256 _amount) public onlyOwner {
        _withdraw(owner, _amount);
    }

    function _withdraw(address _recipient, uint256 _amount) private {
        require(this.balance >= _amount);
        _recipient.transfer(_amount);
        Withdraw(_recipient, _amount);
    }
}

contract Service is TimeLocked {
    using SafeMath for uint256;

    event ServiceSold(address indexed _buyer, uint256 _lockedUntil);

    uint256 public servicePrice = 1 ether;
    uint256 public lastOwnerWithdraw;

    function Service() public {
        period = 2 minutes;
    }

    function buy() public payable timeLock {
        assert(msg.value >= 1 ether);

        if (msg.value > servicePrice) {
            msg.sender.transfer(msg.value.sub(servicePrice));
        }

        ServiceSold(msg.sender, now + period);
    }

    function ownerWithdraw(uint256 _amount) public onlyOwner {
        require((lastOwnerWithdraw + 1 hours) < now);
        lastOwnerWithdraw = now;
        if (_amount > 5 ether) {
            owner.transfer(5 ether);
        } else {
            owner.transfer(_amount);
        }
    }
}