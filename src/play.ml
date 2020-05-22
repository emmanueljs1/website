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
  ; npcs: character list
  ; size: size
  ; tick: int
  }

let init_player (width: int) (height: int) : character =
  let lower_bound = { x = x_min; y = y_min } in
  let upper_bound = { x = width; y = height } in
  let size = { width = 48; height = 84 } in
  let init_pos = { x = width / 2 - size.width; y = height / 2 - size.height} in
  init_character init_pos size lower_bound upper_bound "wizzard_m"

let init_npcs (width: int) (height: int) : character list =
  let lower_bound = { x = x_min; y = y_min } in
  let upper_bound = { x = width; y = height } in
  let k_size = { width = 64; height = 84 } in
  let init_knight_pos = { x = width / 2 - k_size.width; y = y_min } in
  let knight = init_character init_knight_pos k_size lower_bound upper_bound "knight_f" in
  [knight]

let init ~width ~height : model =
  { playing = true
  ; player = init_player width height
  ; npcs = init_npcs width height
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
    let collideables = List.map (fun npc -> npc.collideable) model.npcs in
    let player' = react_character model.player collideables in

    let npcs' = List.map (fun npc ->
      match npc.interacting with
      | Some (c) ->
        if c.collideable.pos.x < npc.collideable.pos.x then
          { npc with sprite = { npc.sprite with action = Idle false } }
        else
          { npc with sprite = { npc.sprite with action = Idle true } }
      | None -> npc
    ) model.npcs
    in

    { model with player = player'; npcs = npcs'; tick = tick' }
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
      | None ->
          begin match key with
          | Enter ->
            begin try
              let adjacent_npc =
                List.find (fun npc ->
                  are_adjacent player.collideable npc.collideable 3
                ) model.npcs
              in
              player.interacting <- Some adjacent_npc;
              adjacent_npc.interacting <- Some player;
              model
              with Not_found -> model end
          | _ -> model
          end
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
  List.iter (fun npc -> draw_character npc canvas model.tick) model.npcs;
  draw_character model.player canvas model.tick

let main (id: string) : unit =
  let program = { init = init; update = update; repaint = repaint } in
  run_program id program
