(* [to_state json_assoc] takes in a json associative array 
    [json_assoc] that represents the state to be loaded in, and returns
    that state in State.t form*)
val to_state: Yojson.Basic.json -> State.t

(* [load_from_file filename] loads the json save located at [filename]
   and creates a State.t record that contains the values within the
   json file. Raises Sys_error if the given filename does not correspond
   to a valid JSON file.*)
val load_from_file: string -> State.t