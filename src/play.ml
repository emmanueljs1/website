open Program

let x_min = 0
let y_min = 0

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

let init_player () : character =
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

let init (width: int) (height: int) : model =
  { playing = true
  ; player = init_player ()
  ; width = width
  ; height = height
  }

type direction = 
  | Up
  | Left
  | Down
  | Right

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
    let player = model.player in

    let x' = player.x + player.vx in
    let y' = player.y + player.vy in
    let player' = { player with x = x'; y = y' } in

    if within_bounds player' x_min y_min model.width model.height then
      { model with player = player' }
    else
      model
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
    | AnimationFrame _ -> timer_update model
    | _ -> model
  in
  model'

let repaint (canvas: canvas) (model: model) : unit =
  let player = model.player in
  let sprite = model.player.sprite in
  canvas.draw_image sprite player.x player.y (Some (player.width, player.height))

let main (id: string) : unit =
  let program = { init = init; update = update; repaint = repaint } in
  run_program id program
