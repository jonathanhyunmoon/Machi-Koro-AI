package AI;

import java.util.*;

import Components.Player;
public class UCT {
	/*
	 * Implementation of the exploration vs exploitation function.
	 * Note, unexplored nodes (n == 0) are explored first. The formula is
	 * otherwise identical.
	 * source: https://en.wikipedia.org/wiki/Monte_Carlo_tree_search#Exploration_and_exploitation
	 */
	public static double UCT_value(int t, double w, int n,Node parent, Node child) {
		if(n == 0) return Double.MAX_VALUE;
		
		double landbuff = 1.05;
		Player currp = parent.get_TS().getState().get_current_player();
		int parentlands = currp.get_landmarks().size();
		
		int childlands = child.get_TS().getState().get_playeri(currp.get_order()).get_landmarks().size();
		if (!(parentlands < childlands)) landbuff = 1;
		
		double success_rate = ((double) w)/((double) n);
		double c = Math.sqrt(2); // exploration parameter
		double exploration_factor = c* Math.sqrt(Math.log(t) / (double) n);
		return landbuff * (success_rate + exploration_factor);
	}
	
	/*
	 * Selects the child of n with the highest UCT value, as in selection phase.
	 * precondition: n must have at least one child.
	 * TODO: should collections.max return the first max, or a random one? relevant
	 * when multiple unexplored nodes
	 */
	public static Node best_UCT(Node n) throws Exception {
		int pV = n.get_TS().getvisitn();
		Node maxc = Collections.max(n.get_children(),
				Comparator.comparing(c -> UCT_value(pV, c.get_TS().getwinn(), c.get_TS().getvisitn(),n,c)));
		
//		double maxd = 0;
//		Node maxc = n;
//		for (Node c : n.get_children()) {
//			double childv = UCT_value(pV, c.get_TS().getwinn(), c.get_TS().getvisitn(),n,c);
//			if (childv > maxd) {
//				maxd = childv;
//				maxc = c;
//			}
//
//		}
		
		return maxc;
	}
}
