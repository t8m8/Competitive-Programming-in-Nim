import unittest, future

include utils

suite "utils":

  test "test function composition":
    proc f(x: int): int = x + 2
    proc g(x: int): int = x * 3
    var x = 5
    check(f(g(x)) == (f & g) x)