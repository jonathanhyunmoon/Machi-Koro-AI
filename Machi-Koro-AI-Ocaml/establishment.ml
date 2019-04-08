(* [industry] represents the color/industry of the card *)
type industry = 
  | Primary 
  | Secondary 
  | Restaurant 
  | Major
  (* [cardType] represents the icon on each establishment card *)
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
  (* [activationTime] is when in the game when the card's effects 
     are activated. [AnyonesTurn] means that the effect can occur after
     anyone rolls. [PlayersTurn] mean that the effect can occur only after
     the player with the card rolls. [OthersTurn] mean that the effect can
     only occur after some other player rolls (not the one with the card). *)
type activationTime = 
  | AnyonesTurn 
  | PlayersTurn 
  | OthersTurn
  (* [effectType] is the type of effect that occurs when the card is 
     activated. *)
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
  | TakeRolled  (* take a number of coins equal to value from
                   the person who just rolled*)
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
(* [card] is a record that represents a single kind of establishment
   card *)
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
let string_of_industry = function
  | Primary -> "Primary" 
  | Secondary -> "Secondary" 
  | Restaurant -> "Restaurant"
  | Major -> "Major" 
(** [string_of_cardtype] gives a string representation of the given
    cardType variant *)
let string_of_cardtype = function
  | Wheat -> "Wheat"
  | Cow -> "Cow"
  | Gear -> "Gear" 
  | Bread -> "Bread"
  | Factory -> "Factory"
  | Fruit -> "Fruit"
  | Cup -> "Cup"
  | Major -> "Major Establishment/Landmark"
  | Boat -> "Boat"
  | Suitcase -> "Suitcase"
(** [card_to_string] is a string representation of a card, containing
    its name, industry, type, construction cost, and activation numbers*)

(** [are_equal c1 c2] is true if and only if [c1] equals c2 *)
let are_equal card1 card2 = card1.name = card2.name

(** [clean str] is the string [str] with whitespace on the edges trimmed off
    and converted to lower case  *)
let clean str = str |> String.trim |> String.lowercase_ascii

(** [card_list_to_string c] is a list of names of cards in [c] *)
let card_list_to_string list =
  let rec extract_names acc= function
    | [] -> acc
    | h::t -> extract_names ((clean h.name)::acc) t in
  extract_names [] list

(** [card_list_to_string_counted c] is a list of names of cards in [c], 
    with the amount of times that that card comes up *)
let card_list_to_string_counted (lst:card list) = 
  (* counts the number of times cards appears in the list *)
  let rec counter card acc = function
    | [] -> acc
    | h::t -> if h.name = card.name then counter card (acc+1) t
      else counter card acc t in
  (* deletes all instances of card in list *)
  let rec delete_card card acc = function
    | [] -> acc
    |h::t -> if h.name = card.name then delete_card card acc t else
        delete_card card (h::acc) t in
  (* creates the list with the names of cards and the number of times they 
     appear *)
  let rec helper acc cardList = 
    match cardList with
    | [] -> acc
    | h::t -> helper 
                ((h.name ^" : "^ (string_of_int (counter h 1 t)))::acc) 
                (delete_card h [] t) in
  helper [] lst

(** [card_list_to_string_counted_price c] is a list of names of cards in [c], 
    with the amount of times that that card comes up, and its price *)
let card_list_to_string_counted_price (lst:card list) = 
  (* counts the number of times cards appears in the list *)
  let rec counter card acc = function
    | [] -> acc
    | h::t -> if h.name = card.name then counter card (acc+1) t
      else counter card acc t in
  (* deletes all instances of card in list *)
  let rec delete_card card acc = function
    | [] -> acc
    |h::t -> if h.name = card.name then delete_card card acc t else
        delete_card card (h::acc) t in
  (* creates the list with the names of cards and the number of times they 
     appear *)
  let rec helper acc cardList = 
    match cardList with
    | [] -> acc
    | h::t -> helper 
                ((h.name ^" : Price : "^ (string_of_int h.construction_cost) 
                  ^ " coins : " ^
                  (string_of_int (counter h 1 t)) ^ " available")::acc) 
                (delete_card h [] t) in
  helper [] lst

let get_construction_cost (card:card) = card.construction_cost


(* [name_to_card string_clist] is the card in [c_list] whose name corresponds
   to the string [string] (after whitespace has been trimmed and it's been
   converted to lowercase). Raises: Failure if the card could not be found
   in [c_list].*)
let rec name_to_card string c_list = 
  match c_list with
  | [] -> failwith "EXC in Establishment.name_to_card: couldn't be found"
  | h::t ->  if clean(h.name) = clean (string) then h else name_to_card 
        string t 

let card_to_effect_description card = 
  let string_activation_time =
    match card.effect.activation_time with 
    | AnyonesTurn -> " on anyone's turn."
    | PlayersTurn -> " on your turn."
    | OthersTurn -> " on anyone's but your turn."
  in
  match card.effect.effect_type with
  | Collect -> 
    "Collect " 
    ^ string_of_int card.effect.value 
    ^ " coins from the bank"
    ^ string_activation_time 
  | CollectGear -> 
    "Collect "
    ^ string_of_int card.effect.value 
    ^ " coins times the number of gear cards you have from the bank"
    ^ string_activation_time
  | CollectWheat ->
    "Collect "
    ^ string_of_int card.effect.value 
    ^ " coins times the number of wheat cards you have from the bank"
    ^ string_activation_time
  | CollectCow -> 
    "Collect "
    ^ string_of_int card.effect.value 
    ^ " coins times the number of cow cards you have from the bank"
    ^ string_activation_time
  | Take -> 
    "Take "
    ^ string_of_int card.effect.value 
    ^ " coins from another player" 
    ^ string_activation_time
  | TakeRolled -> 
    "Take "
    ^ string_of_int card.effect.value 
    ^ " coins from the person who just rolled"
    ^ string_activation_time
  | TakeAll -> 
    "Take "
    ^ string_of_int card.effect.value 
    ^ " coins from all other players" 
    ^ string_activation_time
  | Trade ->
    "Trade a non-major establishment with another player"
    ^ string_activation_time
  | HarborCollect ->
    "If you have a harbor, get 3 coins from the bank on anyone's turn"
    ^ string_activation_time
  | HarborCollectTunaRolled ->
    "Every player with a harbor and a tuna boat collects"
    ^ string_of_int card.effect.value 
    ^ " times the" 
    ^ " number of tuna boats"
    ^ string_activation_time
  | FlowerCollect ->
    "Collect 1 coin from the bank for every flower orchard the player has"
    ^ string_activation_time
  | CollectCup ->
    "Collect " 
    ^ string_of_int card.effect.value 
    ^ " coins times the number of cup cards you have from the bank"
    ^ string_activation_time
  | HarborTake ->  
    "Take from a single other player "
    ^ string_of_int card.effect.value 
    ^ " coins if you have a harbor"
    ^ string_activation_time
  | CollectCupBread -> 
    "Collect from each player " 
    ^ string_of_int card.effect.value 
    ^ " coins for every cup and bread establishment they have"
    ^ string_activation_time
  | Tax ->
    "Take half of the coins from each player who has "
    ^ string_of_int card.effect.value
    ^ " coins or more"
    ^ string_activation_time

(** [card_to_string] is a string representation of a card, containing
    its name, industry, type, construction cost, and activation numbers*)
let card_to_string (card:card) = 
  "Card Name: " ^ card.name 
  ^ "\n<Industry> " ^ string_of_industry card.industry 
  ^ "\n<Card Type> " ^ string_of_cardtype card.card_type ^ 
  "\n<Construction Cost> " ^ string_of_int card.construction_cost ^
  "\n<Activation Numbers> " ^ 
  ((List.map string_of_int card.activation_numbers) |>  
   (String.concat ", "))
  ^ "\n<Effect> " ^ card_to_effect_description card 
  ^ "\n"
(** [card_printer c] prints out the string representation of [c] *)
let card_printer (card:card) = 
  ANSITerminal.(
    print_string [cyan;Bold] 
      ("Card Name: "));
  ANSITerminal.(
    print_string [white] 
      ( card.name)); 
  ANSITerminal.(
    print_string [cyan;Bold] 
      (  "\nIndustry: "));
  ANSITerminal.(
    print_string [white] 
      (string_of_industry card.industry ));
  ANSITerminal.(
    print_string [cyan;Bold] 
      ( "\nCard Type: " ));
  ANSITerminal.(
    print_string [white] 
      (string_of_cardtype card.card_type));
  ANSITerminal.(
    print_string [cyan;Bold] 
      ( "\nConstruction Cost: "));
  ANSITerminal.(
    print_string [white] 
      (  string_of_int card.construction_cost));
  ANSITerminal.(
    print_string [cyan;Bold] 
      ( "\nActivation Numbers: " ));
  ANSITerminal.(
    print_string [white] 
      ( ((List.map string_of_int card.activation_numbers) |>  
         (String.concat ", "))));
  ANSITerminal.(
    print_string [cyan;Bold] 
      ( "\nEffect: " ));
  ANSITerminal.(
    print_string [white] 
      (  card_to_effect_description card 
         ^ "\n"))
(**[sort_fun] is a comparison function between two cards. It compares
   the strings that results from running [card_to_string] on the two
   cards. *)
let sort_fun = 
  fun (x:card) (y:card) -> Pervasives.compare (card_to_string x)
      (card_to_string y)