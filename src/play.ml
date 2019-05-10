open Tea.App
open Tea.Html
module Svg = Tea.Svg
module Sub = Tea.Sub
module Cmd = Tea.Cmd
module AnimationFrame = Tea.AnimationFrame

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
  { x = 50
  ; y = y_min
  ; width = 32
  ; height = 44
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

type msg =
  | Tick of AnimationFrame.t
  | KeyDown of Keyboard.key_event
  | KeyUp of Keyboard.key_event
  [@@bs.deriving {accessors}]

let dir_of_key (key: Keyboard.key) : direction option =
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

let update (model: model) (msg: msg) : model * msg Cmd.t =
  let player = model.player in
  let model' =
    match msg with
    | KeyDown event ->
      begin match event.key_code |> Keyboard.key_of_keycode |> dir_of_key with
      | Some dir ->
        begin match dir with
        | Up -> { model with player = { player with vy = -3 } }
        | Left -> { model with player = { player with vx = -3 } }
        | Down -> { model with player = { player with vy = 3 } }
        | Right -> { model with player = { player with vx = 3 } }
        end
      | None -> model
      end
    | KeyUp event ->
      begin match event.key_code |> Keyboard.key_of_keycode |> dir_of_key with
      | Some dir ->
        begin match dir with
        | Up | Down -> { model with player = { player with vy = 0 } }
        | Left | Right -> { model with player = { player with vx = 0 } }
        end
      | None -> model
      end
    | Tick _ -> timer_update model
  in
  model', Cmd.none

let view (model: model) : msg Vdom.t =
  div
    [ style "margin" "0 auto"
    ; style "display" "flex"
    ; style "height" "100%"
    ; style "width" "100%"
    ]
    [
      if model.playing then
        Svg.svg
        [ style "height" "100%"
        ; style "width" "100%"
        ]
        [ Svg.svgimage
          [ Svg.Attributes.xlinkHref model.player.sprite
          ; Svg.Attributes.x (string_of_int model.player.x)
          ; Svg.Attributes.y (string_of_int model.player.y)
          ; Svg.Attributes.width (string_of_int model.player.width)
          ; Svg.Attributes.height (string_of_int model.player.height)
          ]
          []
        ]
      else
        div [] []
    ]

let subscriptions (model: model) : msg Sub.t =
  [ Keyboard.downs keyDown
  ; Keyboard.ups keyUp
  ; if model.playing then AnimationFrame.every tick else Sub.none
  ] |> Sub.batch

let main =
  standardProgram
    { init = (fun () -> (init (), Cmd.none))
    ; update = update
    ; view = view
    ; subscriptions = subscriptions
    }
