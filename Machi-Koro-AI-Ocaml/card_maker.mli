type e = {
  name:string; 
  industry:Establishment.industry; 
  card_type:Establishment.cardType;
  construction_cost:int; 
  activation_numbers:int list;
  effect:Establishment.effect;
  amount: int
}
type l = {
  name:string; 
  construction_cost:int;
  effect:Landmark.effect;
}
type deck = {
  establishments: e list;
  landmarks: l list
}

(* [create_deck] creates a new deck record consisting of two lists,
   one containing the custom establishments that the user creates, and another
   containing the custom landmarks that the user creates*)
val create_deck : unit -> deck

(** [deck_to_json deck] gives a json associative array representing the
    given deck [deck]. The associative array corresponds with the cardlist
    schema given in json_schema_cardlist.json*)
val deck_to_json : deck -> Yojson.Basic.json

(** [to_file json_assoc] saves the json association list to the filename that
    the user inputs, then it returns the filename*)
val to_file : Yojson.Basic.json -> string