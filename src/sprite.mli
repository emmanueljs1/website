open Action

type sprite =
  { action : action
  ; asset_dir: string
  ; sprite_base : string
  }

val init_sprite: action -> string -> string -> sprite
val sprite_img: sprite -> int -> string
