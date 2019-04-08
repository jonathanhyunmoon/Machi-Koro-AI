open Yojson.Basic.Util

(*_________________HELPER FUNCTIONS FOR LOADING JSON SAVES_________________*)

(* [to_player json_assoc] takes in a json associative array 
    [json_assoc] that represents the player to converted into an OCaml
    record, and returns the player in OCaml record form*)
let to_player (json_assoc:Yojson.Basic.json) : Player.t =
  try 
    {
      id = to_string (member "id" json_assoc);
      num_dice = to_int (member "number of dice" json_assoc);
      dice_rolls = Parse_json.to_ocaml_list (member "dice rolls" json_assoc)
          to_int;
      cash = to_int (member "cash" json_assoc);
      assets = Parse_json.to_establishment_list (member "assets" json_assoc);
      landmarks = Parse_json.to_landmark_list (member "landmarks" json_assoc);
      order = to_int (member "order" json_assoc)

    }
  with
    Type_error _ -> failwith ("failure in Load_from_json.to_player, invalid" ^ 
                              " json type")

(* [to_state json_assoc] takes in a json associative array 
    [json_assoc] that represents the state to be loaded in, and returns
    that state in State.t form*)
let to_state (json_assoc:Yojson.Basic.json) : State.t =
  {
    players = Parse_json.to_ocaml_list (member "players" json_assoc)
        to_player;
    bank = to_int (member "bank" json_assoc);
    available_cards = Parse_json.to_establishment_list 
        (member "available cards" json_assoc);
    current_player = to_int (member "current player" json_assoc);
    landmark_cards = Parse_json.to_landmark_list 
        (member "landmark cards" json_assoc)
  }

let to_state_AI (json_assoc:Yojson.Basic.json) : State.t =
  {
    players = Parse_json.to_ocaml_list (member "players" json_assoc)
        to_player;
    bank = to_int (member "bank" json_assoc);
    available_cards = Parse_json.to_establishment_list 
        (member "available cards" json_assoc);
    current_player = to_int (member "current player" json_assoc);
    landmark_cards = Parse_json.to_landmark_list 
        (member "landmark cards" json_assoc)
  }
let is_blocked (address:string) : bool =
  try( 
    let ic = open_in address in
    let json_assoc = Yojson.Basic.from_channel ic in
    let _ = close_in ic in
    to_int((member "control" json_assoc)) == 0
  )
  with 
  | Yojson.Json_error s -> true


(* [load_from_file filename] loads the json save located at [filename]
   and creates a State.t record that contains the values within the
   json file. Raises Sys_error if the given filename does not correspond
   to a valid JSON file.*)
let load_from_file (filename:string) = 
  (Yojson.Basic.from_file filename) |> to_state

let load_from_file_AI (address: string) = 
  let ic = open_in address in 
  let _ = close_in ic in
  (Yojson.Basic.from_channel ic) |> to_state_AI