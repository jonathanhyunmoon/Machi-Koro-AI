open Establishment

type player_id = string
type t = {
  id: player_id;
  num_dice: int;
  dice_rolls: int list;
  cash: int;
  assets: Establishment.card list;
  landmarks: Landmark.card list;
  order: int
}
(** [create_players n] is a list of [n] new players *)
val create_players : int -> t list

(** [change_cash p amt] changes [p.cash] by amt, which can be positive and 
    negative *)
val add_cash : t -> int -> t
(**[isWinner] is whether the current player has won by havig all the
   landmark cards activated*)
val is_winner : t -> Landmark.card list -> bool
(**[take_cash] is a tuple containing the player object with the amount of 
   cash substracted(Cash will never go below 0,so if the amount to take 
   is less than 0, then the new cash value is 0.) and the amount of cash
   to give to the party that is taking the cash*)
val take_cash : t -> int -> t * int

(**[buy_card] is a tuple of player object with [card] added to their assets 
   if they have enough money to buy the card, and the amount owed to the
    bank*)
val buy_card : t -> Establishment.card -> t * int

(** [roll player] is the updated player instance whose dice_roll field is 
    changed to be of length player.num_dice and are filled with that many new 
    random numbers*)
val roll : t -> t

(** [calc_roll player] calculates the new roll value from the list of dice 
    rolls represented by [player.dice_rolls]. *)
val calc_roll : t -> int

(** [num_of_card_type p card_type] is the number of cards of type [card_type] 
    player [p] has (i.e. in p.assets) *)
val num_of_card_type : t -> Establishment.cardType -> int 

(** [num_of_cards_with_same_name p name] is the number of cards with the same  
    name as string as [name] that the player has. *)
val num_of_cards_with_same_name : t -> string -> int

(** [get_lst_of_matching_industry_cards p valid_industries] is the list of 
    cards in [p.assets] that has a "valid" industry type.

    An establishment card [c] has a "valid" industry type if it satisfies:
    [List.mem c.industry valid_industries] *)
val get_lst_of_matching_industry_cards : 
  t -> Establishment.industry list-> Establishment.card list

(** [to_string player] is a string representation of [player] *)
val to_string : t -> string

(** [dice_to_roll player int] gives [player], but with its num_dice field
    replaced with [int]*)
val dice_to_roll : t ->int ->t