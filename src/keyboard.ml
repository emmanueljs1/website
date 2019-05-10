(* Inspired by https://quernd.github.io/tutorials/tea-chess/ *)

module Json = Tea.Json
module Result = Tea.Result
module Sub = Tea.Sub

type key_event = 
  { key_code : int
  ; shift : bool
  ; ctrl : bool
  ; alt : bool
  ; meta : bool
  }

type key =
  | W
  | A
  | S
  | D
  | Other

let key_of_keycode (keycode: int) : key =
  match keycode with
  | 87 -> W
  | 65 -> A
  | 83 -> S
  | 68 -> D
  | _ -> Other

let key_event =
  let open Json.Decoder in
  map5
    (fun key_code shift ctrl alt meta -> {key_code; shift; ctrl; alt; meta})
    (field "keyCode" int)
    (field "shiftKey" bool)
    (field "ctrlKey" bool)
    (field "altKey" bool)
    (field "metaKey" bool)

let registerGlobal name key tagger =
  let open Vdom in
  let enableCall callbacks_base =
    let callbacks = ref callbacks_base in
    let fn = fun ev ->
      let open Json.Decoder in
      let open Result in
      match decodeEvent key_event ev with
      | Error _ -> None
      | Ok pos -> Some (tagger pos) 
    in
    let handler = EventHandlerCallback (key, fn) in
    let elem = Web_node.document_node in
    let cache = eventHandler_Register callbacks elem name handler in
    fun () ->
      let _ = eventHandler_Unregister elem name cache in
      ()
  in
  Sub.registration key enableCall

let downs ?(key="") tagger =
  registerGlobal "keydown" key tagger

let ups ?(key="") tagger =
  registerGlobal "keyup" key tagger
