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
		return players.get(current_player);
	}
	
	public void purchase_establishment (Establishment est) {
		available_cards.remove(est);
		int const_cost = est.get_constructionCost();
		bank = bank + const_cost;
		
		// updates current player's assets after buying establishment est
		Player new_player = get_current_player();
		new_player.purchase_assets(est);
		players.remove(current_player);
		players.add(current_player, new_player);
	}
	
	public void purchase_landmark (Landmark lm) {
		landmark_cards.remove(lm);
		int const_cost = lm.get_constructionCost();
		bank = bank + const_cost;
		
		// updates current player's assets after buying landmark lm
		Player new_player = get_current_player();
		new_player.purchase_landmarks(lm);
		players.remove(current_player);
		players.add(current_player, new_player);
	}
	
	
}
