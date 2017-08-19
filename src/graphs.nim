import algorithm, sequtils

import priorityqueue

type
  G*[T] = seq[seq[tuple[to: int, dist: T]]]

proc newG*[T](n: int): G[T] =
  newSeqWith(n, newSeq[(int, T)]())

proc add*[T](self: var G[T], s, t: int, d: T) =
  self[s].add((t, d))

# ==============================================================================

template dijkstra*() =
  proc shortestPaths[T](g: G[T], start: int): (seq[T], seq[int]) =
    var
      n = g.len
      dist = newSeq[T](n)
      prev = newSeq[int](n)
      pQ = newPriorityQueue[T](
        proc(a: T, b: T): int =
          if dist[a] != dist[b]: dist[a] - dist[b]
          else: a - b
      )

    dist.fill(high(T) div 2)
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
