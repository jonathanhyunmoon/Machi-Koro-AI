
(*____________________FUNCTIONS FOR CONVERTING INTO JSON_____________________*)
let clean str = str |> String.trim |> String.lowercase_ascii

(* [int_to_json] takes in an integer, and gives a Yojson.Basic.json integer 
   representation *)
let int_to_json (number:int) : Yojson.Basic.json =
  `Int number

(* [list_to_json list func] is a Yojson.Basic.json list containing json 
   representations of the elements of the given list [list], using
   [to_json_func] to convert the individual elements into json 
   representations, and then mapping that to all the elements in the list,
   before convertin that list to a Yojson.Basic.json list *)
let list_to_json (list:'a list) (to_json_func: 'a -> Yojson.Basic.json) :
  Yojson.Basic.json =
  `List (List.map to_json_func list)


(*___________________HELPER FUNCTIONS FOR state_to_json______________________*)

(* helper functions for establishment_to_json *)

(* [industry_to_json industry] is a Yojson.Basic.json string representation
   of the given Establishment.industry [industry] *)
let industry_to_json
    (industry:Establishment.industry) : Yojson.Basic.json =
  match industry with
  | Primary -> `String "Primary"
  | Secondary -> `String "Secondary"
  | Restaurant -> `String "Restaurant"
  | Major -> `String "Major"

(* [card_type_to_json card_type] is a Yojson.Basic.json string representation
   of the given Establishment.card_type [card_type] *)
let card_type_to_json
    (card_type:Establishment.cardType) : Yojson.Basic.json =
  match card_type with
  | Wheat -> `String "Wheat"
  | Cow -> `String "Cow"
  | Gear -> `String "Gear"
  | Bread -> `String "Bread"
  | Factory -> `String "Factory"
  | Fruit -> `String "Fruit"
  | Cup -> `String "Cup"
  | Major -> `String "Major"
  | Boat -> `String "Boat"
  | Suitcase -> `String "Suitcase"

(* [activation_time_to_json act_time] converts the activation time (act_time) 
   of a card into a Yojson.Basic.json string representation *)
let activation_time_to_json 
    (act_time:Establishment.activationTime) : Yojson.Basic.json =
  match act_time with
  | AnyonesTurn ->`String "Anyone's Turn"
  | PlayersTurn -> `String "Player's Turn"
  | OthersTurn -> `String "Others' Turn"

(* [effect_type_to_json] converts an effect type [effect_type] into a 
   Yojson.Basic.json string representation *)
let establishment_effect_type_to_json 
    (effect_type:Establishment.effectType) : Yojson.Basic.json =
  match effect_type with
  | Collect -> `String "Collect"
  | CollectGear -> `String "Collect Gear"
  | CollectWheat -> `String "Collect Wheat"
  | CollectCow -> `String "Collect Cow"
  | Take -> `String "Take"
  | TakeRolled -> `String "Take Rolled"
  | TakeAll -> `String "Take All"
  | Trade -> `String "Trade"
  | HarborCollect -> `String "Harbor Collect"
  | HarborCollectTunaRolled -> `String "Harbor Collect Tuna Rolled"
  | FlowerCollect -> `String "Flower Collect"
  | CollectCup -> `String "Collect Cup"
  | HarborTake -> `String "Harbor Take"
  | CollectCupBread -> `String "Collect Cup Bread"
  | Tax -> `String "Tax"

(* [establishment_effect_to_json] converts the establishment effect of a 
   card [effect] into a Yojson.Basic.json string representation *)
let establishment_effect_to_json 
    (effect:Establishment.effect) : Yojson.Basic.json =
  `Assoc [
    ("activation time", activation_time_to_json(effect.activation_time));
    ("value", `Int effect.value);
    ("effect type", establishment_effect_type_to_json(effect.effect_type))
  ]

(* [establishment_to_json establishment] is a Yojson.Basic.json associative
   array representation of the given Establishment.card [establishment] *)
let establishment_to_json
    (establishment:Establishment.card) : Yojson.Basic.json =
  `Assoc [
    ("name", `String establishment.name);
    ("quantity", `Int 1);
    ("industry", industry_to_json establishment.industry);
    ("card type", card_type_to_json establishment.card_type);
    ("construction cost", `Int establishment.construction_cost);
    ("activation numbers", 
     list_to_json (establishment.activation_numbers) int_to_json);
    ("effect", establishment_effect_to_json establishment.effect)
  ]


(* helper functions for landmark_to_json *)

(* [landmark_effect_type_to_json] is a Yojson.Basic.json string representing
   the given Landmark.effectType [effect_type] *)
let landmark_effect_type_to_json
    (effect_type:Landmark.effectType) : Yojson.Basic.json =
  match effect_type with
  | DoubleRoll -> `String "Double Roll"
  | MallCollect -> `String "Mall Collect"
  | DoublesTurn -> `String "Doubles Turn"
  | Reroll -> `String "Reroll"
  | CityHall -> `String "City Hall"
  | AddToDie -> `String "Add To Die"
  | BuildOrTake -> `String "Build Or Take"

(* [landmark_effect_type_to_json effect] is a Yojson.Basic.json associative
   array representing the given Landmark.effect [effect] *)
let landmark_effect_to_json (effect:Landmark.effect) : Yojson.Basic.json =
  `Assoc [
    ("value", `Int effect.value);
    ("effect type", landmark_effect_type_to_json effect.effect_type);
  ]

(* [face_to_json face] is a Yojson.Basic.json string representing the
   given Landmark.face [face]*)
let face_to_json (face:Landmark.face) : Yojson.Basic.json =
  match face with
  | Up -> `String "Up"
  | Down -> `String "Down"

(* [landmark_to_json landmark] is a Yojson.Basic.json associative array
   representing the given Landmark.card [landmark] *)
let landmark_to_json
    (landmark:Landmark.card) : Yojson.Basic.json =
  `Assoc [
    ("name", `String landmark.name);
    ("industry", `String "Landmark");
    ("card type", `String "Major");
    ("construction cost", `Int landmark.construction_cost);
    ("effect", landmark_effect_to_json landmark.effect);
    ("face", face_to_json landmark.face)
  ]


(* other helper functions *)

(* [player_to_json player] is a Yojson.Basic.json associative array
   representing the given Player.t [player] *)
let player_to_json (player:Player.t) : Yojson.Basic.json =
  `Assoc [
    ("id", `String player.id);
    ("number of dice", `Int player.num_dice);
    ("dice rolls", list_to_json player.dice_rolls int_to_json);
    ("cash", `Int player.cash);
    ("assets", list_to_json player.assets establishment_to_json);
    ("landmarks", list_to_json player.landmarks landmark_to_json);
    ("order", `Int player.order)
  ]


(* [state_to_json] is a Yojson.Basic.json associative array representing
   all fields in the given State.t [state]. *)
let state_to_json (state:State.t) : Yojson.Basic.json =   
  `Assoc [
    ("players", list_to_json state.players player_to_json);
    ("bank", `Int state.bank);
    ("available cards", list_to_json state.available_cards 
       establishment_to_json);
    ("current player", `Int state.current_player);
    ("landmark cards", list_to_json state.landmark_cards landmark_to_json)
  ]

let state_to_json_AI (state:State.t) : Yojson.Basic.json =   
  `Assoc [
    ("control", `Int 0);
    ("players", list_to_json state.players player_to_json);
    ("bank", `Int state.bank);
    ("available cards", list_to_json state.available_cards 
       establishment_to_json);
    ("current player", `Int state.current_player);
    ("landmark cards", list_to_json state.landmark_cards landmark_to_json)
  ]

(* [save_to_file save filename] takes a json save, and writes it to 
   [filename].json *)
let save_to_file (save:Yojson.Basic.json) (filename:string) =
  let _ = match clean(filename) with
    | "alternatecards"
    | "basiccards"
    | "basichand"
    | "harbor expansion"
    | "json_schema_cardlist"
    | "json_schema_saves" -> failwith "attempt to edit critical files
    for the game"
    | _ -> () in
  let address = filename ^ ".json" in
  let open_channel = open_out address in
  Printf.fprintf open_channel "%s" (Yojson.Basic.pretty_to_string save);
  close_out open_channel


let save_to_file_AI (save:Yojson.Basic.json) (address:string) =
  let open_channel = open_out address in
  Printf.fprintf open_channel "%s" (Yojson.Basic.pretty_to_string save);
  close_out open_channel