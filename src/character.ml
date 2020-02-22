open Direction

type action =
  | Idle
  | Run of direction
  | Hit

type character =
  { x: int
  ; y: int
  ; width: int
  ; height: int
  ; vx: int
  ; vy: int
  ; action: action
  ; sprite_base: string
  }

let character_size (c: character): int * int = (c.width, c.height)

let move_character (c: character) (y_lo: int) (y_hi: int) (x_lo: int) (x_hi: int): character =
  let x' = min (max x_lo (c.x + c.vx)) (x_hi- c.width) in
  let y' = min (max y_lo (c.y + c.vy)) (y_hi - c.height) in
  { c with x = x'; y = y' }

let act_character (c: character): character =
  let action' =
    match c.vx, c.vy with
    | vx, _ when vx > 0 -> Run Right
    | vx, _ when vx < 0 -> Run Left
    | _ -> Idle
  in
  { c with action = action' }

let character_sprite (c: character) (tick: int): string =
  let str_of_action (action: action): string =
    match action with
    | Run Right -> "run_right"
    | Run Left -> "run_left"
    | Hit -> "hit"
    | _ -> "idle"
  in

  let sprite_action = str_of_action c.action in
  let sprite_base = c.sprite_base in
  let pos = min (tick / 5) 3 in
  Printf.sprintf "../images/%s_m_%s_anim_f%d.png" sprite_base sprite_action pos

let init_character (init_x: int) (init_y: int) (width: int) (height: int) (sprite_base: string) : character =
  { x = init_x
  ; y = init_y
  ; width = width
  ; height = height
  ; vx = 0
  ; vy = 0
  ; action = Idle
  ; sprite_base = sprite_base
  } 