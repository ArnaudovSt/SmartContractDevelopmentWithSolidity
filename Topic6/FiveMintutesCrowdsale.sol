pragma solidity ^0.4.18;

import './modifiers/Owned.sol';
import './common/SafeMath.sol';

contract FiveMintutesCrowdsale is Owned {
    using SafeMath for uint256;

    uint256 public endOfCrowdsale = now.add(5 minutes);
    uint256 public withdrawLockedUntil = now.add(1 years);
    uint256 public constant buyPrice = 200 finney;

    mapping (address=>uint256) public balanceOf;
    address[] public tokenHolders;

    function buy() public payable {
        require(now < endOfCrowdsale);
        uint256 purchaseAmount = msg.value.mul(1 ether);
        purchaseAmount = purchaseAmount.div(buyPrice);

        _checkForNewOwnerAndSend(msg.sender, purchaseAmount);
    }

    function transfer(address _to, uint256 _amount) public {
        require(now > endOfCrowdsale);
        require(_to != address(0));
        require(balanceOf[msg.sender].sub(1) >= _amount);

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);

        _checkForNewOwnerAndSend(_to, _amount);
    }

    function withdraw(address _to, uint256 _amount) public onlyOwner {
        require(now > withdrawLockedUntil);
        require(_to != address(0));
        require(this.balance >= _amount);
        _to.transfer(_amount);
    }

    function isTokenHolder(address _tokenHolder) public view returns(bool) {
        return balanceOf[_tokenHolder] > 1;
    }

    function wasTokenHolder(address _tokenHolder) public view returns(bool) {
        return balanceOf[_tokenHolder] == 1;
    }

    function allTokenHolders() public view returns(address[]) {
        return tokenHolders;
    }

    function totalPhantomUnits() public view returns(uint256) {
        return tokenHolders.length;
    }

    function _checkForNewOwnerAndSend(address _to, uint256 _amount) private {
        if (balanceOf[_to] == 0) {
            balanceOf[_to] = _amount.add(1);
            tokenHolders.push(_to);
        } else {
            balanceOf[_to] = balanceOf[_to].add(_amount);
        }
    }
}