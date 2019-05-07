package AI;

import java.util.*;
public class UCT {
	public static double UCT_value(int t, double w, int n) {
		if(n == 0)
			return Integer.MAX_VALUE;
		double success_rate = ((double) w)/((double) n);
		double c = Math.sqrt(2);
		double exploration_factor = c* Math.sqrt(Math.log(t) / (double) n);
		return success_rate + exploration_factor;
	}
	
	public static Node best_UCT(Node n) {
		int pV = n.get_TS().getvisitn();
		return Collections.max(n.get_children(),
				Comparator.comparing(c -> UCT_value(pV, c.get_TS().getwinn(), c.get_TS().getvisitn())));
	}
}
