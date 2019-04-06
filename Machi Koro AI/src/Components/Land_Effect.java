package Components;

import Components.Est_Effect.effect_type;

public class Land_Effect extends Effect {
	/*
	 * 	type effect = {
	 * 		value: int; 
	 * 		effect_type: effectType
	 * 	}
	 */
	enum effect_type {
		DoubleRoll, /* can choose before your turn to roll either 1 or 2 dice */
        MallCollect, /* whenever you collect from a bread or a
                                 cafe card, collect one extra coin*/
        DoublesTurn, /* if you roll doubles, then you can choose
                                   to take another turn*/
        Reroll, /* you can choose to roll again and replace your
                            previous roll with this landmark*/
        CityHall, /* If you have 0 coins, get one from the bank */
        AddToDie, /* If roll is greater than or equal to 10, player can 
                              add 2 */
        BuildOrTake, /* If player build's nothing on their turn
                                 take 10 coins from the bank */
	}
	private effect_type effectType;
	public Land_Effect(int v, String et) throws Exception {
		super(v);
		effectType= str_to_effect_type(et);
	}
	public effect_type str_to_effect_type (String s) throws Exception {
		switch (s) {
			case "Double Roll": return effect_type.DoubleRoll;
			case "Mall Collect": return effect_type.MallCollect;
			case "Doubles Turn": return effect_type.DoublesTurn;
			case "Reroll": return effect_type.Reroll;
			case "City Hall": return effect_type.CityHall;
			case "Add To Die": return effect_type.AddToDie;
			case "Build Or Take": return effect_type.BuildOrTake;
			default: throw new Exception ("\n" + s + 
					" is not a valid string representation of an effect type.");
			
		}
	}
	
}
