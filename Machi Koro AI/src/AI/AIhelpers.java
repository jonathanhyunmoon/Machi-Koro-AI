package AI;
import java.util.LinkedList;

import Components.*;

public class AIhelpers {
	/* Given the original state origst, return a new state
	 * reflecting the resulting state after the AI has made a decision
	 * in phase 3.
	 * This implementation first chooses the landmark with the highest
	 * expected value, which is approximated by the price. If not enough
	 * coins are owned to purchase a landmark, then it chooses the highest price
	 * establishment.
	 */
	public static State make_decision(State origst) {
		Player player = origst.get_current_player();

		// assuming not all landmarks are owned, ie LandOptions is not empty.
		// this would mean the player won
		LinkedList<Landmark> LandOptions = landmarksUnownedPurchasable(origst,player);
		int LandOpsSize = LandOptions.size();

		if (LandOpsSize != 0) { // will purchase a landmark in this turn
			Landmark bestop = LandOptions.get(0);
			for (int i = 0; i < LandOpsSize; i++) {
				Landmark testop = LandOptions.get(i);
				if (testop.get_constructionCost() > bestop.get_constructionCost()) {
					bestop = testop;
				}
			}

			origst.purchase_landmark(bestop);
			return origst;
		}

		// purchase an establishment
		LinkedList<Establishment> estOps = estOpsPurchasable(origst, player);
		if (estOps.isEmpty()) return origst; // return origst if no options to purchase
		LinkedList<Establishment> uniOps = uniqueEst(estOps);
		LinkedList<Establishment> maxOps = maxEsts(uniOps);

		int estopssize = maxOps.size();
		int index = (int)(Math.random()*estopssize);

		Establishment bestest = maxOps.get(index);

		origst.purchase_establishment(bestest);
		return origst;

	}

	/*
	 * Returns the resulting list of states after the current player in st
	 * purchases each of the list of establishments
	 */
	public static LinkedList<State> childStatesE(State st, LinkedList<Establishment> ests) {
		LinkedList<State> children = new LinkedList<State>();

		State temp = st;
		for (Establishment est : ests) {
			temp.purchase_establishment(est);
			children.add(temp);
			temp = st;
		}

		//		children.add(st);
		return children;
	}

	/*
	 * Returns the resulting list of states after the current player in st
	 * purchases each of the list of landmarks
	 */
	public static LinkedList<State> childStatesL(State st, LinkedList<Landmark> lands) {
		LinkedList<State> children = new LinkedList<State>();

		State temp = st;
		for (Landmark land : lands) {
			temp.purchase_landmark(land);
			children.add(temp);
			temp = st;
		}

		//		children.add(st);
		return children;
	}

	/* returns a LinkedList of landmarks not owned and purchasable
	 * by player p
	 */
	public static LinkedList<Landmark> landmarksUnownedPurchasable(State st, Player p) {
		LinkedList<Landmark> landsnotowned = new LinkedList<Landmark>();
		LinkedList<Landmark> landsowned = p.get_landmarks();
		LinkedList<Landmark> alllands = st.get_landmark_cards();

		int cash = p.get_cash();

		int totallands = alllands.size();
		for (int i = 0; i < totallands; i++) {
			Landmark curr = alllands.get(i);
			if (!landsowned.contains(curr) && curr.get_constructionCost() <= cash) landsnotowned.add(curr);
		}

		return landsnotowned;
	}

	/* returns a LinkedList of establishments not owned and purchsable
	 * by player p
	 * maybe dont add to list 2 dice establishments if train station unowned?
	 */
	public static LinkedList<Establishment> estOpsPurchasable(State st, Player p) {
		LinkedList<Establishment> estOps = new LinkedList<Establishment>();
		LinkedList<Establishment> allest = st.get_available_cards();
		int cash = p.get_cash();

		int allestsize = allest.size();
		for (int i = 0; i < allestsize; i++) {
			Establishment curr = allest.get(i);
			if (curr.get_constructionCost() <= cash) estOps.add(curr);
		}
		return estOps;
	}

	/* returns a LinkedList of establishments with only unique elements
	 */
	public static LinkedList<Establishment> uniqueEst(LinkedList<Establishment> est) {
		int size = est.size();
		LinkedList<Establishment> uniEst = new LinkedList<Establishment>();
		for (int i = 0; i < size; i++) {
			Establishment curr = est.get(i);
			if (!uniEst.contains(curr)) uniEst.add(curr);
		}
		return uniEst;
	}

	/* given a LinkedList of establishments, returns a LinkedList
	 * with only the highest price establishment(s).
	 * If multiple establishments have the same highest price, 
	 * they are all returned.
	 */
	public static LinkedList<Establishment> maxEsts(LinkedList<Establishment> est) {
		int size = est.size();
		LinkedList<Establishment> maxEsts = new LinkedList<Establishment>();
		int max = 0;
		for (int i = 0; i < size; i++) {
			Establishment curr = est.get(i);
			int currcost = curr.get_constructionCost();
			if (currcost > max) {
				maxEsts.clear();
				maxEsts.add(curr);
				max = currcost;
			}
			else if (currcost == max) {
				maxEsts.add(curr);
			}
		}
		return maxEsts;
	}

	/*
	 * Updates the current player's cash with an addition of the total sum of the expected values of the cards it currently holds
	 */
	public void updateCash(State st, Player p) {
		float sum = (float) 0; 
		for (Establishment e: p.get_assets()) {
			sum += Heuristics.estVal(st, p, e);
		}
		for (Landmark l: p.get_landmarks()) {
			sum+= Heuristics.landmark_values(st, p, l); 
		}
		
		p.add_cash((int)sum);
		
	}



}




