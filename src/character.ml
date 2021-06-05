open Action
open Collideable
open Program
open Sprite
open Util

type character =
  { collideable: collideable
  ; sprite: sprite
  }

let init_character (init_pos: point) (size: size) (lower_bound: point)
  (upper_bound: point) (asset_dir: string) (sprite_base: string) : character =
  { collideable = init_collideable init_pos size lower_bound upper_bound
  ; sprite = init_sprite (Idle true) asset_dir sprite_base
  }

let draw_character (c: character) (canvas: canvas) (tick: int): unit =
  let sprite_img = sprite_img c.sprite tick in
  let size = (c.collideable.size.width, c.collideable.size.height) in
  let (x, y) = (c.collideable.pos.x, c.collideable.pos.y) in
  canvas.draw_image sprite_img x y (Some size)

let react_character (c: character) (collideables: collideable list) : character =
  let action' =
    match c.collideable.vx, c.collideable.vy with
    | vx, _ when vx != 0 -> Run (vx > 0)
    | _ ->
      begin match c.sprite.action with
      | Run is_right -> Idle is_right
      | _ -> c.sprite.action
      end
  in
  { collideable = move_collideable c.collideable collideables
  ; sprite = { c.sprite with action = action' }
  }
