package Components;
public class Est_Effect extends Effect{
/*
 * 	type effect = {
 * 		activation_time: activationTime;
 * 		value: int; 
 * 		effect_type: effectType
 * 	}
 */
	enum activation_time{
		Anyones_Turn, Players_Turn, Others_Turn
	}
	enum effect_type{
		/* collect amount given by value from the bank */
		Collect,
		CollectGear, /* collect from the bank value times the number 
		                   of gear cards one has */
		CollectWheat, /* collect from the bank value times the 
		                    number of wheat cards one has */
		CollectCow, /* collect from the bank value times the 
		                  number of cow cards one has */
		Take,  /* take from a single other player a number of coins
		             equal to value */
		TakeRolled,  /* take a number of coins equal to value from
		                   the person who just rolled*/
		TakeAll, /* take from all other players a number of coins
		               equal to value */
		Trade, /* trade a non-major establishment with another
		             player */
		HarborCollect, /* if you have a harbor, get 3 coins from the bank
		                     on anyone's turn */
		HarborCollectTunaRolled, /* every player with a harbor and a tuna boat
		                               collects the amount times the number of tuna 
		                               boats */
		FlowerCollect, /* Collect 1 coin from the bank for every
		                     flower orchard the player has */
		CollectCup, /* collect from the bank the valuer times the
		                  number of cup cards */
		HarborTake, /* take from a single other player a number of coins
		                  equal to value if you have a harbor */
		CollectCupBread, /* collect one coin from each player for every cup and
		                       bread establishment they have */
		Tax, /* take half of the coins from each player who has
		           10 coins or more */

	}
	
	private activation_time activationTime;
	private effect_type effectType;
	public Est_Effect(int v, String at, String et) throws Exception { // maybe pass in as strings
		super(v);
		activationTime= str_to_activation_time(at);
		effectType=str_to_effect_type(et);
	}
	
	/*
	 * TRANSLATIONAL METHODS
	 */
	public activation_time str_to_activation_time(String s) throws Exception {
		switch(s) {
			case "Anyone's Turn": return activation_time.Anyones_Turn;
			case "Player's Turn": return activation_time.Players_Turn;
			case "Others' Turn": return activation_time.Others_Turn;
			default: throw new Exception ("\n" + s + 
					" is not a valid string representation of an activation time.");
		}
	}
	public effect_type str_to_effect_type (String s) throws Exception {
		switch(s) {
			case "Collect": return effect_type.Collect;
			case "Collect Gear": return effect_type.CollectGear;
			case "Collect Wheat": return effect_type.CollectWheat;
			case "Collect Cow": return effect_type.CollectCow;
			case "Take": return effect_type.Take;
			case "Take Rolled": return effect_type.TakeRolled;
			case "Take All": return effect_type.TakeAll;
			case "Trade": return effect_type.Trade;
			case "Harbor Collect": return effect_type.HarborCollect;
			case "Harbor Collect Tuna Rolled": return effect_type.HarborCollectTunaRolled;
			case "Flower Collect": return effect_type.FlowerCollect;
			case "Collect Cup": return effect_type.CollectCup;
			case "Harbor Take": return effect_type.HarborTake;
			case "Collect Cup Bread": return effect_type.CollectCupBread;
			case "Tax": return effect_type.Tax;
			default: throw new Exception ("\n" + s + 
					" is not a valid string representation of an effect type.");
		}
	}
	
	/*
	 * GETTER METHODS
	 */
	public activation_time get_activation_time() {
		return activationTime;
	}
	public effect_type get_effect_type() {
		return effectType;
	}
}
