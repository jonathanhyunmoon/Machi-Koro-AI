package Engine;

import Components.*;

public class Main {
	public static void main(String [] args) throws Exception {
		Parse_JSON parser = new Parse_JSON();
		Components.State st = parser.parse_state("endgame");
		Write_JSON writer = new Write_JSON();
		writer.state_to_json(st, "endgame2");
	}
}
