module Game exposing (main)

import Browser
import Browser.Dom  exposing (getViewport)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Svg exposing (svg, image)
import Svg.Attributes exposing (xlinkHref, x, y)

main =
  Browser.sandbox { init = 0, update = update, view = view }

type Msg = MoveLeft | MoveRight | MoveUp | MoveDown

update msg model =
  case msg of
    MoveLeft ->
      model

    MoveRight ->
      model

    MoveUp ->
      model

    MoveDown ->
      model

view model =
  div
    [ style "margin" "0 auto"
    , style "display" "flex"
    , style "height" "100%"
    , style "width" "100%"
    ]
    [
      svg
      [ style "height" "100%"
      , style "width" "100%"
      ]
      [
        image
        [ xlinkHref "../images/sprite.png", x "50", y "200" ]
        []
      ]
    ]
