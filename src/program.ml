open Gui

type ('model, 'msg) program =
  { init: unit -> 'model
  ; update: 'model -> event -> 'model
  ; view: canvas -> 'model -> unit
  }

let run_program (id: string) (program: ('model, 'msg) program) : unit =
  let msgs = ref [] in
  let model = ref (program.init ()) in
  let (canvas, ec) = mk_canvas id in

  ec.add_event_listener (fun event ->
    let msg = event in
    msgs := msg :: !msgs
  );

  let loop () : unit =
    model := List.fold_right (fun x acc -> program.update acc x) !msgs !model;
    canvas.clear ();
    program.view canvas !model;
    msgs := []
  in

  (* TODO: possibily use requestAnimationFrame *)
  set_interval loop (1000 / 60)