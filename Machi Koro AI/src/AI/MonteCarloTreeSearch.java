package AI;
import java.util.List;

import Components.*;
public class MonteCarloTreeSearch {
	static final int WIN_SCORE = 10; 
	private int client_player; // the player the agent will decide for


	public State findNextMove(State st) {
		client_player = st.get_current_player().get_order();
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
				explore = potential.getRandomChild(); // can be improved
			}
			int result = simulateRandomPlayout(explore);
			backPropagation(explore, result);
		}
		Node winner = rootNode.getChildWithMaxScore();
		tree.setRoot(winner);
		return winner.get_TS().getState();
	}
	
	/*
	 * Traverse down the tree based on UCT until a leaf (node with no children)
	 * is encountered. This would happen on an unexplored node or a finished game
	 * node.
	 * This is the selection phase.
	 */
	private Node potentialNode(Node root) {
	    Node node = root;
	    while (node.get_children().size() != 0) {
	        node = UCT.best_UCT(node);
	    }
	    return node;
	}
// TODO: check this
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

	/*
	 * Adds any possible child states to n's list of children and
	 * sets each child's parent as n
	 */
	private void expand(Node n) {
		List<TreeState> potentialStates = n.get_TS().childStates();
		potentialStates.forEach(treeState -> {
			Node newNode = new Node(treeState);
			newNode.set_parent(n);
			// note: treestate's number already set by childStates()
			n.add_child(newNode);
		});
	}	
	/*
	 * Starting from node n, simulate a random playout of a game until a win/loss.
	 * Return the result.
	 * This does not keep track of the states encountered or moves made.
	 */
	public int simulateRandomPlayout(Node n) {
		int playout = 10; // playout depth?
		Node temp = new Node(n); 
		TreeState tempState = temp.get_TS(); 
		int winStatus = tempState.getState().win_condition(); 
		if (winStatus != -1 && winStatus != client_player) {
			temp.get_parent().get_TS().setwinn(Integer.MIN_VALUE);
			return winStatus;
		}
		while(winStatus == -1) {
			State st = tempState.getState();
			st = State.nextTurn(st);
			tempState.setState(st);
			tempState = State.nextTurn(tempState);
			tempState = State.randomPlay(tempState);
			//boardStatus = tempState.getBoard().checkStatus();
		}
		return winStatus;
		
	}
}
	
