type document
external doc: document = "document" [@@bs.val]
external getElementById: document -> string -> Dom.element = "getElementById" [@@bs.send]
external style: Dom.element -> Dom.cssStyleDeclaration = "style" [@@bs.get]
external color: Dom.cssStyleDeclaration -> string = "color" [@@bs.get]
external set_color: Dom.cssStyleDeclaration -> string -> unit = "color" [@@bs.set]
external parentElement: Dom.element -> Dom.element = "parentElement" [@@bs.get]
external querySelector: Dom.element -> string -> Dom.element = "querySelector" [@@bs.send]

let is_hover (e: Dom.element) : bool =
  querySelector (parentElement e) ":hover" == e

let change_color () : unit =
  let el = getElementById doc "click-to-play" in
  let style = el |> style in
  if is_hover el then
    set_color style "white"
  else
    if color style = "white" then
      set_color style "#595959"
    else
      set_color style "white"


let _ = Js.Global.setInterval change_color 250
