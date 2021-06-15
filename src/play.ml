open Character
open Collideable
open Constants
open Direction
open Program
open Sprite
open Util

type model = 
  { playing: bool
  ; player: character
  ; npcs: (character * string) list
  ; interacting: character option
  ; size: size
  ; tick: int
  }

let lower_bound = { x = x_min; y = y_min }
let get_upper_bound (width: int) (height: int) : point = { x = width; y = height }

let init_player (width: int) (height: int) (asset_dir: string) : character =
  let upper_bound = get_upper_bound width height in
  let size = { width = 48; height = 84 } in
  let init_pos = { x = width / 2 - size.width; y = height / 2 - size.height} in
  init_character init_pos size lower_bound upper_bound asset_dir "wizzard_m"

let init_knight (width: int) (height: int) (asset_dir: string) (spanish: bool): character * string =
  let lower_bound = { x = x_min; y = y_min } in
  let upper_bound = get_upper_bound width height in
  let knight_size = { width = 64; height = 84 } in
  let init_knight_pos = { x = width / 2 - knight_size.width; y = y_min } in
  let knight =
    init_character init_knight_pos knight_size lower_bound upper_bound asset_dir "knight_f"
  in
  let knight_text = if spanish then knight_text_es else knight_text_en in
  knight, knight_text

let init_npcs (width: int) (height: int) (asset_dir: string) (spanish: bool) : (character * string) list =
  [init_knight width height asset_dir spanish]

let init (spanish: bool) (asset_dir: string) = (fun ~width ~height ->
  { playing = true
  ; player = init_player width height asset_dir
  ; npcs = init_npcs width height asset_dir spanish
  ; interacting = None
  ; size = { width = width; height = height }
  ; tick = 0
  }
)

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
    | Resize (w', h') ->
      let w, h = model.size.width, model.size.height in
      let scale_factor_x = float_of_int w' /. float_of_int w in
      let scale_factor_y = float_of_int h' /. float_of_int h in

      let scale (factor: float) (i: int) : int =
        int_of_float ((float_of_int i) *. factor)
      in

      let x_min' = scale scale_factor_x x_min in
      let y_min' = scale scale_factor_y y_min in

      let scale_collideable (collideable: collideable) : collideable =
        let x' = scale scale_factor_x collideable.pos.x in
        let y' = scale scale_factor_y collideable.pos.y in
        let pos' = { x = min (max x' x_min') w'; y = min (max y' y_min) h' } in
        let upper_bound' = { x = w'; y = h'} in
        { collideable with pos = pos'
        ; upper_bound = upper_bound'
        ; lower_bound = { x = x_min'; y = y_min' }
        }
      in

      let npcs' =
        List.map (fun (npc, s) ->
          { npc with collideable = scale_collideable npc.collideable }, s
        ) model.npcs
      in

      let player_collideable' = scale_collideable player.collideable in
      let player' = { player with collideable = player_collideable' } in
      { model with player = player'
      ; npcs = npcs'
      ; size = { width = w'; height = h' }
      }
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

let main (id: string) (spanish: bool) (asset_dir: string) (assets_filenames: string array) : unit =
  let program =
    { init = init spanish asset_dir
    ; update = update
    ; repaint = repaint
    }
  in
  run_program id (Some asset_dir) (Array.to_list assets_filenames) program
