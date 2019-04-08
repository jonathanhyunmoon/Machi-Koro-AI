open OUnit2

(** [print_all_cards cardlist] calls card_to_string on all of the cards in 
    [cardlist], and then prints the result *)
let rec print_all_cards cardlist =
  match cardlist with
  | [] -> ()
  | h :: t -> print_endline(Establishment.card_to_string h);
    print_all_cards t

(* _________________Establishment.card cards for testing__________________ *)

let wheat_field : Establishment.card 
  = {
    name = "Wheat Field"; 
    industry = Primary;
    card_type = Wheat; 
    construction_cost = 1;
    activation_numbers = [1];
    effect = {
      activation_time = AnyonesTurn;
      value = 1;
      effect_type = Collect
    }
  }
let ranch : Establishment.card 
  = {
    name = "Ranch"; 
    industry = Primary;
    card_type = Cow; 
    construction_cost = 1;
    activation_numbers = [2];
    effect = {
      activation_time = AnyonesTurn;
      value = 1;
      effect_type = Collect
    }
  }
let forest : Establishment.card 
  = {
    name = "Forest"; 
    industry = Primary;
    card_type = Gear; 
    construction_cost = 3;
    activation_numbers = [5];
    effect = {
      activation_time = AnyonesTurn;
      value = 1;
      effect_type = Collect
    }
  }
let mine : Establishment.card 
  = {
    name = "Mine";
    industry = Primary;
    card_type = Gear;
    construction_cost = 6;
    activation_numbers = [9];
    effect = {
      activation_time = AnyonesTurn;
      value = 5;
      effect_type = Collect
    }
  }
let apple_orchard : Establishment.card 
  = {
    name = "Apple Orchard";
    industry = Primary;
    card_type = Wheat;
    construction_cost = 3;
    activation_numbers = [10];
    effect = {
      activation_time = AnyonesTurn;
      value = 3;
      effect_type = Collect
    }
  }

(* secondary industry cards *)
let bakery : Establishment.card 
  = {
    name = "Bakery";
    industry = Secondary;
    card_type = Bread;
    construction_cost = 1;
    activation_numbers = [2;3];
    effect = {
      activation_time = PlayersTurn;
      value = 1;
      effect_type = Collect
    }
  }
let convenience_store : Establishment.card 
  = {
    name = "Convenience Store";
    industry = Secondary;
    card_type = Bread;
    construction_cost = 2;
    activation_numbers = [4];
    effect = {
      activation_time = PlayersTurn;
      value = 3;
      effect_type = Collect
    }
  }
let cheese_factory : Establishment.card 
  = {name = "Cheese Factory";
     industry = Secondary;
     card_type = Factory;
     construction_cost = 5;
     activation_numbers = [7];
     effect = {
       activation_time = PlayersTurn;
       value = 3;
       effect_type = CollectCow
     }
    }
let furniture_factory : Establishment.card 
  = {
    name = "Furniture Factory";
    industry = Secondary;
    card_type = Factory;
    construction_cost = 3;
    activation_numbers = [8];
    effect = {
      activation_time = PlayersTurn;
      value = 3;
      effect_type = CollectGear
    }
  }
let fruit_veg_market : Establishment.card 
  = {
    name = "Fruit and Vegetable Market";
    industry = Secondary;
    card_type = Fruit;
    construction_cost = 2;
    activation_numbers = [11;12];
    effect = {
      activation_time = PlayersTurn;
      value = 2;
      effect_type = CollectWheat
    }
  }

(* restaurant cards *)
let cafe : Establishment.card 
  = {
    name = "Cafe";
    industry = Restaurant;
    card_type = Cup;
    construction_cost = 2;
    activation_numbers = [3];
    effect = {
      activation_time = OthersTurn;
      value = 1;
      effect_type = TakeRolled
    }
  }
let family_restaurant : Establishment.card 
  = {
    name = "Family Restaurant";
    industry = Restaurant;
    card_type = Cup;
    construction_cost = 3;
    activation_numbers = [9;10];
    effect = {
      activation_time = OthersTurn;
      value = 2;
      effect_type = TakeRolled
    }
  }

(* major establishments *)
let stadium : Establishment.card 
  = {
    name = "Stadium";
    industry = Major;
    card_type = Major;
    construction_cost = 6;
    activation_numbers = [6];
    effect = {
      activation_time = PlayersTurn;
      value = 2;
      effect_type = TakeAll
    }
  }
let tv_station : Establishment.card 
  = {
    name = "TV Station";
    industry = Major;
    card_type= Major;
    construction_cost = 7;
    activation_numbers = [6];
    effect = {
      activation_time = PlayersTurn;
      value = 5;
      effect_type = Take
    }
  }
let business_center : Establishment.card 
  = {
    name = "Business Center";
    industry = Major;
    card_type = Major;
    construction_cost = 8;
    activation_numbers = [6];
    effect = {
      activation_time = PlayersTurn;
      value = 0;
      effect_type = Trade
    }
  }

(* _________________Landmark.card cards for testing__________________ *)

let train_station : Landmark.card = {
  name = "Train Station";
  industry = Landmark;
  card_type = Major;
  construction_cost = 4;
  effect = {
    value = 1;
    effect_type = DoubleRoll
  };
  face = Down
}

let shopping_mall : Landmark.card = {
  name = "Shopping Mall";
  industry = Landmark;
  card_type = Major;
  construction_cost = 10;
  effect = {
    value = 1;
    effect_type = MallCollect
  };
  face = Down
}

let amusement_park : Landmark.card = {
  name = "Amusement Park";
  industry = Landmark;
  card_type = Major;
  construction_cost = 16;
  effect = {
    value = 1;
    effect_type = DoublesTurn
  };
  face = Down
}

let radio_tower : Landmark.card = {
  name = "Radio Tower";
  industry = Landmark;
  card_type = Major;
  construction_cost = 22;
  effect = {
    value = 1;
    effect_type = Reroll
  };
  face = Down
}

(*______________________ PARSED JSONS FOR TESTING __________________________*)



(** _____THIS FUNCTION IS TAKEN FROM THE test.ml OF ASSIGNMENT 2_________
    [cmp_set_like_lists lst1 lst2] compares two lists to see whether
    they are equivalent set-like lists.  That means checking two things.
    First, they must both be {i set-like}, meaning that they do not
    contain any duplicates.  Second, they must contain the same elements,
    though not necessarily in the same order. *)
let cmp_set_like_lists lst1 lst2 =
  let uniq1 = List.sort_uniq compare lst1 in
  let uniq2 = List.sort_uniq compare lst2 in
  List.length lst1 = List.length uniq1
  &&
  List.length lst2 = List.length uniq2
  &&
  uniq1 = uniq2

(* [cmp_different_order lst1 lst2] is whether the contents of two lists
   are the same, even if their order is different. Duplicate elements are 
   counted multiple times, so two lists will not be considered the same,
   if the number of copies of a particular element is different.
    Works for any kind of list, even ones with elements that don't have a 
    compare function *)
let cmp_different_order lst1 lst2 =
  (* [search item lst2 acc] gives an option that indicates whether the
     given [item] is inside of the list [lst2]. If it's not then it returns
     [None]. If it is, then it returns [Some lst], where [lst] is [lst2]
     without the [item] being searched.*)
  let rec search item lst2 acc = 
    match lst2 with
    | [] -> None
    | h::t -> if item = h then Some (acc@t)
      else search item t (h::acc) in
  let rec cmp_different_order_helper lst1 lst2 =
    (* checks if both lists are empty - and if so, returns true *)
    match lst1 with
    | [] -> if (lst2 = []) then true
      else false
    | h::t -> match (search h lst2 []) with
      | None -> false
      | Some lst -> cmp_different_order_helper t lst in
  cmp_different_order_helper lst1 lst2


let cmp_establishments (est1:Establishment.card) (est2:Establishment.card) =
  est1.name = est2.name
  && est1.industry = est2.industry
  && est1.card_type = est2.card_type
  && est1.construction_cost = est2.construction_cost
  && cmp_set_like_lists est1.activation_numbers est2.activation_numbers
  && est1.effect = est2.effect

let cmp_landmarks (lmk1:Landmark.card) (lmk2:Landmark.card) =
  lmk1.name = lmk2.name
  && lmk1.industry = lmk2.industry
  && lmk1.card_type = lmk2.card_type
  && lmk1.construction_cost = lmk2.construction_cost
  && lmk1.effect = lmk2.effect
  && lmk1.face = lmk2.face

(* [cmp_different_order_establishments lst1 lst2] is whether the contents of 
   two lists of establishments are the same, even if their order is different.  
   Duplicate elements are counted multiple times, so two lists will not be 
   considered the same, if the number of copies of a particular element is 
   different. Uses the custom compare function for establishments. *)
let cmp_different_order_establishments lst1 lst2 =
  (* [search item lst2 acc] gives an option that indicates whether the
     given [item] is inside of the list [lst2]. If it's not then it returns
     [None]. If it is, then it returns [Some lst], where [lst] is [lst2]
     without the [item] being searched.*)
  let rec search item lst2 acc = 
    match lst2 with
    | [] -> None
    | h::t -> if (cmp_establishments) item h then Some (acc@t)
      else search item t (h::acc) in
  let rec cmp_different_order_establishments_helper lst1 lst2 =
    (* checks if both lists are empty - and if so, returns true *)
    match lst1 with
    | [] -> if (lst2 = []) then true
      else false
    | h::t -> match (search h lst2 []) with
      | None -> false
      | Some lst -> cmp_different_order_establishments_helper t lst in
  cmp_different_order_establishments_helper lst1 lst2

let cmp_different_order_custom lst1 lst2 cmp =
  (* [search item lst2 acc] gives an option that indicates whether the
     given [item] is inside of the list [lst2]. If it's not then it returns
     [None]. If it is, then it returns [Some lst], where [lst] is [lst2]
     without the [item] being searched.*)
  let rec search item lst2 acc =
    match lst2 with
    | [] -> None
    | h::t -> if cmp item h then Some (acc@t)
      else search item t (h::acc) in
  let rec cmp_different_order_custom_helper lst1 lst2 =
    (* checks if both lists are empty - and if so, returns true *)
    match lst1 with
    | [] -> if (lst2 = []) then true
      else false
    | h::t -> match (search h lst2 []) with
      | None -> false
      | Some lst -> cmp_different_order_custom_helper t lst in
  cmp_different_order_custom_helper lst1 lst2

let cmp_players (player1:Player.t) (player2:Player.t) =
  player1.id = player2.id
  && player1.num_dice = player2.num_dice
  && cmp_different_order_custom player1.dice_rolls player2.dice_rolls (=)
  && player1.cash = player2.cash
  && cmp_different_order_custom player1.assets player2.assets 
    cmp_establishments
  && cmp_different_order_custom player1.landmarks player2.landmarks
    cmp_landmarks
  && player1.order = player2.order

let cmp_states (state1:State.t) (state2:State.t) = 
  cmp_different_order_custom state1.players state2.players cmp_players
  && state1.bank = state2.bank
  && cmp_different_order_custom state1.available_cards state2.available_cards
    cmp_establishments
  && state1.current_player = state2.current_player
  && cmp_different_order_custom state1.landmark_cards state2.landmark_cards
    cmp_landmarks


(* [string_of_int_list list] returns a string that represents an integer
   list. Used for debugging failed test cases. *)
let string_of_int_list list =
  String.concat " " (List.map string_of_int list)

(* [string_of_string_list list] returns a string that represents an string
   list. Used for debugging failed test cases. Basically repackages 
   String.concat in a format that works better with OUnit printing*)
let string_of_string_list list =
  String.concat " " list

(* [count_elements] is the number of times an element appears in a list, plus
   the counter. Generally, [counter] is initialized to 0. *)
let rec count_elements element list 
    (counter:int)
  = match list with
  | [] -> counter
  | h::t -> if h = element
    then count_elements element t (counter + 1) 
    else count_elements element t counter

(* [count_cards] is the number of times a card appears in a list, plus
   the counter. Generally, [counter] is initialized to 0. Uses the custom
   equality function [cmp_establishments] for establishment cards *)
let rec count_cards element list 
    (counter:int)
  = match list with
  | [] -> counter
  | h::t -> if (cmp_establishments h element)
    then count_cards element t (counter + 1) 
    else count_cards element t counter




(* ____________________tests for the Basiccards module____________________ *)
let basic_card_tests = [ 
  (* testing that initial_deck is correct *)
  "initial_deck size" >:: (fun _ -> 
      assert_equal 84
        (List.length Basiccards.initial_deck));
  "initial_deck contents" >:: 
  (fun _ -> assert_equal true
      (List.mem (forest) (Basiccards.initial_deck)));
  "initial_deck contents 2" >:: 
  (fun _ -> assert_equal true
      (List.mem (mine) (Basiccards.initial_deck)));
  (* testing that the number of each card is the deck is correct *)
  "initial_deck contents 3" >:: 
  (fun _ -> assert_equal 6
      (count_cards (mine) (Basiccards.initial_deck) 0));
  "initial_deck contents 4" >:: 
  (fun _ ->  assert_equal ~printer:string_of_int 6
      (count_cards (bakery) (Basiccards.initial_deck) 0));
  "initial_deck contents 5" >:: 
  (fun _ -> assert_equal 4
      (count_cards (stadium) (Basiccards.initial_deck) 0));
  "initial_deck contents 6" >:: 
  (fun _ -> assert_equal 6
      (count_cards (furniture_factory) (Basiccards.initial_deck) 0));
  "initial_deck contents 7" >:: 
  (fun _ -> assert_equal 6
      (count_cards (forest) (Basiccards.initial_deck) 0));
  (* tests that all cards are present in the initial deck *)
  "initial_deck contents all" >::
  (fun _ -> assert_equal ~cmp:cmp_different_order_establishments 
      [wheat_field;ranch;forest;mine;apple_orchard;bakery;convenience_store;
       cheese_factory;furniture_factory;fruit_veg_market;cafe;family_restaurant;
       stadium;tv_station;business_center] 
      (List.sort_uniq compare Basiccards.initial_deck)
  );
  "test sort_uniq" >:: 
  (fun _ -> assert_equal ~printer:string_of_int
      15 (List.length (List.sort_uniq compare Basiccards.initial_deck)));

  (* testing that initial_deck_landmarks is correct *)
  "initial_leck_landmark size" >:: 
  (fun _ -> assert_equal 4 
      (List.length (Basiccards.initial_deck_landmarks)));
  "initial_leck_landmark contents" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order
      [train_station;amusement_park;radio_tower;shopping_mall]
      (Basiccards.initial_deck_landmarks));

  (* testing that initial_deck_setlike works as intended *)
  "initial_deck setlike size" >:: (fun _ -> 
      assert_equal 15
        (List.length (Basiccards.initial_deck_setlike
                        Basiccards.initial_deck)));
  "initial_deck_setlike contents" >:: 
  (fun _ -> assert_equal 1
      (count_elements (mine) 
         (Basiccards.initial_deck_setlike Basiccards.initial_deck) 0));
  "initial_deck_setlike contents 2" >:: 
  (fun _ -> assert_equal 1
      (count_elements (stadium) 
         (Basiccards.initial_deck_setlike Basiccards.initial_deck) 0));

  (* testing that set_of_names_of_all_cards is correct *)
  "set_of_names_of_all_cards test" >:: 
  (fun _ -> assert_equal ~printer:string_of_string_list
      ~cmp:cmp_different_order (Basiccards.set_of_names_of_all_cards
                                  Basiccards.initial_deck)
      ["wheat field"; "ranch"; "forest"; "mine"; "apple orchard"; "bakery";
       "convenience store"; "cheese factory"; "furniture factory"; 
       "fruit and vegetable market"; "cafe"; "family restaurant"; "stadium";
       "tv station"; "business center"]);

  (* testing that string_to_est works *)
  "string_to_est test" >:: (fun _ -> 
      assert_equal (Basiccards.string_to_est "cheese factory"
                      Basiccards.initial_deck)
        (cheese_factory));
  "string_to_est test 2" >:: (fun _ -> 
      assert_equal (Basiccards.string_to_est "business center"
                      Basiccards.initial_deck)
        (business_center));
  "string_to_est test 3" >:: (fun _ -> 
      assert_equal (Basiccards.string_to_est "stadium"
                      Basiccards.initial_deck)
        (stadium));
  "string_to_est test 4" >:: 
  (fun _ -> assert_raises 
      (Basiccards.InvalidEstCard " is not a valid establishment card") 
      (fun () -> (Basiccards.string_to_est "invalid" 
                    Basiccards.initial_deck))
  )
]




(*____________________tests for Establishment module___________________ *)


let establishment_tests = [
  (* testing that card_list_to_string works *)
  "card_list_to_string test" >:: (fun _ -> 
      assert_equal ~cmp:cmp_set_like_lists (Establishment.card_list_to_string 
                                              (Basiccards.initial_deck_setlike
                                                 Basiccards.initial_deck))
        ["wheat field"; "ranch"; "forest"; "mine"; "apple orchard"; "bakery";
         "convenience store"; "cheese factory"; "furniture factory"; 
         "fruit and vegetable market"; "cafe"; "family restaurant"; "stadium";
         "tv station"; "business center"]);
  (* testing for non-set like lists *)
  "card_list_to_string test 2" >:: (fun _ -> 
      assert_equal 84 (List.length (Establishment.card_list_to_string
                                      Basiccards.initial_deck)));
  "card_list_to_string test 3" >:: (fun _ -> 
      assert_equal 4 (count_elements "tv station" 
                        (Establishment.card_list_to_string
                           Basiccards.initial_deck) 0));
  "card_list_to_string test 4" >:: (fun _ -> 
      assert_equal 6 (count_elements "furniture factory" 
                        (Establishment.card_list_to_string
                           Basiccards.initial_deck) 0))
]



(*_______________________tests for other modules___________________________ *)


(* the following two functions are exactly the same as functions that are
   called in state.ml and player.ml to create an initial state, only modified
   so that each player starts with 500 coins to facilitate testing *)
(* same as create_players in Player.ml, but sets minimum cash to be
   much higher, for testing purposes *)
let create_players_lots_of_money n : Player.t list = 
  let rec helper n (acc:Player.t list) = 
    if n = 0 then acc else
      helper (n-1) ({
          id = "Player " ^ (string_of_int n);
          num_dice = 1;
          dice_rolls = [-1];
          cash = 500;
          assets = Basiccards.initial_player_deck;
          landmarks = [];
          order = n-1
        }::acc) in
  helper n []

let init_state_lots_of_money n landmarks establishments : State.t= 
  if n = 2 then {
    players = create_players_lots_of_money n;
    bank = 282;
    available_cards = (Basiccards.initial_deck)@establishments;
    current_player = 0;
    landmark_cards = (Basiccards.initial_deck_landmarks)@landmarks
  }
  else if n = 3 then {
    players = create_players_lots_of_money n;
    bank = 282;
    available_cards = (Basiccards.initial_deck)@establishments;
    current_player = 0;
    landmark_cards = (Basiccards.initial_deck_landmarks)@landmarks
  }
  else if n = 4 then {
    players = create_players_lots_of_money n;
    bank = 282;
    available_cards = (Basiccards.initial_deck)@establishments;
    current_player = 0;
    landmark_cards = (Basiccards.initial_deck_landmarks)@landmarks
  }
  else raise (State.InvalidNumberofPlayers (n))


let initial_state = State.init_state 4 [] []

let initial_test_state = init_state_lots_of_money 4 [] []

let get_cash_list (playerlist:Player.t list) =
  let rec get_cash_list_helper (playerlist:Player.t list) acc =
    match playerlist with
    | [] -> acc
    | h::t -> get_cash_list_helper t ((h.cash)::acc) in
  get_cash_list_helper playerlist []

(* here, p1 has 4 bakeries *)
let p1_has_4_bakeries = 
  State.purchase_establishment
    (State.purchase_establishment
       (State.purchase_establishment initial_test_state "Player 1" 
          bakery) "Player 1" bakery) "Player 1" bakery

let p3_has_4_wheat_fields = 
  State.purchase_establishment
    (State.purchase_establishment
       (State.purchase_establishment initial_test_state "Player 3" 
          wheat_field) "Player 3" wheat_field) "Player 3" wheat_field


let other_tests = [
  (* these are the tests for player.ml____________________________________ *)
  (* Testing create_players *)
  "create_players test" >:: (fun _ -> 
      assert_equal 2
        (List.length (Player.create_players 2)));
  "create_players test 2" >:: (fun _ -> 
      assert_equal 4
        (List.length (Player.create_players 4)));

  (* the following tests also test create_players, along with other 
     functions *)
  "get cash test" >:: (fun _ ->
      assert_equal ~printer:string_of_int_list [3;3;3;3]
        (get_cash_list (Player.create_players 4)));
  (* tests that each player has the right number of cards
     "get player card test" >:: (fun _ ->
      assert_equal [2;2;2]
        (List.map (List.length)
           (List.map (Player.cash) (Player.create_players 3)))); *)

  (* the other functions in Player aren't used in the game at the moment,
     so they're ignored for now *)

  (* testing functions for State module___________________________________ *)

  "init_state test" >:: (fun _ -> assert_equal "Player 1"
                            (State.get_current_player_id 
                               (State.init_state 3 [] [])));

  "init_state test 2" >:: (fun _ -> assert_equal "Player 1"
                              (State.get_current_player_id 
                                 (State.init_state 2 [] [])));

  "init_state test 3" >:: (fun _ -> assert_equal "Player 1"
                              (State.get_current_player_id 
                                 initial_state));

  (* tests that next_state, get_current_player_id, and 
     order_to_id works correctly *)
  "next_state test" >:: (fun _ -> assert_equal "Player 2"
                            (State.get_current_player_id 
                               (State.next_state initial_state)));

  "next_state test 2" >:: (fun _ -> assert_equal "Player 3"
                              (State.get_current_player_id 
                                 (initial_state 
                                  |> (State.next_state) 
                                  |> (State.next_state))));

  "next_state test 3" >:: (fun _ -> assert_equal "Player 4"
                              (State.get_current_player_id 
                                 (initial_state 
                                  |> (State.next_state) 
                                  |> (State.next_state)
                                  |> (State.next_state))));

  "next_state test wraparound" >:: (fun _ -> assert_equal "Player 1"
                                       (State.get_current_player_id 
                                          (initial_state 
                                           |> (State.next_state) 
                                           |> (State.next_state)
                                           |> (State.next_state)
                                           |> (State.next_state))));

  "next_state test multiple wraparound" >:: (fun _ -> assert_equal "Player 1"
                                                (State.get_current_player_id 
                                                   ((State.init_state 2 [] [])
                                                    |> (State.next_state) 
                                                    |> (State.next_state)
                                                    |> (State.next_state)
                                                    |> (State.next_state))));

  (* checks that the various purchase functions add the correct amount
     to the bank*)
  "initial bank amount is correct" >:: 
  (fun _ -> assert_equal (initial_state.bank) 282);

  "bank purchase amount added is correct" >:: 
  (fun _ -> assert_equal 285 
      ((State.purchase_establishment initial_test_state "Player 1"
          furniture_factory).bank));

  "bank purchase amount added is correct" >:: 
  (fun _ -> assert_equal 290 
      ((State.purchase_establishment initial_test_state "Player 3"
          business_center).bank));

  "bank purchase_landmark amount added is correct" >:: 
  (fun _ -> assert_equal 286 
      ((State.purchase_landmark initial_test_state "Player 4"
          "train station").bank));

  "bank purchase_landmark amount added is correct 2" >:: 
  (fun _ -> assert_equal 304 
      ((State.purchase_landmark initial_test_state "Player 2"
          "radio tower").bank));

  "purchase amount subtracted is correct" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order  [497;500;500;500] 
      (get_cash_list (State.purchase_establishment initial_test_state 
                        "Player 1" furniture_factory).players));

  "purchase_landmark amount subtracted is correct" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order [490;500;500;500] 
      (get_cash_list (State.purchase_landmark initial_test_state 
                        "Player 4"
                        "shopping mall").players));

  (* tests one purchase followed by another *)
  "purchase_landmark amount subtracted is correct again" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order [478;490;500;500] 
      (get_cash_list ((
           State.purchase_landmark
             (State.purchase_landmark initial_test_state 
                "Player 4"
                "shopping mall") "Player 3" "radio tower"
         ).players)));

  "p1_has_4_bakeries is correct" >:: 
  (fun _ -> assert_equal 5 
      (List.length (State.get_current_player p1_has_4_bakeries).assets));

  "p1_has_4_bakeries is correct 2" >:: 
  (fun _ -> assert_equal [500;500;500;497] ~cmp:cmp_different_order
      ~printer:string_of_int_list
      (get_cash_list (p1_has_4_bakeries).players))
]



(*________________ the following functions help test effects _______________ *)

(*for testing purposes, generates a dice roll list with either 1 or 2 values,
    depending on the length of the list given*)
let generate_dice_list (values: int list) = 
  let rec generate_dice_list_helper amount values acc = 
    if amount = 0 then acc
    else match values with
      | [] -> failwith "insufficient dice"
      | h :: t -> generate_dice_list_helper (amount - 1) t (h::acc) in
  if List.length values = 1 then values
  else generate_dice_list_helper 2 values []

(** for testing purposes, this function manually sets the roll values of the
    given player to be whatever is contained within value *)
let set_roll_value (playerlist:Player.t list)
    (player_numb:int) (values:int list) : Player.t list =
  let rec set_roll_value_helper (playerlist:Player.t list) (values:int list) 
      (player_numb:int) (acc:Player.t list): Player.t list
    = match playerlist with
    | [] -> failwith "player not in list"
    (* checks if the player matches the given number - if so, then updates
       the player's rolls *)
    | h :: t -> if h.id = ("Player " ^ (string_of_int player_numb)) then
        let edited_player : Player.t = {
          id = h.id;
          num_dice = h.num_dice;
          dice_rolls = (generate_dice_list values);
          cash = h.cash;
          assets = h.assets;
          landmarks = h.landmarks;
          order = h.order;
        } in
        acc@(edited_player::t)
      else set_roll_value_helper t values player_numb (h::acc) in
  set_roll_value_helper playerlist values player_numb []

(* [set_roll_value_using_state state player_numb values] updates the state's 
   roll values using the given player_number (the one to be modified), and 
   the given list of roll values [values]. The player corresponding to the
   given player number's rolls are changed to the first two entries in the
   given list.*)
let set_roll_value_using_state (state:State.t) (player_numb:int) 
    (values:int list) : State.t =
  {
    players = set_roll_value (state.players) player_numb values;
    bank = state.bank;
    available_cards = state.available_cards;
    current_player = state.current_player;
    landmark_cards = state.landmark_cards
  }

(* _________________________states for testing____________________________ *)

let p2s_turn = initial_test_state |> State.next_state

let p3s_turn = p2s_turn |> State.next_state

let p4s_turn = p3s_turn |> State.next_state

let p1_has_1_mine = 
  (State.purchase_establishment initial_test_state "Player 1" 
     mine)

let p1_has_2_mines = 
  State.purchase_establishment 
    (State.purchase_establishment initial_test_state "Player 1" 
       mine) "Player 1" mine

let p2_has_2_mines_as_well =
  State.purchase_establishment 
    (State.purchase_establishment p1_has_2_mines "Player 2" 
       mine) "Player 2" mine

let p2_has_1_family_restaurant =
  State.purchase_establishment initial_test_state "Player 2" family_restaurant

let p2_has_2_family_restaurants =
  State.purchase_establishment p2_has_1_family_restaurant 
    "Player 2" family_restaurant

let p2_has_2_family_restaurants_1_cafe = 
  State.purchase_establishment p2_has_2_family_restaurants
    "Player 2" cafe

let p2_has_2_family_restaurants_2_cafe = 
  State.purchase_establishment p2_has_2_family_restaurants_1_cafe
    "Player 2" cafe

let p3_has_4_wheat_fields_1_fruit_market = 
  State.purchase_establishment p3_has_4_wheat_fields "Player 3" 
    fruit_veg_market

let p3_fruit_market_turn3 = 
  p3_has_4_wheat_fields_1_fruit_market |> State.next_state |> State.next_state

let p1_has_2_mines_2_furniture_factories = State.purchase_establishment
    (State.purchase_establishment p1_has_2_mines "Player 1" furniture_factory)
    "Player 1" furniture_factory

let p1_has_stadium = State.purchase_establishment initial_test_state "Player 1"
    stadium


let effect_tests = [
  (* tests the base case without any effects *)
  "effect test 0" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          [500;500;500;500] 
                          (get_cash_list
                             (initial_test_state.players)));

  "effect collect test 1" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                                  [501;501;501;501] 
                                  (get_cash_list
                                     ((State.activate_effects
                                         (set_roll_value_using_state 
                                            initial_test_state 1 [1])).
                                        players)));

  (* tests if same effect happens when another player rolls 1 *)
  "effect test 2" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          [501;501;501;501] 
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    (p2s_turn) 2 [1])).
                                players)));

  (* tests that player's turn items work correctly *)
  "effect test 3" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [500;500;500;501] 
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    p3s_turn 3 [2])).
                                players)));
  (* test that the effects of collect stack *)
  "effect test 4" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [500;500;501;500]
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    p1_has_4_bakeries 1 [3])).
                                players)));
  (* another test that the effects of collect stack *)
  "effect test 5" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [501;501;501;501]
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    p3_has_4_wheat_fields 1 [1])).
                                players)));

  (* tests that effects that give more than one coin work *)
  "effect test 6" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [500;500;499;500]
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    p1_has_1_mine 1 [4;5])).
                                players)));

  (* tests that anyone's turn effects that give more than one coin work *)
  "effect test 7" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [500;500;499;500]
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    (p1_has_1_mine |>
                                     State.next_state) 2 [4;5])).
                                players)));

  (* test that these same effects stack *)
  "effect test 8" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [500;500;498;500]
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    p1_has_2_mines 1 [4;5])).
                                players)));

  (* test that these same effects stack for multiple players*)
  "effect test 9" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                          ~printer:string_of_int_list
                          [500;498;498;500]
                          (get_cash_list
                             ((State.activate_effects
                                 (set_roll_value_using_state 
                                    p2_has_2_mines_as_well 1 [4;5])).
                                players)));

  (* test that restaurants take coins from other players*)
  "effect test 10" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                           ~printer:string_of_int_list
                           [498;499;500;500]
                           (get_cash_list
                              ((State.activate_effects
                                  (set_roll_value_using_state 
                                     p2_has_1_family_restaurant 1 [4;5])).
                                 players)));

  (* test that restaurants stack *)
  "effect test 11" >:: (fun _ -> assert_equal ~cmp:cmp_different_order 
                           ~printer:string_of_int_list
                           [496;498;500;500]
                           (get_cash_list
                              ((State.activate_effects
                                  (set_roll_value_using_state 
                                     p2_has_2_family_restaurants 1 [4;5])).
                                 players)));

  (* test that cafes work on top of collect*)
  "effect test 12" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order 
      ~printer:string_of_int_list
      [500;493;500;500]
      (get_cash_list ((State.activate_effects
                         (set_roll_value_using_state 
                            p2_has_2_family_restaurants_1_cafe 1 [3])).
                        players)));

  (* test that cafes stack and work on top of collect *)
  "effect test 13" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order 
      ~printer:string_of_int_list
      [499;492;500;500]
      (get_cash_list
         ((State.activate_effects
             (set_roll_value_using_state 
                p2_has_2_family_restaurants_2_cafe 1 [3])).players)));

  (* test that fruit markets work *)
  "effect test 13" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order 
      ~printer:string_of_int_list
      [500;500;495+(4*2);500]
      (get_cash_list
         ((State.activate_effects
             (set_roll_value_using_state 
                p3_fruit_market_turn3 3 [5;6])).players)));

  (* test that fruit markets work *)
  "effect test 14" >:: 
  (fun _ -> assert_equal ~cmp:cmp_different_order 
      ~printer:string_of_int_list
      [500;500;495+(4*2);500]
      (get_cash_list
         ((State.activate_effects
             (set_roll_value_using_state 
                p3_fruit_market_turn3 3 [5;6])).players)));

  (* test that furniture_factories work and stack *)
  "effect test 15" >::  
  (fun _ -> assert_equal ~cmp:cmp_different_order 
      ~printer:string_of_int_list
      [482+(3*2)*2;500;500;500]
      (get_cash_list
         ((State.activate_effects
             (set_roll_value_using_state 
                p1_has_2_mines_2_furniture_factories 1 [4;4])).players)));

  (* test that stadiums (take all effect) work *)
  "effect test 16" >::  
  (fun _ -> assert_equal ~cmp:cmp_different_order 
      ~printer:string_of_int_list
      [494+(2*3);498;498;498]
      (get_cash_list
         ((State.activate_effects
             (set_roll_value_using_state 
                p1_has_stadium 1 [3;3])).players)));     

]




(* ______testing saving/loading files, as well as more effects_____________ *)


let _ = Save_to_json.save_to_file ((set_roll_value_using_state 
                                      p1_has_stadium 1 [3;3]) |> 
                                   Save_to_json.state_to_json) "test_save"

let _ = Save_to_json.save_to_file 
    ((Load_from_json.load_from_file "test_save.json") |> 
     Save_to_json.state_to_json) "test_save_2"

let _ = Save_to_json.save_to_file 
    ((Load_from_json.load_from_file "testing_jsons/harbors.json") |> 
     Save_to_json.state_to_json) "testing_jsons/harbors2"

let harbors = (Load_from_json.load_from_file "testing_jsons/harbors.json")

let harbors2 = (Load_from_json.load_from_file "testing_jsons/harbors2.json")

let loaded_once = (Load_from_json.load_from_file "test_save.json")

let loaded_twice = (Load_from_json.load_from_file "test_save_2.json")

let first_json = (Load_from_json.load_from_file "testing_jsons/first.json")

let first_alternate_json = 
  (Load_from_json.load_from_file "testing_jsons/first.json")

let first_after_effect_json = 
  (Load_from_json.load_from_file "testing_jsons/first_after_effect.json")

let take_cow = 
  (Load_from_json.load_from_file "testing_jsons/take_cow.json")

let take_cow_after_effect = 
  (Load_from_json.load_from_file "testing_jsons/take_cow_after_effect.json")

let take_wheat = 
  (Load_from_json.load_from_file "testing_jsons/take_wheat.json")

let take_wheat_after_effect = 
  (Load_from_json.load_from_file "testing_jsons/take_wheat_after_effect.json")

let tuna_boat =
  (Load_from_json.load_from_file "testing_jsons/tuna_boat.json")

let tuna_boat_after_effect = 
  (Load_from_json.load_from_file "testing_jsons/tuna_boat_after_effect.json")

let cafe = 
  (Load_from_json.load_from_file "testing_jsons/cafe.json")

let cafe_after_effect = 
  (Load_from_json.load_from_file "testing_jsons/cafe_after_effect.json")

let cafe2 = 
  (Load_from_json.load_from_file "testing_jsons/cafe2.json")

let cafe2_after_effect = 
  (Load_from_json.load_from_file "testing_jsons/cafe2_after_effect.json")

let save_tests = [
  "save test saved and loaded once" >:: (
    fun _ -> assert_equal ~cmp:cmp_different_order_establishments
        p1_has_stadium.available_cards loaded_once.available_cards
  );

  "save test saved and loaded twice" >:: (
    fun _ -> assert_equal ~cmp:cmp_different_order_establishments
        loaded_once.available_cards loaded_twice.available_cards
  );

  "save test saved and loaded twice bank" >:: (
    fun _ -> assert_equal
        p1_has_stadium.bank loaded_twice.bank
  );

  "save test saved and loaded twice landmark cards" >:: (
    fun _ -> assert_equal ~cmp:cmp_different_order
        p1_has_stadium.landmark_cards loaded_twice.landmark_cards
  );

  (* tests that saving and loading a state again doesn't change anything,
     even with expansion cards *)
  "harbor expansion save and load" >:: (
    fun _ -> assert_equal ~cmp:cmp_states
        harbors harbors2
  );

  "save test saved and loaded twice current_player" >:: (
    fun _ -> assert_equal p1_has_stadium.current_player
        loaded_twice.current_player
  );

  "collect player's turn only test" >:: (
    fun _ -> assert_equal ~cmp:cmp_different_order
        first_after_effect_json.available_cards 
        (first_json |> State.activate_effects).available_cards
  );

  "collect player's turn only test 2" >:: (
    fun _ -> assert_equal ~cmp:cmp_different_order 
        ~printer:string_of_int_list
        (get_cash_list (first_after_effect_json.players))
        (get_cash_list ((first_json |> State.activate_effects).players))
  );

  "collect player's turn only test 3" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        first_after_effect_json
        (first_json |> State.activate_effects)
  );

  "check that tests work with quantities other than 1" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        first_after_effect_json
        (first_alternate_json |> State.activate_effects)
  );

  (* checking that the take cow effect applies the appropriate multipliers *)
  "check that take cow works" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        take_cow_after_effect
        (take_cow |> State.activate_effects)
  );

  (* checking that the take cow effect applies the appropriate multipliers *)
  "check that take cow works" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        take_cow_after_effect
        (take_cow |> State.activate_effects)
  );

  "check that take wheat works" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        take_wheat_after_effect
        (take_wheat |> State.activate_effects));

  "check that cafes work" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        cafe_after_effect
        (cafe |> State.activate_effects)
  );

  "check that cafes work when the player whose money was taken has less than
   amount needed" >:: (
    fun _ -> assert_equal ~cmp:cmp_states ~printer:State.to_string
        cafe2_after_effect
        (cafe2 |> State.activate_effects)
  )
]




let test_suite =
  "test suite for A5"  >::: List.flatten [
    basic_card_tests; other_tests; effect_tests; save_tests
  ]


let _ = print_all_cards ((State.get_current_player p1_has_4_bakeries).assets)
let _ = run_test_tt_main test_suite
(* let _ = List.map (fun x -> print_string("\n"^x^"\n")) 
    Basiccards.set_of_names_of_all_cards *)