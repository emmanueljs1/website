module HTMLDocument = struct
  type document
  external doc: document = "document" [@@bs.val]
end

module HTMLWindow = struct
  type window
  external window: window = "window" [@@bs.val]
  external height: window -> int = "innerHeight" [@@bs.get]
  external width: window -> int = "innerWidth" [@@bs.get]
  external requestAnimationFrame: window -> (int -> unit) -> unit = "requestAnimationFrame" [@@bs.send]
end

module HTMLRect = struct
  type rect
  external left: rect -> int = "left" [@@bs.get]
  external top: rect -> int = "top" [@@bs.get]
end

module HTMLElement = struct
  type element = Dom.element
  external getElementById: HTMLDocument.document -> string -> element = "getElementById" [@@bs.send]
  external tagName: element -> string = "tagName" [@@bs.get]
  external setTabIndex: element -> int -> unit = "tabIndex" [@@bs.set]
  external getBoundingClientRect: element -> HTMLRect.rect = "getBoundingClientRect" [@@bs.send]
  external width: element -> int = "width" [@@bs.get]
  external height: element -> int = "height" [@@bs.get]
  external focus: element -> unit = "focus" [@@bs.send]
end

module HTMLEvent = struct
  type event = Dom.event
  external addEventListener: HTMLElement.element -> string -> (event -> unit) -> bool -> unit = "addEventListener" [@@bs.send]
  external eventType: event -> string = "type" [@@bs.get]
  external eventKey: event -> string = "key" [@@bs.get]
  external clientX: event -> int = "clientX" [@@bs.get]
  external clientY: event -> int = "clientY" [@@bs.get]
end

module HTMLImage = struct
  type imageElement
  external newImage : unit -> imageElement = "Image" [@@bs.new]
  external setWidth : imageElement -> int -> unit = "width" [@@bs.set]
  external getWidth : imageElement -> int = "width" [@@bs.get]
  external setHeight : imageElement -> int -> unit = "height" [@@bs.set]
  external getHeight : imageElement -> int = "height" [@@bs.get]
  external setSource : imageElement -> string -> unit = "src" [@@bs.set]
  external setOnload : imageElement -> (unit -> unit) -> unit = "onload" [@@bs.set]

  let setSize (img: imageElement) (size: int * int) : unit =
    let (w, h) = size in
    setWidth img w;
    setHeight img h
end

module HTMLCanvas = struct
  type canvasRenderingContext2D
  type canvasElement
  external fromElement : HTMLElement.element -> canvasElement = "%identity"
  external getContext: canvasElement -> string -> canvasRenderingContext2D = "getContext" [@@bs.send]
  external strokeStyle: canvasRenderingContext2D -> string = "strokeStyle" [@@bs.get]
  external setStrokeStyle: canvasRenderingContext2D -> string -> unit = "strokeStyle" [@@bs.set]
  external lineWidth: canvasRenderingContext2D -> int = "lineWidth" [@@bs.get]
  external setLineWidth: canvasRenderingContext2D -> int -> unit = "lineWidth" [@@bs.set]
  external clearRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "clearRect" [@@bs.send]
  external drawImage: canvasRenderingContext2D -> HTMLImage.imageElement -> int -> int -> int -> int -> int -> int -> int -> int -> unit = "drawImage" [@@bs.send]
  external fillRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "fillRect" [@@bs.send]
  external fillText: canvasRenderingContext2D -> string -> int -> int -> unit = "fillText" [@@bs.send]
  external setFont: canvasRenderingContext2D -> string -> unit = "font" [@@bs.set]
  external strokeRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "strokeRect" [@@bs.send]
  external moveTo: canvasRenderingContext2D -> int -> int -> unit = "moveTo" [@@bs.send]
  external lineTo: canvasRenderingContext2D -> int -> int -> unit = "lineTo" [@@bs.send]
  external arc: canvasRenderingContext2D -> int -> int -> int -> float -> float -> unit = "arc" [@@bs.send]
  external beginPath: canvasRenderingContext2D -> unit = "beginPath" [@@bs.send]
  external closePath: canvasRenderingContext2D -> unit = "closePath" [@@bs.send]
  external stroke: canvasRenderingContext2D -> unit = "stroke" [@@bs.send]
  external imageSmoothingEnabled: canvasRenderingContext2D -> bool = "imageSmoothingEnabled" [@@bs.get]
  external setImageSmoothingEnabled: canvasRenderingContext2D -> bool -> unit = "imageSmoothingEnabled" [@@bs.set]
end
