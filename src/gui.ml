type document
external doc: document = "document" [@@bs.val]

external getElementById: document -> string -> Dom.element = "getElementById" [@@bs.send]
external tagName: Dom.element -> string = "tagName" [@@bs.get]
external setTabIndex: Dom.element -> int -> unit = "tabIndex" [@@bs.set]

external addEventListener: Dom.element -> string -> (Dom.event -> unit) -> bool -> unit = "addEventListener" [@@bs.send]
external eventType: Dom.event -> string = "type" [@@bs.get]
external eventKey: Dom.event -> string = "key" [@@bs.get]

type canvasRenderingContext2D
type canvasElement
external elementToCanvasElement : Dom.element -> canvasElement = "%identity"
external getContext: canvasElement -> string -> canvasRenderingContext2D = "getContext" [@@bs.send]
external clearRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "clearRect" [@@bs.send]
external canvasWidth: canvasElement -> int = "width" [@@bs.get]
external canvasHeight: canvasElement -> int = "height" [@@bs.get]

let context (canvas: canvasElement) : canvasRenderingContext2D =
  getContext canvas "2d"

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

let key_of_string (s: string) : key =
  match s with
  | "W" -> W
  | "A" -> A
  | "S" -> S
  | "D" -> D
  | "Q" -> Q
  | "E" -> E
  | "Enter" -> Enter
  | " " -> Space
  | "Shift" -> Shift
  | "ArrowUp" -> ArrowUp
  | "ArrowLeft" -> ArrowLeft
  | "ArrowDown" -> ArrowDown
  | "ArrowRight" -> ArrowRight
  | _ -> Other

type event =
  | Click
  | KeyDown of key
  | KeyUp of key

type event_controller =
  { add_event_listener: (event -> unit) -> unit
  }

let mk_event_controller (id: string) : event_controller =
  let el = getElementById doc id in
  { add_event_listener = (fun listener ->
      let listener' (e: Dom.event) : unit =
        match eventType e with
        | "click" -> listener Click
        | "keydown" -> listener (KeyDown (key_of_string (eventKey e)))
        | "keyup" -> listener (KeyUp (key_of_string (eventKey e)))
        | _ -> ()
      in
      addEventListener el "click" listener' false;
      addEventListener el "keydown" listener' false;
      addEventListener el "keyup" listener' false
    )
  }

type canvas = 
  { draw_image: string -> int -> int -> unit
  ; fill_rect: int -> int -> int -> int -> unit
  ; draw_rect: int -> int -> int -> int -> unit
  ; draw_line: int -> int -> int -> int -> unit
  ; draw_circle: int -> int -> int -> unit
  ; draw_arc: int -> int -> int -> int -> int -> unit
  ; set_color: string -> unit
  ; get_color: unit -> string
  ; set_line_width: int -> unit
  ; get_line_width: unit -> int
  ; clear: unit -> unit
  }

let mk_canvas (id: string) : canvas * event_controller =
  let el = getElementById doc id in
  if tagName el <> "CANVAS" then
    invalid_arg "not a canvas element"
  else
    setTabIndex el 0;
    let canvas = elementToCanvasElement el in
    let ctx = context canvas in

    { draw_image = (fun _ _ _ -> failwith "unimplemented")
    ; fill_rect = (fun _ _ _ _ -> failwith "unimplemented")
    ; draw_rect = (fun _ _ _ _ -> failwith "unimplemented")
    ; draw_line = (fun _ _ _ _ -> failwith "unimplemented")
    ; draw_circle = (fun _ _ _ -> failwith "unimplemented")
    ; draw_arc = (fun _ _ _ _ _ -> failwith "unimplemented")
    ; set_color = (fun _ -> failwith "unimplemented")
    ; get_color = (fun () -> failwith "unimplemented")
    ; set_line_width = (fun _ -> failwith "unimplemented")
    ; get_line_width = (fun () -> failwith "unimplemented")
    ; clear = (fun () ->
        clearRect ctx 0 0 (canvasWidth canvas) (canvasHeight canvas)
      )
    },
    mk_event_controller id

let set_interval (tick: unit -> unit) (delta: int) : unit =
  ignore (Js.Global.setInterval tick delta)
