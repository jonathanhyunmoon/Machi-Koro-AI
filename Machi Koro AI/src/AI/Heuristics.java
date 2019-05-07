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
	 * Train station unactivated: i.e. Player p can only roll one die 
	 * Returns the "dynamic" value of a card, based on the expected value of the
	 * profit. 
	 * Lowest possible value is 0, i.e. buying a card cannot hurt you.
	 * Use when evaluating a possible purchase, not for when the card is owned.
	 * 
	 */
	public static float valueOneD(State s, Player p, Establishment c) {
		int num_players = s.get_players().size();

		boolean harborowned = p.has_Harbor();
		String cname = c.get_name();
		boolean is_sushi_bar = (cname == "Sushi Bar");
		if (!harborowned && is_sushi_bar) return 0;


		LinkedList<Integer> actnums = c.get_activation_numbers();
		String cind = c.get_industry();


		int income = c.get_effect().get_value();  // how many coins from a card
		float baseVal; 
		if (cind == "Primary") { // blue cards: value does not change with # players	
			baseVal = baseVal(actnums, income, 1);
			if (cname == "Flower Orchard") {
				int num_flowershop = p.num_card("Flower Shop");
				baseVal = baseVal + (num_flowershop * (float)1/6 * 1); 
			}
			return baseVal * 1; 
		} else if (cind == "Secondary") { // green cards: value * fraction of your turn
			if (cname == "Flower Shop") {
				int num_flowerorch = p.num_card("Flower Orchard");
				income = income * num_flowerorch; 
				return baseVal (actnums, income, 1);
			}
			baseVal = baseVal(actnums, income, 1);
			return baseVal * 1/ (num_players);
		} else if (cind == "Restaurant") { // red cards: value * fraction of other players' turns
			baseVal = baseVal(actnums, income, 1);
			return baseVal * (num_players-1) / num_players; 
		} else { // NOTE: VALUE ACTUALLY PROB. MORE BC TAKING FROM SOMEONE vs. TAKING FROM BANK
			// purple cards: value * fraction of your turn
			switch (cname) {
			case "Stadium": // 
				income = income * num_players;
			case "Business Center": 
				income = 8; 
			case "TV Station": 
				income += 0; 
			}
			baseVal = baseVal (actnums, income, 1); 
			return baseVal * 1/ (num_players);
		}
	}

	/*
	 * Train station activated: i.e. Player p can only roll two dice
	 * Returns the "dynamic" value of a card, based on the expected value of the profit.
	 * Lowest possible value is 0, i.e. buying a card cannot hurt you.
	 * Use when evaluating a possible purchase, not for when the card is owned.
	 * 
	 */
	public static float valueTwoD(State s, Player p, Establishment c) {

		LinkedList<Integer> actnums = c.get_activation_numbers();
		int num_players = s.get_players().size();
		String cind = c.get_industry();

		boolean harborowned = p.has_Harbor();
		String cname = c.get_name();
		boolean harbortype = (cname == "Sushi Bar" || cname == "Mackarel Boat" || cname == "Tuna Boat");
		if (!harborowned && harbortype) return 0;

		int income = c.get_effect().get_value();  // how many coins from a card

		float baseVal; 
		if (cind == "Primary") { // Blue cards	
			baseVal = baseVal (actnums, income, 2); 
			String type = c.get_cardType();

			if (type == "Wheat") {
				int num_fruit_veg = p.num_card("Fruit and Vegetable Market");
				baseVal += (float) 1/12 * 2 * num_fruit_veg;
			}

			if (type == "Gear") {
				int num_furniture = p.num_card("Furniture Factory");
				baseVal += (float) 5/36 * 3 * num_furniture;
			}

			if (type == "Cow") {
				int num_cheese_fact = p.num_card("Cheese Factory");
				baseVal += (float) 1/6 * 3 * num_cheese_fact;
			}

			if (cname == "Flower Orchard") {
				if (cname == "Flower Orchard") {
					int num_flowershop = p.num_card("Flower Shop");
					baseVal += (float)5/36 * 1 * num_flowershop;
				}
			}

			if(cname == "Tuna Boat") {
				int num_trainst_players = s.num_trainst_players(); 

				int num_train_harbor_players = s.num_harbor_train_players();
				int num_train_noharbor_players = num_trainst_players - num_train_harbor_players;

				float harbor_frequency = (float) 1/2;  // how frequent a player uses their harbor to add 2 to their rolled val 

				// rolling a 10  -> choice of 10 or 12
				float roll_10  = ((0 * (float) 1/12 + 12 * (float) 1/12) * harbor_frequency * num_train_harbor_players/ num_players); 
				// rolling a 11  -> choice of 11 or 13
				float roll_11 = ((0 * (float) 1/18 + 13 * (float) 1/18) * harbor_frequency * num_train_harbor_players/ num_players);
				// rolling a 12  -> choice of 12 or 14 or automatic 12 for train no harbor players
				float roll_12 = ((12 * (float) 1/36 + 14 * (float) 1/36) * harbor_frequency * num_train_harbor_players/ num_players) + 
						12 * (float) 1/36 * num_train_noharbor_players/ num_players;  // rolling a 12 

				return roll_10 + roll_11 + roll_12;
			}
			return baseVal * 1;
		} else if (cind == "Secondary") { // Green cards
			if (cname == "Furniture Factory") {
				int num_gear = p.num_type("Gear"); 
				income *= num_gear; 
			} else if (cname == "Fruit and Vegetable Market") {
				int num_wheat = p.num_type("Wheat");
				income *= num_wheat;	
			} else if (cname == "Cheese Factory") {
				int num_cow = p.num_type("Cow");
				income *= num_cow; 				
			} else if (cname == "Flower Shop"){
				int num_flowerorch = p.num_card("Flower Orchard");
				income *= num_flowerorch; 
			} else if (cname == "Food Warehouse") {
				int num_cup = p.num_type ("Cup");
				income *= num_cup;
			}
			baseVal = baseVal(actnums, income, 2) ;
			return baseVal * 1/ (num_players);
		} else if (cind == "Restaurant") {
			baseVal = baseVal (actnums, income, 2); 
			return baseVal * (num_players -1) / (num_players); 
		} else {// NOTE: VALUE ACTUALLY PROB. MORE BC TAKING FROM SOMEONE vs. TAKING FROM BANK
			// purple cards: value * fraction of your turn
			switch (cname) {
			case "Stadium":
				income = income * num_players;
			case "Business Center": 
				income = 8; 
			case "TV Station": 
				income += 0;
			case "Publisher": 
				int mult = s.total_cup_bread() - p.num_cup_bread(); 
				income *= mult; 
			case "Tax Office": 
				income = 4; 
			}
			baseVal = baseVal (actnums, income, 2); 
			return baseVal * 1/ (num_players);
		}
	}

	public static float landmark_values (State s, Player p, Landmark l) {
		return NULL; 
	}

	public static float valueAvg(State s, Player p, Establishment e) {
		return (valueOneD(s,p,e) + valueTwoD(s, p, e))/2; 
	}

	/*
	 * Returns the establishment that has the highest reward, calculated by the valueOneD and value TwoD function, 
	 * for player p in State s.
	 * 
	 * Takes into account how many dice player p can roll. 
	 */
	public static Establishment highest_Establishment(State s, Player p) {
		HashMap <Establishment, Float> landmarks_rewards = new HashMap <Establishment, Float>();

		boolean has_trainSt = p.has_TrainSt(); 

		Establishment highest_reward = s.get_available_cards().element();
		float highest_reward_val = (float) 0; 
		float reward_val; 

		for (Establishment e: s.get_available_cards()) {
			if (!has_trainSt) {
				reward_val = valueOneD(s,p,e); 
				landmarks_rewards.put(e, reward_val);

			} else {
				reward_val = (valueOneD(s,p,e) + valueTwoD(s, p, e))/2;
				landmarks_rewards.put(e, reward_val);
			}
			if (reward_val > highest_reward_val) {
				highest_reward_val = reward_val; 
				highest_reward = e;
			}			
		}
		return highest_reward;
	}


	/*
	 * Returns the "non-dynamic" expected value of a linkedlist of
	 * activation numbers. Accounts for number of dice.
	 * 
	 * expected value =  probability of rolling activation number(s) of card * value of card
	 * where the value of a card is defined to be the number of coins you are expected to
	 * get from that card if its activation number is rolled.
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