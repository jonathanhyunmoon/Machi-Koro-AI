(** [turn_color st] is a ANSITerminal color for the text depending on whose 
    turn it is.*)
val turn_color: State.t -> ANSITerminal.style

(** [purchase_est_phase st] is the updated state [st'] such that if the player 
    "successfully" purchases an establishment, [st'] reflects such changes. If
    quit is called, the game is terminated. If finish is called, then [st'=st]

    A "successful" purchase of establishment [est] by player [p] given input  
    string [in] has the characteristics:
    1) [in] is a valid name of an establishment
        (i.e. [List.mem Basiccards.set_of_names_of_all_cards in])
    2) [p] has enough cash to purchase the establishment 
        (i.e. [p.cash >= est.construction_cost])
    3) [est] is an available establishment in the game. 
        (i.e. [List.mem st.available_cards est]) *)
val purchase_est_phase: State.t -> State.t

(** [purchase_landmark_phase st] is the updated state [st'] such that if the  
    player "successfully" purchases an landmark, [st'] reflects such changes. 
    If quit is called, the game is terminated. If finish is called, then 
    [st'=st]

    A "successful" purchase of establishment [est] by player [p] given input  
    string [in] has the characteristics:
    1) [in] is a valid name of an establishment
        (i.e. [List.mem Basiccards.set_of_names_of_all_cards in])
    2) [p] has enough cash to purchase the establishment 
        (i.e. [p.cash >= est.construction_cost])
    3) [est] is an available establishment in the game. 
        (i.e. [List.mem st.available_cards est]) *)
val purchase_landmark_phase: State.t -> State.t

(** [init_phase] is the initial state constructed by calling 
    State.init_state.*)
val init_phase: Landmark.card list -> Establishment.card list -> State.t

(** [phase_1 st] is the tuple with state [st] and the sum of the values  
    returned by [n] number of dice *)
val phase_1: State.t -> State.t

(** [phase_2 st] is the updated [st'] modified to reflect the income 
    each player earns depending on current player [p]'s roll value, that is 
    [Player.calc_roll st]*)
val phase_2: State.t -> State.t 

(** [phase_3 st] updates the current [st] to reflect the choice whether to 
    purchase an establishment or not. *)
val phase_3: State.t -> State.t 