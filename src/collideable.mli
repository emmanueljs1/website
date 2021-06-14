open Util

type collideable =
  { pos: point
  ; size: size
  ; vx: int
  ; vy: int
  ; lower_bound: point
  ; upper_bound: point
  }

val init_collideable : point -> size -> point -> point -> collideable
val are_colliding : collideable -> collideable -> bool
val are_adjacent : collideable -> collideable -> int -> bool
val move_collideable : collideable -> collideable
val move_collideable_safe : collideable -> collideable list -> collideable
val speed_collideable: collideable -> int -> int -> collideable
