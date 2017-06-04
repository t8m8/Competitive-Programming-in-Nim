import unittest, future

{.warning[SmallLshouldNotBeUsed]: off.}
include segmenttree

suite "priority queue":

  const Inf = 1 shl 30

  test "test initialize":
    var
      n = 10
      st = newSegmentTree[int](n, (x: int, y: int) => min(x, y), Inf)
    check(st.n == n)
    check(st.elms.len == 31)
    check(st.ident == Inf)

    for elm in st.elms:
      check(elm == Inf)

    check(st.f(3, 8) == 3)
    check(st.f(5, 2) == 2)

  test "test query/update [RMQ]":
    var
      n = 10
      st = newSegmentTree[int](n, (x: int, y: int) => min(x, y), Inf)

    check(st.query(0, 10) == Inf)
    st.update(3, 10)
    check(st.query(0, 10) == 10)
    check(st.query(0, 3) == Inf)
    check(st.query(4, 10) == Inf)

    st[5] = 8
    check(st[5, 6] == 8)
    check(st[0, 5] == 10)
    check(st[0, 10] == 8)