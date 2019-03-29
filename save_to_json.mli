(** [list_to_json list func] is a Yojson.Basic.json list containing json 
    representations of the elements of the given list [list], using
    [to_json_func] to convert the individual elements into json 
    representations, and then mapping that to all the elements in the list,
    before convertin that list to a Yojson.Basic.json list *)
val list_to_json: 'a list -> ('a -> Yojson.Basic.json) -> Yojson.Basic.json

(* [industry_to_json industry] is a Yojson.Basic.json string representation
   of the given Establishment.industry [industry] *)
val industry_to_json: Establishment.industry -> Yojson.Basic.json

(* [card_type_to_json card_type] is a Yojson.Basic.json string representation
   of the given Establishment.card_type [card_type] *)
val card_type_to_json: Establishment.cardType -> Yojson.Basic.json

(* [establishment_effect_to_json] converts the establishment effect of a 
   card [effect] into a Yojson.Basic.json string representation *)
val establishment_effect_to_json: Establishment.effect -> Yojson.Basic.json

(* [int_to_json] takes in an integer, and gives a Yojson.Basic.json integer 
   representation *)
val int_to_json: int -> Yojson.Basic.json

(** [establishment_to_json establishment] is a Yojson.Basic.json associative
    array representation of the given Establishment.card [establishment] *)
val establishment_to_json: Establishment.card -> Yojson.Basic.json

(**[landmark_effect_to_json effect] is a Yojson.Basic.json associative
   array representing the given Landmark.effect [effect]*)
val landmark_effect_to_json: Landmark.effect -> Yojson.Basic.json

(** [landmark_to_json landmark] is a Yojson.Basic.json associative array
    representing the given Landmark.card [landmark] *)
val landmark_to_json: Landmark.card -> Yojson.Basic.json

(** [state_to_json] is a Yojson.Basic.json associative array representing
    all fields in the given State.t [state]. *)
val state_to_json: (State.t) -> Yojson.Basic.json

(** [save_to_file save filename] takes a json save, and writes it to 
    [filename].json *)
val save_to_file: (Yojson.Basic.json) -> string -> unit