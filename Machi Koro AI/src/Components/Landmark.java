package Components;
public class Landmark {
	enum industry {
		Landmark
	}
	enum card_type {
		Major
	}
	enum face {
		Up, Down
	}
	
/*
 * 	type card = {
 * 		name:string;  
 * 		industry:industry; 
 * 		card_type:cardType;
 * 		construction_cost:int;
 * 		effect:effect;
 * 		face: face
 * 	}
 */
	private String name;
	private industry industry;
	private card_type cardType;
	private int constructionCost;
	private Land_Effect effect;
	private face face;
	public Landmark(String n, String i, String ct, int cc, Land_Effect e, String f) throws Exception {
		try {
		name = n;
		industry = str_to_industry(i);
		cardType = str_to_card_type(ct);
		constructionCost = cc;
		effect = e;
		face = str_to_face(f);
		}
		catch(Exception ex) {
			throw new Exception("\nfailed to create landmark card, " + name
					+ ", because: \n\t" + ex.getMessage());
		}
	}
	
	public card_type str_to_card_type(String s) throws Exception {
		switch(s) {
			case "Major": return card_type.Major;
			default: throw new Exception ("\n" + s + 
					" is not a valid string representation of a card_type.");
		}
	}
	public industry str_to_industry(String s) throws Exception {
		switch(s) {
			case "Landmark": return industry.Landmark;
			default: throw new Exception ("\n" + s + 
					" is not a valid string representation of an industry.");
		}
	}
	public face str_to_face(String s) throws Exception {
		switch(s) {
			case "Up": return face.Up;
			case "Down": return face.Down;
			default: throw new Exception ("\n" + s + 
					" is not a valid string representation of a face.");
		}
	}
	public String get_name() {
		return name;
	}
	public String get_industry() {
		return industry.toString();
	}
	public String get_cardType() {
		return cardType.toString();
	}
	public int get_constructionCost() {
		return constructionCost;
	}
	public Land_Effect get_effect() {
		return effect;
	}
	public String get_face() { 
		return face.toString();
	}
}
