open Program

external w_height: int = "innerHeight" [@@bs.val][@@bs.scope "window"]
external w_width: int = "innerWidth" [@@bs.val][@@bs.scope "window"]

let x_min = 0
let y_min = 250

type character =
  { x: int
  ; y: int
  ; width: int
  ; height: int
  ; vx: int
  ; vy: int
  ; sprite: string
  }

let within_bounds (c: character) (x_lo: int) (y_lo: int) (x_hi: int) (y_hi: int) : bool =
  c.x >= x_lo &&
  c.y >= y_lo &&
  c.x + c.width <= x_hi &&
  c.y + c.height <= y_hi

let init_player () =
  { x = 0
  ; y = 0
  ; width = 8
  ; height = 10
  ; vx = 0
  ; vy = 0
  ; sprite = "../images/sprite.png"
  }

type model = 
  { playing: bool
  ; player: character
  ; width: int
  ; height: int
  }

let init () = 
  { playing = true
  ; player = init_player ()
  ; width = w_width
  ; height = w_height
  }

type direction = 
  | Up
  | Left
  | Down
  | Right

let dir_of_key (key: Gui.key) : direction option =
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
    let player =
      if w_height = model.height && w_width = model.width then
        model.player
      else
        (* window was resized *)
        if within_bounds model.player x_min y_min w_width w_height then
          model.player
        else
          init_player ()
    in

    let model' = { model with width = w_width; height = w_height } in
    let x' = player.x + player.vx in
    let y' = player.y + player.vy in
    let player' = { player with x = x'; y = y' } in

    if within_bounds player' x_min y_min w_width w_height then
      { model' with player = player' }
    else 
      model'
  else
      model

let update (model: model) (msg: Gui.event) : model =
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
    | _ -> model
  in
  model'

let view (canvas: Gui.canvas) (model: model) : unit =
  let player = model.player in
  let sprite = model.player.sprite in
  canvas.draw_image sprite player.x player.y (Some (player.width, player.height))

let main (id: string) : unit =
  let program = { init = init; update = update; view = view } in
  run_program id program
