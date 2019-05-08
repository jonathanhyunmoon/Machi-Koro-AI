package AI;
import Components.*;
public class MonteCarloTreeSearch {
	static final int WIN_SCORE = 10; 
	private int client_player;


	public State findNextMove(State st) {
		client_player = st.get_current_player().get_order();
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
	
	public int simulateRandomPlayout(Node n) {
		int playout = 10; 
		Node temp = new Node(n); 
		TreeState tempState = temp.get_TS(); 
		int winStatus = temp.get_TS().getState().win_condition(); 
		if (winStatus != client_player) {
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
