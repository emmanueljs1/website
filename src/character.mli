open Collideable
open Program
open Sprite
open Util

type character =
  { collideable: collideable
  ; sprite: sprite
  }

val init_character: point -> size -> point -> point -> string -> character
val draw_character: character -> canvas -> int -> unit
val react_character: character -> collideable list -> character
