open Tea.App
open Tea.Html
module Svg = Tea.Svg
module Sub = Tea.Sub
module Cmd = Tea.Cmd

let lower_x_bound = 0

let lower_y_bound = 200

type character =
  { x: int
  ; y: int
  ; width: int
  ; height: int
  ; vx: int
  ; vy: int
  ; sprite: string
  }

let init_player () = 
  { x = 50
  ; y = lower_y_bound
  ; width = 32
  ; height = 44
  ; vx = 0
  ; vy = 0
  ; sprite = "../images/sprite.png" 
  }

type model = 
  { playing: bool
  ; player: character
  }

let init () = { playing = true; player = init_player () }

type direction = 
  | Up
  | Left
  | Down
  | Right

type msg =
  | Move of direction * bool
  | Tick of float
  | Noop
  [@@bs.deriving {accessors}]

let update (model: model) (msg: msg) : model * msg Cmd.t =
  match msg with
  | _ -> model, Cmd.none

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
  failwith "unimplemented"

let main : (unit, model, msg) standardProgram =
  { init = (fun () -> (init (), Cmd.none))
  ; update = update
  ; view = view
  ; subscriptions = subscriptions
  }
