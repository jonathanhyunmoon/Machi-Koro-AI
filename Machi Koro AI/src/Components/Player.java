package Components;
import java.util.LinkedList;

import AI.Heuristics;

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
	private double fcash;
	private LinkedList <Establishment> assets;
	private LinkedList <Landmark> landmarks;
	private int order;

	public Player(String i, int nd, LinkedList <Integer> dr, int c, LinkedList <Establishment> a, 
			LinkedList <Landmark> l, int o) {
		id = i;
		num_dice = nd;
		dice_rolls = dr;
		cash = c;
		fcash = (double) c;
		assets = a;
		landmarks = l;
		order = o;
	}
	public Player(String i, int nd, LinkedList <Integer> dr, double c, LinkedList <Establishment> a, 
			LinkedList <Landmark> l, int o) {
		id = i;
		num_dice = nd;
		dice_rolls = dr;
		cash = 0;
		fcash = (double) c;
		assets = a;
		landmarks = l;
		order = o;
	}
	
	public static Player copyOf(Player p) throws Exception {
		LinkedList<Establishment> assetscpy = new LinkedList<Establishment>();
		for (Establishment e : p.get_assets()) {
			Establishment cpy = Establishment.copyOf(e);
			assetscpy.add(cpy);
		}
		
		LinkedList<Landmark> landscpy = new LinkedList<Landmark>();
		for (Landmark l : p.get_landmarks()) {
			Landmark cpy = Landmark.copyOf(l);
			landscpy.add(cpy);
		}
		
		Player temp = new Player(p.get_id(),
				p.get_num_dice(),
				p.get_dice_rolls(),
				p.get_fcash(),
				assetscpy,
				landscpy,
				p.get_order());
		
		return temp;
	}
	
	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || this.getClass() != o.getClass()) {
            return false;
        }
		Player p = (Player) o;
		return this.order == p.get_order();
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
	public double get_fcash() {
		return fcash;
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
		double const_cost = est.get_constructionCost();
		fcash -= const_cost; 
	}

	public void purchase_landmarks (Landmark lm) {
		landmarks.add(lm);
		double const_cost = lm.get_constructionCost();
		fcash -= const_cost;
	}
	
	public void purchase_assets_end (Establishment est) {
		assets.add(est);
		int const_cost = est.get_constructionCost();
		cash -= const_cost; 
	}

	public void purchase_landmarks_end (Landmark lm) {
		landmarks.add(lm);
		int const_cost = lm.get_constructionCost();
		cash -= const_cost;
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
			if (e.get_name().equals(cardname)) sum++;
		}
		return sum;
	}

	public boolean has_TrainSt() {
		for (Landmark l : landmarks) {
			if (l.get_name().equals("Train Station")) return true;
		}
		return false; 
	}

	public boolean has_Harbor() {
		for (Landmark l: landmarks) {
			if (l.get_name().equals("Harbor")) return true;
		}
		return false;
	}
	public boolean has_Land(String s) {
		for (Landmark l: landmarks) {
			if (l.get_name().equals(s)) return true;
		}
		return false;
	}

	public int num_type(String type) {
		int sum = 0;
		for (Establishment e : assets) {
			if (e.get_cardType().equals(type)) sum++;
		}
		return sum; 
	}

	public int num_cup_bread() {
		return num_type("Cup") + num_type("Bread");
	}
	
	public void add_cash (double c) {
		this.fcash += (double) c;
	}
	
	public void subtract_cash (double c) {
		this.fcash -= (double) c;
	}
	
}







