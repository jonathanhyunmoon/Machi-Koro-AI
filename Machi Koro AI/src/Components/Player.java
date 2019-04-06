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
}
