package AI;

import java.util.List;
import java.util.*;

/*
 * A node of the MCTS tree.
 */
public class Node {
	private TreeState ts;
    private Node parent;
    private List<Node> childArray;
    
    public Node (Node n) {
    	ts = n.get_TS();
    	parent = n.get_parent();
    	childArray = n.get_children();
    }
    public Node(TreeState ts_node) {
    	ts=ts_node;
    	childArray = new LinkedList<Node>();
    }
    public Node(TreeState ts_node, List<Node> cA) {
    	ts=ts_node;
    	childArray = cA;
    }
    public Node(TreeState ts_node, Node p, List<Node> cA) {
    	ts=ts_node;
    	parent = p;
    	childArray = cA;
    }
    
    // setters and getters
    public TreeState get_TS() {
    	return ts;
    }
    public Node get_parent() {
    	return parent;
    }
    public List<Node> get_children(){
    	return childArray;
    }
    public void set_parent(Node p) {
    	parent = p;
    }
    public void set_childArray(List<Node> cA) {
    	childArray = cA;
    }
    public void add_child(Node c) {
    	childArray.add(c);
    }
    public Node getRandomChild() {
    	int rand = (int) Math.random()*(childArray.size());
    	return childArray.get(rand);
    }
    public Node getMaxChild() throws Exception {
    	for (Node c : childArray) {
    		System.out.println("visits/wins: " + c.get_TS().getvisitn()
    				+ "/" + c.get_TS().getwinn()
    				+ " - " + AIhelpers.stateDiff(ts.getState(), c.get_TS().getState()));
    	}
    	return Collections.max(childArray,Comparator.comparing(n -> n.get_TS().getvisitn()));
    }
}

