package Engine;

import Components.*;
import AI.*;

public class Main {
	public static void main(String [] args) throws Exception {
		String filename = "C:/Users/hyun0/Documents/vmshared/ai_help";
		
		Parse_JSON parser = new Parse_JSON();
		State st; 
		Write_JSON writer = new Write_JSON();
		MonteCarloTreeSearch mcts = new MonteCarloTreeSearch();
		while (true) {
			if(!parser.is_blocked(filename)) {
				st = parser.parse_state(filename);
				State updated = mcts.findNextMove(st);
				writer.state_to_json(updated, filename);
			}
		}
	}
}
