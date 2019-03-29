open Player
open Establishment
open Landmark
open Dice
exception InvalidNumberofPlayers of int
type player_id = string
type t = {
  players: Player.t list;
  bank: int;
  available_cards: Establishment.card list;
  current_player : int;
  landmark_cards: Landmark.card list
}

exception NotEnoughMoneyToPurchase of string
exception CardNotAvailable of string
exception DuplicateMajorCard of string

(** [init_state n] is the starting state of the game with the [n] number of 
    players playing the game.
    Raises: [InvalidNumberOfPlayers] if  n < 2 or n > 4
    ERIE: look in the instruction manual what goes into the starting phase of 
    the game. For instance, the game tells you to start with 3 coins and some 
    starting establishments.*)
val init_state: int -> Landmark.card list -> Establishment.card list -> t

(** [order_to_id] is the player id who plays [order]th in the game*)
val order_to_id: int -> t -> player_id

(** [purchase_establishment st player_id est] is the updated state [st'] in 
    which player [player_id] purchases the establishment [est] if still 
    available.

    That is, if [est] is a member of [st.available_cards]. the amount of money,
    [Player.cash], goes down by the cost of [est], and [player_id] gains that 
    [est] in Player.assets.
    Raises: [NotEnoughMoneyToPurchase] if player does not have enough money to
    purchase. 
    [CardNotAvailable] if the card is not available
*)
val purchase_establishment: t -> player_id -> Establishment.card -> t

(** [purchase_landmark st player_id lmk] is the updated state [st'] in which 
    player [player_id] purchases the landmark represented by the string [lmk] 
    if still available.

    That is, if the value of the boolean corresponding to [lmk] for the 
    player is [false], the amount of money,
    [Player.cash], goes down by the cost of [lmk], and the boolean for 
    [player_id] corresponding to that landmark becomes true.
    Raises: [NotEnoughMoneyToPurchase] if player does not have enough money to
    purchase. 
    [CardNotAvailable] if the card is already purchased
*)
val purchase_landmark: t -> player_id -> string -> t

(** [next_state st] updates the field [turn] in [st] to be the next player's 
    turn. *)
val next_state: t -> t

(** [activate_effects st] is a updated state whose [st.players] list is 
    modified such that fields of each player [p] in state [st] to reflect 
    the Effects of his/her assets [p.assets] based on the roll value 
    [p.dice_rolls]. 

    One thing to consider is whose turn it is.  
    1)Effects with activation_times AnyonesTurn or OthersTurn should only be 
    activated if it is not the player's turn. 
    2)Effects with activation_times AnyonesTurn or PlayersTurn should only be 
    activated if it is the player's turn. 


    For part alpha, this function will take in state [st] and return 
    [st] (i.e. effect is not implemented yet).


    For part beta, this function will take in state [st] and return 
    a modified instance [st'] (i.e. effect should be implemented).

    Ex. If player [p] being modified is the same as [get_current_player_id st] 
    then the Effects with activation_times that are [AnyonesTurn] or 
    [PlayersTurn] can be activated as long as the roll value [p.dice_rolls]
    matches with the [activation_numbers] of the establishment with the Effect 
    in consideration.

    Ex. If player [p] being modified is different from 
    [get_current_player_id st] then the Effects with activation_times that are 
    [AnyonesTurn] or [PlayersTurn] can be activated as long as the roll value 
    [roll_num] matches with the [activation_numbers] of the establishment with 
    the Effect in consideration. *)
val activate_effects: t -> t


(** [pay_player st from_id to_id amount] is an updated state [st'] whose player 
    list [st'.players] is modified such that the player [from_id] pays "as much 
    as possible" to the player [to_id]. 

    let "as much as possible" be defined as:
    1) if player [from_id] has 2 coins but must pay 3,
       player [from_id] will only pay 2 coins, leaving him/her with 0 coins and
       player [to_id] wil get 2 coins.

    2) if player [from_id] has 4 coins and must pay 3,
       player [from_id] will pay 3 coins, leaving him/her with 1 coin and 
       player [to_id] will get 3 coins. *)
val pay_player: t -> player_id -> player_id -> int -> t

(** [pay_players st from_id amount] is an updated state [st'] whose player list 
    [st'.players] is modified such that the player [from_id] pays "as much as 
    possible" to each player in [st'.players] in a "next in order" fashion. 

    "as much as possible" means:
    1) if player [from_id] has 2 coins but must pay 3,
       player [from_id] will only pay 2 coins, leaving him/her with 0 coins and 
       player [to_id] wil get 2 coins.
    2) if player [from_id] has 4 coins and must pay 3,
       player [from_id] will pay 3 coins, leaving him/her with 1 coin and 
       player [to_id] will get 3 coins.
    3) if at any point, player [from_id] runs out of money before paying 
       everyone [amount], the players next in the turn order are paid first. *) 
val pay_players: t -> player_id -> int -> t

(** [id_to_Player t id] is the player with the identifier [id]. *)
val id_to_Player: t -> player_id -> Player.t

(** [is_winning_state] is true if any of the players' [is_winner] calls is 
    true. *)
val is_winning_state: t -> bool

(** [get_current_player_id st] returns the player_id of the player whose turn
     it is in the state [st] *)
val get_current_player_id: t -> player_id

(** [get_current_player st] is the current player in [st] *)
val get_current_player: t -> Player.t

(** [replace_player p ps] is a list of players where [p] replaces a player in 
    [ps] if their ids are equal *)
val replace_player: Player.t -> Player.t list -> Player.t list

(* [replace_player_list players st] is the state [st], but with its player list
   replaced with [players] *)
val replace_player_list : Player.t list -> t -> t

(** [to_string state] is a string representation of [state] *)
val to_string : t -> string

(** [train_station_roll_2 player] is true if the player owns a landmark
    with the DoubleRoll effect, otherwise false *)
val train_station_roll_2 : Player.t -> bool

(** [reroll player] is true if the player owns a landmark
    with the Reroll effect, otherwise false *)
val reroll : Player.t -> bool

(** [take_other_turn player] is true if the player owns a landmark
    with the DoublesTurn effect, and the player rolled doubles, 
    otherwise false*)
val take_other_turn : Player.t -> bool

(** [cityhall_collect player] is true if the conditions are valid for
    the CityHall effect to activate, otherwise false *)
val cityhall_collect : Player.t -> bool

(** [add_2_to_roll player] is true if the conditions are valid for the
    AddToDie effect to activate, otherwise false *)
val add_2_to_roll : Player.t -> bool

(** [buildortake player] is true if the conditions are valid for the
    BuildOrTake effect to activate, otherwise false *)
val buildortake : Player.t -> bool

(** [add2_to_dice player] is [player], but with each of [player]'s dice
    rolls increased by 2 *)
val add2_to_dice : Player.t -> Player.t

(** [withdraw_bank st amt] is state [st], but with integer [amt] subtracted
    from the bank *)
val withdraw_bank : t -> int -> t