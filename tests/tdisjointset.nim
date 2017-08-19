import unittest

include disjointset

suite "disjoint-set":

  test "test initialize":
    var
      n = 10
      ds = newDisjointSet(n)
    for i in 0..<n:
      check(ds[i] == i)

  test "test unite/same/find":
    var
      n = 4
      ds = newDisjointSet(n)

    ds.unite(0, 1)
    check(ds[0] == ds[1])
    check(ds.same(0, 1))
    check(ds.find(0) == ds.find(1))
    check(ds[0] != ds[2])
    ds.unite(2, 3)
    check(ds.same(2, 3))
    check(not ds.same(0, 2))
    ds.unite(0, 2)
    check(ds.same(1, 3))
    check(ds.same(0, 2))