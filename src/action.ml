type action =
  | Idle of bool (* is_right*)
  | Run of bool (* is_right *)

let str_of_is_right (is_right: bool) : string =
  if is_right then "right" else "left"

let str_of_action (action: action) : string =
  match action with
  | Run is_right ->
      let is_right_str = str_of_is_right is_right in
      {j|run_$(is_right_str)|j}
  | Idle is_right ->
      let is_right_str = str_of_is_right is_right in
      {j|idle_$(is_right_str)|j}
