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
	private double fbank;
	private LinkedList <Establishment> available_cards;
	private LinkedList <Landmark> landmark_cards;
	private int current_player;

	public State (LinkedList <Player> ps, int b, LinkedList <Establishment> ac,
			LinkedList <Landmark> lc, int cp) {
		players = ps;
		bank = b;
		fbank = (double) b;
		available_cards = ac;
		landmark_cards = lc;
		current_player = cp;
	}
	public State (LinkedList <Player> ps, double b, LinkedList <Establishment> ac,
			LinkedList <Landmark> lc, int cp) {
		players = ps;
		bank = 0;
		fbank = (double) b;
		available_cards = ac;
		landmark_cards = lc;
		current_player = cp;
	}

	public static State copyOf(State s) throws Exception {
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
		
		State temp = new State(playerscpy,s.get_fbank(),assetscpy,landscpy,s.current_player);
		
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
	public double get_fbank() {
		return fbank;
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
	public Player get_playeri(int i) {
		for (Player p: players) {
			if (p.get_order() == i)
				return p;
		}
		return null;
	}
	public void sub_bank(int i) {
		fbank -= i;
	}

	public void purchase_establishment (Establishment est) {
		available_cards.remove(est);
		double const_cost = est.get_constructionCost();
		fbank += const_cost;

		// updates current player's assets after buying establishment est
		Player new_player = get_current_player();
		new_player.purchase_assets(est);
		remove_current_player(); //maybe not necessary, since no new player made
		players.add(new_player);
	}

	public void purchase_landmark (Landmark lm) {
		double const_cost = lm.get_constructionCost();
		fbank += const_cost;

		// updates current player's assets after buying landmark lm
		Player new_player = get_current_player();
		new_player.purchase_landmarks(lm);
		remove_current_player();
		players.add(new_player);
	}
	
	public void purchase_establishment_end (Establishment est) {
		available_cards.remove(est);
		int const_cost = est.get_constructionCost();
		bank += const_cost;

		// updates current player's assets after buying establishment est
		Player new_player = get_current_player();
		new_player.purchase_assets_end(est);
		remove_current_player(); //maybe not necessary, since no new player made
		players.add(new_player);
	}

	public void purchase_landmark_end (Landmark lm) {
		int const_cost = lm.get_constructionCost();
		bank += const_cost;

		// updates current player's assets after buying landmark lm
		Player new_player = get_current_player();
		new_player.purchase_landmarks_end(lm);
		remove_current_player();
		players.add(new_player);
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
	public static State nextTurn(State s) throws Exception {
		State temp = copyOf(s);
		temp.current_player++;
		temp.current_player %= (temp.get_players().size());
		return temp;
	}

	/*
	 * Updates the current player's cash with an addition of the total sum of
	 * the expected values of the cards it currently holds
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
	public double update_pcash(Player p) throws Exception {
		double sum = (double) 0; 
		double currsteal = (double) 0;
		
		for (Establishment e: p.get_assets()) {
			double value = Heuristics.curr_playEstVal(this, p, e);
			if (e.get_cardType().equals("Restaurant")) currsteal += value;
			sum += value;
		}
		
		fbank -= (sum-currsteal);
		if (fbank <= 0) throw new Exception("bank is broke");
		
		for (Landmark l: p.get_landmarks()) {
			String lname = l.get_name();
			switch(lname) {
			case "Amusement Park":
				sum *= (double)7/6;
				continue;
			case "Radio Tower":
				sum *= 2;
			default:
				sum += Heuristics.curr_playLandmark(this, p, l);
			}
			 
		}

		p.add_cash(sum);
		

		return currsteal;
	}

	/*
	 * Updates State s.t. each player's cash is increased by their expected
	 * values of the cards it currently holds. 
	 */
	public void update_scash() throws Exception {
		double currsteal = (double) 0;
		for (Player p: players) {
			currsteal += update_pcash(p);
		}
		get_current_player().subtract_cash(currsteal);
	}

	/*
	 * Returns order number of player that wins if State s is a winning condition state. 
	 * The winning condition state is defined to be a state where at least one
	 * player has activated all of its landmark cards.
	 * If no player has won, function returns -1. 
	 */
	public int win_condition(){
		LinkedList <Player> players = get_players(); 
		Player currp = get_current_player();
		int currlandsn = currp.get_landmarks().size();
		boolean one_left = landmark_cards.size()-currlandsn==1;


		boolean ret;
		
		for (Player p: players) {
			ret = true;
			LinkedList <Landmark> landmarks = p.get_landmarks(); 
			
			for (Landmark l: landmark_cards) {
				if (one_left && (int)currp.get_fcash()>= l.get_constructionCost()) {
					return currp.get_order();
				}
				if (!landmarks.contains(l)) {
					ret = false;
					break;
				}
			}
			if (ret) return p.get_order(); 
			
		}
		return -1; 
	}
	
	public boolean win_condition_2 () {
		if (win_condition() != -1) return true;
		else return false; 
	}
}