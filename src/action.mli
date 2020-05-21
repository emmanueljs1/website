type action =
  | Idle of bool (* is_right*)
  | Run of bool (* is_right *)
  | Interact

val str_of_action: action -> string
