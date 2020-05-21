open Collideable
open Sprite
open Util

type character =
  { collideable: collideable
  ; sprite: sprite
  }

let init_character (init_pos: point) (size: size) (lower_bound: point)
  (upper_bound: point) (sprite_base: string) : character =
  { collideable = init_collideable init_pos size lower_bound upper_bound
  ; sprite = init_sprite (Idle true) sprite_base
  }

let react_character (c: character) : character =
  let action' =
    match c.sprite.action with
    | Interact -> c.sprite.action
    | _ ->
      begin match c.collideable.vx, c.collideable.vy with
      | vx, _ when vx != 0 -> Run (vx > 0)
      | _ ->
        begin match c.sprite.action with
        | Run is_right -> Idle is_right
        | _ -> c.sprite.action
        end
      end
  in
  { collideable = move_collideable c.collideable
  ; sprite = { c.sprite with action = action' }
  }
