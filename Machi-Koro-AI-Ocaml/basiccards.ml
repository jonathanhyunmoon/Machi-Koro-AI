open Establishment
open Parse_json

(* [BasicCards] is a module that contains all of the cards, both 
     establishment and landmark, within the basic Machi Koro game *)
(* primary industry cards *)

(** [initial_deck] is a list of Establishment.card cards created by parsing the
    json located at "basiccards.json". *)
let initial_deck = Parse_json.load_establishments 
    (Yojson.Basic.from_file "basiccards.json")

(** [initial_deck_landmarks] is a list of Landmark.card cards created by 
    parsing the json located at "basiccards.json". *)
let initial_deck_landmarks = 
  Parse_json.load_landmarks (Yojson.Basic.from_file "basiccards.json")

(** [initial_player_deck] is a list of Landmark.card cards created by 
    parsing the json located at "basichand.json". This will be used
    as each player's starting hand. *)
let initial_player_deck = Parse_json.load_establishments
    (Yojson.Basic.from_file "basichand.json")

(** [initial_deck_setlike] creates a setlike list consisting of the elements
    in the deck [cards]  *)
let initial_deck_setlike cards = 
  List.sort_uniq Establishment.sort_fun cards

(** [clean str] is the string [str] with whitespace on the edges trimmed off
    and converted to lower case  *)
let clean str = str |> String.trim |> String.lowercase_ascii

(**[set_of_names_of_all_cards cards] is a set-like list of all of the names
   of the cards in the given list [cards]. The names have had whitespace
   on the ends trimmed off, and have been converted to lowercase.*)
let set_of_names_of_all_cards cards = 
  let rec extract_names acc = function
    | [] -> acc
    | h::t -> extract_names ((clean h.name)::acc) t in
  List.sort_uniq compare (extract_names [] cards)

exception InvalidEstCard of string
exception InvalidLandmarkCard of string

(** [string_to_est str cards] is the card associated with [str] in the 
    list of establishment cards [cards].
    Raises: InvalidEstCard if the given name [str] is not the name
    of a valid establishment card.*)
let string_to_est (str: string) (cards:Establishment.card list): card =
  (* if str is not in the set of names then raise exception *)
  if not(List.mem str (set_of_names_of_all_cards cards)) 
  then raise (InvalidEstCard " is not a valid establishment card")
  else 
    let rec get_card_with_correct_name = function
      | [] -> raise (InvalidEstCard "Failure in basiccards.string_to_est:
  string argument is not a valid establishment card. UNUSUAL VERSION.")
      | h::t -> if str=clean(h.name) then h else get_card_with_correct_name t 
    in get_card_with_correct_name (initial_deck_setlike cards)