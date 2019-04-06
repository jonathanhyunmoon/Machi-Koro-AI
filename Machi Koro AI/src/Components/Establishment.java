package Components;

import java.util.LinkedList;

public class Establishment  {
	enum industry{
		Primary, Secondary, Restaurant, Major
	}
	enum card_type{
		Wheat, Cow, Gear, Bread, Factory, Fruit, Cup, Major, Boat, Suitcase
	}
	/*
	 * 	type card = {
	 * 		name:string; 
	 * 		industry:industry; 
	 * 		card_type:cardType;
	 * 		construction_cost:int; 
	 * 		activation_numbers:int list;
	 *		effect:effect
	 * 	}
	 */
	private String name;
	private industry industry;
	private card_type cardType;
	private int constructionCost;
	private LinkedList <Integer> activation_numbers;
	private Est_Effect effect;

	public Establishment(String n, String i, String ct, int cc, LinkedList <Integer> an, Est_Effect e) throws Exception {
		try {
			name = n;
			industry = str_to_industry(i);
			cardType = str_to_card_type(ct);
			constructionCost = cc;
			activation_numbers = an;
			effect = e;
		}
		catch(Exception ex) {
			throw new Exception("\nfailed to create establishment card, " + name
					+ ", because: \n\t" + ex.getMessage());
		}
	}

	public card_type str_to_card_type(String s) throws Exception {
		switch(s) {
		case "Wheat": return card_type.Wheat;
		case "Cow": return card_type.Cow;
		case "Gear": return card_type.Gear;
		case "Bread": return card_type.Bread;
		case "Factory": return card_type.Factory;
		case "Fruit": return card_type.Fruit;
		case "Cup": return card_type.Cup;
		case "Major": return card_type.Major;
		case "Boat": return card_type.Boat;
		case "Suitcase": return card_type.Suitcase;
		default: throw new Exception ("\n" + s + 
				" is not a valid string representation of a card_type.");
		}
	}
	public industry str_to_industry(String s) throws Exception {
		switch(s) {
		case "Primary": return industry.Primary;
		case "Secondary": return industry.Secondary;
		case "Restaurant": return industry.Restaurant;
		case "Major": return industry.Major;
		default: throw new Exception ("\n" + s + 
				" is not a valid string representation of an industry.");
		}
	}
	public String get_name() {
		return name;
	}
	public String get_industry(){
		return industry.toString();
	}
	public String get_cardType(){
		return cardType.toString();
	}
	public int get_constructionCost(){
		return constructionCost;
	}
	public LinkedList <Integer> get_activation_numbers(){
		return activation_numbers;
	}
	public Est_Effect get_effect() {
		return effect;
	}

}
