open Action

type sprite =
  { action: action
  ; sprite_base: string
  }

let init_sprite (action: action) (sprite_base: string): sprite =
  { action = action
  ; sprite_base = sprite_base
  }

let sprite_img (s: sprite) (tick: int) : string =
  let sprite_action = str_of_action s.action in
  let sprite_base = s.sprite_base in
  let pos = min (tick / 5) 3 in
  Printf.sprintf "../images/%s_%s_anim_f%d.png" sprite_base sprite_action pos
