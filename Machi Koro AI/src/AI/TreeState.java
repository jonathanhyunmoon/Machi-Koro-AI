package AI;
import AI.AIhelpers.*;
import Components.*;
import java.util.LinkedList;


public class TreeState {
	State state;
	int playeri;
	int visitn;
	int winn;
	
	public TreeState(State st, int vn, int wn) {
		state = st;
		playeri = state.get_current_player_int();
		visitn = vn;
		winn = wn;
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
	public int getwinn() {
		return winn;
	}
	
	public void setvisitn(int vn) {
		visitn = vn;
	}
	public void setwinn(int wn) {
		winn = wn;
	}
	
	/*
	 * Starting from current state, obtain the list of states that the game could
	 * end up in. Then, updates each players' bank using expected profit.
	 * Each state will be in phase 3.
	 */
	public LinkedList<TreeState> childStates() {
		Player currplayer = state.get_current_player();
		
		state = state.nextTurn(state);
		LinkedList<Landmark> landops = AIhelpers.landmarksUnownedPurchasable(state,currplayer);
		LinkedList<State> children = AIhelpers.childStatesL(state, landops);
		
		LinkedList<Establishment> estops = AIhelpers.estOpsPurchasable(state, currplayer);
		estops = AIhelpers.uniqueEst(estops);
		LinkedList<State> childrenL = AIhelpers.childStatesE(state, estops);
		children.addAll(childrenL);
		children.add(state);
		
		
		
		
		return children;
	}
}
