type industry = Landmark
type cardType = Major
type face = Up | Down
type effectType = DoubleRoll (* can choose before your turn to roll either 1 
                                                              or 2 dice *)
                | MallCollect (* whenever you collect from a bread or a
                                 cafe card, collect one extra coin*)
                | DoublesTurn (* if you roll doubles, then you can choose
                                   to take another turn*)
                | Reroll (* you can choose to roll again and replace your
                            previous roll with this landmark*)
                | CityHall (* If you have 0 coins, get one from the bank *)
                | AddToDie (* If roll is greater than or to 10, player can 
                              add 2 *)
                | BuildOrTake (* If player build's nothing on their turn
                                 take 10 coins from the bank *)
type effect = {
  value: int; 
  effect_type: effectType
}
type card = 
  {name:string; industry:industry; card_type:cardType;
   construction_cost:int; effect:effect; face: face}
(** [string_of_industry] is "landmark" *)
val string_of_industry : string
(** [string_of_cardtype] is "major" *)
val string_of_cardtype : string
(** [card_to_string card] is a string representation of [card] *)
val card_to_string : card -> string

(** [get_construction_cost card] is the construction cost of [card] *)
val get_construction_cost : card -> int

(** [card_to_string] is a string representation of a card, containing
    its name, industry, type, construction cost, and face*)
val card_to_string : card -> string

(** [landmark_card_list_to_str_list lst] is a string list that contains
    the names of the landmark cards within the list [lst]*)
val landmark_card_list_to_str_list : card list -> string list

val card_to_effect_description: card -> string 


