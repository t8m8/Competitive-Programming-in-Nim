import unittest

include priorityqueue

suite "priority queue":

  test "test initialize":
    var pQ = newPriorityQueue[int](cmp)
    check(pQ.len == 0)

  test "test push/pop":
    var pQ = newPriorityQueue[int](cmp)
    pQ.push(1)
    pQ.push(3)
    pQ.push(2)
    check(pQ.len == 3)
    check(pQ.pop == 1)
    check(pQ.len == 2)
    check(pQ.pop == 2)
    check(pQ.len == 1)
    check(pQ.pop == 3)
    check(pQ.len == 0)

  test "test delete":
    var pQ = newPriorityQueue[int](cmp)
    pQ.push(1)
    pQ.push(2)
    pQ.push(3)
    pQ.delete(2)
    check(pQ.len == 2)
    check(pQ.pop == 1)
    check(pQ.pop == 3)

    pQ.push(5)
    pQ.delete(5)
    check(pQ.len == 0)

    pQ.delete(10)