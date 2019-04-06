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
}
