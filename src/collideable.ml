open Util

type collideable =
  { pos: point
  ; size: size
  ; vx: int
  ; vy: int
  ; lower_bound: point
  ; upper_bound: point
  }

module CollideableSet =
  Set.Make(struct type t = collideable let compare = compare end)

let init_collideable (init_pos: point) (size: size) (lower_bound: point)
  (upper_bound: point) : collideable =
  { pos = init_pos
  ; size = size
  ; vx = 0
  ; vy = 0
  ; lower_bound = lower_bound
  ; upper_bound = upper_bound
  }

let are_colliding (c1: collideable) (c2: collideable) : bool =
  (* TODO: implement *)
  false

let move_collideable (c: collideable) : collideable =
  let x' = min (max c.lower_bound.x (c.pos.x + c.vx)) (c.upper_bound.x- c.size.width) in
  let y' = min (max c.lower_bound.y (c.pos.y + c.vy)) (c.upper_bound.y - c.size.height) in
  { c with pos = { x = x'; y = y' } }

let speed_collideable (c: collideable) (vx: int) (vy: int) : collideable =
  { c with vx = vx; vy = vy }
