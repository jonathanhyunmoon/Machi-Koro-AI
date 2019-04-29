package AI;
import java.util.LinkedList;
import java.util.HashMap;

import Components.*;

public class Heuristics {
	
	public static int valueOneD(State s, Player p, Landmark c) {
		
		return 0;
	}
	
	/*
	 * Returns the "dynamic" value of a card, based on the expected value of the
	 * profit, as well as any "multiplying" cards Player p may own.
	 * Value does not depend on p's bank, only on expected value based on p's
	 * cards (multipliers and train station).
	 * Lowest possible value is 0, ie buying a card cannot hurt you.
	 */
	public static float valueOneD(State s, Player p, Establishment c) {
		// possible optimization: manually enter each probability
		// may not matter since baseVal is O(1)
		LinkedList<Integer> actnums = c.get_activation_numbers();
		String cind = c.get_industry();
		if (cind == "Primary") { // blue cards. value does not change with # players
			boolean harborowned = containsNameL(p.get_landmarks(),"Harbor");
			String cname = c.get_name();
			boolean harbortype = (cname == "Sushi Bar" || cname == "Macakrel Boat" || cname == "Tuna Boat");
			if (!harborowned && harbortype) return 0;
			
			int income = c.get_effect().get_value(); 
			float baseVal = baseVal(actnums,income,p.get_num_dice());
			
			int mult = 0;
			switch (c.get_name()) {
			case "Mine":
				mult = p.num_card("Furniture Factory");
				return baseVal + mult*((float)5/36)*3; // use 5/36 instead of baseval to avoid unnecessary calls
			case "Forest":
				mult = p.num_card("Furniture Factory");
				return baseVal + mult*((float)5/36)*3;
			
			}
			
		} else if (cind == "Secondary") {
			
		}
		
		return (float)0.0;
	}
	
	public static float valueTwoD(State s, Player p, Landmark c) {
		return 0;
	}
	
	public static float valueTwoD(State s, Player p, Establishment c) {
		LinkedList<Integer> actnums = c.get_activation_numbers();
		if (actnums.get(0) == 1) return 0;
		return 0;
	}
	
	/*
	 * Returns the total expected value of Landmark c.
	 * Use if the train station is owned.
	 */
	public static float valueAvg(State s, Player p, Landmark c) {
		return 0;
	}
	
	public static float valueAvg(State s, Player p, Establishment c) {
		return 0;
	}
	
	/*
	 * Returns the "non-dynamic" expected value of a linkedlist of
	 * activation numbers. Accounts for number of dice.
	 */
	public static float baseVal(LinkedList<Integer> actnums, int income, int numdice) {
		if (numdice == 1) { // one die
			if (actnums.getFirst() > 6) return 0;
			if (actnums.size() == 1) return (float) income * (float) 1 / 6;
			return (float) income * (float) 2 / 6;
		}
		// two dice
		else if (actnums.getFirst() == 1) return 0;
		float probtotal = 0;
		for (Integer actnum : actnums) {
			int dist = Math.abs(7-actnum);
			probtotal += (float) (6-dist) / 36;
		}
		return probtotal * income;
	}
	
	/*
	 * Returns true if the list of establishments space contains an establishment
	 * named s, false otherwise.
	 * Time complexity: O(n), n is length of space
	 */
	public static boolean containsName(LinkedList<Establishment> space, String s) {
		for (Establishment e : space) {
			if (e.get_name() == s) return true;
		}
		return false;
	}
	/*
	 * Returns true if the list of landmarks space contains a landmark
	 * named s, false otherwise.
	 * Time complexity: O(n), n is length of space
	 */
	public static boolean containsNameL(LinkedList<Landmark> space, String s) {
		for (Landmark l : space) {
			if (l.get_name() == s) return true;
		}
		return false;
	}
}