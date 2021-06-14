open Util

type collideable =
  { pos: point
  ; size: size
  ; vx: int
  ; vy: int
  ; lower_bound: point
  ; upper_bound: point
  }

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
  c1.pos.x < c2.pos.x + c2.size.width &&
  c1.pos.x + c1.size.width > c2.pos.x &&
  c1.pos.y < c2.pos.y + c2.size.height &&
  c1.pos.y + c1.size.height > c2.pos.y

let are_adjacent (c1: collideable) (c2: collideable) (radius: int) : bool =
  let size1' = { width = c1.size.width + radius; height = c1.size.height + radius } in
  let pos1' = { x = c1.pos.x - radius; y = c1.pos.y - radius } in
  let size2' = { width = c2.size.width + radius; height = c2.size.height + radius } in
  let pos2' = { x = c2.pos.x - radius; y = c2.pos.y - radius } in
  are_colliding { c1 with size = size1'; pos = pos1' } { c2 with size = size2'; pos = pos2' }

let move_collideable (c: collideable) : collideable =
  let x' = min (max c.lower_bound.x (c.pos.x + c.vx)) (c.upper_bound.x - c.size.width) in
  let y' = min (max c.lower_bound.y (c.pos.y + c.vy)) (c.upper_bound.y - c.size.height) in
  { c with pos = { x = x'; y = y' } }



let move_collideable_safe (c: collideable) (cs: collideable list) : collideable =
  let colliding (collideable: collideable) : bool =
    List.fold_left (fun acc c2 ->
      are_colliding c2 collideable || acc
    ) false cs
  in

  if colliding c then
    (* Attempt to move 20 steps to safe position, 1 at a time *)
    let candidates =
      let rec candidates_gen (c': collideable) : collideable stream =
        Cons (c', fun () -> move_collideable c' |> candidates_gen)
      in
      stream_take (candidates_gen c) 20
    in

    (* Pick first safe step, otherwise perform unsafe move to try to
     * get collideable out of impossible position *)
    begin match List.find_opt (fun c' -> colliding c' |> not) candidates with
    | None -> move_collideable c
    | Some c' ->  c'
    end
  else
    let c' = move_collideable c in
    if colliding c' then c else c'

let speed_collideable (c: collideable) (vx: int) (vy: int) : collideable =
  { c with vx = vx; vy = vy }
