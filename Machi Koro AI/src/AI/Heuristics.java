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
		if (actnums.get(0) > 6) return 0;
		
		int income = c.
		// possible optimization in the future: hashmap with all expvals
		// HashMap<LinkedList<Integer>,Integer> ExpVals = 
		
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
}