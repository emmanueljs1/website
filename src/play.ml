open Character
open Collideable
open Direction
open Program
open Sprite
open Util

let x_min = 0
let y_min = 60

type model = 
  { playing: bool
  ; player: character
  ; size: size
  ; tick: int
  }

let init_player (width: int) (height: int) : character =
  let init_pos = { x = x_min; y = y_min } in
  let player_size = { width = 48; height = 84 } in
  let lower_bound = init_pos in
  let upper_bound = { x = width; y = height } in
  init_character init_pos player_size lower_bound upper_bound "wizzard_m"

let init ~width ~height : model =
  { playing = true
  ; player = init_player width height
  ; size = { width = width; height = height }
  ; tick = 0
  }

let dir_of_key (key: key) : direction option =
  match key with
  | W ->
    Some Up
  | A ->
    Some Left
  | S ->
    Some Down
  | D ->
    Some Right
  | _ -> None

let timer_update (model: model) : model =
  if model.playing then
    let tick' = (model.tick + 1) mod 25 in
    let player' = react_character model.player in
    { model with player = player'; tick = tick' }
  else
      model

let update (model: model) (msg: msg) : model =
  let player = model.player in
  let model' =
    match msg with
    | KeyDown key ->
      begin match dir_of_key key with
      | Some dir ->
        let p_collideable' =
          match dir with
          | Up -> { player.collideable with vy = -3 }
          | Left -> { player.collideable with vx = -3 }
          | Down -> { player.collideable with vy = 3 }
          | Right -> { player.collideable with vx = 3 }
        in
        { model with player = { player with collideable = p_collideable' } }
      | None -> model
      end
    | KeyUp key ->
      begin match dir_of_key key with
      | Some dir ->
        let p_collideable' =
          match dir with
          | Up | Down -> { player.collideable with vy = 0 }
          | Left | Right -> { player.collideable with vx = 0 }
        in
        { model with player = { player with collideable = p_collideable' } }
      | None -> model
      end
    | Resize (w, h) ->
      let p_collideable = player.collideable in
      let x' = max (min p_collideable.pos.x w) x_min in
      let y' = max (min p_collideable.pos.y h) y_min in
      let pos' = { x = x'; y = y' } in
      let upper_bound' = { x = w; y = h} in
      let p_collideable' = { p_collideable with pos = pos'; upper_bound = upper_bound' } in
      { model with player = { player with collideable = p_collideable' } }
    | AnimationFrame _ -> timer_update model
    | _ -> model
  in
  model'

let repaint (canvas: canvas) (model: model) : unit =
  let player = model.player in
  let sprite_img = sprite_img model.player.sprite model.tick in
  let size = (player.collideable.size.width, player.collideable.size.height) in
  let (x, y) = (player.collideable.pos.x, player.collideable.pos.y) in
  canvas.draw_image sprite_img x y (Some size)

let main (id: string) : unit =
  let program = { init = init; update = update; repaint = repaint } in
  run_program id program
