(**Helper functions*)
let clean str = str |> String.trim |> String.lowercase_ascii

(** [get_longest_length_est card_lst] is the length of the establishment card 
    name that is the longest in [card_lst].*)
let get_longest_length_est (card_lst:Establishment.card list) = 
  let rec helper length (lst:Establishment.card list) = 
    match lst with
    | [] -> length
    | h::t -> let length' = String.length h.name in 
      if length' > length then helper length' t else helper length t in 
  helper 0 card_lst

(** [get_longest_length_land card_lst] is the length of the landmark card name
    that is the longest in [card_lst].*)
let get_longest_length_land (card_lst:Landmark.card list) = 
  let rec helper length (lst:Landmark.card list) = 
    match lst with
    | [] -> length
    | h::t -> let length' = String.length h.name in 
      if length' > length then helper length' t else helper length t in 
  helper 0 card_lst

(** [turn_color st] is the appropriate ANSITerminal color depending on the 
    current player. *)
let turn_color (st:State.t): ANSITerminal.style =
  let turn = 
    (st |> State.get_current_player_id |> State.id_to_Player st).order 
  in
  let color_lst = [
    ANSITerminal.yellow; 
    ANSITerminal.cyan; 
    ANSITerminal.blue;
    ANSITerminal.magenta]
  in 
  List.nth color_lst turn

let baseprint str = ANSITerminal.(print_string [white;Bold] str) 
let entryprint color str  = ANSITerminal.(print_string color str) 
(*___________________________________________________________________________*)
let display_main_msg_1 () = 
  baseprint(
    "\n______________________________________________________________________\n"
    ^ "\n"
    ^ "Welcome to ^o^ JER's Mid-Term-inal Project ^o^ of the game Machi Koro.\n"
    ^ "______________________________________________________________________\n"
    ^ "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    ^ "<Start>\n\n"
    ^ "<Load Expansion Pack>\n\n"
    ^ "<Create Custom Deck>\n\n"
    ^ "<Load Save>\n\n"
    ^ "<Instructions>\n\n"
    ^ "<Quit>\n"
  );
  print_string "> "

let display_main_msg_2 () = 
  baseprint (
    "Please input a valid command: \n\n\n"
    ^ "<Start>\n\n"
    ^ "<Load Expansion Pack>\n\n"
    ^ "<Create Custom Deck>\n\n"
    ^ "<Load Save>\n\n"
    ^ "<Instructions>\n\n"
    ^ "<Quit>\n"
  );
  print_string "> "

(*___________________________________________________________________________*)
let display_init_phase_msg () =
  baseprint(
    "\n\n\n\n\n\n\n\n\n"
    ^ "______________________________________________________\n"
    ^ "THE LEGENDARY GAME OF TERMINAL MACHI KORO HAS BEGUN!!!\n"
    ^ "______________________________________________________\n"
    ^ "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    ^ "How many players are playing (2-4)?\n" 
  )

let display_init_EXC_msg_1 (x:int) = 
  entryprint [ANSITerminal.red] (
    string_of_int x
    ^ " is not between 2 and 4. Please choose between 2 and 4.\n"); 
  print_string  "> "

let display_init_EXC_msg_2 () = 
  entryprint [ANSITerminal.red](
    "That is not a number. Please choose a number between 2 and 4.\n"); 
  print_string  "> " 

(*___________________________________________________________________________*)
let display_main_phase_msg_1 (st:State.t) =
  entryprint [turn_color st; Bold] (
    "\n\n"
    ^ State.get_current_player_id st ^ "'s turn!\n"
  )
let display_main_phase_msg_2 (st:State.t) (current_player: Player.player_id) =
  entryprint [turn_color st](
    current_player ^ " ends his/her turn with " 
    ^ string_of_int (
      (State.id_to_Player st current_player).cash)
    ^ " coins and the following assets"
  )
let display_main_phase_msg_3 (st:State.t) (current_player: Player.player_id) =
  let _ = entryprint [turn_color st] 
      ("\n<-----||Inventory||----->") in
  let topline n = 
    let rec topline' n acc =
      if n = 0 then "_" ^ acc  else topline' (n-1) "_" ^ acc in 
    topline' n "_\n" in
  let botline n =
    let rec botline' n acc =
      if n = 0 then  "|" ^ acc else botline' (n-1) "_" ^ acc in
    botline' n "|\n" in

  let name_extractor str = 
    let index_of_colon = String.index str ':' in
    let crude = String.sub str 0 index_of_colon in
    String.trim crude in 

  let count_extractor str = 
    let index_of_fst_colon = String.index str ':' in
    let crude = String.sub str (index_of_fst_colon+1) 
        (String.length str-index_of_fst_colon-1) in 
    crude |> String.trim |> String.lowercase_ascii |> int_of_string in

  let current_player_ests = 
    (State.id_to_Player st current_player).assets in 
  let current_player_lands = 
    (State.id_to_Player st current_player).landmarks in
  let estimated_length_est = 
    get_longest_length_est current_player_ests + 11 in
  let estimated_length_land = 
    get_longest_length_land current_player_lands in

  let rec nc_list_generator string_lst acc =
    match string_lst with 
    | [] -> acc
    | h::t -> nc_list_generator t (
        (name_extractor h, count_extractor h)::acc) in 

  let adjusted_n_est (name:string) : string = 
    let rec helper n updated = 
      if n = 0 then updated else helper (n-1) (updated^" ") in
    let length = get_longest_length_est current_player_ests in 
    helper (length-(String.length name)) name in 

  let adjusted_n_land (name:string) : string = 
    let rec helper n updated = 
      if n = 0 then updated else helper (n-1) (updated^" ") in
    let length = get_longest_length_land current_player_lands in 
    helper (length-(String.length name)) name in 

  let adjusted_c (num): string =
    let rec helper n updated =
      if n = 0 then updated else helper (n-1) (updated ^" ") in 
    let length = 2 in 
    let str_count = string_of_int num in 
    helper (length-(String.length str_count)) str_count in 

  let boxed_est nc_list n= 
    let rec one_row lst= 
      match lst with 
      | [] -> baseprint(botline n)
      | (name,count)::t -> 
        let _ = baseprint "|" in 
        let _ = entryprint [turn_color st] (adjusted_n_est name)  in
        let _ = baseprint "| " in 
        let _ = entryprint [turn_color st] ("Count: " ^ adjusted_c count) in   
        let _ = baseprint "|\n" in 
        one_row t in 
    let _ = baseprint (topline n) in
    one_row nc_list in 

  let boxed_land n_list n= 
    let rec one_row lst= 
      match lst with 
      | [] -> baseprint(botline n)
      | name::t -> 
        let _ = baseprint "|" in 
        let _ = entryprint [turn_color st] (adjusted_n_land name)  in 
        let _ = baseprint "|\n" in 
        one_row t in 
    let _ = baseprint (topline n) in
    one_row n_list in 
  let est_string_lst = 
    Establishment.card_list_to_string_counted current_player_ests in 
  let est_ncc_pairs = 
    nc_list_generator est_string_lst [] in
  let land_string_lst = 
    Landmark.landmark_card_list_to_str_list current_player_lands in 
  let _ = entryprint [turn_color st] ("\n||Establishments||\n") in
  let _ = boxed_est est_ncc_pairs estimated_length_est in 
  let _ = entryprint [turn_color st] ("\n||Landmarks||\n") in 
  if List.length land_string_lst <> 0 
  then
    boxed_land land_string_lst estimated_length_land
  else ()

(*___________________________________________________________________________*)
let display_phase_1_msg_1 (tc:ANSITerminal.style) =
  entryprint [tc; Bold](
    "\nPHASE 1:\n"
  );
  print_string "> "
let display_phase_1_msg_1a (tc:ANSITerminal.style) =
  entryprint [tc] (" Press \"R\" to roll!\n");
  print_string "> "

let display_phase_1_msg_1b (tc:ANSITerminal.style) =
  entryprint [tc] (
    " Double Roll effect from landmark cards has been activated!\n" ^
    "Would you like to roll 1 or 2 die?\n"
  );
  print_string "> "

let display_phase_1_msg_2 (tc:ANSITerminal.style) (roll_num:int) =
  entryprint[tc](
    " You just rolled a " ^ (string_of_int roll_num) ^ "!\n"
  )

let display_phase_1_msg_3 (tc:ANSITerminal.style)  =
  entryprint [tc](
    " Please input \"r\" or \"R\" to roll the die/dice.\n"
  );
  print_string "> "
let display_phase_1_msg_3b (tc:ANSITerminal.style)  =
  entryprint[tc](
    " Please input either 1 or 2.\n"
  );
  print_string "> "

(*___________________________________________________________________________*)
let display_phase_2_msg_1 (tc:ANSITerminal.style)  =
  entryprint [tc; Bold](
    "\nPHASE 2:\n"
  ); 
  entryprint [tc](
    " The effects of your cards are being activated. " ^ 
    "Please wait.\n"
  )

(*___________________________________________________________________________*)
let display_phase_3_msg_1 (tc:ANSITerminal.style)  =
  entryprint [tc; Bold] (
    "\nPHASE 3:\n"
  ); 
  entryprint [tc] (
    " Would you like to purchase an ESTABLISHMENT, purchase a LANDMARK, " ^ 
    "SAVE and quit, " ^
    "or FINISH your turn? For info about the effects of cards, type HELP.\n"
  );
  print_string "> "

let display_phase_3_msg_2 (tc:ANSITerminal.style)  =
  entryprint [tc] (
    " Please input a valid command \"establishment\" or \"landmark\""^
    " or \"help\" or \"save\" or \"finish\".\n"
  );
  print_string "> "

(*___________________________________________________________________________*)
let display_purchase_est_phase_msg_1 (tc:ANSITerminal.style)  =
  entryprint [tc] (
    "\n\n Which establishment would you like to purchase?\n"
    ^ " You can end your turn at any time by inputting FINISH. \n"
  )
let display_purchase_est_phase_EXC_msg_1 (tc:ANSITerminal.style) (input:string) 
    (str:string) =
  entryprint [tc] ("\n" ^ input ^ str ^ "\n");
  print_string  "> " 
let display_purchase_est_phase_EXC_msg_2 (tc:ANSITerminal.style) (input:string) 
    (str:string)=
  entryprint [tc] ("\n Card with name " ^ input ^ str^"\n");
  print_string  "> " 
let display_purchase_est_phase_EXC_msg_3 (tc:ANSITerminal.style) (input:string) 
    (str:string) cards=
  let cc = 
    string_of_int (Basiccards.string_to_est input cards).construction_cost in
  entryprint [tc] (
    "\n You don't have enough money to purchase that!\n"
    ^ " You only have " ^ str ^ " coins. \n "
    ^ input ^ " costs " ^ cc ^ " coins.\n"
  );
  print_string "> " 
let display_purchase_est_phase_EXC_msg_4 (tc:ANSITerminal.style) (input:string) 
    (str:string)=
  entryprint [tc] (
    "\n You already have a copy of that card!"
    ^ "\n Each player can only own at most one copy of each major "
    ^ "establishment.\n");
  print_string "> " 

let build_or_take_msg () = baseprint (
    "Build or Take effect has been activated.\n" ^
    "Since you did not construct anything on this turn,"^
    " you get 10 coins from the bank\n" 
  )

(*_______________________________________________________________________ *)
let display_purchase_landmark_phase_msg_1 (tc:ANSITerminal.style) 
    (state:State.t) =
  let player = State.get_current_player state in
  let _ = entryprint [tc](
      "\n\n What landmark would you like to purchase?\n"
      ^ " You can end your turn at any time by inputting FINISH. \n"
    ) in

  let topline n = 
    let rec topline' n acc =
      if n = 0 then "_" ^ acc  else topline' (n-1) "_" ^ acc in 
    topline' n "_\n" in
  let botline n =
    let rec botline' n acc =
      if n = 0 then  "|"^acc else botline' (n-1) "_" ^ acc in
    botline' n "|\n" in

  let rec npc_list_generator (cards:Landmark.card list) (player:Player.t) acc= 
    match cards with
    | [] -> acc
    | h::t ->
      let color = if player.cash >= h.construction_cost 
        then [ANSITerminal.green; Bold] 
        else [ANSITerminal.red] in
      if not (List.mem h player.landmarks) then       
        npc_list_generator t player ((h.name,h.construction_cost, color)::acc)
      else 
        npc_list_generator t player acc
  in

  let estimated_length =
    get_longest_length_land state.landmark_cards + 12 in 
  let adjusted_n (name:string) : string = 
    let rec helper n updated = 
      if n = 0 then updated else helper (n-1) (updated^" ") in
    let length = get_longest_length_land state.landmark_cards in 
    helper (length-(String.length name)) name in 

  let adjusted_p (price:int): string = 
    let rec helper n updated = 
      if n = 0 then updated else helper (n-1) (updated^" ") in
    let length = 3 in 
    let str_price  = string_of_int price in 
    helper (length-(String.length str_price)) str_price in 

  let boxed npc_list n= 
    let rec one_row lst= 
      match lst with 
      | [] -> baseprint(botline n)
      | (name, price, color)::t -> 
        let _ = baseprint "|" in 
        let _ = entryprint color (adjusted_n name)  in
        let _ = baseprint "| " in 
        let _ = entryprint color ("Price: " ^ adjusted_p price)  in 
        let _ = baseprint "|\n" in 
        one_row t in 
    let _ = baseprint (topline n) in
    one_row npc_list in 
  let name_player_color = npc_list_generator state.landmark_cards player [] in
  boxed name_player_color estimated_length

let display_purchase_landmark_phase_EXC_msg_1 (tc:ANSITerminal.style) 
    (input:string) 
    (str:string)=
  ANSITerminal.(print_string [tc](
      "\n" ^ input ^ str ^ "\n" 
    ));
  print_string  "> " 
let display_purchase_landmark_phase_EXC_msg_2 (tc:ANSITerminal.style) 
    (input:string) 
    (str:string)=
  entryprint [tc] ("\n Card with name " ^ input ^ str^"\n");
  print_string  "> " 
let display_purchase_landmark_phase_EXC_msg_3 (tc:ANSITerminal.style) 
    (input:string) 
    (str:string) 
    (landmarks:Landmark.card list) =
  let rec cc_matcher input (landmarks:Landmark.card list) = 
    match landmarks with
    | [] -> failwith 
              "UNUSUAL ERROR in main.display_purchase_landmark_phase_EXC_msg_3" 
    | h::t -> if clean (input) = clean (h.name) 
      then string_of_int h.construction_cost else
        cc_matcher input t in
  let cc = cc_matcher input landmarks
  in
  entryprint [tc] (
    "\n You don't have enough money to purchase that!\n"
    ^ " You only have " ^ str ^ " coins. \n "
    ^ input ^ " costs " ^ cc ^ " coins.\n"
  );
  print_string "> " 
(* [display_available_establishments] displays the name, price, and 
   availability of each card. *)
let display_available_establishments (st:State.t) : unit = 
  let topline n = 
    let rec topline' n acc =
      if n = 0 then "_" ^ acc  else topline' (n-1) "_" ^ acc in 
    topline' n "_\n" in
  let botline n =
    let rec botline' n acc =
      if n = 0 then  "|" ^ acc else botline' (n-1) "_" ^ acc in
    botline' n "|\n" in

  let available_establishments = 
    Establishment.card_list_to_string_counted_price
      (List.sort Establishment.sort_fun (st.available_cards)) in
  (*Forest : Price : 3 coins : 6 available, *)
  let name_extractor str = 
    let index_of_colon = String.index str ':' in
    let crude = String.sub str 0 index_of_colon in
    String.trim crude in 

  let price_extractor str =
    let index_of_fst_colon = String.index str ':' in
    let index_of_sec_colon= String.index_from str (index_of_fst_colon+1) ':' in
    let index_of_c = String.index_from str (index_of_sec_colon+1) 'c' in 
    let crude = String.sub str (index_of_sec_colon+1) 
        (index_of_c-index_of_sec_colon-2) in 
    crude |> clean |> int_of_string in 

  let availability_extractor str = 
    let index_of_fst_colon = String.index str ':' in
    let index_of_sec_colon = String.index_from str (index_of_fst_colon+1) ':' in 
    let index_of_thd_colon = String.index_from str (index_of_sec_colon+1) ':' in
    let index_of_a = String.index_from str (index_of_thd_colon+1) 'a' in 
    let crude = String.sub str (index_of_thd_colon+1)
        (index_of_a-index_of_thd_colon-2) in 
    crude |> clean |> int_of_string in

  let estimated_length = get_longest_length_est st.available_cards + 30 in

  let determine_tc str=  
    let name_to_cc str = 
      (Establishment.name_to_card str st.available_cards).construction_cost in 
    if str 
       |> name_extractor 
       |> name_to_cc > (State.get_current_player st).cash 
    then [ANSITerminal.red]
    else [ANSITerminal.green;Bold] in

  let rec npca_list_generator string_lst acc =
    match string_lst with 
    | [] -> acc
    | h::t ->  npca_list_generator t (
        (
          name_extractor h,
          price_extractor h,
          determine_tc h,
          availability_extractor h
        )::acc) in 

  let adjusted_n (name:string) : string = 
    let rec helper n updated = 
      if n = 0 then updated else helper (n-1) (updated^" ") in
    let length = get_longest_length_est st.available_cards in 
    helper (length-(String.length name)) name in 

  let adjusted_p (price:int): string = 
    let rec helper n updated = 
      if n = 0 then updated else helper (n-1) (updated^" ") in
    let length = 3 in 
    let str_price  = string_of_int price in 
    helper (length-(String.length str_price)) str_price in 

  let adjusted_a (availability): string =
    let rec helper n updated =
      if n = 0 then updated else helper (n-1) (updated ^" ") in 
    let length = 2 in 
    let str_availability = string_of_int availability in 
    helper (length-(String.length str_availability)) str_availability in 

  let boxed npc_list n= 
    let rec one_row lst= 
      match lst with 
      | [] -> baseprint(botline n)
      | (name, price, color, availability)::t -> 
        let _ = baseprint "|" in 
        let _ = entryprint color (adjusted_n name)  in
        let _ = baseprint "| " in 
        let _ = entryprint color("Price: " ^ adjusted_p price) in
        let _ = baseprint "| " in 
        let _ = entryprint color ("Availability: " ^ adjusted_a availability) in   
        let _ = baseprint "|\n" in 
        one_row t in 
    let _ = baseprint (topline n) in
    one_row npc_list in 
  let name_player_availability_color = 
    npca_list_generator available_establishments [] in
  boxed name_player_availability_color estimated_length
(** [purchase_landmark_phase_helper i t l] is a helper that searches for the 
    landmark corresponding to [i] in [l] and calls purchase_landmark or
    raises InvalidLandmarkCrad if [i] doesn't correspond to anything *)
let rec purchase_landmark_phase_helper input st 
    (landmarks:Landmark.card list) = 
  match landmarks with
  | [] -> raise (Basiccards.InvalidLandmarkCard (
      " is not a valid landmark card. Please input a valid one."))
  | h::t -> if clean(h.name) = clean input then State.purchase_landmark st
        (State.get_current_player_id st) input 
    else purchase_landmark_phase_helper input st t 


let display_help_phase_msg_1 () = 
  baseprint (
    "Would you like to know about ESTABLISHMENT or LANDMARK cards or go BACK?"
    ^ "\n"
  );
  print_string "> "

let display_help_phase_land_msg_1 () = 
  baseprint (
    "Which landmark effect would you like to know about? "
    ^ "Here are all the landmark cards in play."
    ^ " You can go BACK to the game at any point.\n\n "
  );
  Basiccards.initial_deck_landmarks  
  |> List.map (fun (card:Landmark.card) -> card.name)
  |> String.concat "\n " 
  |> baseprint;
  print_string "\n> "

let display_help_phase_land_EXC_msg_1 input str = 
  baseprint ("\""^input^"\""^str^"\n");
  print_string "> "

let display_help_phase_est_msg_1 () = 
  baseprint (
    "Which establishment effect would you like to know about?"
    ^ "Here are all the establishment cards in play."
    ^ " You can go BACK to the game at any point.\n\n "
  );
  Basiccards.initial_deck
  |> Basiccards.initial_deck_setlike 
  |> List.map (fun (card:Establishment.card) -> card.name)
  |> String.concat "\n " 
  |> baseprint;
  print_string "\n> "

let display_help_phase_est_EXC_msg_1 input str = 
  baseprint ("\""^input^"\""^str^"\n");
  print_string "> "

(* Allows for the user to specify the filename that they will save the
   game json to, saves the state to that file, and then quits *)
let rec save_phase (st:State.t) : unit =
  let st_json = Save_to_json.state_to_json st in
  let rec await_save_file () =
    try (
      print_string "Enter the name of the file that you wish to save to!\n> ";
      match clean(read_line ()) with
      exception End_of_file -> 
        print_endline "Please try again.\n"; 
        await_save_file ()
      | "quit" -> exit 0
      | str -> Save_to_json.save_to_file st_json str;
        print_endline ("Save complete to " ^ str ^ ".json, see you soon!");
    )
    with
    | _ -> print_endline ("That's the name of a critical JSON file!\n" ^
                          "Please try again with a different filename!");
      await_save_file () in
  await_save_file ()

(* This is the phase you enter if you say you want to purchase an 
   establishment. You can cancel the purchase by inputting "finish". 
   The game can also be exited by typing "quit".
   If a valid avaliable card is successfully purchased then an updated state is
   returned. *)
let rec purchase_est_phase (st:State.t) : State.t =
  let tc = turn_color st in
  let _ = display_purchase_est_phase_msg_1 tc  in
  let _ = display_available_establishments st in
  let _ = print_string  "> " in
  let rec await_valid_purchase () =
    match clean(read_line ()) with
    | "finish" | "f" -> st
    | "landmark" | "l" -> purchase_landmark_phase st
    | "help" | "h" -> help_phase st
    | "quit" -> exit 0
    | input-> 
      try(
        let est_card = Basiccards.string_to_est input (st.available_cards)in 
        State.purchase_establishment 
          st 
          (State.get_current_player_id st) 
          est_card
      )
      with 
      | Basiccards.InvalidEstCard str -> 
        display_purchase_est_phase_EXC_msg_1 tc input str; 
        await_valid_purchase () 
      | State.CardNotAvailable str -> 
        display_purchase_est_phase_EXC_msg_2 tc input str; 
        await_valid_purchase () 
      | State.NotEnoughMoneyToPurchase str->
        display_purchase_est_phase_EXC_msg_3 
          tc 
          input 
          str
          (st.available_cards);
        await_valid_purchase () 
      | State.DuplicateMajorCard str->
        display_purchase_est_phase_EXC_msg_4 tc input str;
        await_valid_purchase ()
  in await_valid_purchase ()

(* This is the phase you enter if you want to purchase a landmark. Very similar 
   purchase_establishment_phase. *)
and purchase_landmark_phase (st:State.t) : State.t =
  let tc = turn_color st in
  let _ = display_purchase_landmark_phase_msg_1 tc st in
  let rec await_valid_purchase () =
    match clean(read_line ()) with
    | "finish" | "f" -> st
    | "establishment" | "e" -> purchase_est_phase st
    | "help" | "h" -> help_phase st
    | "quit" -> exit 0
    | input-> 
      try(
        purchase_landmark_phase_helper input st (st.landmark_cards)
      )
      with 
      | Basiccards.InvalidLandmarkCard str -> 
        display_purchase_landmark_phase_EXC_msg_1 tc input str; 
        await_valid_purchase () 
      | State.CardNotAvailable str -> 
        display_purchase_landmark_phase_EXC_msg_2 tc input str; 
        await_valid_purchase () 
      | State.NotEnoughMoneyToPurchase str->
        display_purchase_landmark_phase_EXC_msg_3 
          tc
          input
          str
          st.landmark_cards; 
        await_valid_purchase () 

  in await_valid_purchase ()
(* [help_phase] asks whether the user wants to know about an establishment or a 
   landmark.*)
and help_phase st =
  let _ = display_help_phase_msg_1 () in
  let rec await_valid_card_type () = 
    let input = read_line () in 
    match clean input with
    | "finish" | "f" -> st 
    | "quit" -> exit 0
    | "back" -> phase_3 st
    | "establishment" | "e" -> help_phase_est st 
    | "landmark" | "l" -> help_phase_land st
    | invalid -> 
      let _ = print_string "Invalid type of card. Please try again.\n> " in
      await_valid_card_type () in 
  await_valid_card_type ()

(* [help_phase_land] prompts the user to input a valid landmark card name and
   gives you the information tied to that landmark card.*)
and help_phase_land (st:State.t) = 
  let rec get_valid_landmark input (lst:Landmark.card list) =
    match lst with  
    | [] -> raise (Basiccards.InvalidLandmarkCard (
        " is not a valid landmark card. Please input a valid one."))
    | h::t -> if clean(h.name) = input 
      then h
      else get_valid_landmark input t
  in 
  let rec await_valid_land () =
    match clean(read_line ()) with
    | "finish" | "f" -> st
    | "back" -> phase_3 st
    | "quit" -> exit 0
    | input -> try(
      let card = get_valid_landmark input st.landmark_cards in 
      let _ = print_string (" " ^ Landmark.card_to_effect_description card) in 
      help_phase st
    )
      with 
      | Basiccards.InvalidLandmarkCard str -> 
        let _ = display_help_phase_land_EXC_msg_1 input str in 
        await_valid_land ()
  in 
  let _ = display_help_phase_land_msg_1 () in
  await_valid_land ()

(* [help_phase_est] prompts the user to input a valid establishment card name 
   and gives you the information tied to that establishment card.*)
and help_phase_est (st:State.t) = 
  let rec get_valid_establishment input (lst:Establishment.card list) =
    match lst with  
    | [] -> raise (Basiccards.InvalidEstCard (
        " is not a valid establishment card. Please input a valid one."))
    | h::t -> if clean(h.name) = input 
      then h
      else get_valid_establishment input t
  in  
  let rec await_valid_est () =
    match clean(read_line ()) with
    | "finish" | "f" -> st
    | "back" -> phase_3 st
    | "quit" -> exit 0
    | input -> try(
      let card = get_valid_establishment input 
          (Basiccards.initial_deck |> Basiccards.initial_deck_setlike) in 
      let _ =  Establishment.card_printer card 
      in help_phase st
    )
      with 
      | Basiccards.InvalidEstCard str -> 
        let _ = display_help_phase_est_EXC_msg_1 input str in 
        await_valid_est ()
  in 
  let _ = display_help_phase_est_msg_1 () in await_valid_est ()
(* [phase_3 st] is the state in which an establishment or a landmark card can
   be purchased, the user can access the help phase for the information of each 
   card, or the user can skip all of this and end his/her turn. *)
and phase_3 (st: State.t): (State.t) =  
  let tc = turn_color st in
  let _ = display_phase_3_msg_1 tc in
  let buildortake = State.buildortake (State.get_current_player st) in
  let rec await_command ()=
    match clean (read_line ()) with
    | "establishment" | "e" -> purchase_est_phase st
    | "landmark" | "l" -> purchase_landmark_phase st
    | "save" | "s" -> save_phase st; exit 0
    | "help" | "h" -> help_phase st
    | "quit" -> exit 0
    | "finish" | "f" -> 
      if buildortake then
        let _ = build_or_take_msg () in
        let player = Player.add_cash (State.get_current_player st) 10 in
        State.withdraw_bank
          (State.replace_player_list 
             (State.replace_player player st.players) 
             st)
          10
      else
        st
    | _ -> display_phase_3_msg_2 tc; await_command () 
  in await_command ()

(*[init_phase l e] creates a game state with the landmark cards in list [l] and
  the establishment cards in list [e] *)
let init_phase landmarks establishments: State.t = 
  display_init_phase_msg ();
  let rec await_valid_number_of_players () =
    try(
      match clean(read_line ()) with
      | exception End_of_file -> 
        print_endline "Please try again."; 
        await_valid_number_of_players ()
      | "quit" -> exit 0
      | n -> 
        let int_n = (int_of_string n) in 
        if int_n < 2 || int_n > 4 then raise 
            (State.InvalidNumberofPlayers int_n)
        else int_of_string n
    )
    with
    | State.InvalidNumberofPlayers x -> 
      display_init_EXC_msg_1 x;
      await_valid_number_of_players ()
    | Failure _ -> 
      display_init_EXC_msg_2 ();
      await_valid_number_of_players ()
  in 
  let n_players  = await_valid_number_of_players () in
  State.init_state n_players landmarks establishments


(*___________________________________________________________________________*)
(** [yes_or_no] is 1 if readline is yes, and 2 if no *)
let rec yes_or_no () =
  match clean (read_line ()) with
  | "yes" -> 1
  | "no" -> 2
  | _ ->  baseprint ("Please enter yes or no\n"); 
    print_string  "> "; yes_or_no ()
(** [num_dice_to_roll b tc] prompts the user to enter the number of dice they
    want to roll if [b] is true, [tc] is Ansiterminal styling *)
let rec num_dice_to_roll b tc = 
  if b then
    try
      match read_int () with
      | 1 -> display_phase_1_msg_1a tc;1
      | 2 -> display_phase_1_msg_1a tc;2 
      | _ -> display_phase_1_msg_3b tc; num_dice_to_roll b tc
    with Failure i ->
      if clean i = "quit" then exit 0 
      else
        display_phase_1_msg_3b tc; num_dice_to_roll b tc
  else 1
(** [add_2_roll b] if [b] is true then prompt user to enter yes or no if they
    want to add 2 to their dice roll. If yes then true, else false *)
let add_2_roll b = 
  if b then
    let _ = baseprint (
        "Add2 effect has been activated.\n" ^
        "Would you like to add 2 to your current roll?\n" 
      ) in
    if (yes_or_no ()) = 1 then true
    else false
  else false
(** [await_R add state current_player tc] is the helper function in charge
    of rolling the die and activating the associated landmark effects in the
    die rolling stage *)
let rec await_R add (state : State.t) current_player tc =
  match clean (read_line ()) with
  | "r" -> let current_player' = Player.roll current_player in  
    let rolled_state = 
      State.replace_player_list   
        (State.replace_player current_player' state.players) state in
    let roll_num = Player.calc_roll current_player' in 
    let _ = display_phase_1_msg_2 tc (roll_num) in
    if roll_num >= 10  then
      if ((add_2_roll add) = true) then
        let rolled_state = 
          State.replace_player_list   
            (State.replace_player 
               (State.add2_to_dice current_player') state.players) 
            state in
        let roll_num = 
          Player.calc_roll (State.get_current_player rolled_state) in 
        let _ = display_phase_1_msg_2 tc (roll_num) in
        rolled_state
      else rolled_state
    else
      rolled_state
  | "quit" -> exit 0
  | _ -> display_phase_1_msg_3 tc; await_R add state current_player tc
(* phase_1 is where the current player's fields dice_rolls, which is an int
   list, is updated. It then calculates the sum of the rolls using 
   Player.calc_roll and generates a state that represents those player rolls.*)
let phase_1 (st: State.t): State.t  =
  let tc = turn_color st in
  let current_player = State.get_current_player st in
  (* roll message dictates whether to activate the effect to roll 2 die *)
  let roll_message = State.train_station_roll_2 current_player in
  let _ = display_phase_1_msg_1 tc in 
  let _ = if roll_message then display_phase_1_msg_1b tc
    else display_phase_1_msg_1a tc in
  let current_player = Player.dice_to_roll 
      current_player 
      (num_dice_to_roll roll_message tc) in
  let players = State.replace_player current_player (st.players) in
  let state = State.replace_player_list players st in
  (* add2 dicatates whether to activate the add2 effect *)
  let add2 = State.add_2_to_roll current_player in
  await_R add2 state current_player tc
(* this phase is activated when the redo turn effect is active. it is the same
   as phase_1, but without some of the messages*)
let phase_1_redo (st: State.t): State.t  =
  let tc = turn_color st in
  let current_player = State.get_current_player st in
  let roll_message = State.train_station_roll_2 current_player in
  let () = if roll_message then display_phase_1_msg_1b tc
    else display_phase_1_msg_1a tc in
  let current_player = Player.dice_to_roll 
      current_player 
      (num_dice_to_roll roll_message tc) in
  let players = State.replace_player current_player (st.players) in
  let state = State.replace_player_list players st in
  let add2 = State.add_2_to_roll current_player in
  await_R add2 state current_player tc

(*Effects are activated here.*)
let phase_2 (st: State.t) = 
  let tc = turn_color st in
  let _ = display_phase_2_msg_1 tc in 
  State.activate_effects st 


let winning_phase () = let _ = print_endline 
                           "\nCONGRATULATIONS! YOU WIN!" in ()
(** [redoroll st] if the current player has the option to redo phase 1,
    then this function is called. It asks the user whether they want to or not.
    If the user says yes, it reruns phase 1 and returns the appropriate state, 
    otherwise it returns [st] *)
let rec redoroll st =
  match clean (read_line ()) with
  | "yes" -> phase_1_redo st
  | "no" -> st
  | _ ->  baseprint "Please enter yes or no\n"; 
    print_string  "> "; redoroll st
(** [do_phase1 st go] if [go] is true, then print out reroll message after phase 
    1 and run redoroll. Otherwise just do phase 1 *)
let do_phase1 st go = 
  if go then 
    let st' = phase_1 st in
    baseprint ("Reroll effect has been activated. Would you like to reroll?\n"
               ^ "Please enter yes or no.\n"); 
    print_string  "> ";
    redoroll st'
  else phase_1 st
(** [take_2nd_turn_helper st current_player] asks [current_player] if
    they want to take a second turn. If they chose yes, then take another
    turn and return the appropriate state. Otherwise return [st] *)
let rec take_2nd_turn_helper st current_player =
  let yn = yes_or_no () in 
  if yn = 1 then 
    let s1 = 
      do_phase1 st (State.reroll (State.id_to_Player st current_player)) in
    let s2 = phase_2 s1 in
    let s3 = phase_3 s2 in
    let _ = display_main_phase_msg_2 s3 current_player in 
    let _ = display_main_phase_msg_3 s3 current_player in 
    State.next_state s3
  else State.next_state st
let take_2nd_turn st b current_player = 
  if b then
    (baseprint 
       ("Double turn effect has been activated. "^
        " Would you like to take another turn?\n"^
        "Please enter yes or no\n"); 
     print_string  "> ";
     (take_2nd_turn_helper st current_player)) 
  else State.next_state st

(* [main_phase st] returns an updated game state in which all of the actions
   done within one player's turn are made. *)
let rec main_phase (st: State.t) : unit =
  let _ = display_main_phase_msg_1 st in
  let current_player = State.get_current_player_id st in
  let _ = display_main_phase_msg_3 st current_player in
  let cityhall_c = State.cityhall_collect 
      (State.id_to_Player st current_player) in 
  let st = 
    if cityhall_c then 
      let _ = 
        baseprint
          ("City Hall effect has been activated. "^
           "Since you had 0 coins, you will now have 1\n"); 
        print_string  "> "; in
      (* give player 1 coin from bank *)
      let player = Player.add_cash (State.id_to_Player st current_player) 1 in
      State.withdraw_bank
        (State.replace_player_list (State.replace_player player st.players) st)
        1
    else st in
  let s1 = do_phase1 st (State.reroll 
                           (State.id_to_Player st current_player)) in
  let s2 = phase_2 s1 in
  let s3 = phase_3 s2 in
  let _ = display_main_phase_msg_2 s3 current_player in 
  let _ = display_main_phase_msg_3 s3 current_player in 
  let redoturn = 
    State.take_other_turn (State.id_to_Player st current_player) in

  let next_state = take_2nd_turn s3 redoturn current_player in
  if State.is_winning_state next_state then winning_phase ()
  else main_phase next_state

(*___________________________________________________________________________*)

let play_game () =
  let initial = init_phase [] [] in
  main_phase initial
let play_game_expanded game = 
  let landmarks = Parse_json.load_landmarks (Yojson.Basic.from_file game) in
  let establishments =  
    Parse_json.load_establishments 
      (Yojson.Basic.from_file game) in
  main_phase (init_phase landmarks establishments)


let rec load_expansion_pack_phase () = 
  ANSITerminal.(print_string [white;Bold] 
                  "Please enter the name of the game file you want to load.\n"); 
  print_string  "> ";
  try 
    try
      match read_line () with
      | exception End_of_file -> ()
      | file_name -> play_game_expanded file_name
    with Failure _ -> 
      ANSITerminal.(print_string [red](
          "\n\nThat was an invalid file\n"^
          "Please enter a valid file\n"));
      print_endline ("Press the enter key to retry,"^
                     " or enter \"quit\" to quit.\n");
      if (read_line ()) = "quit" then
        exit 0
      else
        load_expansion_pack_phase ()
  with 
  | Sys_error _ ->
    ANSITerminal.(print_string [red]
                    "\n\nThat was an invalid name\n");
    print_endline "Press the enter key to retry, or enter \"quit\" to quit.\n";
    if (read_line ()) = "quit" then
      exit 0
    else
      load_expansion_pack_phase ()
  | _ -> ANSITerminal.(print_string [red]
                         "\n\nThat was an invalid JSON file.\n
                         Make sure you aren't trying to load a game save.");
    print_endline "Press the enter key to retry, or enter \"quit\" to quit.\n";
    if (read_line ()) = "quit" then
      exit 0
    else
      load_expansion_pack_phase ()

let create_custom_deck_phase () =
  let _ = ANSITerminal.(print_string [white; Bold] (
      "\n\n\n\n\n\n\n\n\n"
      ^ "______________________________________________________\n"
      ^ "Welcome to the Machi Koro Card Creator                \n"
      ^ "______________________________________________________\n"
      ^ "You will be prompted to enter various values. \n\n\n\n"
      ^ "Please make sure to the instructions very carefully.\n"
      ^ "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
      ^ "Press enter when you are ready\n" 
    )) in
  let _ = read_line () in
  let deck = Card_maker.create_deck () in
  let assoc_deck = Card_maker.deck_to_json deck in
  let filename = (Card_maker.to_file assoc_deck)^".json" in
  let _ = ANSITerminal.(print_string [white; Bold] (
      "\nYour custom deck is saved as "^filename^".\n"
      ^ "If you would like to use it in future games,"^
      " load it as an expansion pack.\n"
      ^ "Would you like to use your new custom expansion pack in this game?\n"
      ^ "Please enter yes or no\n" 
    )); print_string "> " in
  if yes_or_no () = 1 then
    match filename with
    | exception End_of_file -> ()
    | file_name -> play_game_expanded filename
  else play_game ()

(* [load_save] generates a state based on the JSON file at the location
   that the user specifies, and then launches the game at that state *)
let rec load_save () = 
  try (
    let _ = ANSITerminal.(print_string [white; Bold] (
        "\n\n\n\n\n\n\n\n\n"
        ^ "______________________________________________________\n"
        ^ "Let's load an existing save into the game!            \n"
        ^ "______________________________________________________\n"
        ^ "Press enter when you are ready\n")) in 
    let _ = read_line () in
    let _ = ANSITerminal.(print_string [white; Bold] (
        "Please enter the name of the save that you want to load.\n" ^
        "DO NOT forget the .json file extension at the end of the name\n")) in 
    let filename = read_line () in
    if filename = "quit" then exit 0 else 
      let state_to_load = Load_from_json.load_from_file filename in
      let _ = ANSITerminal.(print_string [white; Bold] ("Load successful. " ^
                                                        "Have fun!")) in
      main_phase state_to_load
  )
  with
  (* invalid file name *)
  | Sys_error _ -> let _ = ANSITerminal.(print_string [red; Bold] (
      "That was an invalid file address.\nPlease try again.")) in 
    load_save ()
  (* invalid JSON file format *)
  | _ -> let _ = ANSITerminal.(print_string [red; Bold] (
      "That was an invalid JSON file. Make sure that you're not trying " ^
      "to load a cardlist instead of a save.")) in 
    load_save ()
(** [instructions] displays the instructions and prompts users to press
    enter to keep going. After instructions are done, 
    prompts user for further actions *)
let rec instructions () =
  let _ = ANSITerminal.(print_string [white](
      "Welcome to the city of Machi Koro!\n"^
      "You’ve just been elected Mayor. "));
    ANSITerminal.(print_string [white;Bold](
        "Congratulations!\n"));
    ANSITerminal.(print_string [white](
        "Unfortunately, the citizens have some pretty big demands: jobs, a \n"^
        "theme park, a couple of cheese factories, and maybe even a radio "^
        "tower.\nA tough proposition since the city currently consists of a "^
        "wheat field,\na bakery, and a single die. Armed only with "^
        "your trusty "^
        "die and a dream, \nyou must grow Machi Koro into the largest city "^
        "in the region.\nYou will need to collect income from developments,\n"^
        "build public works, and steal from your neighbors’ coffers. \n"^
        "Just make sure they aren’t doing the same to you!\n\n\n"^
        "Machi Koro is a fast-paced, lighthearted game for you and up to 3 "^
        "friends. \nOnce you’ve had a taste of Machi Koro, "^
        "this infectiously fun"^
        " game may have you \nwondering if your computer ever served another"^
        " purpose other than gaming. \nThey say you can’t"^
        " build Rome in a day, "^
        "but Machi Koro will be built in less than 30 minutes!\n\n"^
        "Press enter to continue")) in
  let _ = read_line () in
  let _ = 
    ANSITerminal.(print_string [white;Bold](
        "GAME FLOW\n\n")); 
    ANSITerminal.(print_string [white](
        "Players take turns in clockwise order. "
        ^"A turn consists of the following three phases:\n• Roll Dice"^
        "\n• Earn Income\n• Construction\n"));
    ANSITerminal.(print_string [white;Bold](
        "Game End:\n"));
    ANSITerminal.(print_string [white]
                    (" The player to construct all of"^
                     " their Landmarks first wins the game!\n\n"^
                     "Press enter to continue")) in
  let _ = read_line () in
  let _ = 
    ANSITerminal.(print_string [white;Bold](
        "ROLL DICE\n"));
    ANSITerminal.(print_string [white](
        "• To begin their turn a player rolls the dice."^
        " At the start of the game each playe will roll a single die.\n"^
        "• Once a player has built their Train Station, "^
        "they may roll one or two dice on their turn.\n"^
        "• When rolling two dice, the dice are always summed together.\n\n"^
        "Press enter to continue")) in
  let _ = read_line () in
  let _ = 
    ANSITerminal.(print_string [white;Bold](
        "EARN INCOME\n"));
    ANSITerminal.(print_string [white;Bold](
        "• Players earn income based on the "^
        "dice roll and the effects of the \n"^
        "Establishments that they own that match the dice roll.\n"^
        "• There are 4 different types of Establishments that\n earn"^
        " income in different ways:\n"));
    ANSITerminal.(print_string [blue;Bold](
        "BlUE:\n"));
    ANSITerminal.(print_string [blue](
        "Primary Industry:\n"^
        "Get income from the bank, during anyone’s turn.\n"));
    ANSITerminal.(print_string [green;Bold](
        "GREEN:\n"));
    ANSITerminal.(print_string [green](
        "Secondary Industry:\n"^
        "Get income from the bank, during your turn only.\n"));
    ANSITerminal.(print_string [red;Bold](
        "RED:\n"));
    ANSITerminal.(print_string [red](
        "Restaurants:\n"^
        "Take coins from the person who rolled the dice.\n"));
    ANSITerminal.(print_string [magenta;Bold](
        "Purple:\n"));
    ANSITerminal.(print_string [magenta](
        "Major Establishment:\n"^
        "Get income from all other players, but during your turn only.\n\n"));
    ANSITerminal.(print_string [white](
        "Press enter to continue")); in
  let _ = read_line () in
  let _ = 
    ANSITerminal.(print_string [white; Bold](
        "COIN TRANSACTIONS BETWEEN PLAYERS\n"));
    ANSITerminal.(print_string [white](
        "If a player owes another player money and cannot "^
        "afford to pay it,\n"^
        "they pay what they can and the rest is exempted "^
        "(a player’s coin total"^
        "\ncan never go below zero), the receiving player is"^
        " not compensated for the lost income. \n\n"^
        "Press enter to continue")) in
  let _ = read_line () in
  let _ = 
    ANSITerminal.(print_string [white; Bold]( 
        "BUILDING NEW ESTABLISHMENTS AND COMPLETING LANDMARKS\n"));
    ANSITerminal.(print_string [white](
        "To conclude a player’s turn, he or she may pay to construct one "^
        "single Establishment\n OR pay to finish construction on a single "^
        "Landmark by paying the\n cost of"^
        " the card. If the player enters the landmark purchasing phase,\n"^
        "but does not have enough money, then their turn is over."^
        "\n\nOnce constructed, an Establishment is taken from the"^
        " supply and added to the player’s deck.\nWhen constructing a"^
        " Landmark, the Landmark card is activated \n"^
        "and the Landmark’s effects are now active. \nLandmarks may be "^
        "constructed in any order the player chooses.\n\nPlayers may"^
        " construct multiple copies of all other Establishment types \nas "^
        "described in the Income section of these rules.\n\n"));
    ANSITerminal.(print_string [white; Bold]( 
        "GAME ENDS WHEN A PLAYER COLLECTS ALL OF THE LANDMARK CARDS\n\n"^
        "Press enter to continue")) in
  let _ = read_line () in
  let _ = 
    ANSITerminal.(
      print_string [white;Bold] 
        ("\n_______________________________________________________"^
         "___________\n"
         ^ "\n"
         ^ "Instructions are over. Please type in what you would like to do\n"
         ^ "_______________________________________________________"^
         "___________\n"
         ^ "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
         ^ "<Start>\n\n"
         ^ "<Load Expansion Pack>\n\n"
         ^ "<Create Custom Deck>\n\n"
         ^ "<Instructions>\n\n"
         ^ "<Quit>\n"));
    print_string "> " in
  (*we had to repeat this bit of code because there is no way 
    that i can put this function above if i havent declared instructions () 
    yet*)
  let rec await_main_command () =
    match clean(read_line ()) with
    | exception End_of_file -> 
      print_endline "Please try again."; 
      await_main_command ()
    | "quit" -> exit 0
    | "start" -> play_game ()
    | "load expansion pack" -> load_expansion_pack_phase ()
    | "create custom deck" -> create_custom_deck_phase ()
    | "load save" -> load_save ()
    | "instructions" -> instructions ()
    | _ -> display_main_msg_2 (); await_main_command () in
  await_main_command ()
let rec main () : unit =
  display_main_msg_1 ();
  (* prompts user input to be a valid number of players 
     for Machi Koro (2-4).
     user can also quit at any time. *)
  let rec await_main_command () =

    match clean(read_line ()) with
    | exception End_of_file -> 
      print_endline "Please try again."; 
      await_main_command ()
    | "quit" -> exit 0
    | "start" -> play_game ()
    | "load expansion pack" -> load_expansion_pack_phase ()
    | "create custom deck" -> create_custom_deck_phase ()
    | "instructions" -> instructions ()
    | "load save" -> load_save ()
    | _ -> display_main_msg_2 (); await_main_command () in

  await_main_command ()

(* Execute the game engine. *)
let () = main ()

