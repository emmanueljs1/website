open Util

type collideable =
  { pos: point
  ; size: size
  ; vx: int
  ; vy: int
  ; lower_bound: point
  ; upper_bound: point
  }

module CollideableSet : Set.S with type elt = collideable

val init_collideable : point -> size -> point -> point -> collideable
val are_colliding : collideable -> collideable -> bool
val move_collideable: collideable -> collideable
val speed_collideable: collideable -> int -> int -> collideable
