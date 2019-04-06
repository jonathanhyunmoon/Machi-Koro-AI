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
}
