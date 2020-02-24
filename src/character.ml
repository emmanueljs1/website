type action =
  | Idle of bool
  | Run of bool
  | Hit
  | Attacked

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

let character_size (c: character) : int * int = (c.width, c.height)

let move_character (c: character) (y_lo: int) (y_hi: int) (x_lo: int) (x_hi: int) : character =
  let x' = min (max x_lo (c.x + c.vx)) (x_hi- c.width) in
  let y' = min (max y_lo (c.y + c.vy)) (y_hi - c.height) in
  { c with x = x'; y = y' }

let act_character (c: character) : character =
  let action' =
    match c.action with
    | Hit | Attacked -> c.action
    | _ ->
      begin match c.vx, c.vy with
      | vx, _ when vx != 0 -> Run (vx > 0)
      | _ ->
        begin match c.action with
        | Run is_right -> Idle is_right
        | _ -> c.action
        end
      end
  in
  { c with action = action' }

let is_colliding (c1: character) (c2: character) : bool =
  (* TODO: implement *)
  false

let character_sprite (c: character) (tick: int) : string =
  let str_of_is_right (is_right: bool) : string =
    if is_right then "right" else "left"
  in

  let str_of_action (action: action) : string =
    match action with
    | Run is_right -> Printf.sprintf "run_%s" (str_of_is_right is_right)
    | Hit -> "hit"
    | Attacked -> "attacked"
    | Idle is_right -> Printf.sprintf "idle_%s" (str_of_is_right is_right)
  in

  let sprite_action = str_of_action c.action in
  let sprite_base = c.sprite_base in
  let pos = min (tick / 5) 3 in
  Printf.sprintf "../images/%s_%s_anim_f%d.png" sprite_base sprite_action pos

let init_character (init_x: int) (init_y: int) (width: int) (height: int) (sprite_base: string) : character =
  { x = init_x
  ; y = init_y
  ; width = width
  ; height = height
  ; vx = 0
  ; vy = 0
  ; action = Idle true
  ; sprite_base = sprite_base
  }
