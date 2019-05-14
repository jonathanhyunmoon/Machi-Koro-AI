package Engine;

import Components.*;
import AI.*;

public class Main {
	public static void main(String [] args) throws Exception {
		String jon = "C:/Users/hyun0/Documents/vmshared/ai_help";
		String jon2 ="C:/Users/hyun0/Documents/Machi-Koro-AI/Machi Koro AI/jennaisave";
		String jas = "/Users/JasonJung/OneDrive/Sophomore/sem_2/ai/Machi-Koro-AI/jennaisave2_p3";
		String win;
		
		// change this after pulling
		String filename = jas;
		
		Parse_JSON parser = new Parse_JSON();
		State st; 
		Write_JSON writer = new Write_JSON();
		MonteCarloTreeSearch mcts = new MonteCarloTreeSearch();
		while (true) {
			if(!parser.is_blocked(filename)) {
				System.out.println("making a decision!");
				st = parser.parse_state(filename);
				State mctsmove = mcts.findNextMove(st);
				State updated = AIhelpers.correctState(st, mctsmove);
				writer.state_to_json(st, filename);
			}
		}
	}
}
