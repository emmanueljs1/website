open Action

type sprite =
  { action: action
  ; asset_dir: string
  ; sprite_base: string
  }

let init_sprite (action: action) (asset_dir: string)
  (sprite_base: string): sprite =
  { action = action
  ; asset_dir = asset_dir
  ; sprite_base = sprite_base
  }

let sprite_img (s: sprite) (tick: int) : string =
  let sprite_action = str_of_action s.action in
  let asset_dir = s.asset_dir in
  let sprite_base = s.sprite_base in
  let pos = min (tick / 5) 3 in
  Printf.sprintf "%s/%s_%s_anim_f%d.png" asset_dir sprite_base sprite_action pos
