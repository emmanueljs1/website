open Html
module ImgMap = Map.Make(String)

let context (canvas: HTMLCanvas.canvasElement) : HTMLCanvas.canvasRenderingContext2D =
  HTMLCanvas.getContext canvas "2d"

let document = HTMLDocument.doc

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

let key_of_string (s: string) : key =
  match s with
  | "w" -> W
  | "a" -> A
  | "s" -> S
  | "d" -> D
  | "q" -> Q
  | "e" -> E
  | "Enter" -> Enter
  | " " -> Space
  | "Shift" -> Shift
  | "ArrowUp" -> ArrowUp
  | "ArrowLeft" -> ArrowLeft
  | "ArrowDown" -> ArrowDown
  | "ArrowRight" -> ArrowRight
  | _ -> Other

type event =
  | Click of int * int
  | MouseDown of int * int
  | MouseUp of int * int
  | MouseMove of int * int
  | KeyDown of key
  | KeyUp of key
  | Resize of int * int
  [@@bs.deriving {accessors}]

type event_controller =
  { get_focus: unit -> unit
  ; add_event_listener: (event -> unit) -> unit
  }

let mk_event_controller (id: string) : event_controller =
  let el = HTMLElement.getElementById document id in
  { get_focus = (fun () -> HTMLElement.focus el)
  ; add_event_listener = (fun listener ->
      let listener' (e: Dom.event) : unit =
        match HTMLEvent.eventType e with
        | "click" ->
          let rect = HTMLElement.getBoundingClientRect el in
          let x = HTMLEvent.clientX e - HTMLRect.left rect in
          let y = HTMLEvent.clientY e - HTMLRect.top rect in
          Click (x, y) |> listener
        | "mousedown" ->
          let rect = HTMLElement.getBoundingClientRect el in
          let x = HTMLEvent.clientX e - HTMLRect.left rect in
          let y = HTMLEvent.clientY e - HTMLRect.top rect in
          MouseDown (x, y) |> listener
        | "mouseup" ->
          let rect = HTMLElement.getBoundingClientRect el in
          let x = HTMLEvent.clientX e - HTMLRect.left rect in
          let y = HTMLEvent.clientY e - HTMLRect.top rect in
          MouseUp (x, y) |> listener
        | "mousemove" ->
          let rect = HTMLElement.getBoundingClientRect el in
          let x = HTMLEvent.clientX e - HTMLRect.left rect in
          let y = HTMLEvent.clientY e - HTMLRect.top rect in
          MouseMove (x, y) |> listener
        | "keydown" ->
          KeyDown (key_of_string (HTMLEvent.eventKey e)) |> listener
        | "keyup" ->
          KeyUp (key_of_string (HTMLEvent.eventKey e)) |> listener
        | "resize" ->
          let width = HTMLElement.width el in
          let height = HTMLElement.height el in
          Resize (width, height) |> listener
        | _ -> ()
      in
      HTMLEvent.addEventListener el "click" listener' false;                   
      HTMLEvent.addEventListener el "keydown" listener' false;
      HTMLEvent.addEventListener el "keyup" listener' false;
      HTMLEvent.addEventListener el "mousedown" listener' false;
      HTMLEvent.addEventListener el "mouseup" listener' false;
      HTMLEvent.addEventListener el "mousemove" listener' false;
      HTMLEvent.addEventListener el "resize" listener' false;
    )
  }

type canvas = 
  { draw_image: string -> int -> int -> (int * int) option -> unit
  ; fill_rect: int -> int -> int -> int -> unit
  ; draw_rect: int -> int -> int -> int -> unit
  ; draw_line: int -> int -> int -> int -> unit
  ; draw_circle: int -> int -> int -> unit
  ; draw_arc: int -> int -> int -> float -> float -> unit
  ; set_color: string -> unit
  ; get_color: unit -> string
  ; set_line_width: int -> unit
  ; get_line_width: unit -> int
  ; get_size: unit -> (int * int)
  ; clear: unit -> unit
  }

let mk_canvas (id: string) : canvas * event_controller =
  let el = HTMLElement.getElementById document id in
  if HTMLElement.tagName el <> "CANVAS" then
    invalid_arg "not a canvas element"
  else
    HTMLElement.setTabIndex el 0;
    let canvas = HTMLCanvas.fromElement el in
    let ctx = context canvas in
    HTMLCanvas.setImageSmoothingEnabled ctx false;

    let loaded_image_sources = ref ImgMap.empty in

    { draw_image = (fun imgsrc x y size_opt ->
        if ImgMap.mem imgsrc !loaded_image_sources then
          let img = ImgMap.find imgsrc !loaded_image_sources in
          let img_w = HTMLImage.getWidth img in
          let img_h = HTMLImage.getHeight img in
          let (w, h) =
            match size_opt with
            | None -> img_w, img_h
            | Some size -> size
          in
          HTMLCanvas.drawImage ctx img 0 0 img_w img_h x y w h
        else
          let img = HTMLImage.newImage () in
          HTMLImage.setSource img imgsrc;
          HTMLImage.setOnload img (fun () ->
            loaded_image_sources := ImgMap.add imgsrc img !loaded_image_sources;
            let img_w = HTMLImage.getWidth img in
            let img_h = HTMLImage.getHeight img in
            let (w, h) =
              match size_opt with
              | None -> img_w, img_h
              | Some size -> size
            in
            HTMLCanvas.drawImage ctx img 0 0 img_w img_h x y w h
          );
          HTMLCanvas.closePath ctx
      )
    ; fill_rect = (fun x y w h -> HTMLCanvas.fillRect ctx x y w h)
    ; draw_rect = (fun x y w h -> HTMLCanvas.strokeRect ctx x y w h)
    ; draw_line = (fun x1 y1 x2 y2 ->
        HTMLCanvas.beginPath ctx;
        HTMLCanvas.moveTo ctx x1 y1;
        HTMLCanvas.lineTo ctx x2 y2;
        HTMLCanvas.closePath ctx;
        HTMLCanvas.stroke ctx
      )
    ; draw_circle = (fun x y r ->
        HTMLCanvas.beginPath ctx;
        HTMLCanvas.arc ctx x y r 0.0 (2.0 *. acos (-1.0));
        HTMLCanvas.closePath ctx;
        HTMLCanvas.stroke ctx
      )
    ; draw_arc = (fun x y r theta1 theta2 ->
        HTMLCanvas.beginPath ctx;
        HTMLCanvas.arc ctx x y r theta1 theta2;
        HTMLCanvas.closePath ctx;
        HTMLCanvas.stroke ctx
      )
    ; set_color = (fun c -> HTMLCanvas.setStrokeStyle ctx c)
    ; get_color = (fun () -> HTMLCanvas.strokeStyle ctx)
    ; set_line_width = (fun w -> HTMLCanvas.setLineWidth ctx w)
    ; get_line_width = (fun () -> HTMLCanvas.lineWidth ctx)
    ; get_size = (fun () -> HTMLElement.width el, HTMLElement.height el)
    ; clear = (fun () ->
        let width = HTMLElement.width el in
        let height = HTMLElement.height el in
        HTMLCanvas.clearRect ctx 0 0 width height
      )
    },
    mk_event_controller id

let set_interval (tick: unit -> unit) (delta: int) : unit =
  ignore (Js.Global.setInterval tick delta)

let request_animation_frame (callback: int -> unit) : unit =
  let window = HTMLWindow.window in
  HTMLWindow.requestAnimationFrame window callback