pragma solidity ^0.4.18;

import './modifiers/Owned.sol';

contract StructEnumExercise is Owned {
    enum State { Unlocked, Locked, Restricted }

    struct Info {
        uint256 timestamp;
        address invoker;
        uint96 counter;
    }

    Info public info;

    State public currentState = State.Unlocked; // 8bit while < 2^8

    modifier checkState() {
        require(currentState != State.Locked);

        if (currentState == State.Restricted) {
            require(msg.sender == owner);
        }

        _;
    }

    function changeState(State _newState) public onlyOwner() {
        currentState = _newState;
    }

    function updateInfo() public checkState() {
        info = Info(now, msg.sender, ++info.counter);
    }
}