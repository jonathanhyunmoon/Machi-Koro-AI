package Components;
import java.util.*;

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
		remove_current_player();
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

}



