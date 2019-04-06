package Engine;

import Components.*;

public class Main {
	public static void main(String [] args) throws Exception {
		Parse_JSON parser = new Parse_JSON();
		Components.State st = parser.parse_state("endgame");
		System.out.println(st);
	}
}
