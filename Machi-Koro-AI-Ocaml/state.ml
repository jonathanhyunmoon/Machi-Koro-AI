open Player
open Establishment
open Landmark
open Dice
open Basiccards
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
exception InvalidNumberofPlayers of int
exception DuplicateMajorCard of string
exception CannotTradeMajorEst of string
exception CannotTradeWithSelf of string 
exception CannotTakeFromSelf of string 

(*_________________________ helper functions ___________________________ *)
(** [clean str] trims the whitespace off of the string [str], and renders it 
    into lowercase *)
let clean str = str |> String.trim |> String.lowercase_ascii

(** [search_list item list] is whether the given item [item] is an element
    of the list [list] *)
let rec search_list item list =
  match list with
  | [] -> false
  | h::t -> if item = h then true
    else search_list item t
(** [add_landmarks l] is a list of landmarks made of [l] without repetitions *)
let rec add_landmarks landmarks acc = 
  match landmarks with
  | [] -> acc
  | h::t -> if List.mem h acc then add_landmarks t acc 
    else add_landmarks t (h::acc)

let init_state n landmarks establishments= 
  if n = 2 then {
    players = Player.create_players n;
    bank = 282;
    available_cards = (Basiccards.initial_deck)@establishments;
    current_player = 0;
    landmark_cards = add_landmarks landmarks 
        (Basiccards.initial_deck_landmarks)
  }
  else if n = 3 then {
    players = Player.create_players n;
    bank = 282;
    available_cards = (Basiccards.initial_deck)@establishments;
    current_player = 0;
    landmark_cards = add_landmarks landmarks 
        (Basiccards.initial_deck_landmarks)
  }
  else if n = 4 then {
    players = Player.create_players n;
    bank = 282;
    available_cards = (Basiccards.initial_deck)@establishments;
    current_player = 0;
    landmark_cards = add_landmarks landmarks 
        (Basiccards.initial_deck_landmarks)
  }
  else raise (InvalidNumberofPlayers (n))

let order_to_id n state =  
  let rec helper (n:int) (player_list: Player.t list) = 
    match player_list with
    | [] -> failwith "Player Not found"
    | h::t -> if h.order = n then
        h.id 
      else helper n t in
  helper n (state.players)

(**[get_player p_id players] is the player 
   associated with [p_id] in [players] *)
let rec get_player p_id players =
  match players with
  | [] -> failwith "invalid player"
  | h::t -> if clean(h.id) = clean(p_id) then h else get_player p_id t 

(**[delete_card_from_deck cards card] is [cards] without [card]. Only removes
   one card *)
let rec delete_card_from_deck cards card acc= 
  match cards with
  | [] -> acc
  | h::t -> if Establishment.are_equal h card then acc@t 
    else delete_card_from_deck t card (h::acc)
(**[create_players_purchase_helper player players card] is a [players] where 
   [player] has been altered to refelct a purchase of [card]*) 
let rec create_players_purchase_helper 
    player players (card:Establishment.card) acc =
  match players with
  | [] -> acc
  | h::t -> if h.id = player.id then {
      id = player.id;
      num_dice = player.num_dice;
      dice_rolls = player.dice_rolls;
      cash = player.cash - card.construction_cost;
      assets = card::(player.assets);
      landmarks = player.landmarks;
      order = player.order

    }::(acc@t)
    else create_players_purchase_helper player t card (h::acc)

(* [create_players_purchase_landmark_helper] is a helper function that
   sets new player values for a successful landmark purchase*)
let rec create_players_purchase_landmark_helper 
    player players (landmark:string) landmarkcards acc =
  let rec helper_2 player players (landmarkcard:Landmark.card) acc = 
    match players with
    | [] -> acc
    | h::t -> if h.id = player.id then {
        id = player.id;
        num_dice = player.num_dice;
        dice_rolls = player.dice_rolls;
        cash = player.cash - landmarkcard.construction_cost;
        assets = player.assets;
        landmarks = (landmarkcard)::player.landmarks;
        order = player.order
      }::(acc@t)
      else helper_2 player t landmarkcard (h::acc) in
  let rec helper landmark landmarks = 
    match landmarks with
    | [] -> failwith ("invalid landmark given for " ^
                      "create_players_purchase_landmark_helper")
    | h::t -> if clean (h.name) = clean (landmark) 
      then helper_2 player players h [] 
      else helper landmark t in
  helper landmark landmarkcards

let purchase_establishment state p_id card =
  (* get player from id *)
  let player = get_player p_id (state.players) in
  (* checks to see if the card passed is a card in card_list *)
  let rec check_for_card card_list card = 
    match card_list with
    | [] -> false
    | h::t -> if Establishment.are_equal h card then true 
      else check_for_card t card in
  if check_for_card (state.available_cards) card then
    if (card.construction_cost > (player.cash))
    then raise (NotEnoughMoneyToPurchase (string_of_int(player.cash)))

    else
      (* checks if the card is both an establishment, and already belongs
         to the player seeking to buy it - if so, then prevents the player
         from buying *)
    if (card.card_type = Establishment.Major && search_list card 
          ((get_player p_id state.players).assets)) 
    then raise 
        (DuplicateMajorCard (card.name 
                             ^ " is a major establishment" ^ 
                             " already in your possession."))
    else 
      let _ = ANSITerminal.(print_string [green]) 
          ("You've successfully purchased " ^ card.name ^ "\n") in
      {
        players = create_players_purchase_helper player (state.players) 
            card [];
        bank = state.bank + card.construction_cost;
        available_cards = delete_card_from_deck (state.available_cards) 
            card [];
        current_player = state.current_player;
        landmark_cards = state.landmark_cards
      }
  else raise (CardNotAvailable " is not an available establishment card.\n
   Please give an available establishment card name.\n")

let purchase_landmark state p_id landmark_card =
  let player = get_player p_id (state.players) in
  let rec helper state player landmark_card landmarks = 
    match landmarks with
    | [] -> raise (CardNotAvailable " is not an available landmark card.\n
   Please give an available landmark card name.\n")
    | h::t ->
      if clean (landmark_card) = clean (h.name) then 
        if h.construction_cost > (player.cash)
        then raise (NotEnoughMoneyToPurchase (string_of_int(player.cash)))
        (* checks if the play's already bought a train station *)
        else if List.mem h player.landmarks then raise 
            (CardNotAvailable " has already been purchased.\n
   Please give an available landmark card name.\n")
        else let _ = ANSITerminal.(print_string [green]) 
                 ("You've successfully purchased " ^ h.name ^ "\n") in
          {
            players = create_players_purchase_landmark_helper player 
                (state.players) landmark_card state.landmark_cards [];
            bank = state.bank + h.construction_cost;
            available_cards = state.available_cards;
            current_player = state.current_player;
            landmark_cards = state.landmark_cards;
          }
      else helper state player landmark_card t in
  helper state player landmark_card state.landmark_cards


let next_state t = 
  let rec num_players acc = function
    | [] -> acc
    | h::t -> num_players (acc + 1) t in
  {
    players = t.players;
    bank = t.bank;
    available_cards = t.available_cards;
    current_player = (t.current_player + 1) mod (num_players 0 t.players);
    landmark_cards = t.landmark_cards
  }

(** [sort_players_helper] is 1 if [player1] has order greater than [player2],
    0 if equal, -1 other wise*)
let sort_players_helper player1 player2 =  
  if player1.order>player2.order then 1
  else if player1.order<player2.order then -1
  else 0
(** [set_i_to_beginning n p] sets [n] to the beginning of [p], 
    preserving order, and then returns [p] without the head *)
let rec set_i_to_beginning n players = 
  match players with
  | [] -> players
  | h::t -> if h.order = n then players else set_i_to_beginning n (t@[h])

(** [replace_player p ps] is a list of players where [p] replaces a player in 
    [ps] if their ids are equal *)
let replace_player player players =
  let rec replace_player' player' players' acc = 
    match players' with
    | [] -> acc
    | h::t -> if h.id = player'.id then player'::(t@acc) 
      else replace_player' player' t (h::acc) in 
  replace_player' player players []

(* [replace_player_list players st] is the state [st], but with its player list
   replaced with [players] *)
let replace_player_list players st = {
  players = players;
  bank = st.bank;
  available_cards = st.available_cards;
  landmark_cards = st.landmark_cards;
  current_player = st.current_player
}

let pay_player state from_id to_id amount = 
  let players = state.players in
  let from_player = get_player from_id players in
  let to_player = get_player to_id players in
  (* if the from_player does not have enough money to pay to_player, then set 
     from_player cash to 0 and give to_player all of from_players cash *)
  if from_player.cash - amount < 0 then 
    let to_player' = Player.add_cash to_player (from_player.cash) in
    let from_player' = Player.add_cash from_player (-from_player.cash) in
    let players =   
      replace_player to_player' (replace_player from_player' players) in
    {
      players = players;
      bank = state.bank;
      available_cards = state.available_cards;
      current_player = state.current_player;
      landmark_cards = state.landmark_cards
    } 
  else
    (* else proceed with transaction normally *)
    let to_player' = Player.add_cash to_player amount in
    let from_player' = Player.add_cash from_player (-amount) in 
    let players = 
      replace_player to_player' (replace_player from_player' players) in
    {
      players = players;
      bank = state.bank;
      available_cards = state.available_cards;
      current_player = state.current_player;
      landmark_cards = state.landmark_cards
    }
(**[pay_players_helper frm_p to_plist amount] is a list of players where 
   [frm_p] has paid [amount] to all players in [to_plist], unless they have 
   run out of money*)
let rec pay_players_helper from_player to_player_list amount acc= 
  match to_player_list with
  | [] -> acc
  | h::t -> if from_player.cash - amount < 0 then 
      (* if the from_player does not have enough money to pay h, set 
         from_player cash to 0 and give to_player all of from_players cash,
         end computation here and return player list *)
      let h' = Player.add_cash h from_player.cash in
      let from_player' = Player.add_cash from_player (-from_player.cash)
      in [h';from_player']@(acc@t)
    else 
      (* proceed with transaction normally *)
      let h' = Player.add_cash h amount in
      let from_player' = Player.add_cash from_player (-amount) in 
      pay_players_helper from_player' t amount (h'::acc)

let pay_players state from_id amount =
  let players = state.players in
  let from_player = get_player from_id players in
  (* sort players so that pay_players_helper can pay the players in order.  
     Excludes the player [from_id] *)
  let sorted_players =
    List.tl (set_i_to_beginning 
               (state.current_player) 
               (List.sort sort_players_helper players)) in
  {
    players = pay_players_helper from_player sorted_players amount [];
    bank = state.bank;
    available_cards = state.available_cards;
    current_player = state.current_player;
    landmark_cards = state.landmark_cards
  }
(** [receive_from_all s p a] is a state where every player in [s] except [p]
    has paid [p] [a] coins *)
let receive_from_all state player amount = 
  let rec receive_from_all_helper p_lst st'=
    match p_lst with
    | [] -> st'
    | h::t -> if h.id = player.id 
      then receive_from_all_helper t st'
      else let paid_state = pay_player st' h.id player.id amount in 
        receive_from_all_helper t paid_state
  in 
  let sorted_players= 
    set_i_to_beginning (player.order)
      (List.sort sort_players_helper state.players) in
  receive_from_all_helper (List.rev (List.tl sorted_players)) state

let id_to_Player state p_id = get_player p_id (state.players)
let get_current_player_id (st:t): player_id = 
  order_to_id (st.current_player) st
let get_current_player st = 
  st |> get_current_player_id |> id_to_Player st

let is_winning_state state = 
  let players = state.players in
  let rec winner players = 
    match players with
    | [] -> false
    | h::t -> Player.is_winner h  (state.landmark_cards) || winner t in
  winner players

(** [turn_color t p] is the color corresponding to player [p] in [t]
    for the ANSITerminal *)
let turn_color (st:t) (p_id:player_id): ANSITerminal.style  =
  let turn = 
    (p_id |> id_to_Player st).order 
  in
  let color_lst = [
    ANSITerminal.yellow; 
    ANSITerminal.cyan; 
    ANSITerminal.blue;
    ANSITerminal.magenta]
  in 
  List.nth color_lst turn


let display_collect_fun_msg_1 tc (card:Establishment.card) player =
  ANSITerminal.(print_string [tc] (
      " " ^ player.id ^ "'s " ^ card.name ^ "'s collect effect has been" 
      ^ " activated."
      ^ " You will collect " ^ string_of_int card.effect.value ^ " coins. \n"
    ))

let display_collect_fun_msg_2 tc (card:Establishment.card) player =
  ANSITerminal.(print_string [tc] (
      " " ^ player.id ^ "'s Shopping Mall effect has been" 
      ^ " activated rewarding one more coin.\n"
    ))
(** [collect_fun c t p] displays the collect effect message for player [p]
    in [t] and returns the updated state *)
let collect_fun (card:Establishment.card) st player = 
  let tc = turn_color st player.id in 
  let _ = display_collect_fun_msg_1 tc card player in
  let payment_value =
    if card.card_type = Establishment.Bread &&
       List.mem "Shopping Mall"   
         (Landmark.landmark_card_list_to_str_list player.landmarks) 
    then
      let _ = display_collect_fun_msg_2 tc card player in
      card.effect.value + 1 else card.effect.value in
  let updated_player = Player.add_cash player payment_value in
  let cb = -payment_value in 
  let p_lst = replace_player updated_player st.players in
  {
    players = p_lst;
    bank = st.bank + cb;
    available_cards = st.available_cards;
    current_player = st.current_player;
    landmark_cards = st.landmark_cards
  }
(** [display_collect_card_type_fun_msg_1 tc c num type p] 
    displays a message in [tc] style about player [p]'s [c] card and [type] 
    effect with [num] *)
let display_collect_card_type_fun_msg_1 tc (card:Establishment.card) num 
    c_type player=
  ANSITerminal.(print_string [tc] (
      " " ^ player.id ^ "'s " ^ card.name ^ 
      "'s collect card type effect has been "
      ^ "activated. Since you have " ^ string_of_int num 
      ^ " of cards with the type " ^ Establishment.string_of_cardtype c_type 
      ^ ", you will collect " ^ string_of_int num ^ " coins. \n"
    ));
  print_string("> ")
(** [collect_card_type_fun t p type] displays the appropriate message
    about the collect [type] effect and updates player [p] and stat [t] *)
let collect_card_type_fun (card:Establishment.card) st player c_type =
  let rec collectmall = function
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | MallCollect -> true && (match c_type with 
          | Cup | Bread -> true | _ -> false)
      | _ -> collectmall t in
  let mallcollect = collectmall player.landmarks in
  let tc = turn_color st player.id in 
  let num = Player.num_of_card_type player c_type in 
  let _ = display_collect_card_type_fun_msg_1 tc card num c_type player in 
  let updated_player =
    if mallcollect then
      Player.add_cash player (num*(card.effect.value + 1))
    else
      Player.add_cash player (num*card.effect.value) in
  let cb = 
    if mallcollect then 
      let _ = ANSITerminal.(print_string [tc] (
          " " ^ player.id ^ "'s Mall Collect effect has been "
          ^ "activated. Since you have " ^ string_of_int num 
          ^ " of cards with the type " ^ 
          Establishment.string_of_cardtype c_type 
          ^ ", you will collect " ^ string_of_int 
            (num*(card.effect.value + 1)) ^ " coins. \n"
        )) in
      -num*(card.effect.value + 1)
    else
      -num*card.effect.value in 
  let p_lst = replace_player updated_player st.players in
  {
    players = p_lst;
    bank = st.bank + cb;
    available_cards = st.available_cards;
    current_player = st.current_player;
    landmark_cards = st.landmark_cards
  }

(** [is_valid_player_id st p] is true if [p] is a player in state [st],
    false otherwise *)
let is_valid_player_id player st p_string = 
  let players = st.players in
  let rec check_players' p = function
    | [] -> false
    | h::t -> if clean(h.id) = p then true else check_players' p t in
  check_players' p_string players

exception InvalidPlayerId
(** [get_valid_player_id p t ps] is a valid player_id in [t] that resembles
    [ps]  *)
let get_valid_player_id player st p_string =
  let players = st.players in
  let rec check_players' p = function
    | [] -> raise InvalidPlayerId
    | h::t -> if clean h.id = clean p then h.id else check_players' p t in
  check_players' p_string players


let display_take_fun_msg_1 tc (card:Establishment.card) player =
  ANSITerminal.(print_string [tc] (
      " " ^ player.id ^ "'s " ^ card.name ^ 
      "'s take effect has been activated. Who "
      ^ "do you want " ^ (string_of_int card.effect.value) ^ " coins from?: \n"
    ));
  print_string("> ")
let display_take_fun_msg_2 tc  =
  ANSITerminal.(print_string [tc] (
      " Invalid player id. Please input a valid player id. \n"
    ));
  print_string("> ")
(** [take_fun c t p] is the state after the take effect of player [p] with
    card [c] has take effect. Displays appropriate messages and prompts player
    for another player id from whom to take *)
let take_fun (card:Establishment.card) st (player:Player.t) =
  let tc = turn_color st player.id in 
  let _ = display_take_fun_msg_1 tc card player in
  let rec await_valid_player_id () = 
    let input = clean(read_line()) in 
    match input with 
    | "quit" -> exit 0 
    | "finish" | "f" -> "finish"
    | input -> if clean player.id = input 
      then raise 
          (CannotTakeFromSelf "Taking money from yourself is not allowed.") 
      else if is_valid_player_id player st input 
      then input 
      else let _ = display_take_fun_msg_2 tc in await_valid_player_id () in
  let crude_player_id = await_valid_player_id () in 
  if crude_player_id = "finish" then st else 
    pay_player st crude_player_id player.id card.effect.value

let display_take_rolled_fun_msg_1 tc st (card:Establishment.card) player =
  ANSITerminal.(print_string [tc] (
      player.id ^ "'s " ^ card.name ^ "'s take rolled effect has been "
      ^ "activated. \nYou will take " ^ string_of_int card.effect.value 
      ^ " coins from the current player, " ^ get_current_player_id st ^".\n"
    ))
let display_take_rolled_fun_msg_2 tc st (card:Establishment.card) player =
  ANSITerminal.(print_string [tc] (
      " " ^ player.id ^ "'s Shopping Mall effect has been" 
      ^ " activated rewarding one more coin.\n"
    ))
(** [take_rolled_fun c t p] is a state where player [p]'s card [c]'s
    take rolled effect has been activated. DIsplays appropriate messages *)
let take_rolled_fun (card:Establishment.card) st player =
  let tc = turn_color st player.id in 
  let _ = display_take_rolled_fun_msg_1 tc st card player in
  let player_who_rolled_id = get_current_player_id st in 
  let payment_value =
    if List.mem "Shopping Mall"  
        (Landmark.landmark_card_list_to_str_list player.landmarks) 
    then let _ = display_take_rolled_fun_msg_2 tc st card player in
      card.effect.value + 1 else card.effect.value in
  let output = pay_player st player_who_rolled_id player.id 
      payment_value in output

let display_take_all_fun_msg_1 tc (card:Establishment.card) player =
  ANSITerminal.(print_string [tc] (
      " " ^ player.id ^ "'s " ^ card.name ^ "'s take all effect has been "
      ^ "activated. You will take " ^ string_of_int card.effect.value 
      ^ " coins from all players.\n" 
    ))
(** [take_all_fun c t p] is a state where player [p]'s card [c]'s take all
    effect has been activated in state [t]. Displays appropriate messages *)
let take_all_fun (card:Establishment.card) st player = 
  let tc = turn_color st player.id in 
  let _ = display_take_all_fun_msg_1 tc card player in
  receive_from_all st player card.effect.value

(** [add_card player card] is a player with [card] added to its assets *)
let add_card player card = 
  {
    id = player.id;
    num_dice = player.num_dice;
    dice_rolls = player.dice_rolls;
    cash = player.cash;
    assets = card::(player.assets);
    landmarks = player.landmarks;
    order = player.order
  }
(** [take_card player card] is a player with [card] taken out of its assets *)
let take_card player card = 
  {
    id = player.id;
    num_dice = player.num_dice;
    dice_rolls = player.dice_rolls;
    cash = player.cash;
    assets = delete_card_from_deck player.assets card [];
    landmarks = player.landmarks;
    order = player.order
  }

(** [trade_establishment fp tp fc tc t] is a state where players [fp] and [tc]
    have traded cards [fc] and [tc], respectively, in state [t]. 
    Displays appropriate messages *)
let trade_establishment from_player to_player 
    (from_card:Establishment.card) (to_card:Establishment.card) state = 
  if from_card.card_type = Establishment.Major 
  || to_card.card_type = Establishment.Major 
  then raise (CannotTradeMajorEst "Cannot trade a major establishment.")
  else
    let new_f_player = add_card (take_card from_player from_card) to_card in
    let new_to_player = add_card (take_card to_player to_card) from_card in
    let temp_player_list = 
      state.players 
      |> replace_player new_f_player  
      |> replace_player new_to_player in
    replace_player_list temp_player_list state


let display_trade_fun_msg_1 (tc:ANSITerminal.style) (card:Establishment.card)=
  ANSITerminal.(print_string [tc]
                  (" The trade effect for the card "
                   ^ card.name 
                   ^ " has been activated. Who do you want to trade with?\n"
                  ));
  print_string("> ")

let display_trade_fun_msg_2 (tc:ANSITerminal.style) =
  ANSITerminal.(print_string [tc] (
      " Invalid player id. Please input a valid player id. \n"
    ));
  print_string("> ")

let display_await_valid_est_EXC_msg_1 (tc:ANSITerminal.style) str =
  ANSITerminal.(print_string [tc] (
      " " ^ str ^ " Please input a valid establishment card name.\n"
    ));
  print_string("> ")

let display_trade_fun_msg_4 (tc:ANSITerminal.style) (st:t) player_id=
  ANSITerminal.(print_string [tc]
                  (" " ^ player_id ^ " has these available cards: \n"));
  let _ = List.map 
      (fun (x:string) -> ANSITerminal.(print_string [tc] ("\n"^x)))
      (Establishment.card_list_to_string_counted
         ((id_to_Player st player_id).assets)) in 
  ANSITerminal.(print_string [tc]
                  "\n Which of these cards would you like to take?\n");      
  print_string("> ")

let display_trade_fun_msg_5 (tc:ANSITerminal.style) (st:t) player_id=
  ANSITerminal.(print_string [tc]
                  " You currently have these available cards: \n");
  let _ = List.map 
      (fun (x:string) -> ANSITerminal.(print_string [tc] ("\n"^x)))
      (Establishment.card_list_to_string_counted
         ((id_to_Player st player_id).assets)) in 
  ANSITerminal.(print_string [tc]
                  "\n Which of these cards would you like to get rid of?\n"); 
  print_string("> ")

let display_trade_fun_EXC_msg_1 (tc:ANSITerminal.style) str=
  ANSITerminal.(print_string [tc] (
      " " ^ str ^ " Please input a player id other than yourself.\n"
    ))

let display_trade_fun_EXC_msg_2 (tc:ANSITerminal.style) str=
  ANSITerminal.(print_string [tc] (
      " " ^ str ^ " Please name an non-Major establishment card.\n"
    ))

let display_trade_fun_EXC_msg_3 (tc:ANSITerminal.style) str=
  ANSITerminal.(print_string [tc] (
      " " ^ str ^ " Please name a valid establishment card.\n"
    ))


(** [est_name_to_est_card e t] is the card corresponding name [e] in state
    [t].
    Requires: [e] is a valid card name in state [t] *)
let est_name_to_est_card current_player est_name  =
  let get_valid_est_name player est_string =
    let establishments = player.assets in
    let rec check_est e (ests:Establishment.card list) = 
      match ests with
      | [] -> raise (CardNotAvailable (est_string ^ 
                                       "is not an available card."))
      | h::t -> if clean h.name = clean e 
        then h.name else check_est e t in
    check_est est_string establishments in 

  let establishments = current_player.assets in
  let rec get_card est_name (ests:Establishment.card list) = 
    match ests with 
    | [] -> raise (CardNotAvailable (est_name ^ " is not a valid card."))
    | h::t -> if clean est_name = clean h.name
      then h
      else get_card est_name t in
  get_card (get_valid_est_name current_player est_name) establishments


exception Finish
(** [await_valid_est p t] is an establishment card in player [p]'s hand in 
    state [t] *)
let rec await_valid_est tc player st = 
  try(
    let input = read_line() in 
    match clean input with 
    | "quit" -> exit 0 
    | "finish" | "f" -> raise Finish
    | x -> input |> est_name_to_est_card player)
  with
  | CardNotAvailable str ->  
    let _ = display_await_valid_est_EXC_msg_1 tc str in 
    await_valid_est tc player st
(** [trade_fun c t p] is a state where player [p] has given card [c] to 
    some player in state [t] *)
let rec trade_fun card (st:t) player : t =
  let tc = turn_color st player.id in 

  let rec await_valid_player_id () =
    try(
      let input = read_line() in 
      match clean input with 
      | "quit" -> exit 0 
      | "finish" | "f" -> raise Finish
      | x -> if clean(player.id) = x 
        then raise (CannotTradeWithSelf "Trading with yourself is not allowed.") 
        else input |> get_valid_player_id player st
    ) 
    with 
    | CannotTradeWithSelf str -> display_trade_fun_EXC_msg_1 tc str;
      await_valid_player_id ()  
    | InvalidPlayerId -> let _ = display_trade_fun_msg_2 tc 
      in await_valid_player_id () in

  try (
    let _ = display_trade_fun_msg_1 tc card in
    let tradee_player_id = await_valid_player_id () in 
    let tradee = tradee_player_id |> id_to_Player st in
    let _ = display_trade_fun_msg_4 tc st tradee.id in
    let tradee_est = await_valid_est tc tradee st in
    if tradee_est.card_type = Establishment.Major 
    then raise (CannotTradeMajorEst "Cannot trade a major establishment.")
    else
      let _ = display_trade_fun_msg_5 tc st player.id in
      let trader_est = await_valid_est tc player st in
      trade_establishment tradee player tradee_est trader_est st
  )
  with 
  | CannotTradeMajorEst str -> 
    let _ = display_trade_fun_EXC_msg_2 tc str in 
    trade_fun card st player
  | Finish -> st

(** [harbor_collect_fun c t p] is a state where player [p]'s card [c]'s
    harbor_collect effect has been applied in state [t]. Displays
    apprpriate messages *)
let harbor_collect_fun (card:Establishment.card) st (player:Player.t) = 
  if List.mem "Harbor" (Landmark.landmark_card_list_to_str_list 
                          (player.landmarks)) 
  then 
    let updated_player = Player.add_cash player card.effect.value in
    let cb = -card.effect.value in 
    let p_lst = replace_player updated_player st.players in
    {
      players = p_lst;
      bank = st.bank + cb;
      available_cards = st.available_cards;
      current_player = st.current_player;
      landmark_cards = st.landmark_cards
    }
  else st

let display_harbor_collect_tuna_rolled_fun_msg_1 tc (card:Establishment.card) 
    st =
  ANSITerminal.(print_string [tc](
      " The " ^card.name^" card's effect has been activated.\n"
      ^ (get_current_player_id st) ^ ", please roll the dice (\"r\")" 
      ^ " to determine the multiplier for value of " ^card.name^"\n"
    ));
  print_string "> "

let display_harbor_collect_tuna_rolled_fun_msg_2 tc roll_num =
  ANSITerminal.(print_string [tc](
      " The dice roll was a: " ^ (string_of_int roll_num) ^ "\n"
    ));
  print_string "> "

let display_harbor_collect_tuna_rolled_fun_msg_3 tc = 
  ANSITerminal.(print_string [tc](
      " Please input \"r\" or \"R\" to roll the die/dice.\n"
    ));
  print_string "> "
(** [harbor_collect_tune_rolled_fun c t p] is a state where player [p]'s
    card [c]'s harbor_collect_tuna_rolled effect has been applied in state [t].
    Displays apprpriate messages *)
let harbor_collect_tuna_rolled_fun (card:Establishment.card) st player = 
  let tc = turn_color st (get_current_player_id st) in
  let _ = display_harbor_collect_tuna_rolled_fun_msg_1 tc card st in 
  let current_player = get_current_player st in

  let rec await_R ()=
    match clean (read_line ()) with
    | "r" -> let current_player' = Player.roll current_player in 
      (*maybe error here?*)
      let roll_num = Player.calc_roll current_player' in 
      let _ = display_harbor_collect_tuna_rolled_fun_msg_2 tc (roll_num) in
      roll_num
    | "quit" -> exit 0
    | _ -> display_harbor_collect_tuna_rolled_fun_msg_3 tc; await_R ()
  in 

  let dice_roll = await_R () in 

  let rec tuna_boat_multiplier new_lst old_lst cb' dr= 
    match old_lst with
    | [] -> (new_lst,cb')
    | h::t -> if List.mem "Harbor" (Landmark.landmark_card_list_to_str_list 
                                      (h.landmarks))
      then  let amt = ((num_of_cards_with_same_name h (clean card.name)) * dr) 
        in tuna_boat_multiplier (Player.add_cash h amt::new_lst) t (cb'-amt) dr
      else tuna_boat_multiplier (h::new_lst) t (cb') dr
  in 
  let (updated_p_lst,cb) = tuna_boat_multiplier [] st.players 0 dice_roll in
  {
    players = updated_p_lst;
    bank = st.bank + cb;
    available_cards = st.available_cards;
    current_player = st.current_player;
    landmark_cards = st.landmark_cards
  }
(** [flower_collect_fun c t p] is a state where player [p]'s card [c]'s
    flower_collect effect has been applied in state [t]. Displays
    apprpriate messages *)
let flower_collect_fun card st player = 
  let cb = Player.num_of_cards_with_same_name player "Flower Orchard" in
  let updated_player = Player.add_cash player cb in 
  {
    players = replace_player updated_player st.players;
    bank = st.bank - cb;
    available_cards = st.available_cards;
    current_player = st.current_player;
    landmark_cards = st.landmark_cards
  }
(** [harbor_take_fun c t p] is a state where player [p]'s card [c]'s
    harbor_take effect has been applied in state [t]. Displays
    apprpriate messages *)
let harbor_take_fun (card:Establishment.card) st player =
  if List.mem "Harbor" (Landmark.landmark_card_list_to_str_list 
                          (player.landmarks)) 
  then take_fun card st player
  else st
(** tax_fun c t p] is a state where player [p]'s card [c]'s
    tax effect has been applied in state [t]. Displays
    apprpriate messages *)
let tax_fun (card:Establishment.card) st player = 
  let rec tax_each (new_lst:Player.t list) (old_lst:Player.t list) total=
    match old_lst with
    | [] -> Player.add_cash player total ::new_lst
    | h::t -> if clean (h.id) = clean (player.id) 
      then tax_each new_lst t total
      else let tax_fifty_percent = h.cash/2 in  
        tax_each ((Player.add_cash h (-tax_fifty_percent))::new_lst) t 
          (total+tax_fifty_percent) in
  let updated_player_list= (tax_each [] st.players 0) in 
  replace_player_list (updated_player_list) st
(** [active_card_effect c r t p] is a state where player [p]'s card [c]'s
    effect effect has been applied in state [t] according to roll [r]. Displays
    apprpriate messages *)
let activate_card_effect (card: Establishment.card) roll_num st player_id: t= 
  let player = id_to_Player st player_id in
  if List.mem roll_num card.activation_numbers then 
    (*let tc = turn_color st player_id in 
      let _ = display_activate_card_effect_msg_1 card roll_num player tc in*) 
    match card.effect.effect_type with
    | Collect -> 
      collect_fun card st player
    | CollectGear -> collect_card_type_fun 
                       card st player Establishment.Gear
    | CollectCow -> collect_card_type_fun 
                      card st player Establishment.Cow
    | CollectWheat -> collect_card_type_fun 
                        card st player Establishment.Wheat
    | Take -> take_fun card st player
    | TakeRolled -> take_rolled_fun card st player
    | TakeAll-> take_all_fun card st player
    | Trade -> trade_fun card st player
    | HarborCollect -> harbor_collect_fun card st player
    | HarborCollectTunaRolled -> harbor_collect_tuna_rolled_fun card st player
    | FlowerCollect -> flower_collect_fun card st player
    | CollectCup -> collect_card_type_fun 
                      card st player Establishment.Cup
    | HarborTake -> harbor_take_fun card st player
    | CollectCupBread -> let temp_st = collect_card_type_fun 
                             card st player Establishment.Bread in 
      collect_card_type_fun 
        card temp_st player Establishment.Cup 
    | Tax -> tax_fun card st player
  else st
(** [activate_industry_effects p t i] is a state where player [p]'s industries
    [i] effects have been applied in state [t]. Displays
    apprpriate messages *)
let activate_industry_effects (traversing_player:Player.t) (st:t) 
    (industries:Establishment.industry list): t = 
  let current_player = get_current_player st (*the player whose turn it is*) in 
  let roll_num =  Player.calc_roll current_player  in
  let matching_industry_cards =
    Player.get_lst_of_matching_industry_cards traversing_player industries in
  let rec activate_individual_effects (card_lst:Establishment.card list)
      (st':t): t = 
    match card_lst with 
    | [] -> st'
    | h::t -> 
      let is_t_eq_c = 
        (* Is the traversing player the person whose turn it is *)
        current_player.id = traversing_player.id in
      match  h.effect.activation_time with 
      | AnyonesTurn ->
        let updated_state = 
          activate_card_effect h roll_num st' traversing_player.id in
        activate_individual_effects t updated_state 
      | PlayersTurn ->  
        if is_t_eq_c
        then
          let updated_state = 
            activate_card_effect h roll_num st' traversing_player.id in
          activate_individual_effects t updated_state 
        else 
          activate_individual_effects t st'
      | OthersTurn ->  
        if not is_t_eq_c
        then  
          let updated_state = 
            activate_card_effect h roll_num st' traversing_player.id in
          activate_individual_effects t updated_state 
        else 
          activate_individual_effects t st'
  in
  activate_individual_effects matching_industry_cards st

let display_activate_effects_msg_1 st updated_player_id = 
  let updated_player = id_to_Player st updated_player_id in
  ANSITerminal.(print_string [turn_color st updated_player_id] (
      " " ^ updated_player.id 
      ^" now has " 
      ^ (string_of_int updated_player.cash) 
      ^ " coins.\n"))

let display_activate_effects_msg_2 () = 
  ANSITerminal.(print_string [white;Bold] (
      "Activating all restaurant effects.\n"
    ))
let display_activate_effects_msg_3 () = 
  ANSITerminal.(print_string [white;Bold] (
      "Activating all primary/secondary effects.\n"
    ))
let display_activate_effects_msg_4 () = 
  ANSITerminal.(print_string [white;Bold] (
      "Activating all major effects.\n"
    ))

let activate_effects (st:t): t =  
  let sorted_players = 
    set_i_to_beginning 
      (st.current_player) 
      (List.sort sort_players_helper st.players)  in
  let rec restaurant_effects st' player_lst: t= 
    match player_lst with
    | [] -> st'
    | h::t -> 
      let updated_state = activate_industry_effects h st'
          [Establishment.Restaurant] in 
      let _ = display_activate_effects_msg_1 updated_state h.id in 
      restaurant_effects updated_state t in
  let rec primary_and_secondary_effects st' player_lst: t= 
    match player_lst with
    | [] -> st'
    | h::t -> 
      let updated_state = activate_industry_effects h st'
          [Establishment.Primary; Establishment.Secondary] in 
      let _ = display_activate_effects_msg_1 updated_state h.id in 
      primary_and_secondary_effects updated_state t in 
  let rec major_effects st' player_lst: t= 
    match player_lst with
    | [] -> st'
    | h::t ->  
      let updated_state = activate_industry_effects h st'
          [Establishment.Major] in 
      let _ = display_activate_effects_msg_1 updated_state h.id in 
      major_effects updated_state t in
  let _ = display_activate_effects_msg_2 () in
  let temp_st' = restaurant_effects st sorted_players in 
  let _ = display_activate_effects_msg_3 () in 
  let temp_st'' = primary_and_secondary_effects temp_st' sorted_players in 
  let _ = display_activate_effects_msg_4 () in
  major_effects temp_st'' sorted_players

(** [train_station_roll_2 player] is true if the player owns a landmark
    with the DoubleRoll effect, otherwise false *)
let train_station_roll_2 (player:Player.t) =
  let landmarks = player.landmarks in
  let rec doubleroll_extract = function 
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | DoubleRoll -> true
      | _ -> doubleroll_extract t in
  doubleroll_extract landmarks

(** [reroll player] is true if the player owns a landmark
    with the Reroll effect, otherwise false *)
let reroll player = 
  let landmarks = player.landmarks in
  let rec reroll_extract = function 
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | Reroll -> true
      | _ -> reroll_extract t in
  reroll_extract landmarks

(** [take_other_turn player] is true if the player owns a landmark
    with the DoublesTurn effect, and the player rolled doubles, 
    otherwise false*)
let take_other_turn player = 
  let landmarks = player.landmarks in
  let doubles = function
    | [] -> false
    | h::t -> if List.mem h t then true else false in 
  let rec doubleturn_extract = function 
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | DoublesTurn -> true
      | _ -> doubleturn_extract t in
  doubleturn_extract landmarks && (doubles (player.dice_rolls))

(** [cityhall_collect player] is true if the conditions are valid for
    the CityHall effect to activate *)
let cityhall_collect player = 
  let landmarks = player.landmarks in
  let rec extract = function 
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | CityHall -> true
      | _ -> extract t in
  extract landmarks && (player.cash = 0)

(** [add_2_to_roll player] is true if the conditions are valid for the
    AddToDie effect to activate *)
let add_2_to_roll player = 
  let landmarks = player.landmarks in
  let rec extract = function 
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | AddToDie -> true
      | _ -> extract t in
  extract landmarks

(** [add2_to_dice player] is [player], but with each of [player]'s dice
    rolls increased by 2 *)
let add2_to_dice player = 
  let add2 = function
    | [] -> []
    | h::t -> (h+2)::t in
  {
    id = player.id;
    num_dice = player.num_dice;
    dice_rolls = add2 player.dice_rolls;
    cash = player.cash;
    assets = player.assets;
    landmarks = player.landmarks;
    order = player.order
  }

(** [buildortake player] is true if the conditions are valid for the
    BuildOrTake effect to activate *)
let buildortake player = 
  let landmarks = player.landmarks in
  let rec extract = function 
    | [] -> false
    | h::t -> match h.effect.effect_type with
      | BuildOrTake -> true
      | _ -> extract t in
  extract landmarks

(** [withdraw_bank st amt] is state [st], but with integer [amt] subtracted
    from the bank *)
let withdraw_bank st amt = 
  {
    players = st.players;
    bank = st.bank - amt;
    available_cards = st.available_cards;
    current_player = st.current_player;
    landmark_cards = st.landmark_cards
  }

let to_string state = 
  let rec players acc = function
    | [] -> acc
    | h::t -> players (((Player.to_string h)^"\n")^acc) t in
  let rec cardsEst acc = function
    | [] -> acc
    | h::t -> cardsEst (((Establishment.card_to_string h)^"\n")^acc) t in
  let rec cardsLand acc = function
    | [] -> acc
    | h::t -> cardsLand (((Landmark.card_to_string h)^"\n")^acc) t in
  "Players: " ^ players "" state.players ^
  "Bank: " ^ string_of_int (state.bank) ^
  "Available cards: " ^ cardsEst "" state.available_cards ^
  "Landmark Cards: " ^ cardsLand "" state.landmark_cards ^
  "Current Player: " ^string_of_int state.current_player


