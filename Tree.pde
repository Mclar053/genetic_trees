class Tree{
  
  private ArrayList<Node> nodes;
  private int treeSize;
  private int currentLevel = 0;
  
  Tree(){
    treeSize = 4;
    nodes = new ArrayList<Node>();
    nodes.add(new Node());
    createTree();
  }
  
  Tree(int _treeSize){
    treeSize = _treeSize;
    nodes = new ArrayList<Node>();
    nodes.add(new Node());
    createTree();
  }
  
  Tree(ArrayList<Node> _nodes){
    nodes = _nodes;
  }
  
  void createTree(){
    createNodes(0);
  }
  
  void mutate(int _index){
    Node currentNode = nodes.get(_index);
    currentNode.setRoomID((int)random(100));
    nodes.set(_index, currentNode);
  }
  
  //Recursive to create nodes for tree
  void createNodes(int _nodeNum){
    //Checks if current level in tree is less than the max treesize
    if(currentLevel++<treeSize){
      //Gets the current node from node arraylist
      Node currentNode = nodes.get(_nodeNum);
      
      //Sets the children array length to a random number between 1-3
       currentNode.setChildrenArray((int)random(1,4));
      
      //For each child node
      for(int i=0; i<currentNode.getChildren().length; i++){
        //Create a new node in the nodes arraylist
        nodes.add(new Node(_nodeNum));
        //Set the child node's index in the current node
        currentNode.setChildNode(i,nodes.size()-1);
        //Create child nodes for the newly create child node
        createNodes(nodes.size()-1);
      }
      //Save the current node in the arraylist
      nodes.set(_nodeNum,currentNode);
    }
    //Move out of a level in the tree
    currentLevel--;
  }
  
  Node getParentNode(int _n){
    if(_n<nodes.size()){
      return nodes.get(nodes.get(_n).getParent());
    }
    return null;
  }
  
  Node[] getChildrenNodes(){
    return new Node[3];
  }
  
  Node getNode(int _n){
    if(_n<nodes.size()){
      return nodes.get(_n);
    }
    return null;
  }
  
  ArrayList<Node> getNodes(){
    return nodes;
  }
  
  int getSize(){
    return nodes.size();
  }
  
  void printNodes(){
    println(nodes.size());
    for(int i=0; i<nodes.size(); i++){
      Node n = nodes.get(i);
      int[] c = n.getChildren();
      print(i,"----",n.getParent(),"----",n.getRoomID(),"****");
      if(c!=null){
        for(int _c: c) print(" ",_c);
      }
      print("\n\n");
    }
  }
  
}