import tables, future

type
  PrirorityQueue*[T] = ref object of RootObj
    elms: seq[T]
    idxs: TableRef[T, int]
    cmp: (T, T) -> int

proc newPriorityQueue*[T](cmp: (T, T) -> int): PrirorityQueue[T] =
  new(result)
  result.elms = newSeq[T]()
  result.idxs = newTable[T, int]()
  result.cmp = cmp

template parent(cur: int): int =
  if cur == 0: -1
  else: (cur - 1) div 2

template childl(cur: int): int =
  cur * 2 + 1

template childr(cur: int): int =
  cur * 2 + 2

proc innerDel[T](self: PrirorityQueue[T], cur: int) =
  self.idxs.del(self.elms[cur])
  self.elms.del(cur)

proc innerSwap[T](self: PrirorityQueue[T], s, t: int) =
  let (sval, tval) = (self.elms[s], self.elms[t])
  swap(self.elms[s], self.elms[t])
  swap(self.idxs[sval], self.idxs[tval])

proc valid[T](self: PrirorityQueue[T], upper, lower: int): bool =
  let val = self.cmp(self.elms[upper], self.elms[lower])
  assert(val != 0)
  result = val < 0

proc valid[T](self: PrirorityQueue[T], cur: int = 0): bool =
  var (chl, chr) = (childl(cur), childr(cur))
  result = true
  if chl < self.len:
    result = result and self.valid(cur, chl)
    result = result and self.valid(chl)
  if chr < self.len:
    result = result and self.valid(cur, chr)
    result = result and self.valid(chr)

proc upHeap[T](self: PrirorityQueue[T], cur: var int) =
  var par = parent(cur)

  while par >= 0 and not self.valid(par, cur):
    self.innerSwap(cur, par)
    (cur, par) = (par, parent(par))

proc downHeap[T](self: PrirorityQueue[T], cur: var int) =
  var (chl, chr) = (childl(cur), childr(cur))

  while chl < self.elms.len:
    var ch =
      if chr >= self.elms.len or self.valid(chl, chr): chl
      else: chr

    if self.valid(cur, ch):
      break
    self.innerSwap(cur, ch)

    (cur, chl, chr) = (ch, childl(ch), childr(ch))

proc len*[T](self: PrirorityQueue[T]): int =
  assert(self.elms.len == self.idxs.len)
  self.elms.len

proc push*[T](self: PrirorityQueue[T], data: T): bool {.discardable.} =
  if self.idxs.contains(data):
    return false
  var
    n = self.elms.len
    cur = n
  self.elms.setLen(n + 1)
  self.elms[cur] = data
  self.idxs[data] = cur
  self.upHeap(cur)
  return true

proc peek*[T](self: PrirorityQueue[T]): T =
  self.elms[0]

proc pop*[T](self: PrirorityQueue[T]): T {.discardable.} =
  assert(self.elms.len > 0)
  var
    n = self.elms.len
    cur = 0
  result = self.elms[0]
  self.innerSwap(0, n-1)
  self.innerDel(n-1)
  self.downHeap(cur)

proc del*[T](self: PrirorityQueue[T], data: T): bool {.discardable.} =
  if not self.idxs.contains(data):
    return false
  let n = self.elms.len
  var idx = self.idxs[data]
  if idx == n - 1:
    self.innerDel(n-1)
  else:
    self.innerSwap(idx, n-1)
    self.innerDel(n-1)
    self.downHeap(idx)
    self.upHeap(idx)
  return true