open Save_to_json
type e = {
  name:string; 
  industry:Establishment.industry; 
  card_type:Establishment.cardType;
  construction_cost:int; 
  activation_numbers:int list;
  effect:Establishment.effect;
  amount: int
}
type l = {
  name:string;    
  construction_cost:int;
  effect:Landmark.effect;
}
type deck = {
  establishments: e list;
  landmarks: l list
}
(** [clean str] trims the whitespace off of the string [str], and renders it 
    into lowercase *)
let clean str = str |> String.trim |> String.lowercase_ascii
(** [get_industry] is the industry of the card the user is creating *)
let get_industry () = 
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the industry of your card\n"^
         "Primary: "));
    ANSITerminal.(
      print_string [white] 
        ("These are things like farms, mines, ranches, and other "^
         "similar things\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Secondary: "));
    ANSITerminal.(
      print_string [white] (
        "These are things like shops, services, and other "^
        "businesses\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Restaurants:"));
    ANSITerminal.(
      print_string [white] 
        (" These are for restaurants\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Major: "));
    ANSITerminal.(
      print_string [white] 
        ("These are for other businesses that have strategic value\n"));
    print_string "> " in
  let rec industry_type () = 
    match clean (read_line ()) with
    | "primary" -> Establishment.Primary
    | "secondary" -> Establishment.Secondary
    | "restaurant" -> Establishment.Restaurant
    | "major" -> Establishment.Major
    | _ -> ANSITerminal.(
        print_string [red;Bold] 
          ("Please enter valid industry type\n"));
      print_string "> ";
      industry_type () in
  industry_type ()
(** [get_card_type] is the type of the card the user is creating *)
let get_card_type () =
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the Card Type\n"));
    ANSITerminal.(
      print_string [white;Bold] 
        ("The card types are\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Wheat\nCow\nGear\nBread\nFactory\n"^
         "Fruit\nCup\nMajor\nBoat\nSuitcase\n"));
    print_string "> " in
  let rec card_type () = 
    match clean (read_line ()) with
    | "wheat" -> Establishment.Wheat
    | "cow" -> Establishment.Cow
    | "gear" -> Establishment.Gear
    | "bread" -> Establishment.Bread
    | "factory" -> Establishment.Factory
    | "fruit" -> Establishment.Fruit
    | "cup" -> Establishment.Cup
    | "major" -> Establishment.Major
    | "boat" -> Establishment.Boat
    | "suitcase" -> Establishment.Suitcase
    | _ -> ANSITerminal.(
        print_string [red;Bold] 
          ("Please enter valid card type\n"));
      print_string "> ";
      card_type () in
  card_type ()
(** [get_activation_time] is the activation time of the card the user
    is creating *)
let get_activation_time () =let _ =  ANSITerminal.(
    print_string [green;Bold] 
      ("Please enter the activation time\n"));
    ANSITerminal.(
      print_string [white] 
        ("The activation times are\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Anyone's turn:"));
    ANSITerminal.(
      print_string [white] 
        (" Card effect can be activated on anyone's turn."^
         "\n Please enter [anyone]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Player's turn:"));
    ANSITerminal.(
      print_string [white] 
        (" Card effect can only be activated during current"^
         " player's turn.\n Please enter [player]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Other's turn:"));
    ANSITerminal.(
      print_string [white] 
        (" Card effect can only be activated during "^
         "other players turns.\n Please enter [others]\n"));
    print_string "> " in
  let rec activationtime () = 
    match clean (read_line ()) with
    | "anyone" -> Establishment.AnyonesTurn
    | "player" -> Establishment.PlayersTurn
    | "others" -> Establishment.OthersTurn
    | _ -> ANSITerminal.(
        print_string [red;Bold] 
          ("Please enter valid activation time\n"));
      print_string "> ";
      activationtime () in
  activationtime () 
(** [get_effect_type_est] is the effect of the establishment card
    the user is creating *)
let get_effect_type_est () =
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the effect type\n"));
    ANSITerminal.(
      print_string [white] 
        ( "The effect types are\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Collect:"));
    ANSITerminal.(
      print_string [white] 
        (" Collect the value from the back.\n Please enter [collect]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Collect Gear:"));
    ANSITerminal.(
      print_string [white] 
        (" Collect from the bank the value times the number "^
         "of gear cards one has.\n Please enter [collect gear]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Collect Wheat:"));
    ANSITerminal.(
      print_string [white] 
        (" Collect from the bank the value times the number of"^
         " wheat cards one has.\n Please enter [collect wheat]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Collect Cow:"));
    ANSITerminal.(
      print_string [white]  
        (" Collect from the bank the value times the number of"^
         " cow cards one has.\n Please enter [collect cow]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Take:"));
    ANSITerminal.(
      print_string [white] 
        (" Take from another player a number of coins equal to the value."^
         "\n Please enter [take]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Take All:"));
    ANSITerminal.(
      print_string [white]  
        (" Take from all players amount equal to value."^
         "\n Please enter [take all]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Take Rolled:"));
    ANSITerminal.(
      print_string [white]  
        (" Take amount of coins equal to value from the player who "^
         "just rolled.\n Please enter [take rolled] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Trade:"));
    ANSITerminal.(
      print_string [white]  
        (" Trade a non-major establishment with another player."^
         "\n Please enter [trade]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Harbor Collect:"));
    ANSITerminal.(
      print_string [white]  
        (" If you have a Harbor, collect 3 coins from the bank."^
         "\n Please enter [harbor collect]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Harbor Collect Tuna Rolled:"));
    ANSITerminal.(
      print_string [white]  
        (" Every player with a harbor and a tuna boat"^
         " collects the value times the amount of tuna boats."^
         "\n Please enter [harbor collect tuna rolled] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Flower Collect:"));
    ANSITerminal.(
      print_string [white]  
        (" Collect 1 coin from the bank for every flower "^
         "orchard the player has.\n Please enter [flower collect] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Collect Cup:"));
    ANSITerminal.(
      print_string [white]  
        (" Collect from the bank the value times the number "^
         "of cup cards the player has.\n Please enter [collect cup]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Harbor Take:"));
    ANSITerminal.(
      print_string [white]  
        (" Take from another player a number of coins equal to the"^
         " value if you have a harbor.\n Please enter [harbor take]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Collect Cup and Bread:"));
    ANSITerminal.(
      print_string [white]  
        (" Collect one cup from each player for every "^
         "cup and bread establishment they have.\n"^
         " Please enter [collect cup bread] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Tax:"));
    ANSITerminal.(
      print_string [white]  
        (" Take half of the coins from each player who has 10 coins or"^
         " more.\n Please enter [tax] \n"));
    print_string "> " in
  let rec effect_type () = 
    match clean (read_line ()) with
    | "collect" -> Establishment.Collect
    | "collect gear" -> Establishment.CollectGear
    | "collect wheat" -> Establishment.CollectWheat
    | "collect cow" -> Establishment.CollectCow
    | "take" -> Establishment.Take
    | "take rolled" -> Establishment.TakeRolled
    | "take all" -> Establishment.TakeAll
    | "trade" -> Establishment.Trade
    | "harbor collect" -> Establishment.HarborCollect
    | "harbor collect tuna rolled" -> Establishment.HarborCollectTunaRolled
    | "flower collect" -> Establishment.FlowerCollect
    | "collect cup" -> Establishment.CollectCup
    | "harbor take" -> Establishment.HarborTake
    | "collect cup bread" -> Establishment.CollectCupBread
    | "tax" -> Establishment.Tax
    | _ -> ANSITerminal.(
        print_string [red;Bold] 
          ("Please enter valid effect type\n"));
      print_string "> ";
      effect_type () in
  effect_type ()
(** [get_int] is an int greater than 0 read from the terminal *)
let rec get_int () = 
  try
    let int = read_int () in
    if int<0 then 
      let _ = ANSITerminal.(
          print_string [red;Bold] 
            ("Please enter a nonnegative value\n")); 
        print_string "> " in get_int ()
    else
      int
  with Failure _ ->
    let _ = ANSITerminal.(
        print_string [red;Bold] 
          ("Please enter a nonnegative value\n")); 
      print_string "> " in get_int ()
(** [yes_or_no] is 1 if user types in yes into terminal, and 2 if no *)
let rec yes_or_no () =
  match clean (read_line ()) with
  | "yes" -> 1
  | "no" -> 2
  | _ ->  ANSITerminal.(print_string [red;Bold] 
                          ("Please enter yes or no\n")); 
    print_string  "> "; yes_or_no ()
(** [get_activation_numbers] is list of the activation numbers of the card the 
    user is creating *)
let get_activation_numbers () =
  let _ = ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the activation number for the card\n"));
    print_string "> " in
  let rec no_repeat lst = 
    let num = get_int () in
    if List.mem num lst then
      let _ = ANSITerminal.(
          print_string [red;Bold] 
            ("This is already an activation number. Please enter another\n"));
        print_string  "> " in no_repeat lst
    else if num >12 then
      let _ = ANSITerminal.(
          print_string [red;Bold] 
            ("Please enter a number between 1 and 12\n"));
        print_string  "> " in no_repeat lst
    else num in
  let rec get_activation_nums acc counter =
    if counter = 1 then (no_repeat acc)::acc 
    else
      let num1 = no_repeat acc in
      let _ = ANSITerminal.(
          print_string [green;Bold] 
            ("Would you like to enter another activation number?\n"));
        print_string "> " in
      if yes_or_no () = 1 then 
        let _ = ANSITerminal.(
            print_string [green;Bold] 
              ("Please enter another activation number\n"));
          print_string  "> " in
        get_activation_nums (num1::acc) (counter - 1)
      else num1::acc in
  get_activation_nums [] 3
(** [get_num_card] is the amount of a specific card the user is creating *)
let get_num_card () = 
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the amount of cards\n"));
    print_string "> " in
  let rec get_num_card_helper () = 
    try
      let int = read_int () in
      if int<0 then 
        let _ = ANSITerminal.(
            print_string [red;Bold] 
              ("Please enter a nonnegative value\n")); print_string "> " 
        in get_int ()
      else if int > 20 || int = 0 then
        let _ = ANSITerminal.(
            print_string [red;Bold] 
              ("Please enter a nonnegative value between 1 and 20\n"));
          print_string "> " 
        in get_int ()
      else
        int
    with Failure _ ->
      let _ = ANSITerminal.(
          print_string [red;Bold] 
            ("Please enter a nonnegative value\n"));
        print_string "> " in get_int () in
  get_num_card_helper ()
(** [create_establishment] is the establishment card the user is creating*)
let create_establishment_card names = 
  let _ = ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the name of your card\n"));
    print_string "> " in
  let rec get_name names = 
    let name = read_line () in
    if List.mem (clean name) names then
      let _= ANSITerminal.(
          print_string [red;Bold] 
            ("You have already used that as a name for a previous card, "^
             "please choose another name.\n"));
        print_string "> " in
      get_name names
    else name in
  let name = get_name names in
  let industry = get_industry () in
  let ctype = get_card_type () in
  let atime = get_activation_time () in
  let etype = get_effect_type_est () in
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the value of the card\n"^
         "The value is the amount of coins that you can gain from the card.\n"^
         "In other words, it is the card's weight\n"^
         "THIS IS NOT THE SAME AS COST\n"));
    print_string "> " in
  let value = get_int () in
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the cost of the card\n"));
    print_string "> " in
  let cost = get_int () in
  let activation_numbers = get_activation_numbers () in
  let num_card = get_num_card () in
  {
    name = name;
    industry = industry;
    card_type = ctype;
    construction_cost = cost;
    activation_numbers = activation_numbers;
    effect = {
      activation_time = atime;
      value = value;
      effect_type = etype
    };
    amount = num_card
  }
(** [get_effect_type_land] is the effect of the landmark card the user 
    is creating *)
let get_effect_type_land () =
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the effect type\n"));
    ANSITerminal.(
      print_string [white] 
        ("The effect types are\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Double Roll:"));
    ANSITerminal.(
      print_string [white] 
        (" Can choose before your turn whether to roll 1 or 2 dice."
         ^"\n Please enter [double roll] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Mall Collect:"));
    ANSITerminal.(
      print_string [white] 
        (" Whenever you collect from a bread or a cafe card,"^
         " collect on extra coin.\n Please enter [mall collect] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Double Turn:"));
    ANSITerminal.(
      print_string [white] 
        (" If you roll doulbes, then you can choose to take"^
         "another turn.\n Please enter [double turn] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Reroll:"));
    ANSITerminal.(
      print_string [white] 
        (" YOu can choose to roll again and replace previous roll.\n"^
         " Please enter [reroll]\n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("City Hall:"));
    ANSITerminal.(
      print_string [white] 
        (" If you have ) coins, get one from the bank.\n"^
         " Please enter [city hall] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Add to Die:"));
    ANSITerminal.(
      print_string [white] 
        (" If your roll is greater than 10, you can choose to add"^
         " 2 to the total.\n Please enter [add2] \n"));
    ANSITerminal.(
      print_string [green;Bold] 
        ("Build or Take:"));
    ANSITerminal.(
      print_string [white] 
        (" If a player builds nothing on their turn, then"^
         "get 10 coins from the bank.\n Please enter [build or take]\n"));
    print_string "> " in
  let rec effect_type () = 
    match clean (read_line ()) with
    | "double roll" -> Landmark.DoubleRoll
    | "mall collect" -> Landmark.MallCollect
    | "double turn" -> Landmark.DoublesTurn
    | "reroll" -> Landmark.Reroll
    | "city hall" -> Landmark.CityHall
    | "add2" -> Landmark.AddToDie
    | "build or take" -> Landmark.BuildOrTake 
    | _ -> ANSITerminal.(
        print_string [red;Bold] 
          ("Please enter valid effect type\n"));
      print_string "> ";
      effect_type () in
  effect_type ()

(** [create_landmark_card] is a landmakr card the user is creating *)
let create_landmark_card names =
  let _ = ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the name of your card\n"));
    print_string "> " in
  let rec get_name names = 
    let name = read_line () in
    if List.mem (clean name) names then
      let _= ANSITerminal.(
          print_string [red;Bold] 
            ("You have already used that as a name for a previous card, "^
             "please choose another name.\n"));
        print_string "> " in
      get_name names
    else name in
  let name = get_name names in
  let effecttype = get_effect_type_land () in
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the value of the card\n"^
         "The value is the amount of coins that you can gain from the card.\n"^
         "In other words, it is the card's weight\n"^
         "THIS IS NOT THE SAME AS COST\n"));
    print_string "> " in
  let value = get_int () in
  let _ =  ANSITerminal.(
      print_string [green;Bold] 
        ("Please enter the cost of the card\n"));
    print_string "> " in
  let cost = get_int () in
  {
    name = name;
    construction_cost = cost;
    effect = {
      value = value;
      effect_type = effecttype
    }
  }
let rec name_extractor_list_e acc (lst:e list) = 
  match lst with
  | [] -> acc
  | h::t -> name_extractor_list_e ((clean h.name)::acc) t

let rec name_extractor_list_l acc (lst:l list) = 
  match lst with
  | [] -> acc
  | h::t -> name_extractor_list_l ((clean h.name)::acc) t

let rec create_establishment_deck (acc: e list) = 
  let names = name_extractor_list_e [] acc in
  let cards = create_establishment_card names in
  let _ = ANSITerminal.(
      print_string [green;Bold] 
        ("Would you like to create another establishment card?\n"));
    ANSITerminal.(
      print_string [white] 
        "Please enter yes or no\n");
    print_string "> " in
  if yes_or_no () = 1 then
    create_establishment_deck (cards::acc)
  else cards::acc
(** [create_landmark_deck] is a deck of landmark cards created
    by the user *)
let rec create_landmark_deck acc = 
  let names = name_extractor_list_l [] acc in
  let cards = create_landmark_card names in
  let _ = ANSITerminal.(
      print_string [green;Bold] 
        ("Would you like to create another landmark card?\n"));
    ANSITerminal.(
      print_string [white] 
        "Please enter yes or no\n");
    print_string "> " in
  if yes_or_no () = 1 then
    create_landmark_deck (cards::acc)
  else cards::acc

(* [create_deck] creates a new deck record consisting of two lists,
   one containing the custom establishments that the user creates, and another
   containing the custom landmarks that the user creates*)
let create_deck () = 
  let _ = ANSITerminal.(
      print_string [cyan;Bold] 
        ("Now creating Establishment Cards\n")); in
  let establishments = create_establishment_deck [] in
  let _ = ANSITerminal.(
      print_string [cyan;Bold] 
        ("Now creating Landmark Cards\n")); in
  let landmarks = create_landmark_deck [] in
  {
    establishments = establishments;
    landmarks = landmarks
  }

(* [e_to_json est] takes in an e record, [est], and converts it into a
   json associative array, wich represents the establishment card detailed
   within [est], along with the quantity of that particular card *)
let e_to_json (est:e) : Yojson.Basic.json =
  `Assoc [
    ("name", `String est.name);
    ("quantity", `Int est.amount);
    ("industry", Save_to_json.industry_to_json est.industry);
    ("card type", Save_to_json.card_type_to_json est.card_type);
    ("construction cost", `Int est.construction_cost);
    ("activation numbers", 
     Save_to_json.list_to_json (est.activation_numbers) 
       int_to_json);
    ("effect", Save_to_json.establishment_effect_to_json est.effect)
  ]

(* [l_to_json est] takes in an l record, [lmk], and converts it into a
   json associative array, wich represents the landmark card detailed
   within [lmk] *)
let l_to_json (lmk:l) : Yojson.Basic.json =
  `Assoc [
    ("name", `String lmk.name);
    ("industry", `String "Landmark");
    ("card type", `String "Major");
    ("construction cost", `Int lmk.construction_cost);
    ("effect", Save_to_json.landmark_effect_to_json lmk.effect);
    ("face", `String "Down")
  ]

(** [deck_to_json deck] gives a json associative array representing the
    given deck [deck]. The associative array corresponds with the cardlist
    schema given in json_schema_cardlist.json*)
let deck_to_json (deck:deck) : Yojson.Basic.json =
  let json_e_list = Save_to_json.list_to_json (deck.establishments)
      e_to_json in
  let json_l_list = Save_to_json.list_to_json (deck.landmarks)
      l_to_json in
  `Assoc [
    ("name", `String "custom deck");
    ("establishments", json_e_list);
    ("landmarks", json_l_list)
  ]

(** [to_file json_assoc] saves the json association list to the filename that
    the user inputs, then it returns the filename*)
let rec to_file (json_assoc:Yojson.Basic.json) = 
  try 
    let save_to_file (save:Yojson.Basic.json) (filename:string) =
      let _ = match clean(filename) with
        | "alternatecards"
        | "basiccards"
        | "basichand"
        | "harbor expansion"
        | "json_schema_cardlist"
        | "json_schema_saves" -> failwith "attempt to edit critical files
    for the game"
        | _ -> () in
      let address = filename ^ ".json" in
      let open_channel = open_out address in
      Printf.fprintf open_channel "%s" (Yojson.Basic.pretty_to_string save);
      close_out open_channel in
    let _ = ANSITerminal.(
        print_string [white;Bold] 
          ("Please enter the name of this deck\n")); in
    let filename = read_line () in
    let _ = save_to_file json_assoc filename in
    filename
  with 
  | _ -> let _ = ANSITerminal.(
      print_string [red;Bold] 
        ("Please enter a valid name for the json file that" ^
         " does not conflict with critical files\n")); in
    to_file json_assoc