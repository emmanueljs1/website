module HTMLDocument = struct
  type document
  external doc: document = "document" [@@bs.val]
end

module HTMLElement = struct
  type element = Dom.element
  external getElementById: HTMLDocument.document -> string -> element = "getElementById" [@@bs.send]
  external tagName: element -> string = "tagName" [@@bs.get]
  external setTabIndex: element -> int -> unit = "tabIndex" [@@bs.set]
end

module HTMLEvent = struct
  type event = Dom.event
  external addEventListener: HTMLElement.element -> string -> (event -> unit) -> bool -> unit = "addEventListener" [@@bs.send]
  external eventType: event -> string = "type" [@@bs.get]
  external eventKey: event -> string = "key" [@@bs.get]
end

module HTMLCanvas = struct
  type canvasRenderingContext2D
  type canvasElement
  external fromElement : HTMLElement.element -> canvasElement = "%identity"
  external width: canvasElement -> int = "width" [@@bs.get]
  external height: canvasElement -> int = "height" [@@bs.get]
  external getContext: canvasElement -> string -> canvasRenderingContext2D = "getContext" [@@bs.send]
  external strokeStyle: canvasRenderingContext2D -> string = "strokeStyle" [@@bs.get]
  external setStrokeStyle: canvasRenderingContext2D -> string -> unit = "strokeStyle" [@@bs.set]
  external lineWidth: canvasRenderingContext2D -> int = "lineWidth" [@@bs.get]
  external setLineWidth: canvasRenderingContext2D -> int -> unit = "lineWidth" [@@bs.set]
  external clearRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "clearRect" [@@bs.send]
  external drawImage: canvasRenderingContext2D -> string -> int -> int -> unit = "drawImage" [@@bs.send]
  external drawImageWidthHeight: canvasRenderingContext2D -> string -> int -> int -> int -> int -> unit = "drawImage" [@@bs.send]
  external fillRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "fillRect" [@@bs.send]
  external strokeRect: canvasRenderingContext2D -> int -> int -> int -> int -> unit = "strokeRect" [@@bs.send]
  external moveTo: canvasRenderingContext2D -> int -> int -> unit = "moveTo" [@@bs.send]
  external lineTo: canvasRenderingContext2D -> int -> int -> unit = "lineTo" [@@bs.send]
  external arc: canvasRenderingContext2D -> int -> int -> int -> float -> float -> unit = "arc" [@@bs.send]
  external beginPath: canvasRenderingContext2D -> unit = "beginPath" [@@bs.send]
  external stroke: canvasRenderingContext2D -> unit = "stroke" [@@bs.send]
end
