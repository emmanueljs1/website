type action =
  | Idle of bool (* is_right*)
  | Run of bool (* is_right *)
  | Interact

let str_of_is_right (is_right: bool) : string =
  if is_right then "right" else "left"

let str_of_action (action: action) : string =
  match action with
  | Run is_right -> Printf.sprintf "run_%s" (str_of_is_right is_right)
  | Idle is_right -> Printf.sprintf "idle_%s" (str_of_is_right is_right)
  | Interact -> failwith "unimplemented"
