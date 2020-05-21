open Collideable
open Sprite
open Util

type character =
  { collideable: collideable
  ; sprite: sprite
  }

val init_character: point -> size -> point -> point -> string -> character
val react_character: character -> character