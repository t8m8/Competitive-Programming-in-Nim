import future

proc `&`*[T0, T1, T2](f: T0 -> T1, g: T1 -> T2): T0 -> T2 = (x: T0) => f(g(x))