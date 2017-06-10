import unittest, algorithm, future

include priorityqueue

suite "priority queue":

  test "test initialize":
    var pQ = newPriorityQueue[int](cmp)
    check(pQ.len == 0)

  test "test push/pop":
    block:
      var pQ = newPriorityQueue[int](cmp)
      pQ.push(1)
      pQ.push(3)
      pQ.push(2)
      check(pQ.len == 3)
      check(pQ.peek == 1)
      check(pQ.pop == 1)
      check(pQ.len == 2)
      check(pQ.peek == 2)
      check(pQ.pop == 2)
      check(pQ.len == 1)
      check(pQ.peek == 3)
      check(pQ.pop == 3)
      check(pQ.len == 0)
      check(pQ.push(1) == true)
      check(pQ.push(1) == false)
      check(pQ.len == 1)
      check(pQ.pop == 1)

    block:
      var
        pQ = newPriorityQueue[int]((x: int, y:int) => y - x)
        data = @[691376718, 675743011, 419348620, 606513610, 760834766,
            737223703, 45187204, 192261429, 105261250, 81555483]
        curmax = 0
      for i in 0..<data.len:
        curmax = max(curmax, data[i])
        pQ.push(data[i])
        check(pQ.peek() == curmax)
      check(pQ.valid())
      data.sort(cmp, Descending)
      for i in 0..<data.len:
        check(data[i] == pQ.pop())
        check(pQ.valid())

  test "test delete":
    block:
      var pQ = newPriorityQueue[int](cmp)
      pQ.push(1)
      pQ.push(2)
      pQ.push(3)
      pQ.del(2)
      check(pQ.len == 2)
      check(pQ.pop == 1)
      check(pQ.pop == 3)
      check(pQ.len == 0)
      pQ.push(5)
      check(pQ.len == 1)
      pQ.del(5)
      check(pQ.len == 0)
      pQ.del(10)

    block:
      var
        pQ = newPriorityQueue[int]((x: int, y:int) => y - x)
        data = @[691376718, 675743011, 419348620, 606513610, 760834766,
            737223703, 45187204, 192261429, 105261250, 81555483]
      for i in 0..<data.len:
        pQ.push(data[i])
      for i in 0..<data.len:
        check(pQ.del(pQ.peek()) == true)
        check(pQ.valid())
