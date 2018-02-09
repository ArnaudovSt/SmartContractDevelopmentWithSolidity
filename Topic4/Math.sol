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

library MathExtended {
    function mod(uint256 _a, uint256 _b) internal pure returns(uint256) {
        return _a % _b;
    }
    
    function sqrt(uint256 _a) internal pure returns (uint256) {
        uint256 b = (_a + 1) / 2;
        uint256 c = _a;
        
        while (b < c) {
            c = b;
            b = (_a / b + b) / 2;
        }
        
        return c;
    }
    
    function pow(uint256 _a, uint256 _b) internal pure returns(uint256) {
        return _a ** _b;
    }
    
    function nPow(int256 _a, uint256 _b) internal pure returns(int256) {
        if (_a < 0 && _b % 2 != 0) {
            return -int(uint256(-_a) ** _b);
        }
        
        return int(uint256(_a) ** _b);
    }
    
    function nnPow(int256 _a, int256 _b) internal pure returns(int256) {
        if (_a == 0) {
            return 0;
        }
        
        if (_b == 0) {
            return 1;
        }
        
        if (_b == -1 && (_a == -1 || _a == 1)) {
            return _a;
        }
        
        if (_b <= -1) {
            return 0;
        }
        
        if (_a < 0) {
            uint256 res = uint256(-_a) ** uint256(_b);
            if (_b % 2 != 0) {
                return -int(res);
            }
            
            return int(res);
        }
        
        return int(uint256(_a) ** uint256(_b));
    }
    
    function fastPow(uint256 _a, uint256 _b) internal pure returns (uint256) {
        if (_a == 0) {
            return 0;
        }
        
        if (_a == 1) {
            return _a;
        }
        
        if (_b == 0) {
            return 1;
        }
        
        if (_b == 1) {
            return _a;
        }
        
        return _fastPow(_a, _b);
    }
    
    function _fastPow(uint256 _a, uint256 _b) private pure returns (uint256) {
        if (_b == 0) {
            return 1;
        }
        
        if (_b % 2 != 0) {
            return _a * _fastPow(_a, _b - 1);
        }
        
        uint256 half = _fastPow(_a, _b / 2);
        half *= half;
        return half;
    }
}

contract Test {
    using SafeMath for uint256;
    using MathExtended for uint256;
    using MathExtended for int256;
    
    function getMul(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.mul(_b);
    }

    function getDiv(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.div(_b);
    }

    function getSub(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.sub(_b);
    }

    function getAdd(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.add(_b);
    }
    
    function getMod(uint256 _a, uint256 _b) public pure returns(uint256) {
        return _a.mod(_b);
    }
    
    function getSqrt(uint256 _a) public pure returns (uint256) {
        return _a.sqrt();
    }
    
    function getPow(uint256 _a, uint256 _b) public pure returns(uint256) {
        return _a.pow(_b);
    }
    
    function getNPow(int256 _a, uint256 _b) public pure returns(int256) {
        return _a.nPow(_b);
    }
    
    function getNnPow(int256 _a, int256 _b) public pure returns(int256) {
        return _a.nnPow(_b);
    }
    
    function getFastPow(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.fastPow(_b);
    }
}

contract Homework {
    using SafeMath for uint256;
    using MathExtended for uint256;
    using MathExtended for int256;
    
    uint256 private sv1 = 0;
    int256 private sv2 = 0;
    
    function getState() public view returns (uint256, int256) {
        return (sv1, sv2);
    }
    
    function clearState() public {
        delete sv1;
        delete sv2;
    }
    
    function setSv2(int256 _value) public {
        sv2 = _value;
    }
    
    function stateMul(uint256 _b) public {
        sv1 = sv1.mul(_b);
    }

    function stateDiv(uint256 _b) public {
        sv1 = sv1.div(_b);
    }

    function stateSub(uint256 _b) public {
        sv1 = sv1.sub(_b);
    }

    function stateAdd(uint256 _b) public {
        sv1 = sv1.add(_b);
    }
    
    function stateMod(uint256 _b) public {
        sv1 = sv1.mod(_b);
    }
    
    function stateSqrt() public {
        sv1 = sv1.sqrt();
    }
    
    function statePow(uint256 _b) public {
        sv1 = sv1.pow(_b);
    }
    
    function stateNPow(uint256 _b) public {
        sv2 = sv2.nPow(_b);
    }
    
    function stateNnPow(int256 _b) public {
        sv2 = sv2.nnPow(_b);
    }
    
    function stateFastPow(uint256 _b) public {
        sv1 = sv1.fastPow(_b);
    }
}