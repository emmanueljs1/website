module Game exposing (main)

import Browser
import Browser.Dom  exposing (Viewport, getViewport)
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import String exposing (fromInt)
import Svg exposing (svg, image)
import Svg.Attributes exposing (xlinkHref, x, y, width, height)
import Task exposing (perform)

lowerXBound : Int
lowerXBound = 0

lowerYBound : Int
lowerYBound = 200

type alias Character =
  { x: Int
  , y: Int
  , width: Int
  , height: Int
  , vx: Int
  , vy: Int
  , sprite: String
  }

initPlayer : Character
initPlayer = 
  { x = 50
  , y = lowerYBound
  , width = 32
  , height = 44
  , vx = 0
  , vy = 0
  , sprite = "../images/sprite.png" 
  }

type alias Model = 
  { playing: Bool
  , player: Character
  , enemies: List (Character, Int)
  , size: (Int, Int)
  }

initModel : Model
initModel =  { playing = True, player = initPlayer, enemies = [], size = (500, 500) }

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
          [ xlinkHref model.player.sprite
          , x (fromInt model.player.x)
          , y (fromInt model.player.y)
          , width (fromInt model.player.width)
          , height (fromInt model.player.height)
          ]
          []
        ]
      else
        div [] []
    ]

type Direction = Up | Left | Down | Right

type Msg 
  = Move Direction Bool
  | GetViewport Viewport
  | Resize Int Int
  | Tick Float
  | Noop

collides : Character -> Character -> Bool
collides c1 c2 =
  c1.x < c2.x + c2.width &&
  c1.x + c1.width > c2.x &&
  c1.y < c2.y + c2.height &&
  c1.y + c1.height > c2.y

inBounds : Character -> Int -> Int -> Int -> Int -> Bool
inBounds c xMin yMin xMax yMax =
  c.x >= xMin &&
  c.y >= yMin &&
  c.x + c.width <= xMax &&
  c.y + c.height <= yMax

moveEnemy : (Character, Int) -> Maybe (Character, Int)
moveEnemy (enemy, timestep) =
  case timestep of
    0 -> Just (enemy, timestep)
    1 -> Just (enemy, timestep)
    2 -> Just (enemy, timestep)
    _ -> Nothing

keepMaybes : List (Maybe a) -> List a
keepMaybes =
  List.foldl (\maybe acc -> case maybe of 
                              Nothing -> acc
                              Just x -> x :: acc
             ) []

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let player = model.player in
  let enemies = model.enemies in
  let (width, height) = model.size in
  case msg of
    Move dir on ->
      case dir of
        Up ->
          if on then
            ({ model | player = { player | vy = -3 } }, Cmd.none)
          else
            ( { model | player = { player | vy = 0 } }, Cmd.none)
        Left ->
          if on then
            ({ model | player = { player | vx = -3 } }, Cmd.none)
          else
            ({ model | player = { player | vx = 0 } }, Cmd.none)
        Down ->
          if on then
            ({ model | player = { player | vy = 3 } }, Cmd.none)
          else
            ({ model | player = { player | vy = 0 } }, Cmd.none)
        Right ->
          if on then
            ({ model | player = { player | vx = 3 } }, Cmd.none)
          else
            ({ model | player = { player | vx = 0 } }, Cmd.none)

    Tick _ ->
      let newX = player.x + player.vx in
      let newY = player.y + player.vy in
      let newPlayer = { player | x = newX, y =  newY } in

      let newEnemies = List.map moveEnemy enemies |> keepMaybes in

      let playerCollidesWithEnemy = List.foldl (\(enemy, _) acc -> acc || collides newPlayer enemy) False newEnemies in

      let playerInBounds = inBounds newPlayer lowerXBound lowerYBound width height in

      -- TODO: animate sprite movement (change image)
      ({ model | player = if playerInBounds then newPlayer else player, enemies = newEnemies }
      , Cmd.none)

    GetViewport { viewport } ->
      ( { model | size = (truncate viewport.width, truncate viewport.height) }, Cmd.none)

    Resize newWidth newHeight ->
      let newX = if player.x > newWidth then newWidth - player.width else player.x in
      let newY = if player.y > newHeight then newHeight - player.height else player.y in
      let newPlayer = { player | x = newX, y = newY} in
      ( { model | player = newPlayer, size = (newWidth, newHeight) }, Cmd.none)

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
    , onKeyDown (Decode.map (msgFromKeyCode True) keyCode)
    , onResize Resize
    ]

main : Program () Model Msg
main =
  Browser.element
    { init = \_ -> (initModel, perform GetViewport getViewport),
      view = view,
      update = update,
      subscriptions = subscriptions
    }
