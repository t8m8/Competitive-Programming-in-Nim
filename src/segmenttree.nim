import future, algorithm

{.warning[SmallLshouldNotBeUsed]: off.}

type
  SegmentTree*[T] = ref object of RootObj
    n: int
    elms: seq[T]
    leaf: int
    f*: (T, T) -> T
    ident*: T

proc newSegmentTree*[T](n: int, f: (T, T) -> T, ident: T): SegmentTree[T] =
  new(result)
  result.n = n
  var size = 1;
  while size < 2*n-1: size = size shl 1
  result.elms = newSeq[T](size - 1)
  result.elms.fill(ident)
  result.leaf = (result.elms.len + 1) div 2
  result.f = f
  result.ident = ident

template par(cur: int): int =
  (cur - 1) div 2

template chl(cur: int): int =
  cur * 2 + 1

template chr(cur: int): int =
  cur * 2 + 2

proc `$`[T](self: SegmentTree[T]): string =
  result = $(self.elms[self.leaf-1..self.n+self.leaf-1])

proc query[T](self: SegmentTree[T], ql, qr, cur, l, r: int): T =
  if r <= ql or qr <= l:
    result = self.ident
  elif ql <= l and r <= qr:
    result = self.elms[cur]
  else:
    let
      lres = self.query(ql, qr, chl(cur), l, (l + r) div 2)
      rres = self.query(ql, qr, chr(cur), (l + r) div 2, r)
    result = self.f(lres, rres)

proc query*[T](self: SegmentTree[T], l, r: int): T =
  # [l, r)
  assert(l < r, "invalid range")
  self.query(l, r, 0, 0, self.leaf)

proc update*[T](self: SegmentTree[T], idx: int, val: T) =
  var cur = idx + self.leaf - 1
  self.elms[cur] = val
  while cur > 0:
    cur = par(cur)
    self.elms[cur] = self.f(self.elms[chl(cur)], self.elms[chr(cur)])

proc `[]`*[T](self: SegmentTree[T], l, r: int): T =
  self.query(l, r)

proc `[]=`*[T](self: SegmentTree[T], idx: int, val: T) =
  self.update(idx, val)