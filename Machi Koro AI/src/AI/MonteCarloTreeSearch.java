package AI;
import java.util.List;

import Components.*;
public class MonteCarloTreeSearch {
	public State findNextMove(State st) {
		Tree tree = new Tree();
		TreeState rootTS = new TreeState(st, 0, 0);
		Node rootNode = new Node(rootTS);
		
		
		int end = 0; // FIX FIX FIX
		
		while(System.currentTimeMillis() < end)
		return null;
	}
	
	private Node best_node(Node root_node) {
		Node n  = root_node;
		while(n.get_children().size() != 0) {
			n = UCT.best_UCT(n);
		}
		return n;
	}
	private void expand(Node n) {
		List<TreeState> potentialStates = n.get_TS().childStates();
		potentialStates.forEach(treeState -> {
			Node newNode = new Node(treeState);
			newNode.set_parent(n);
			n.add_child(newNode);
		});
	}	
}
	
