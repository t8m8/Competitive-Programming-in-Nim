import algorithm, sequtils

import priorityqueue

const Inf* = 1 shl 29

type
  G* = seq[seq[tuple[to: int, dist: int]]]

proc newG*(n: int): G =
  newSeqWith(n, newSeq[(int, int)]())

proc add*(self: var G, s, t, d: int) =
  self[s].add((t, d))

# ==============================================================================

template dijkstra*() =
  proc shortestPaths(g: G, start: int): (seq[int], seq[int]) =
    var
      n = g.len
      dist = newSeq[int](n)
      prev = newSeq[int](n)
      pQ = newPriorityQueue[int](
        proc(a: int, b: int): int =
          if dist[a] != dist[b]: dist[a] - dist[b]
          else: a - b
      )

    dist.fill(Inf)
    prev.fill(-1)
    pQ.push(start)
    dist[start] = 0

    while pQ.len > 0:
      var cur = pQ.pop()
      for next in g[cur]:
        var alt = dist[cur] + next.dist
        if alt < dist[next.to]:
          dist[next.to] = alt
          prev[next.to] = cur
          pQ.push(next.to)

    result = (dist, prev)
