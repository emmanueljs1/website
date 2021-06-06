open Character
open Collideable
open Direction
open Program
open Sprite
open Util

let x_min = 0
let y_min = 60
let dist_delta = 5
let (font, font_size, font_color) = PressStart, 9, Hex "595959"

type model = 
  { playing: bool
  ; player: character
  ; npcs: (character * string) list
  ; interacting: character option
  ; size: size
  ; tick: int
  }

let init_player (width: int) (height: int) (asset_dir: string) : character =
  let lower_bound = { x = x_min; y = y_min } in
  let upper_bound = { x = width; y = height } in
  let size = { width = 48; height = 84 } in
  let init_pos = { x = width / 2 - size.width; y = height / 2 - size.height} in
  init_character init_pos size lower_bound upper_bound asset_dir "wizzard_m"

let init_npcs (width: int) (height: int) (asset_dir: string) : (character * string) list =
  let lower_bound = { x = x_min; y = y_min } in
  let upper_bound = { x = width; y = height } in
  let k_size = { width = 64; height = 84 } in
  let init_knight_pos = { x = width / 2 - k_size.width; y = y_min } in
  let knight =
    init_character init_knight_pos k_size lower_bound upper_bound asset_dir "knight_f"
  in
  [ knight, "Good morrow, traveler! Have thou heard of Emmanuel Suarez? Legend tells he hails from the far land of Puerto Rico" ]

let init ~width ~height ~asset_dir : model =
  { playing = true
  ; player = init_player width height asset_dir
  ; npcs = init_npcs width height asset_dir
  ; interacting = None
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
    let collideables = List.map (fun (npc, _) -> npc.collideable) model.npcs in
    let player' = react_character model.player collideables in

    let interacting' =
      match model.interacting with
      | None -> None
      | Some c ->
        if are_adjacent player'.collideable c.collideable dist_delta then
          model.interacting
        else
          None
    in

    let (npcs', interacting'') =
      List.fold_right (fun (npc, s) (acc, interacting) ->
        match interacting with
        | Some c when c = npc->
            let npc' =
              if player'.collideable.pos.x < npc.collideable.pos.x then
                { npc with sprite = { npc.sprite with action = Idle false } }
              else
                { npc with sprite = { npc.sprite with action = Idle true } }
            in
            (npc', s) :: acc, Some npc'
        | _ -> (npc, s) :: acc, interacting
      ) model.npcs ([], interacting')
    in

    { playing = true
    ; player = player'
    ; npcs = npcs'
    ; interacting = interacting''
    ; size = model.size
    ; tick = tick'
    }
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
            let interacting' =
              try
                let (adjacent_npc, _) =
                  List.find (fun (npc, _) ->
                    are_adjacent player.collideable npc.collideable dist_delta
                  ) model.npcs
                in
                Some adjacent_npc
              with Not_found -> None
            in
            { model with interacting = interacting' }
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
  List.iter (fun (npc, text) ->
    let _ =
      match model.interacting with
      | Some c when c = npc ->
        let x = dist_delta * 2 in
        let y = dist_delta * 2 in
        let bubble_width = model.size.width in
        let bubble_height = font_size * 2 + dist_delta * 2 in
        let bubble_x = x - dist_delta * 2 in
        let bubble_y = y - dist_delta * 2 in
        let bubble_r = Some dist_delta in
        canvas.set_color White;
        canvas.fill_rect bubble_x bubble_y bubble_width bubble_height bubble_r;
        canvas.set_color font_color;
        canvas.draw_text text font font_size x y
      | _ -> ()
    in

    draw_character npc canvas model.tick
  ) model.npcs;
  draw_character model.player canvas model.tick

let main (id: string) (asset_dir: string) : unit =
  let program =
    { init = init
    ; update = update
    ; repaint = repaint
    }
  in
  run_program id asset_dir program
