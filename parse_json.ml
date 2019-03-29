open Yojson.Basic.Util
open Landmark
open Establishment

(* [to_ocaml_list json_list] is an OCaml list that corresponds
   to the given json list, [json_list]. Not used for landmark and 
   establishment cards since they have to take quantity into account *)
let to_ocaml_list (json_list:Yojson.Basic.json) 
    (func:Yojson.Basic.json -> 'a) :
  'a list =
  try 
    let the_list = to_list (json_list) in
    List.map func the_list
  with 
  | Type_error _ -> failwith "invalid arguments in to_ocaml_list"

(*_________________helper functions for load_establishments_________________*)
let clean str = str |> String.trim |> String.lowercase_ascii
(* [to_industry json_string] gives the industry type corresponding to
   a json string [json_string]. Raises error if an invalid json is passed in*)
let to_industry (json_string:Yojson.Basic.json) : Establishment.industry =
  try 
    match clean (to_string(json_string)) with
    | "primary" -> Primary
    | "secondary" -> Secondary
    | "restaurant" -> Restaurant
    | "major" -> Major
    | i -> failwith ("invalid industry value in JSON  "^i)
  with 
  | Type_error _ -> failwith "invalid industry value in JSON"

(* [to_card_type json_string] gives the cardType corresponding to the given
   json string. Raises error if an invalid string or json is passed in *)
let to_card_type (json_string:Yojson.Basic.json) : Establishment.cardType =
  try 
    match clean (to_string(json_string)) with
    | "wheat" -> Wheat
    | "cow" -> Cow
    | "gear" -> Gear
    | "bread" -> Bread
    | "factory" -> Factory
    | "fruit" -> Fruit
    | "cup" -> Cup
    | "major" -> Major
    | "boat" -> Boat
    | "suitcase" -> Suitcase
    | _ -> failwith "invalid card type in JSON"
  with Type_error _ -> failwith "invalid card type in JSON"

(* [to_activation_time json_string] is the Establishment.activationTime
   that corresponds to the given json string, [json_string]. Raises
   error if [json_string] does not correspond to a valid activation time
   json string in the schema *)
let to_activation_time (json_string:Yojson.Basic.json) : 
  Establishment.activationTime =
  match clean (to_string(json_string)) with
  | "anyone's turn" -> AnyonesTurn
  | "player's turn" -> PlayersTurn
  | "others' turn" -> OthersTurn
  | _ -> failwith "invalid string in to_activation_time"

(* [to_effect_type] is the Establishment.effectType that corresponds to
   the given json string, [json_string]*)
let to_effect_type (json_string:Yojson.Basic.json) : Establishment.effectType =
  match clean (to_string(json_string)) with
  | "collect" -> Collect
  | "collect gear" -> CollectGear
  | "collect wheat" -> CollectWheat
  | "collect cow" -> CollectCow
  | "take" -> Take
  | "take rolled" -> TakeRolled
  | "take all" -> TakeAll
  | "trade" -> Trade
  | "harbor collect" -> HarborCollect
  | "harbor collect tuna rolled" -> HarborCollectTunaRolled
  | "flower collect" -> FlowerCollect
  | "collect cup" -> CollectCup
  | "harbor take" -> HarborTake
  | "collect cup bread" -> CollectCupBread
  | "tax" -> Tax
  | i -> failwith ("invalid string in to_effect_type " ^ i)

(* [to_effect] is the Establishment.effect record that corresponds to the
   given json associative array, [json_assoc] *)
let to_effect (json_assoc:Yojson.Basic.json) : Establishment.effect =
  {
    activation_time = to_activation_time(member "activation time" json_assoc);
    value = to_int(member "value" json_assoc);
    effect_type = to_effect_type (member "effect type" json_assoc)
  }

(* [to_establishment json_assoc] is a list containing several copies of an
   Establishment.card corresponding to the given json association list, 
   [json_assoc], where the number of copies is defined by the quanity
   value in [json_assoc] *)
let to_establishment (json_assoc:Yojson.Basic.json) : Establishment.card list =
  (* the establishment to be duplicated *)
  let the_establishment =
    {
      name = to_string(member "name" json_assoc);
      industry = to_industry(member "industry" json_assoc);
      card_type = to_card_type (member "card type" json_assoc);
      construction_cost = to_int (member "construction cost" json_assoc);
      activation_numbers = to_ocaml_list (member "activation numbers"
                                            json_assoc) to_int;
      effect = to_effect (member "effect" json_assoc)
    } in
  (* number of times the card should appear in the list *)
  let repetitions = to_int(member "quantity" json_assoc) in
  (* creates a list with [repetition] copies of [the_establishment] *)
  let rec to_establishment_helper (estab:Establishment.card) acc 
      repetitions : Establishment.card list =
    if (repetitions > 1) then to_establishment_helper estab
        (estab::acc) (repetitions - 1)
    else if (repetitions = 1) then (estab::acc)
    else failwith "zero or negative establishment quantity" in
  to_establishment_helper the_establishment [] repetitions

(* [to_establishment_list json_list] is the Establishment.card list that 
   corresponds to the given json list [json_list]*)
let to_establishment_list (json_list:Yojson.Basic.json) :
  Establishment.card list =
  let json_assoc_list = to_list json_list in
  let rec to_establishment_helper list acc =
    match list with
    | [] -> acc
    | h :: t -> to_establishment_helper t ((to_establishment h)@acc) in
  to_establishment_helper json_assoc_list []

(** [load_establishments json_assoc] takes in a json associative array 
    [json_assoc] that contains all of the cards to be loaded in, (in the 
    cardlist schema format) and returns a list of all of the establishment 
    cards in that associative array, formatted as Establishment.card elements*)
let load_establishments (json_assoc:Yojson.Basic.json) :
  Establishment.card list =
  to_establishment_list (member "establishments" json_assoc)



(*_________________helper functions for load_landmarks_________________*)

(* [to_landmark_industry json_string] is the Landmark.industry corresponding
   to the given json string, [json_string] *)
let to_landmark_industry (json_string:Yojson.Basic.json) : Landmark.industry =
  match clean (to_string(json_string)) with
  | "landmark" -> Landmark
  | _ -> failwith "invalid json string in to_landmark_industry"

(* [to_landmark_card_type json_string] is the Landmark.card_type corresponding
   to the given json string, [json_string] *)
let to_landmark_card_type (json_string:Yojson.Basic.json) : Landmark.cardType =
  match clean (to_string(json_string)) with
  | "major" -> Landmark.Major
  | _ -> failwith "invalid json string in to_landmark_card_type"

(* [to_face json_string] is the Landmark.face corresponding to the given
   json string, [to_face] *)
let to_face (json_string:Yojson.Basic.json) : Landmark.face =
  match clean (to_string json_string) with
  | "up" -> Up
  | "down" -> Down
  | _ -> failwith "invalid string in to_face"

(* [to_landmark_effect_type json_string] is the Landmark.effectType 
   corresponding to the given json string, [json_string] *)
let to_landmark_effect_type (json_string:Yojson.Basic.json) : 
  Landmark.effectType =
  try 
    match clean (to_string(json_string)) with
    | "double roll" -> DoubleRoll
    | "mall collect" -> MallCollect
    | "doubles turn" -> DoublesTurn
    | "reroll" -> Reroll
    | "build or take" -> BuildOrTake
    | "city hall" -> CityHall
    | "add to die" -> AddToDie
    | _ -> failwith "invalid json string in to_landmark_effect_type"
  with _ -> failwith "type error at landmark_effect_type"

(* [to_landmark_effect json_assoc] is the Landmark.effect corresponding
   to the given json association list, [json_assoc] *)
let to_landmark_effect (json_assoc:Yojson.Basic.json) : Landmark.effect =
  {
    value = to_int(member "value" json_assoc);
    effect_type = to_landmark_effect_type(member "effect type" json_assoc)
  }

(* [to_landmark json_assoc] is the Landmark.card that corresponds
   to the given json associative array, [json_assoc] *)
let to_landmark (json_assoc:Yojson.Basic.json) : Landmark.card =
  {
    name = to_string (member "name" json_assoc);
    industry = to_landmark_industry (member "industry" json_assoc);
    card_type = to_landmark_card_type (member "card type" json_assoc);
    construction_cost = to_int (member "construction cost" json_assoc);
    effect = to_landmark_effect (member "effect" json_assoc);
    face = to_face (member "face" json_assoc);
  }

(* [to_landmark_list json_list] is the Landmark.card list that corresponds
   to the given json list in [json_list] *)
let to_landmark_list (json_list:Yojson.Basic.json) : Landmark.card list =
  (* let _ = print_endline "HERE" in *)
  let json_assoc_list = to_list json_list in
  let rec to_landmark_helper list acc =
    match list with
    | [] -> acc
    | h :: t -> to_landmark_helper t ((to_landmark h)::acc) in
  to_landmark_helper json_assoc_list []

(* [load_landmarks json_assoc] takes in a json associative array 
    [json_assoc] that contains all of the cards to be loaded in, and returns 
    a list of all of the landmark cards in that associative array,
    formatted as Landmark.card elements *)
let load_landmarks (json_assoc:Yojson.Basic.json) :
  Landmark.card list = to_landmark_list (member "landmarks" json_assoc)
