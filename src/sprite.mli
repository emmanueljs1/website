open Action

type sprite =
  { action : action
  ; sprite_base : string
  }

val init_sprite: action -> string -> sprite
val sprite_img: sprite -> int -> string
