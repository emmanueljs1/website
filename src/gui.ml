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

let mk_event_controller (id: string) (full_window: bool) : event_controller =
  let el = HTMLElement.getElementById document id in
  let resize_listeners = ref [] in
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
        | _ -> ()
      in
      HTMLEvent.addEventListener el "click" listener' false;                   
      HTMLEvent.addEventListener el "keydown" listener' false;
      HTMLEvent.addEventListener el "keyup" listener' false;
      HTMLEvent.addEventListener el "mousedown" listener' false;
      HTMLEvent.addEventListener el "mouseup" listener' false;
      HTMLEvent.addEventListener el "mousemove" listener' false;
      resize_listeners := !resize_listeners @ [listener];
      let window = HTMLWindow.window in
      HTMLWindow.setOnresize window (fun () ->
        let w, h =
          if full_window then
            let window = HTMLWindow.window in
            HTMLWindow.width window, HTMLWindow.height window
          else
            HTMLElement.width el, HTMLElement.height el
        in
        List.iter (fun f -> Resize (w, h) |> f) !resize_listeners
      )
    )
  }

type canvas = 
  { draw_image: string -> int -> int -> (int * int) option -> unit
  ; draw_text: string -> string -> int -> int -> int -> unit
  ; text_width: string -> string -> int -> int
  ; fill_rect: int -> int -> int -> int -> int option -> unit
  ; draw_rect: int -> int -> int -> int -> int option -> unit
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

let round_rect (ctx: HTMLCanvas.canvasRenderingContext2D) (x: int) (y: int)
  (w: int) (h: int) (r: int) : unit =
  HTMLCanvas.moveTo ctx (x + r) y;
  HTMLCanvas.arcTo ctx (x + w) y (x + w) (y + h) r;
  HTMLCanvas.arcTo ctx (x + w) (y + h) x (y + h) r;
  HTMLCanvas.arcTo ctx x (y + h) x y r;
  HTMLCanvas.arcTo ctx x y (x + w) y r;
  HTMLCanvas.closePath ctx

type asset =
  | Image of string

let image_sources_of_assets (assets: asset list) : string list =
  let rec loop (acc: string list) (l: asset list): string list =
    match l with
    | [] -> acc
    | Image source :: tl -> loop (source :: acc) tl
  in
  loop [] assets

let resize_for_ctx (ctx: HTMLCanvas.canvasRenderingContext2D) = function
  | Resize (w, h) ->
    HTMLCanvas.setWidth (HTMLCanvas.getContextCanvas ctx) w;
    HTMLCanvas.setHeight (HTMLCanvas.getContextCanvas ctx) h;
    HTMLCanvas.setImageSmoothingEnabled ctx false
  | _ -> ()

let mk_canvas (id: string) (full_window: bool) (assets: asset list) : canvas * event_controller =
  let el = HTMLElement.getElementById document id in
  if HTMLElement.tagName el <> "CANVAS" then
    invalid_arg "not a canvas element"
  else
    HTMLElement.setTabIndex el 0;
    let canvas = HTMLCanvas.fromElement el in
    let ctx = context canvas in

    let event_controller = mk_event_controller id full_window in
    (* Set image smoothing enabled and resize canvas on window resizes *)
    let resize = resize_for_ctx ctx in
    resize |> event_controller.add_event_listener;

    let w , h =
      if full_window then
        let window = HTMLWindow.window in
        HTMLWindow.width window, HTMLWindow.height window
      else
        HTMLElement.width el, HTMLElement.height el
      in
    (* "resize" canvas initial time to disable image smoothing *)
    Resize (w, h) |> resize;

    HTMLCanvas.setTextBaseline ctx "top";
    HTMLCanvas.setTextAlign ctx "left";

    let loaded_image_sources = ref ImgMap.empty in

    let load_image (imgsrc: string) (callback: (HTMLImage.imageElement -> unit) option) : unit =
      let img = HTMLImage.newImage () in
      HTMLImage.setOnload img (fun () ->
        loaded_image_sources := ImgMap.add imgsrc img !loaded_image_sources;

        match callback with
        | None -> ()
        | Some f -> f img
      );
      HTMLImage.setSource img imgsrc
    in

    image_sources_of_assets assets |> List.iter (fun imgsrc -> load_image imgsrc None);

    { draw_image = (fun imgsrc x y size_opt ->
        let draw (x: int) (y: int) (size_opt: (int * int) option) (img: HTMLImage.imageElement) : unit =
          let img_w = HTMLImage.getWidth img in
          let img_h = HTMLImage.getHeight img in
          let (w, h) =
            match size_opt with
            | None -> img_w, img_h
            | Some size -> size
          in
          HTMLCanvas.drawImage ctx img 0 0 img_w img_h x y w h;
          HTMLCanvas.closePath ctx
        in

        if ImgMap.mem imgsrc !loaded_image_sources then
          let img = ImgMap.find imgsrc !loaded_image_sources in
          draw x y size_opt img
        else
          Some (draw x y size_opt) |> load_image imgsrc
      )
    ; draw_text = (fun text font font_size x y ->
        Printf.sprintf "%ipx %s" font_size font |> HTMLCanvas.setFont ctx;
        HTMLCanvas.fillText ctx text x y
      )
    ; text_width = (fun text font font_size ->
        Printf.sprintf "%ipx %s" font_size font |> HTMLCanvas.setFont ctx;
        let text_metrics = HTMLCanvas.measureText ctx text in
        TextMetrics.width text_metrics
      )
    ; fill_rect = (fun x y w h -> function
        | None -> HTMLCanvas.fillRect ctx x y w h
        | Some r ->
          round_rect ctx x y w h r;
          HTMLCanvas.fill ctx
      )
    ; draw_rect = (fun x y w h -> function
        | None -> HTMLCanvas.strokeRect ctx x y w h
        | Some r ->
          round_rect ctx x y w h r;
          HTMLCanvas.stroke ctx
      )
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
    ; set_color = (fun c ->
        HTMLCanvas.setStrokeStyle ctx c;
        HTMLCanvas.setFillStyle ctx c
      )
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
    event_controller

let set_interval (tick: unit -> unit) (delta: int) : unit =
  ignore (Js.Global.setInterval tick delta)

let request_animation_frame (callback: int -> unit) : unit =
  let window = HTMLWindow.window in
  HTMLWindow.requestAnimationFrame window callback
