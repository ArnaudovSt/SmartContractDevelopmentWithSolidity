pragma solidity ^0.4.18;

import './modifiers/Owned.sol';
import './common/SignedSafeMath.sol';

contract Calculations is Owned {
    using SignedSafeMath for int256;

    int256 public stateVariable;
    uint256 public lastChange;
    
    function changeState() public onlyOwner {
        stateVariable = stateVariable.add(int(now % 256));
        stateVariable = stateVariable.mul(int(lastChange - now));
        stateVariable = stateVariable.sub(int(block.gaslimit));
        lastChange = now;
    }
}