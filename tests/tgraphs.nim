import unittest, os, sequtils, strutils

include graphs

proc newUndirectedGraph[T](filename: string): G[T] =
  var f: File = open(filename, fmRead)
  defer: close(f)
  var
    input = f.readline.split.map(parseint)
    (n, m) = (input[0], input[1])
  result = newG[T](n)
  for i in 0..<m:
    var
      e = f.readline.split.map(parseint)
      (s, t, d) = (e[0], e[1], e[2])
    result.add(s, t, d)
    result.add(t, s, d)

suite "graphs":

  test "test shortest paths [Dijkstra]":
    dijkstra()

    var
      g = newUndirectedGraph[int]("tests/fixtures/graphs/simple_0.in")
      (dist, prev) = shortestPaths(g, 0)
      expectedDist = @[0, 246, 424, 545, 383, 495, 437, 516,
        460, 616, 415, 626, 463, 443, 273, 300, 604, 411,
        510, 297, 525, 212, 429, 601, 382, 381, 299, 600,
        626, 312, 472, 401, 410, 285, 385, 161, 343, 366,
        401, 453, 335, 413, 374, 419, 529, 333, 373, 680,
        328, 277, 469, 196, 389, 713, 206, 285, 563, 493,
        304, 346, 445, 422, 601, 489, 371, 540, 498, 374,
        419, 575, 400, 702, 483, 364, 184, 374, 612, 406, 192]
      expectedPrev = @[-1, 51, 45, 70, 37, 73, 21, 63, 21,
        17, 37, 32, 61, 77, 1, 74, 65, 21, 63, 33, 46, 74,
        49, 37, 1, 36, 33, 22, 52, 35, 12, 15, 24, 78, 55,
        0, 0, 14, 33, 75, 35, 19, 49, 48, 36, 21, 37, 43, 74,
        21, 58, 78, 35, 51, 35, 1, 18, 55, 51, 40, 67, 77, 78,
        13, 74, 73, 36, 51, 38, 60, 26, 42, 25, 58, 0, 26, 38, 4, 35]

    check(dist == expectedDist)
    check(prev == expectedPrev)