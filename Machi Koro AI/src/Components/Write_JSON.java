package Components;

import java.io.FileNotFoundException; 
import java.io.PrintWriter; 
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Map; 
import org.json.simple.JSONArray; 
import org.json.simple.JSONObject; 

public class Write_JSON {
	public void state_to_json(State st, String filename) throws Exception {
		JSONObject jo = new JSONObject(); 
		JSONArray players_arr =  players_to_json(st.get_players());
		jo.put("players", players_arr);
		jo.put("bank", st.get_bank());
		jo.put("available cards", est_list_to_json(st.get_available_cards()));
		jo.put("current player", st.get_current_player());
		jo.put("landmark cards", land_list_to_json(st.get_landmark_cards()));
		
		PrintWriter pw = new PrintWriter(filename + ".json"); 
        pw.write(jo.toJSONString()); 
          
        pw.flush(); 
        pw.close(); 
	}
	public JSONArray players_to_json(LinkedList<Player> players) throws Exception {
		JSONArray players_array= new JSONArray();
		for(Player player: players) {
			players_array.add(player_to_json(player));
		}
		return players_array;
	}
	public Map player_to_json(Player player) throws Exception {
		Map m = new LinkedHashMap(7);
		m.put("id", player.get_id());
		m.put("number of dice", player.get_num_dice());
		
		JSONArray dice_rolls_arr = new JSONArray();
		for (int i: player.get_dice_rolls())
			dice_rolls_arr.add(i);
		m.put("dice rolls", dice_rolls_arr);
		m.put("cash", player.get_cash());
		JSONArray assets_arr = est_list_to_json(player.get_assets());
		m.put("assets", assets_arr);
		JSONArray landmarks_arr = land_list_to_json(player.get_landmarks());
		m.put("landmarks", landmarks_arr);
		m.put("order", player.get_order());
		return m;
	}
	public JSONArray land_list_to_json(LinkedList<Landmark> land_cards) throws Exception {
		JSONArray landmarks_arr = new JSONArray();
		for(Landmark card : land_cards) {
			landmarks_arr.add(land_card_to_json(card));
		}
		return landmarks_arr;
	}
	public Map land_card_to_json(Landmark card) throws Exception {
		Map m = new LinkedHashMap(7);
		m.put("name", card.get_name());
		m.put("industry", card.get_industry());
		m.put("card type", card.get_cardType());
		m.put("construction cost", card.get_constructionCost());
		m.put("face", card.get_face());
		Land_Effect eff = card.get_effect();
		Map effect_obj = new LinkedHashMap(3);
		effect_obj.put("value", eff.get_value());
		effect_obj.put("effect type", eff.get_effect_type());
		m.put("effect", effect_obj);
		return m;
	}
	public JSONArray est_list_to_json(LinkedList<Establishment> est_cards) throws Exception {
		JSONArray assets_arr = new JSONArray();
		for(Establishment card : est_cards) {
			assets_arr.add(est_card_to_json(card));
		}
		return assets_arr;
	}
	public Map est_card_to_json(Establishment card) throws Exception {
		Map m = new LinkedHashMap(7);
		m.put("name", card.get_name());
		m.put("industry", card.get_industry());
		m.put("card type", card.get_cardType());
		m.put("construction cost", card.get_constructionCost());
		m.put("quantity", 1);
		JSONArray activation_numbers_arr = new JSONArray();
		for (int i: card.get_activation_numbers())
			activation_numbers_arr.add(i);
		m.put("activation numbers", activation_numbers_arr);
		
		Est_Effect eff = card.get_effect();
		Map effect_obj = new LinkedHashMap(3);
		effect_obj.put("activation time", eff.get_activation_time());
		effect_obj.put("value", eff.get_value());
		effect_obj.put("effect type", eff.get_effect_type());
		m.put("effect", effect_obj);
		return m;
	}
}
 