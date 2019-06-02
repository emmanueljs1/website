type ('model, 'msg) program =
  { init: unit -> 'model
  ; update: 'model -> Gui.event -> 'model
  ; view: Gui.canvas -> 'model -> unit
  }

val run_program: string -> ('model, 'msg) program -> unit