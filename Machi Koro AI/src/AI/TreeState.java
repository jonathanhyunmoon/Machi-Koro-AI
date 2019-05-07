package AI;
import Components.State;

import java.util.LinkedList;

import AIhelpers.*;

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
	 * Starting from current state, 
	 */
	public LinkedList<State> childStates() {
		
	}
}
