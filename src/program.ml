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

let key_of_gui_key (key: Gui.key) : key =
  match key with
  | W -> W
  | A -> A
  | S -> S
  | D -> D
  | Q -> Q
  | E -> E
  | Enter -> Enter
  | Space -> Space
  | Shift -> Shift
  | ArrowUp -> ArrowUp
  | ArrowLeft -> ArrowLeft
  | ArrowDown -> ArrowDown
  | ArrowRight -> ArrowRight
  | Other -> Other

type msg =
  | Click of int * int
  | MouseDown of int * int
  | MouseUp of int * int
  | MouseMove of int * int
  | KeyDown of key
  | KeyUp of key
  | Resize of int * int
  | AnimationFrame of int
  [@@bs.deriving {accessors}]

type canvas = { 
  draw_image: string -> int -> int -> (int * int) option -> unit;
  fill_rect: int -> int -> int -> int -> unit;
  draw_rect: int -> int -> int -> int -> unit;
  draw_line: int -> int -> int -> int -> unit;
  draw_circle: int -> int -> int -> unit;
  draw_arc: int -> int -> int -> float -> float -> unit;
  set_color: string -> unit;
  get_color: unit -> string;
  set_line_width: int -> unit;
  get_line_width: unit -> int;
  get_size: unit -> (int * int)
}

type 'model program =
  { init: int -> int -> 'model
  ; update: 'model -> msg -> 'model
  ; repaint: canvas -> 'model -> unit
  }

let run_program (id: string) (program: 'model program) : unit =
  let msgs = ref [] in
  let (canvas, ec) = Gui.mk_canvas id in
  let (w, h) = canvas.get_size () in
  let model = ref (program.init w h) in
  let canvas' =
    { draw_image = canvas.draw_image
    ; fill_rect = canvas.fill_rect
    ; draw_rect = canvas.draw_rect
    ; draw_line = canvas.draw_line
    ; draw_circle = canvas.draw_circle
    ; draw_arc = canvas.draw_arc
    ; set_color = canvas.set_color
    ; get_color = canvas.get_color
    ; set_line_width = canvas.set_line_width
    ; get_line_width = canvas.get_line_width
    ; get_size = canvas.get_size
    }
  in

  ec.add_event_listener (fun event ->
    match event with
    | Click (x, y) -> msgs := (Click (x, y)) :: !msgs
    | MouseDown (x, y) -> msgs := (MouseDown (x, y)) :: !msgs
    | MouseUp (x, y) -> msgs := (MouseUp (x, y)) :: !msgs
    | MouseMove (x, y) -> msgs := (MouseMove (x, y)) :: !msgs
    | KeyDown key -> msgs := (KeyDown (key_of_gui_key key)) :: !msgs
    | KeyUp key -> msgs := (KeyUp (key_of_gui_key key)) :: !msgs
    | Resize (w, h) -> msgs := (Resize (w, h)) :: !msgs
  );

  let last_timestamp = ref None in

  let rec loop (timestamp: int) : unit =
    model := List.fold_right (fun x acc -> program.update acc x) !msgs !model;
    let delta =
      match !last_timestamp with
      | None -> 0
      | Some timestamp' -> timestamp - timestamp'
    in
    model := program.update !model (AnimationFrame delta);
    canvas.clear ();
    program.repaint canvas' !model;
    msgs := [];
    last_timestamp := Some timestamp;
    Gui.request_animation_frame loop
  in

  Gui.request_animation_frame loop