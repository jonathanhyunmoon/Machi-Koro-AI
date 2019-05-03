package AI;
import java.util.LinkedList;
import java.util.HashMap;

import Components.*;

/*
 * When deciding what cards to purchase, use valueAvg.
 * However when deciding how many dice to roll (and possibly other non-purchase
 * moves) the multiplier does not take effect so just use baseval (i think),
 * summing all the values for one dice vs two.
 */
public class Heuristics {
	
	public static int valueOneD(State s, Player p, Landmark c) {
		
		return 0;
	}
	
	/*
	 * For one die:
	 * Returns the "dynamic" value of a card, based on the expected value of the
	 * profit, as well as any "multiplying" cards Player p may own.
	 * Value does not depend on p's bank, only on expected value based on p's
	 * cards (multipliers and train station).
	 * Lowest possible value is 0, ie buying a card cannot hurt you.
	 * Use when evaluating a possible purchase, not for when the card is owned
	 * The base val (1 dice) is added to the multipliers owned, giving dynamic val
	 */
	public static float valueOneD(State s, Player p, Establishment c) {
		int num_players = s.get_players().size();
		
		// possible optimization: manually enter each probability
		// may not matter since baseVal is O(1)
		
		boolean harborowned = containsNameL(p.get_landmarks(),"Harbor");
		String cname = c.get_name();
		boolean harbortype = (cname == "Sushi Bar");
		if (!harborowned && harbortype) return 0;
		
		LinkedList<Integer> actnums = c.get_activation_numbers();
		String cind = c.get_industry();
			
		int income;
		float baseVal; 
		if (cind == "Primary") { // blue cards. value does not change with # players			
			income = c.get_effect().get_value(); 
			baseVal = baseVal(actnums,income,1);
			return baseVal * 1; 
		} else if (cind == "Secondary") { // green 
			income = c.get_effect().get_value();
			baseVal = baseVal(actnums, income, 1);
			return baseVal * 1/ (num_players);
		} else if (cind == "Restaurant") {
			income = c.get_effect().get_value();
			baseVal = baseVal(actnums, income, 1);
			return baseVal * (num_players-1) / num_players; 
		} else {
			 income = c.get_effect().get_value(); 
			 switch (cname) {
				 case "Stadium":
					 income = income * num_players;
				 case "Business Center": 
					 income = 
			 }
			 baseVal = baseVal (actnums, income, 1); 
			 
			 // purple card implementation 
		}
	}
	
	
	
	
		
				
				
				
				
				
				mult = p.num_card("Furniture Factory");
				return baseVal + mult*((float)5/36)*3; // use 5/36 instead of baseval to avoid unnecessary calls
			case "Wheat Field":
				mult = p.num_card("Fruit and Vegetable Market");
				return baseVal + mult*((float)3/36)*2;
			case "Flower Orchard":
				mult = p.num_card("Fruit and Vegetable Market");
				return baseVal + mult*((float)3/36)*2;
			case "Ranch":
				mult = p.num_card("Cheese Factory");
				return baseVal + mult*((float)6/36)*3;
			default:
				return 0;
			
			}
			
		} else if (cind == "Secondary") { // green cards, only breads
			int nplayers = s.get_players().size();
			switch (cname) {
			case "Bakery":
			case "Convenience Store":
			case "Flower Shop":
			default:
				return 0;
			}
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
	 * 
	 * ex: probability of rolling a 3 to activate that card * value of that card
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