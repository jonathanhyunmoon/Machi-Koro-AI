open Yojson.Basic.Util
open Landmark
open Establishment

(* [to_ocaml_list json_list] is an OCaml list that corresponds
   to the given json list, [json_list]. Not used for landmark and 
   establishment cards since they have to take quantity into account *)
val to_ocaml_list: Yojson.Basic.json -> (Yojson.Basic.json -> 'a) -> 'a list



(* 
(* [to_industry json_string] gives the industry type corresponding to
   a json string [json_string]. Raises error if an invalid json is passed in*)
val to_industry: Yojson.Basic.json -> Establishment.industry

(* [to_card_type json_string] gives the cardType corresponding to the given
   json string. Raises error if an invalid string or json is passed in *)
val to_card_type: Yojson.Basic.json -> Establishment.cardType

(* [to_activation_time json_string] is the Establishment.activationTime
   that corresponds to the given json string, [json_string]. Raises
   error if [json_string] does not correspond to a valid activation time
   json string in the schema *)
val to_activation_time: Yojson.Basic.json -> Establishment.activationTime

val to_effect: Yojson.Basic.json -> Establishment.effect
 *)




(* [to_establishment_list json_list] is the Establishment.card list that 
   corresponds to the given json list of json associative arrays [json_list]*)
val to_establishment_list: Yojson.Basic.json -> Establishment.card list

(* [to_landmark_list json_list] is the Landmark.card list that corresponds
   to the given json list of json associative arrays [json_list] *)
val to_landmark_list: Yojson.Basic.json -> Landmark.card list

(** [load_establishments json_assoc] takes in a json associative array 
    [json_assoc] that contains all of the cards to be loaded in, and returns 
    a list of all of the establishment cards in that associative array,
    formatted as Establishment.card elements. Depending on the value
    of the "quantity" field of each card, load_establishments will load
    that many duplicates into the list*)
val load_establishments: (Yojson.Basic.json) -> Establishment.card list

(* [load_landmarks json_assoc] takes in a json associative array 
    [json_assoc] that contains all of the cards to be loaded in, and returns 
    a list of all of the landmark cards in that associative array,
    formatted as Landmark.card elements *)
val load_landmarks: (Yojson.Basic.json) -> Landmark.card list