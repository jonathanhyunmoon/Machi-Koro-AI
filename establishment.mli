(* [industry] is a type that represents the color/industry of an 
     establishment card *)
type industry = 
  | Primary 
  | Secondary 
  | Restaurant 
  | Major
  (* [cardType] is a type that represents the icon on each establishment 
     card *)
type cardType = 
  | Wheat 
  | Cow 
  | Gear 
  | Bread 
  | Factory 
  | Fruit 
  | Cup 
  | Major 
  | Boat 
  | Suitcase  
  (* [cardtype] represents the icon on each establishment card *) 
type activationTime = 
  | AnyonesTurn 
  | PlayersTurn 
  | OthersTurn             
type effectType = 
  | Collect (* collect amount given by value from the bank *)
  | CollectGear (* collect from the bank value times the number
                   of gear cards one has*)
  | CollectWheat (* collect from the bank value times the 
                    number of wheat cards one has *)
  | CollectCow (* collect from the bank value times the 
                  number of cow cards one has *)
  | Take  (* take from a single other player a number of coins
             equal to value *)
  | TakeRolled  (* take the designated number of coins from the person
                   who just rolled*)
  | TakeAll (* take from all other players a number of coins
               equal to value *)
  | Trade (* trade a non-major establishment with another
             player *)
  | HarborCollect (* if you have a harbor, get 3 coins from the bank
                     on anyone's turn *)
  | HarborCollectTunaRolled (* every player with a harbor and a tuna boat
                               collects the amount times the number of tuna 
                               boats *)
  | FlowerCollect (* Collect 1 coin from the bank for every
                     flower orchard the player has *)
  | CollectCup (* collect from the bank the valuer times the
                  number of cup cards *)
  | HarborTake (* take from a single other player a number of coins
                  equal to value if you have a harbor *)
  | CollectCupBread (* collect one coin from each player for every cup and
                       bread establishment they have *)
  | Tax (* take half of the coins from each player who has
           10 coins or more *)
(* [effect] is a record containing three fields that define an
   establishment card's effects. [activation_time] gives the phase when
   a card is activated, [value] is the value of the effect (in coins).
   and [effect_type] is the type of effect (for instance, collecting
   from the bank or stealing from another player)*)
type effect = {
  activation_time: activationTime;
  value: int; 
  effect_type: effectType
}
type card = {
  name:string; 
  industry:industry; 
  card_type:cardType;
  construction_cost:int; 
  activation_numbers:int list;
  effect:effect
}
(** [string_of_industry] is a string representation of the given
    industry variant *)
val string_of_industry : industry -> string
(** [string_of_cardtype] gives a string representation of the given
    cardType variant *)
val string_of_cardtype :cardType -> string


(** [card_to_string] is a string representation of a card, containing
    its name, industry, type, construction cost, and activation numbers*)
val card_to_string : card -> string

(** [card_printer c] prints out the string representation of [c] *)
val card_printer : card -> unit
(** [card_list_to_string c] is a list of names of cards in [c] *)
val card_list_to_string : card list -> string list
(** [card_list_to_string_counted c] is a list of names of cards in [c], with 
    the amount of times that that card comes up *)
val card_list_to_string_counted : card list -> string list
(** [card_list_to_string_counted_price c] is a list of names of cards in [c], 
    with the amount of times that that card comes up, and its price *)
val card_list_to_string_counted_price : card list -> string list


(** [get_construction_cost card] is the construction cost of [card]*)
val get_construction_cost : card -> int

(** [sort_fun c1 c2] compares [c1] and [c2].1 if [c1] is greater than
    [c2], 0 if equal, -1 otherwise *)
val sort_fun : card -> card -> int
(** [are_equal c1 c2] is true if and only if [c1] equals c2 *)
val are_equal : card -> card -> bool
(* [name_to_card string_clist] is the card in [c_list] whose name corresponds
   to the string [string] (after whitespace has been trimmed and it's been
   converted to lowercase). Raises: Failure if the card could not be found
   in [c_list].*)
val name_to_card : string -> card list -> card
(** [card_to_effect_description c] is a string representation of [c]'s effect *)
val card_to_effect_description : card -> string