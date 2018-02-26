pragma solidity ^0.4.18;

library SignedSafeMath {
    function mul(int _a, int _b) internal pure returns (int) {
        if (_a == 0 || _b == 0) {
            return 0;
        }
        int c = _a * _b;
        assert(c / _a == _b);
        if ((_a < 0 && _b < 0) || (_a > 0 && _b > 0)) {
            assert(c > 0);
        } else {
            assert(c < 0);
        }
        return c;
    }

    function div(int _a, int _b) internal pure returns (int) {
        int c = _a / _b; // if _b == 0 it will atomatically throw
        assert(c == _a * _b);
        if ((_a < 0 && _b < 0) || (_a > 0 && _b > 0)) {
            assert(c > 0);
        } else {
            assert(c < 0);
        }
        return c;
    }

    function sub(int _a, int _b) internal pure returns (int) {
        int c = _a - _b;
        assert(c + _b == _a);
        assert(_a - c == _b);
        return c;
    }

    function add(int _a, int _b) internal pure returns (int) {
        int c = _a + _b;
        assert(c - _a == _b);
        assert(c - _b == _a);
        return c;
    }
}