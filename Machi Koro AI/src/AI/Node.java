package AI;

import java.util.List;
import java.util.*;

public class Node {
	private TreeState ts;
    private Node parent;
    private List<Node> childArray;
    
    public Node (Node n) {
    	ts = n.get_TS();
    	parent = n.get_parent();
    	List<Node> = n.get_children();
    }
    public Node(TreeState ts_node) {
    	ts=ts_node;
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
}

