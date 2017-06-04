import future

type
  PrirorityQueue*[T] = ref object of RootObj
    elms: seq[T]
    cmp: (T, T) -> int

proc newPriorityQueue*[T](cmp: (T, T) -> int): PrirorityQueue[T] =
  new(result)
  result.elms = newSeq[T]()
  result.cmp = cmp

template parent(cur: int): int =
  (cur - 1) div 2

template childl(cur: int): int =
  cur * 2 + 1

template childr(cur: int): int =
  cur * 2 + 2

proc upHeap[T](self: var PrirorityQueue[T], cur: var int) =
  var par = parent(cur)

  while par >= 0 and self.cmp(self.elms[cur], self.elms[par]) < 0:
    swap(self.elms[cur], self.elms[par])
    (cur, par) = (par, parent(par))

proc downHeap[T](self: var PrirorityQueue[T], cur: var int) =
  var (chl, chr) = (childl(cur), childr(cur))

  while chl < self.elms.len:
    var ch =
      if chr >= self.elms.len or self.cmp(self.elms[chl], self.elms[chr]) < 0: chl
      else: chr

    if self.cmp(self.elms[cur], self.elms[ch]) < 0:
      break

    swap(self.elms[cur], self.elms[ch])
    (cur, chl, chr) = (ch, childl(cur), childr(cur))

proc len*[T](self: PrirorityQueue[T]): int =
  self.elms.len

proc push*[T](self: var PrirorityQueue[T], data: T) =
  var
    n = self.elms.len
    cur = n
  self.elms.setLen(n + 1)
  self.elms[cur] = data
  self.upHeap(cur)

proc pop*[T](self: var PrirorityQueue[T]): T =
  assert self.elms.len > 0
  var
    n = self.elms.len
    cur = 0
  result = self.elms[0]
  self.elms[cur] = self.elms[n-1]
  self.elms.del(n-1)
  self.downHeap(cur)

proc delete*[T](self: var PrirorityQueue[T], data: T) =
  var
    n = self.elms.len
    idx = -1
  for i in 0..<n:
    if self.elms[i] == data:
      idx = i
      break
  if idx == -1:
    return
  elif idx == n - 1:
    self.elms.del(idx)
  else:
    self.elms[idx] = self.elms[n-1]
    self.elms.del(n-1)
    self.downHeap(idx)
    self.upHeap(idx)