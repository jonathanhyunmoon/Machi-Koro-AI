package AI;
import Components.*;
public class MonteCarloTreeSearch {
	static final int WIN_SCORE = 10; 


	public State findNextMove(State st) {
		Tree tree = new Tree();
		TreeState rootTS = new TreeState(st, 0, 0);
		Node rootNode = new Node(rootTS);


		int end = 0; // FIX FIX FIX

		while(System.currentTimeMillis() < end)
			return null;
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
	
	public int simulateRandomPlayout (Node n) {
		Node temp = new Node(n); 
		TreeState tempState = temp.get_TS(); 
		
	}
}
