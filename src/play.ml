open Character
open Direction
open Program

module CharacterSet =
  Set.Make(struct type t = character let compare = compare end)

let x_min = 0
let y_min = 60

let init_player () : character =
  let player_width = 48 in
  let player_height = 84 in
  init_character x_min y_min player_width player_height "wizzard_m"

let init_enemy (x_max: int) (y_max: int) : character =
  let enemy_width = 48 in
  let enemey_height = 48 in
  let x = Js.Math.random_int x_min (x_max - enemy_width) in
  let y = Js.Math.random_int y_min (y_max - enemey_height) in
  init_character x y enemy_width enemey_height "skelet"

type model = 
  { playing: bool
  ; player: character
  ; enemies: CharacterSet.t
  ; width: int
  ; height: int
  ; tick: int
  }

let init ~width ~height : model =
  { playing = true
  ; player = init_player ()
  ; enemies = CharacterSet.add (init_enemy width height) CharacterSet.empty
  ; width = width
  ; height = height
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
    let player = model.player in
    let player' = move_character player y_min model.height x_min model.width in
    let player'' = act_character player' in
    { model with player = player''; tick = tick' }
  else
      model

let update (model: model) (msg: msg) : model =
  let player = model.player in
  let model' =
    match msg with
    | KeyDown key ->
      begin match dir_of_key key with
      | Some dir ->
        begin match dir with
        | Up -> { model with player = { player with vy = -3 } }
        | Left -> { model with player = { player with vx = -3 } }
        | Down -> { model with player = { player with vy = 3 } }
        | Right -> { model with player = { player with vx = 3 } }
        end
      | None -> model
      end
    | KeyUp key ->
      begin match dir_of_key key with
      | Some dir ->
        begin match dir with
        | Up | Down -> { model with player = { player with vy = 0 } }
        | Left | Right -> { model with player = { player with vx = 0 } }
        end
      | None -> model
      end
    | Resize (w, h) ->
      let x' = max (min model.player.x w) x_min in
      let y' = max (min model.player.y h) y_min in
      let player' = { model.player with x = x'; y = y' } in
      { model with width = w; height = h; player = player' }
    | AnimationFrame _ -> timer_update model
    | _ -> model
  in
  model'

let repaint (canvas: canvas) (model: model) : unit =
  let player = model.player in
  let player_size = character_size player in
  let sprite = character_sprite model.player model.tick in
  canvas.draw_image sprite player.x player.y (Some player_size);
  CharacterSet.iter (fun enemy ->
    let enemy_size = character_size enemy in
    let sprite = character_sprite enemy model.tick in
    canvas.draw_image sprite enemy.x enemy.y (Some enemy_size)
  ) model.enemies

let main (id: string) : unit =
  let program = { init = init; update = update; repaint = repaint } in
  run_program id program
