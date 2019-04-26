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
	 */
	public static int valueOneD(State s, Player p, Establishment c) {
		LinkedList<Integer> actnums = c.get_activation_numbers();
		
		if (c.get_industry() == "Primary") { // blue cards
			int income = c.get_effect().get_value(); 
			float expval = expVal(actnums,income,p.get_num_dice());
		}
		
		return 0;
	}
	
	public static int valueTwoD(State s, Player p, Landmark c) {
		return 0;
	}
	
	public static int valueTwoD(State s, Player p, Establishment c) {
		LinkedList<Integer> actnums = c.get_activation_numbers();
		if (actnums.get(0) == 1) return 0;
		return 0;
	}
	
	public static int valueAvg(State s, Player p, Landmark c) {
		return 0;
	}
	
	public static int valueAvg(State s, Player p, Establishment c) {
		return 0;
	}
	
	/*
	 * Returns the "non-dynamic" expected value of a linkedlist of
	 * activation numbers. Accounts for number of dice.
	 */
	public static float expVal(LinkedList<Integer> actnums, int income, int numdice) {
		if (numdice == 1) { // one die
			if (actnums.get(0) > 6) return 0;
			if (actnums.size() == 1) return (float) income * (float) 1 / 6;
			return (float) income * (float) 2 / 6;
		}
		// two dice
		else if (actnums.get(0) == 1) return 0;
		float probtotal = 0;
		for (Integer actnum : actnums) {
			int dist = Math.abs(7-actnum);
			probtotal += (float) (6-dist) / 36;
		}
		return probtotal * income;
	}
}