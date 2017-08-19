type
  DisjointSet* = ref object of RootObj
    par: seq[int]

proc newDisjointSet*(n: int): DisjointSet =
  result = DisjointSet(par: newSeq[int](n))
  for i in 0..<n:
    result.par[i] = i

proc find(self: DisjointSet, x: int): int =
  if self.par[x] == x:
    result = x
  else:
    self.par[x] = self.find(self.par[x])
    result = self.par[x]

proc same*(self: DisjointSet, x, y: int): bool =
  result = self.find(x) == self.find(y)

proc unite*(self: DisjointSet, x, y: int) =
  let
    s = self.find(x)
    t = self.find(y)
  if s != t: self.par[s] = t

proc `[]`*(self: DisjointSet, x: int): int =
  self.find(x)

proc `$`*(self: DisjointSet): string =
  result = $self.par