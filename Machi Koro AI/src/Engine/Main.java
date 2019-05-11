package Engine;

import Components.*;
import AI.*;

public class Main {
	public static void main(String [] args) throws Exception {
		String jon = "C:/Users/hyun0/Documents/vmshared/ai_help";
		String jas = "/Users/JasonJung/OneDrive/Sophomore/sem_2/ai/Machi-Koro-AI/ai_help";
		String win;
		
		// change this after pulling
		String filename = jas;
		
		Parse_JSON parser = new Parse_JSON();
		State st; 
		Write_JSON writer = new Write_JSON();
		MonteCarloTreeSearch mcts = new MonteCarloTreeSearch();
		while (true) {
			if(!parser.is_blocked(filename)) {
				st = parser.parse_state(filename);
				State mctsmove = mcts.findNextMove(st);
				State updated = AIhelpers.correctState(st, mctsmove);
				writer.state_to_json(st, filename);
			}
		}
	}
}
