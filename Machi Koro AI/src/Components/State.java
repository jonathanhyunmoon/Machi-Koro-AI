package Components;
import java.util.*;

import AI.AIhelpers;
import AI.Heuristics;

public class State {
	/*
	 * 	type t = {
	 * 		players: Player.t list;
	 * 		bank: int;
	 * 		available_cards: Establishment.card list;
	 *  	current_player : int;
	 *  	landmark_cards: Landmark.card list
	 * 	}
	 */
	private LinkedList <Player> players;
	private int bank;
	private LinkedList <Establishment> available_cards;
	private LinkedList <Landmark> landmark_cards;
	private int current_player;

	public State (LinkedList <Player> ps, int b, LinkedList <Establishment> ac,
			LinkedList <Landmark> lc, int cp) {
		players = ps;
		bank = b;
		available_cards = ac;
		landmark_cards = lc;
		current_player = cp;
	}

	public static State copyOf(State s) {
		LinkedList<Player> playerscpy = new LinkedList<Player>();
		for (Player p : s.get_players()) {
			Player cpy = Player.copyOf(p);
			playerscpy.add(cpy);
		}
		
		LinkedList<Establishment> assetscpy = new LinkedList<Establishment>();
		for (Establishment e : s.get_available_cards()) {
			Establishment cpy = Establishment.copyOf(e);
			assetscpy.add(cpy);
		}
		
		LinkedList<Landmark> landscpy = new LinkedList<Landmark>();
		for (Landmark l : s.get_landmark_cards()) {
			Landmark cpy = Landmark.copyOf(l);
			landscpy.add(cpy);
		}
		
		State temp = new State(playerscpy,s.bank,assetscpy,landscpy,s.current_player);
		
		return temp;
	}

	public String toString() {
		String temp="";
		temp+= "number of players: " + players.size() + "\n";
		temp+= "bank: " + bank + "\n";
		temp+= "number of available cards: " + available_cards.size() + "\n";
		temp+= "current_player: " + current_player;

		return temp;
	}
	public LinkedList <Player> get_players(){
		return players;
	}
	public int get_bank() {
		return bank;
	} 
	public LinkedList <Establishment> get_available_cards(){
		return available_cards;
	}
	public LinkedList <Landmark> get_landmark_cards(){
		return landmark_cards;
	}
	public int get_current_player_int() {
		return current_player;
	}
	public Player get_current_player() {
		for (Player p: players) {
			if (p.get_order() == current_player)
				return p;
		}
		return null;
	}

	public void purchase_establishment (Establishment est) {
		available_cards.remove(est);
		int const_cost = est.get_constructionCost();
		bank = bank + const_cost;

		// updates current player's assets after buying establishment est
		Player new_player = get_current_player();
		new_player.purchase_assets(est);
		remove_current_player(); //maybe not necessary, since no new player made
		players.add(new_player);
	}

	public void purchase_landmark (Landmark lm) {
		int const_cost = lm.get_constructionCost();
		bank = bank + const_cost;

		// updates current player's assets after buying landmark lm
		Player new_player = get_current_player();
		new_player.purchase_landmarks(lm);
		remove_current_player();
		players.add( new_player);
	}

	public void remove_current_player() {
		for(int i = 0; i < players.size(); i++) {
			if (players.get(i).get_order() == current_player)
				players.remove(i);
		}
	}
	/* Returns the number of players with train station activated.  
	 */
	public int num_trainst_players() {
		int count = 0;
		for (Player p: players) {
			if (p.has_TrainSt()) count ++; 
		}
		return count; 
	}

	public int num_harbor_players() {
		int count = 0;
		for (Player p: players) {
			if (p.has_Harbor()) count ++; 
		}
		return count; 
	}

	public int num_harbor_train_players() {

		int count = 0;
		for (Player p: players) {
			if (p.has_Harbor() && p.has_TrainSt()) count ++; 
		}
		return count; 
	}

	public int total_cup_bread() {
		int count = 0;
		for (Player p: players) {
			count += p.num_cup_bread();
		}
		return count;
	}

	/*
	 * nextTurn(s) returns a copy of a s with the current_player field of the
	 * state updated to be the next player
	 */
	public static State nextTurn(State s) {
		State temp = copyOf(s);
		temp.current_player++;
		temp.current_player %= (temp.get_players().size());
		return temp;
	}

	/*
	 * Updates the current player's cash with an addition of the total sum of
	 * the expected values of the cards it currently holds
	 * 
	 * TODO: implement the following:
	 * Add: expval of primary always, expval of secondary if p == currp,
	 * 		expval of restaurant if p != currp, expval of purple if p == currp
	 * Subtract: total expval of restaurants of other players if p == currp
	 * 
	 * Account for bank accordingly
	 * 
	 * pitfalls:
	 *  - assumes stealing-type cards always obtain full value
	 *  - assumes a constant income, which might mean that some purchases made
	 *  	might not actually be possible depending on dice roll. possibly the
	 *  	biggest problem with our MCTS currently.
	 *  	fortunately, the call to childNodes on the root node in the expand
	 *  	phase still returns a valid set of children, as it uses the real
	 *  	banks of players. however, the banks of the children use this
	 *  	estimate.
	 */
	public static void update_pcash(State st, Player p) {
		double sum = (double) 0; 
		double subtract = (double) 0;
		Player currp = st.get_current_player();
		
		
		
		for (Establishment e: p.get_assets()) {
			if (e.get_cardType() == "Restaurant") { 
				subtract += Heuristics.curr_playEstVal(st, p, e);
			}
			sum += Heuristics.curr_playEstVal(st, p, e);
		}
		for (Landmark l: p.get_landmarks()) {
			sum+= Heuristics.curr_playLandmark(st, p, l); 
		}

		p.add_cash((int)(sum+0.5));
		LinkedList <Player> players = st.get_players(); 
		for (Player p1 : players) {
			if (p1 != p) p1.subtract_cash((int) (subtract+0.5)); 
		}

	}

	/*
	 * Updates State s s.t. each player's cash is increased by their expected
	 * values of the cards it currently holds. 
	 */
	public static void update_scash(State s) {
		LinkedList <Player> players = s.get_players();
		for (Player p: players) {
			update_pcash(s, p);
		}
	}

	/*
	 * 
	 * Returns order number of player that wins if State s is a winning condition state. 
	 * The winning condition state is defined to be a state where at least one
	 * player has activated all of its landmark cards.
	 * If no player has won, function returns -1. 
	 */
	public int win_condition(){
		LinkedList <Player> players = get_players(); 
		int winner = -1; 
		for (Player p: players) {
			boolean ret = true;
			LinkedList <Landmark> landmarks = p.get_landmarks(); 
			LinkedList <Landmark> all_landmarks = get_landmark_cards();
			for (Landmark l: all_landmarks) {
				if (landmarks.indexOf(l) == -1) ret = false; 
			}
			if (ret) return p.get_order(); 
		}
		return winner; 
	}
	
	public boolean win_condition_2 () {
		if (win_condition() != -1) return true;
		else return false; 
	}
}