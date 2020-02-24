type action =
  | Idle of bool (* is_right*)
  | Run of bool (* is_right *)
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

val character_size: character -> int * int

val move_character: character -> int -> int -> int -> int -> character

val act_character: character -> character

val character_sprite: character -> int -> string

val init_character: int -> int -> int -> int -> string -> character
