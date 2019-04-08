open Establishment
open Basiccards
type player_id = string
type t = {
  id: player_id;
  num_dice: int;
  dice_rolls: int list;
  cash: int;
  assets: Establishment.card list;
  landmarks: Landmark.card list;
  (* NOTE: the first index in order is 0. Player 1 is 0, player 2 is
     1, and so on *)
  order: int
}

let create_players n = 
  let rec helper n acc = 
    if n = 0 then acc else
      helper (n-1) ({
          id = "Player " ^ (string_of_int n);
          num_dice = 1;
          dice_rolls = [-1];
          cash = 3;
          assets = Basiccards.initial_player_deck;
          landmarks = [];
          order = n-1
        }::acc) in
  helper n []

let add_cash player amt= {
  id= player.id;
  num_dice= player.num_dice;
  dice_rolls= player.dice_rolls;
  cash= player.cash + amt;
  assets= player.assets;
  landmarks = player.landmarks;
  order= player.order
}

(**[isWinner] is whether the current player has won by havig all the
   landmark cards activated*)
let is_winner player landmarks = 
  let p_cards = player.landmarks in
  let rec helper cards landmarks = 
    match landmarks with
    | [] -> true
    | h::t -> if List.mem h cards then helper cards t else false in 
  helper p_cards landmarks
(**[take_cash] is a tuple containing the player object with the amount of 
   cash substracted(Cash will never go below 0,so if the amount to take 
   is less than 0, then the new cash value is 0.) and the amount of cash
   to give to the party that is taking the cash*)
let take_cash player amount = ({
    id = player.id;
    num_dice = player.num_dice;
    dice_rolls = player.dice_rolls;
    cash = 
      if player.cash - amount < 0 then 0 
      else player.cash - amount;
    assets = player.assets;
    landmarks = player.landmarks;
    order = player.order
  },
    if player.cash - amount < 0 then player.cash 
    else amount)

(**[buy_card] is a tuple of player object with [card] added to their assets 
   if they have enough money to buy the card, and the amount owed to the
    bank*)
let buy_card player (card:Establishment.card) = 
  if player.cash - get_construction_cost card < 0 then (player, 0) 
  else ({
      id = player.id;
      num_dice = player.num_dice;
      dice_rolls = player.dice_rolls;
      cash = player.cash - (get_construction_cost card);
      assets = card::player.assets;
      landmarks = player.landmarks;
      order = player.order
    }, 
      get_construction_cost card)

let roll player = 
  let rec refresh_rolls n lst = 
    if n > 0 then refresh_rolls (n-1) ((Dice.roll ()):: lst) else lst in 
  let renewed_dice_rolls ()= refresh_rolls player.num_dice [] in
  {
    id = player.id;
    num_dice = player.num_dice;
    dice_rolls = renewed_dice_rolls ();
    cash = player.cash;
    assets = player.assets;
    landmarks = player.landmarks;
    order = player.order
  }

let calc_roll player = 
  List.fold_left (fun acc x -> acc + x ) 0 player.dice_rolls

(** [dice_to_roll player int] gives [player], but with its num_dice field
    replaced with [int]*)
let dice_to_roll player int = 
  {
    id = player.id;
    num_dice = int;
    dice_rolls = player.dice_rolls;
    cash = player.cash;
    assets = player.assets;
    landmarks = player.landmarks;
    order = player.order
  }

let num_of_card_type (player:t) (c_type:Establishment.cardType): int =
  let rec counter count = function
    | [] -> count
    | h::t -> if h.card_type = c_type 
      then counter (count+1) t 
      else counter count t
  in counter 0 player.assets

let num_of_cards_with_same_name (player:t) (name:string) =
  let rec counter count = function
    | [] -> count
    | h::t -> if (h.name |> String.trim |> String.lowercase_ascii) = name 
      then counter (count +1) t
      else counter count t
  in counter 0 player.assets


let get_lst_of_matching_industry_cards (player:t) 
    (valid_industries: Establishment.industry list) =
  let cards = player.assets in 
  let rec helper acc = function
    | [] -> acc
    | h::t -> if (List.mem h.industry valid_industries) 
      then helper (h::acc) t 
      else helper acc t in 
  helper [] cards


let to_string player = 
  let rec cardnamesEst acc (lst:Establishment.card list) = 
    match lst with
    | [] -> acc
    | h::t -> cardnamesEst (h.name ^ ", "^ acc) t in
  let rec cardnamesLand acc (lst:Landmark.card list) = 
    match lst with
    | [] -> acc
    | h::t -> cardnamesLand (h.name ^ ", "^ acc) t in
  "ID: " ^ player.id ^
  "Number of dice: " ^ string_of_int (player.num_dice) ^
  "Cash: " ^ string_of_int (player.cash) ^
  "Establisment Cards: " ^ cardnamesEst "" (player.assets) ^
  "Landmark Cards: " ^ cardnamesLand "" (player.landmarks) ^
  "Order: " ^ string_of_int player.order
