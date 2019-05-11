package AI;

import java.util.*;
public class UCT {
	/*
	 * Implementation of the exploration vs exploitation function.
	 * Note, unexplored nodes (n == 0) are explored first. The formula is
	 * otherwise identical.
	 * source: https://en.wikipedia.org/wiki/Monte_Carlo_tree_search#Exploration_and_exploitation
	 */
	public static double UCT_value(int t, double w, int n,Node parent, Node child) {
		if(n == 0) return Integer.MAX_VALUE;
		
		double landbuff = Integer.MAX_VALUE;
		int parentlands = parent.get_TS().getState().get_landmark_cards().size();
		int childlands = child.get_TS().getState().get_landmark_cards().size();
		if (!(parentlands < childlands)) landbuff = 1;
		
		double success_rate = ((double) w)/((double) n);
		double c = Math.sqrt(2); // exploration parameter
		double exploration_factor = c* Math.sqrt(Math.log(t) / (double) n);
		System.out.println("UCT VALUE IS: " + success_rate + exploration_factor);
		return landbuff * (success_rate + exploration_factor);
	}
	
	/*
	 * Selects the child of n with the highest UCT value, as in selection phase.
	 * precondition: n must have at least one child.
	 * TODO: should collections.max return the first max, or a random one? relevant
	 * when multiple unexplored nodes
	 */
	public static Node best_UCT(Node n) {
		int pV = n.get_TS().getvisitn();
		return Collections.max(n.get_children(),
				Comparator.comparing(c -> UCT_value(pV, c.get_TS().getwinn(), c.get_TS().getvisitn(),n,c)));
	}
}
