package Components;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map; 
import static java.lang.Math.toIntExact;
 
import org.json.simple.JSONArray; 
import org.json.simple.JSONObject; 
import org.json.simple.parser.*; 

public class Parse_JSON {
	
	public Parse_JSON() {
		
	}
	
	public State parse_state(String filename) throws Exception {
		// parsing file "filename.json"
		JSONObject jo = (JSONObject)(new JSONParser().parse(new FileReader(filename+".json"))); 
		JSONArray players_arr = (JSONArray) jo.get("players"); 
        LinkedList <Player> players = parse_players(players_arr);
		int bank = toIntExact((long) jo.get("bank"));
		JSONArray available_cards_arr = (JSONArray) jo.get("available cards");
		LinkedList <Establishment> available_cards = parse_assets(available_cards_arr); 
		JSONArray landmark_cards_arr = (JSONArray) jo.get("landmark cards");
		LinkedList <Landmark> landmark_cards = parse_landmarks(landmark_cards_arr); 
		int current_player = toIntExact((long) jo.get("current player"));
		State st = null;
		try {
			st = new State(players, bank, available_cards, landmark_cards, current_player);
		}
		catch (Exception ex) {
			throw new Exception("Failed to parse json, " + filename 
					+ ", into a game state because: \n\t" + ex.getMessage());
		}
		assert(st != null);
		return st;
	}
	public LinkedList<Player> parse_players(JSONArray ps) throws Exception {
        LinkedList <Player> player_list = new LinkedList<Player>();
        Iterator itr = ps.iterator(); 
        while (itr.hasNext()) { 
        	JSONObject player_obj = (JSONObject) itr.next();
            player_list.add(parse_player(player_obj));
        }
        return player_list;
	}
	public Player parse_player(JSONObject p) throws Exception {
		Player player;
        String id= (String) p.get("id");
        int num_dice= toIntExact((long) p.get("number of dice"));
        
        JSONArray dice_roll_arr = (JSONArray) p.get("dice rolls");
        Iterator itr = dice_roll_arr.iterator(); 
        LinkedList <Integer> dice_roll = new LinkedList<Integer>();
        while(itr.hasNext()) {
        	dice_roll.add(toIntExact((long) itr.next()));
        }
        
        int cash = toIntExact((long) p.get("cash"));
        JSONArray assets_arr = (JSONArray) p.get("assets");
        LinkedList <Establishment> assets = parse_assets(assets_arr);
        
        JSONArray landmarks_arr = (JSONArray) p.get("landmarks");
        LinkedList <Landmark> landmarks = parse_landmarks(landmarks_arr);
        
        int order = toIntExact((long) p.get("order"));
        player = new Player(id, num_dice, dice_roll, cash, assets, landmarks, order);
		return player;
	}
	
	public LinkedList <Establishment> parse_assets(JSONArray a) throws Exception{
		LinkedList <Establishment> assets = new LinkedList<Establishment>();
        Iterator itr = a.iterator(); 
        while (itr.hasNext()) { 
        	JSONObject est_obj = (JSONObject) itr.next();
            assets.add(parse_establishment(est_obj));
        }
        return assets;
	}
	public LinkedList <Landmark> parse_landmarks(JSONArray l) throws Exception{
		LinkedList <Landmark> landmarks = new LinkedList<Landmark>();
        Iterator itr = l.iterator(); 
        while (itr.hasNext()) { 
        	JSONObject land_obj = (JSONObject) itr.next();
        	landmarks.add(parse_landmark(land_obj));
        }
        return landmarks;
	}
	
	public Establishment parse_establishment(JSONObject e) throws Exception {
		String name = (String) e.get("name");
		String industry = (String) e.get("industry");
		String card_type = (String) e.get("card type");
		int construction_cost = toIntExact((long) e.get("construction cost"));
		
		JSONArray activation_numbers_arr = (JSONArray) e.get("activation numbers");
        Iterator itr = activation_numbers_arr.iterator(); 
        LinkedList <Integer> activation_numbers = new LinkedList<Integer>();
        while(itr.hasNext()) {
        	activation_numbers.add(toIntExact((long) itr.next()));
        }
        JSONObject est_effect_obj = (JSONObject) e.get("effect");
        Est_Effect est_effect = parse_est_effect(est_effect_obj);
        Establishment est;
        try{
        	est = new Establishment(name, industry, card_type, construction_cost, activation_numbers, est_effect);
        }
        catch(Exception ex) {
        	throw new Exception ("failed to parse establishment card, " + name
        			+ ", because: \n\t" + ex.getMessage());
        }
        		
        return est;
	}
	
	public Est_Effect parse_est_effect(JSONObject ee) throws Exception {
		String activation_time = (String) ee.get("activation time");
		int value = toIntExact((long) ee.get("value"));
		String effect_type = (String) ee.get("effect type");
		Est_Effect est_effect;
		try {
			est_effect = new Est_Effect(value, activation_time, effect_type);
		}
		catch (Exception ex) {
			throw new Exception ("failed to parse establishment effect, " + effect_type
					+ ", because: \n\t" + ex.getMessage());
		}
		return est_effect;
	}
	public Landmark parse_landmark(JSONObject e) throws Exception {
		String name = (String) e.get("name");
		String industry = (String) e.get("industry");
		String card_type = (String) e.get("card type");
		int construction_cost = toIntExact((long) e.get("construction cost"));
		JSONObject land_effect_obj = (JSONObject) e.get("effect");
        Land_Effect land_effect = parse_land_effect(land_effect_obj);
        String face = (String) e.get("face");
        Landmark land;
        try {
        	land = new Landmark(name, industry, card_type, construction_cost, land_effect, face);
        }
        catch(Exception ex) {
        	throw new Exception ("failed to parse landmark card," + name 
        			+ ", because: \n\t" + ex.getMessage());
        }
        return land;
	}
	public Land_Effect parse_land_effect(JSONObject le) throws Exception {
		int value = toIntExact((long) le.get("value"));
		String effect_type = (String) le.get("effect type");
		Land_Effect land_effect;
		try {
			land_effect = new Land_Effect(value, effect_type);
		}
		catch (Exception ex) {
			throw new Exception ("failed to parse landmark effect, " + effect_type
					+ ", because: \n\t" + ex.getMessage());
		}
		return land_effect;
	}
}
