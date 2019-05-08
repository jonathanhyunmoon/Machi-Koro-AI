package AI;
import java.util.List;

import Components.*;
public class MonteCarloTreeSearch {
	static final int WIN_SCORE = 10; 


	public State findNextMove(State st) {
		Tree tree = new Tree();
		TreeState rootTS = new TreeState(st, 0, 0);
		Node rootNode = new Node(rootTS);


		int end = 0; // FIX FIX FIX

		while(System.currentTimeMillis() < end) {
			Node potential = potentialNode(rootNode);
			if(potential.get_TS().getState().win_condition() != -1) {
				expand(potential);
			}
			Node explore = potential;
			if(potential.get_children().size() > 0) {
				explore = potential.getRandomChild();
			}
			int result = simulateRandomPlayout(explore);
			backPropagation(explore, result);
		}
		Node winner = rootNode.getChildWithMaxScore();
		tree.setRoot(winner);
		return winner.get_TS().getState();
	}
	private Node potentialNode(Node root) {
	    Node node = root;
	    while (node.get_children().size() != 0) {
	        node = UCT.best_UCT(node);
	    }
	    return node;
	}

	public void backPropogation (Node n, int player) {
		Node temp = n;
		while (temp != null) {
			temp.get_TS().increment_visitn(); 
			if (temp.get_TS().getPlayeri() == player) {
				temp.get_TS().add_winn(WIN_SCORE);
			}
			temp = temp.get_parent();
		}
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
	
