package AI;

import AI.AIhelpers.*;
import Components.*;
import java.util.LinkedList;

/*
 * A wrapper class for state, including parameters for MCTS including:
 *  - playeri: current player of this node
 *  - visitn: number of simulations after this node 
 *  - winn: number of wins after this node; 
 */ 
public class TreeState {
	State state; // game state
	int playeri; // current player of this node
	int visitn; // number of simulations after this node
	double winn; // (current player - 1) % totalplayers after this node
	
	
	public TreeState(State st, int vn, double wn) {
		state = st;
		playeri = state.get_current_player_int();
		visitn = vn;
		winn = wn;
	}
	
	/*
	 * Use when initializing a new node. visitn, winn will be 0
	 */
	public TreeState(State st) {
		state = st;
		playeri = state.get_current_player_int();
		visitn = 0;
		winn = (double)0;
	}

	
	public State getState() {
		return state;
	}
	public int getPlayeri() {
		return playeri;
	}
	public int getvisitn() {
		return visitn;
	}
	public double getwinn() {
		return winn;
	}
	
	public void setvisitn(int vn) {
		visitn = vn;
	}
	public void setwinn(int wn) {
		winn = wn;
	}
	public void setState(State st) {
		state = st;
		playeri = state.get_current_player_int();
	}
		
	/*
	 * Starting from current state, obtain the list of states that the game could
	 * end up in. Then, updates each players' bank using expected profit.
	 * For the root node, this will return a valid set of child nodes, though
	 * the resulting banks will be an estimate.
	 * Each state will be in phase 3.
	 */
	public LinkedList<TreeState> childStates() throws Exception {
		// if this is a state already won, make sure no children returned
		if (state.win_condition() != -1) return new LinkedList<TreeState>();
		
		Player currplayer = state.get_current_player();
		int currlandsn = currplayer.get_landmarks().size();
		boolean one_left = state.get_landmark_cards().size()-currlandsn==1;
		
		// first, determine resulting states for all possible purchases made by current player
		// cannot change currplayer here because that would buy for next player
		LinkedList<Landmark> landops = AIhelpers.landmarksUnownedPurchasable(state,currplayer);

		LinkedList<State> children = AIhelpers.childStatesL(state, landops);

		if (one_left && children.size() == 1) {
			
			LinkedList<State> children2 = new LinkedList <State> ();
			// change the current player for each state
			for (State s : children) children2.add(State.nextTurn(s));
			
			
			// change the players' banks, convert to treestate
			LinkedList<TreeState> childTS = new LinkedList<TreeState>();
			for(State s: children2) {
				s.update_scash();
				
				childTS.add(new TreeState(s));
			}
			
			return childTS;
		}


		// TODO: case where this would be wrong? is there ever a situation 
		// you would prefer not to buy anything, even if you can buy everything?
		LinkedList<Establishment> estops = new LinkedList<Establishment>();
		if (currplayer.get_fcash() < 30) {
			estops = AIhelpers.estOpsPurchasable(state, currplayer);
			estops = AIhelpers.uniqueEst(estops);
			LinkedList<State> childrenE = AIhelpers.childStatesE(state, estops);
			children.addAll(childrenE);
			
			State temp = State.copyOf(state);
			children.add(temp);
		}
		
		// **************** BEGIN DEBUGGING ******************
		
//		System.out.println(
//				state.get_current_player().get_id() + " has " + 
//						state.get_current_player().get_fcash() + " coins. || " + 
//						currplayer.get_assets().size()+", "+currplayer.get_landmarks().size());
//		System.out.println("");
//		for (Establishment e : currplayer.get_assets()) {
//			System.out.print(e.get_name() + "; ");
//		}
//		System.out.println("");
//		for (Landmark e : currplayer.get_landmarks()) {
//			System.out.print(e.get_name() + "; ");
//		}
//		
//		System.out.println(state.get_available_cards().size());
//		System.out.println(state.get_landmark_cards().size());
//		double sum2 = 0;
//		for (Establishment e : currplayer.get_assets()) {
//			sum2 += Heuristics.curr_playEstVal(state, currplayer, e);
//		}
//		System.out.println("\n with income: " + sum2 + " AKA " + (int)(sum2+0.5));
//		System.out.println("\t Establishments purchasable \n");
//		for (Establishment e : estops) {
//			System.out.println("  \t> "+ e.get_constructionCost() + " : " + e.get_name());
//		}
//		System.out.println("\t Landmarks purchasable \n");
//		for (Landmark l : landops) {
//			System.out.println("  \t> "+ l.get_constructionCost() + " : " + l.get_name());
//		}
//		if (state.get_current_player().get_fcash() == 0) {
//			System.out.println("ERROR: p has " + state.get_current_player().get_fcash() + " coins.");
//			System.out.println("\t Establishments owned");
//			for (Establishment e : currplayer.get_assets()) {
//				System.out.println("  \t> "+ e.get_constructionCost() + " : " + e.get_name());
//			}
//			System.out.println("\n\t Landmarks owned");
//			for (Landmark l : currplayer.get_landmarks()) {
//				System.out.println("  \t> "+ l.get_constructionCost() + " : " + l.get_name());
//			}
//			double sum = 0;
//			for (Establishment e: currplayer.get_assets()) {
//				sum += Heuristics.curr_playEstVal(state, currplayer, e);
//			}
//			System.out.println("\n with income: " + sum + " AKA " + (int)(sum+0.5));
//
//			throw new Exception("currp is broke");
//		}
		// **************** END DEBUGGING ********************


		

		LinkedList<State> children2 = new LinkedList <State> ();
		// change the current player for each state
		for (State s : children) children2.add(State.nextTurn(s));
		
		
		// change the players' banks, convert to treestate
		LinkedList<TreeState> childTS = new LinkedList<TreeState>();
		for(State s: children2) {
			s.update_scash();
			
			childTS.add(new TreeState(s));
		}
		
		return childTS;
	}
	
	public void increment_visitn() {
		visitn += 1; 
	}
	
	public void add_winn(double n) {
		winn += n; 
	}
}
