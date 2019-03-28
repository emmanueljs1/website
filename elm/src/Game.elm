module Game exposing (main)

import Browser
import Browser.Dom  exposing (getViewport)
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import String exposing (fromInt)
import Svg exposing (svg, image)
import Svg.Attributes exposing (xlinkHref, x, y)

type alias Player =
  {
    x: Int,
    y: Int,
    vx: Int,
    vy: Int,
    sprite: String
  }

initPlayer = { x = 50, y = 200, vx = 0, vy = 0, sprite = "../images/sprite.png" }

type alias Model = 
  {
    playing: Bool,
    player: Player
  }

initModel : Model
initModel =  { playing = True, player = initPlayer }

view : Model -> Html Msg
view model =
  div
    [ style "margin" "0 auto"
    , style "display" "flex"
    , style "height" "100%"
    , style "width" "100%"
    ]
    [
      if model.playing then
        svg
        [ style "height" "100%"
        , style "width" "100%"
        ]
        [ image
          [ xlinkHref model.player.sprite, x (fromInt model.player.x), y (fromInt model.player.y) ]
          []
        ]
      else
        div [] []
    ]

type Direction = Up | Left | Down | Right

type Msg = Move Direction Bool | Tick Float | Noop

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let player = model.player in
  case msg of
    Move dir on ->
      case dir of
        Up ->
          if on then
            ( { model | player = { player | vy = -2 } }, Cmd.none)
          else
            ( { model | player = { player | vy = 0 } }, Cmd.none)
        Left ->
          if on then
            ( { model | player = { player | vx = -2 } }, Cmd.none)
          else
            ( { model | player = { player | vx = 0 } }, Cmd.none)
        Down ->
          if on then
            ( { model | player = { player | vy = 2 } }, Cmd.none)
          else
            ( { model | player = { player | vy = 0 } }, Cmd.none)
        Right ->
          if on then
            ( { model | player = { player | vx = 2 } }, Cmd.none)
          else
            ( { model | player = { player | vx = 0 } }, Cmd.none)
    Tick _ ->
      let newX = player.x + player.vx in
      let newY = player.y + player.vy in
      -- TODO: animate sprite movement (change image)
      ( { model | player = { player | x = newX, y =  newY} }, Cmd.none)
    Noop ->
      (model, Cmd.none)

type Key = W | A | S | D | Space | Other

key : Int -> Key
key keycode =
  case keycode of
    87 -> W
    65 -> A
    83 -> S
    68 -> D
    32 -> Space
    _ -> Other

msgFromKeyCode : Bool -> Int -> Msg
msgFromKeyCode on keycode =
  case key keycode of
    W ->
      Move Up on
    A ->
      Move Left on
    S ->
      Move Down on
    D ->
      Move Right on
    _ ->
      Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ if model.playing then
        onAnimationFrameDelta Tick
      else
       Sub.none
    , onKeyUp (Decode.map (msgFromKeyCode False) keyCode)
    , onKeyDown (Decode.map (msgFromKeyCode True) keyCode) ]

main : Program () Model Msg
main =
  Browser.element
    { init = \_ -> (initModel, Cmd.none),
      view = view,
      update = update,
      subscriptions = subscriptions
    }
