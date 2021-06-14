type point =
  { x: int
  ; y: int
  }

type size =
  { width: int
  ; height: int
  }

type 'a stream = Nil | Cons of 'a * (unit -> 'a stream)

let rec stream_take (s : 'a stream) (n : int) : 'a list =
  if n <= 0 then [] else
  match s with
  |  Nil -> []
  | Cons (hd, tl) -> hd :: stream_take (tl ()) (n - 1)
