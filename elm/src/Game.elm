module Game exposing (main)

import Browser
import Browser.Dom  exposing (getViewport)
import Browser.Events exposing (onKeyDown, onKeyUp)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Svg exposing (svg, image)
import Svg.Attributes exposing (xlinkHref, x, y)

type alias Model = { playing: Bool }

initModel : Model
initModel =  { playing = True }

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
          [ xlinkHref "../images/sprite.png", x "50", y "200" ]
          []
        ]
      else
        div [] []
    ]

type Msg = MoveLeft Bool | MoveRight Bool | MoveUp Bool | MoveDown Bool | Noop

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoveLeft True ->
      ( model, Cmd.none)
    MoveLeft False ->
      ( model, Cmd.none)
    MoveRight _ ->
      (model, Cmd.none)
    MoveUp _ ->
      (model, Cmd.none)
    MoveDown _ ->
      (model, Cmd.none)
    Noop ->
      (model, Cmd.none)

type Key = W | A | S | D | Space | Other

keyOfKeyCode : Int -> Key
keyOfKeyCode keycode =
  case keycode of
    87 -> W
    65 -> A
    83 -> S
    68 -> D
    32 -> Space
    _ -> Other

key : Bool -> Int -> Msg
key on keycode =
  case keyOfKeyCode keycode of
    W ->
      MoveUp on
    A ->
      MoveLeft on
    S ->
      MoveDown on
    D ->
      MoveRight on
    _ ->
      Noop

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onKeyUp (Decode.map (key False) (keyCode))
        , onKeyDown (Decode.map (key True) (keyCode))
        ]

main : Program () Model Msg
main =
  Browser.element
    { init = \_ -> (initModel, Cmd.none),
      view = view,
      update = update,
      subscriptions = subscriptions
    }
