type key =
  | W
  | A
  | S
  | D
  | Q
  | E
  | Enter
  | Space
  | Shift
  | ArrowUp
  | ArrowLeft
  | ArrowDown
  | ArrowRight
  | Other
  [@@bs.deriving {accessors}]

type msg =
  | Click of int * int
  | MouseDown of int * int
  | MouseUp of int * int
  | MouseMove of int * int
  | KeyDown of key
  | KeyUp of key
  | AnimationFrame of int
  [@@bs.deriving {accessors}]

type canvas = { 
  (* Draw an image with filename at (x, y) with an optional width and height *)
  draw_image: string -> int -> int -> (int * int) option -> unit;
  (* Fill a rectange at (x, y) with width and height *)
  fill_rect: int -> int -> int -> int -> unit;
  (* Draw a rectange at (x, y) with width and height *)
  draw_rect: int -> int -> int -> int -> unit;
  (* Draw a line from (x1, y1) to (x2, y2) *)
  draw_line: int -> int -> int -> int -> unit;
  (* Draw a circle at (x, y) with radius r *)
  draw_circle: int -> int -> int -> unit;
  (* Draw an arc at (x, y) with radius r, start angle theta1 and end angle
  * theta2. theta = 0 correspondes to 3 o' clock position of arc's circle.
  * Angle should be in radians *)
  draw_arc: int -> int -> int -> float -> float -> unit;
  (* Set draw color of canvas *)
  set_color: string -> unit;
  (* Get draw color of canvas *)
  get_color: unit -> string;
  (* Set draw line width of canvas *)
  set_line_width: int -> unit;
  (* Get draw line width of canvas *)
  get_line_width: unit -> int;
  (* Get width and height of canvas *)
  get_size: unit -> (int * int)
}

type 'model program =
  { init: int -> int -> 'model
  ; update: 'model -> msg -> 'model
  ; repaint: canvas -> 'model -> unit
  }

val run_program: string -> 'model program -> unit