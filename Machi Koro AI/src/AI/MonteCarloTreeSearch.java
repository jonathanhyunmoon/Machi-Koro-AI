package AI;
import java.util.List;
import java.util.Random;
import java.util.LinkedList;

import Components.*;
public class MonteCarloTreeSearch {
	static final int WIN_SCORE = 1; 
	private int client_player; // the player the agent will decide for
	
	public State findNextMove(State st) throws Exception {
		client_player = st.get_current_player().get_order(); // player the agent is deciding for
		Tree tree = new Tree();
		TreeState rootTS = new TreeState(st);
		
		Node rootNode = new Node(rootTS);

		// how long (in seconds) may MCTS run for?
		long runtime = 20;
		long start_t = System.currentTimeMillis();
		long current_t = System.currentTimeMillis();
		
		while((current_t - start_t) < (runtime * 1000)) {
			Node potential = potentialNode(rootNode);
			if(potential.get_TS().getState().win_condition() == -1) {
				expand(potential);
			}
			
			Node explore = potential;
			if(potential.get_children().size() > 0) {
				explore = potential.getRandomChild(); // can be improved
			}
			
			int result = simulateRandomPlayout(explore);
			
			backPropogation(explore, result);
			
			current_t = System.currentTimeMillis();
		}
		Node winner = rootNode.getMaxChild();
		tree.setRoot(winner);
		System.out.println("depth:" + depth(rootNode));
		return winner.get_TS().getState();
	}
	
	
	public int depth(Node n) {
		if (n.get_children().size() == 0) {
			return 0;
		}
		int maxdepth=-1;
		for (Node node :n.get_children()) {
			int curr_depth = depth(node);
			if(curr_depth > maxdepth) {
				maxdepth = curr_depth;
			}
		}
		return maxdepth+1;
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

	/*
	 * Starting from the child node that was just simulated, add 1 to visitn
	 * and winn if the node's player was the winner of the simulation, then traverse up.
	 */
	public void backPropogation (Node n, int player) {
		Node temp = n;
		while (temp != null) {
			temp.get_TS().increment_visitn(); 
			if (temp.get_TS().getPlayeri() == player) {
				temp.get_TS().add_winn(1);
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
	private void expand(Node n) throws Exception {
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
	 * Return the result (player who won).
	 * This does not keep track of the states encountered or moves made.
	 * This is a simulation of the randomly chosen child node.
	 */
	public int simulateRandomPlayout(Node n) throws Exception {
		Node temp = new Node(n); 
		TreeState tempState = temp.get_TS(); 
		int winStatus = tempState.getState().win_condition(); 
		
		// in tic tac toe, if the next move results in a loss then the parent node
		// is also a losing situation and should be avoided. however in machi koro
		// it is impossible to predict that you will lose on the next turn, so this part
		// is irrelevant.
//		if (winStatus != -1 && winStatus != client_player) { 
//			temp.get_parent().get_TS().setwinn(Integer.MIN_VALUE); 
//			return winStatus;
//		}
		// play random moves until a player wins
		while(winStatus == -1) {
			//System.out.println("CP 4");
			LinkedList<TreeState> children = tempState.childStates();
			//System.out.println("\tsize of children states: " + children.size());
			Random rand = new Random();
			tempState = children.get(rand.nextInt(children.size()));
			winStatus = tempState.getState().win_condition(); 
		}
		
		return winStatus; // returns winner of random playout
		
	}
}
	
