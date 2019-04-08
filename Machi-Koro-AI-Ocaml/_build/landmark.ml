type industry = Landmark
type cardType = Major
type face = Up | Down
(* type activationTime = AfterRoll | BeforeRoll | AfterCollect *)
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
  (* activation_time: activationTime; *)
  value: int; 
  effect_type: effectType
}
type card = 
  {name:string; 
   industry:industry; 
   card_type:cardType;
   construction_cost:int;
   effect:effect;
   face: face}

let string_of_industry = "Landmark"

let string_of_cardtype = "Major"

let card_to_string (card:card) 
  = "Card Name: " ^ card.name ^ " Industry: " ^ string_of_industry 
    ^ "; Card Type: " ^ string_of_cardtype ^ 
    "; Construction Cost: " ^ string_of_int card.construction_cost

let get_construction_cost (card:card) = card.construction_cost

let card_to_string (card:card) 
  = "Card Name: " ^ card.name ^
    " Industry: Landmark; Card Type: Major ; Construction Cost: "
    ^ string_of_int card.construction_cost ^ 
    match card.face with
    | Up -> "Up"
    | Down -> "Down"

(** [landmark_card_list_to_str_list lst] is a string list that contains
    the names of the landmark cards within the list [lst]*)
let rec landmark_card_list_to_str_list (lst:card list) = 
  match lst with
  | [] -> []
  | h::t -> h.name::(landmark_card_list_to_str_list t)

let card_to_effect_description card = 
  match card.effect.effect_type with 
  | DoubleRoll -> 
    "Before your turn, you may choose to roll either 1 or 2 dice.\n"
  | MallCollect -> 
    "Whenever you collect from a bread or a cafe card, collect one extra coin"
    ^ " for each one you collect from.\n"
  | DoublesTurn -> 
    "If you roll a double, then you can choose to take another turn.\n"
  | Reroll -> 
    "You can choose to roll again and replace your previous roll with this" 
    ^ " landmark.\n"
  | CityHall -> 
    "If you have 0 coins, get one from the bank.\n"
  | AddToDie -> 
    "If the dice you roll is greater than or to 10, you may choose to" 
    ^ " add 2 to the dice roll.\n"
  | BuildOrTake -> 
    "If player build's nothing on their turn take 10 coins from the bank.\n"

