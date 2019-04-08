open Establishment
open Landmark

(** [initial_deck] is a list of Establishment.card cards created by parsing the
    json located at "basiccards.json". *)
val initial_deck : Establishment.card list
(** [initial_deck_landmarks] is a list of Landmark.card cards created by 
    parsing the json located at "basiccards.json". *)
val initial_deck_landmarks : Landmark.card list
(** [initial_player_deck] is a list of Landmark.card cards created by 
    parsing the json located at "basichand.json". This will be used
    as each player's starting hand. *)
val initial_player_deck : Establishment.card list
(** [initial_deck_setlike] creates a setlike list consisting of the elements
    in [initial_deck]  *)
val initial_deck_setlike : Establishment.card list -> Establishment.card list
(**[set_of_names_of_all_cards cards] is a set-like list of all of the names
   of the cards in the given list [cards]. The names have had whitespace
   on the ends trimmed off, and have been converted to lowercase.*)
val set_of_names_of_all_cards : Establishment.card list -> string list

exception InvalidEstCard of string
exception InvalidLandmarkCard of string

(** [string_to_est str] is the card associated with [str].
    Raises: InvalidEstCard if the given name [str] is not the name
    of a valid establishment card.*)
val string_to_est: string -> Establishment.card list -> Establishment.card