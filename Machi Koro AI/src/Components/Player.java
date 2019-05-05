package Components;
import java.util.LinkedList;

public class Player {
	/*
	 * 	type t = {
	 * 		id: player_id;
	 * 		num_dice: int;
	 * 		dice_rolls: int list;
	 * 		cash: int;
	 * 		assets: Establishment.card list;
	 * 		landmarks: Landmark.card list;
	 * 		order: int
	 * 	}
	 */
	private String id;
	private int num_dice;
	private LinkedList <Integer> dice_rolls;
	private int cash;
	private LinkedList <Establishment> assets;
	private LinkedList <Landmark> landmarks;
	private int order;

	public Player(String i, int nd, LinkedList <Integer> dr, int c, LinkedList <Establishment> a, 
			LinkedList <Landmark> l, int o) {
		id = i;
		num_dice = nd;
		dice_rolls = dr;
		cash = c;
		assets = a;
		landmarks = l;
		order = o;
	}
	public String get_id() {
		return id;
	}
	public int get_num_dice() {
		return num_dice;
	}
	public LinkedList <Integer> get_dice_rolls(){
		return dice_rolls;
	}
	public int get_cash() {
		return cash;
	}
	public LinkedList <Establishment> get_assets(){
		return assets;
	}
	public LinkedList <Landmark> get_landmarks(){
		return landmarks;
	}
	public int get_order() {
		return order;
	}

	public void purchase_assets (Establishment est) {
		assets.add(est);
		int const_cost = est.get_constructionCost();
		cash = cash - const_cost; 
	}

	public void purchase_landmarks (Landmark lm) {
		landmarks.add(lm);
		int const_cost = lm.get_constructionCost();
		cash = cash - const_cost;
	}

	/*
	 * Returns the number of establishments cardname this player has.
	 * Put here instead of in heuristics as it seemed like something you'd ask a person:
	 * "how many furniture factories you have? very big multiplier"
	 * Time complexity: O(n), n is number of establishments player owns
	 */
	public int num_card(String cardname) {
		int sum = 0;
		for (Establishment e : assets) {
			if (e.get_name() == cardname) sum++;
		}
		return sum;
	}

	public boolean has_TrainSt() {
		for (Landmark l : landmarks) {
			String name = l.get_name();
			if (name == "Train Station") return true;
		}
		return false; 
	}

	public boolean has_Harbor() {
		for (Landmark l: landmarks) {
			String name = l.get_name();
			if (name == "Harbor") return true;
		}
		return false;
	}

	public int num_type(String type) {
		int sum = 0;
		for (Establishment e : assets) {
			if (e.get_cardType() == type) sum++;
		}
		return sum; 
	}
	
	public int num_cup_bread() {
		return num_type("Cup") + num_type ("Bread");
	}
}






