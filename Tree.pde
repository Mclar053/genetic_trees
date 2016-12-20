class Tree{
  
  //---------------PROPERTIES
  private ArrayList<Node> nodes;
  private int treeSize;
  private int currentLevel = 0;
  int count;
  
  private int[] tempIndex; 
  
  //---------------CONSTRUCTORS
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
  
  //---------------METHODS
  
  //Create Tree
  void createTree(){
    createNodes(0);
  }
  
  
  //Mutate Node
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
  
  ArrayList<Node> createSubTree(int _index, boolean _invert){
    println("------START SUB TREE------");
    ArrayList<Node> subNodes = new ArrayList<Node>();
    tempIndex = new int[nodes.size()];
    for(int i=0; i<tempIndex.length; i++){
      tempIndex[i] = -1;
    }
    
    count = 0;
    
    if(_invert){
      //tempIndex = findNodesInvert(0, _index);
    } else{
      findNodes(_index);
    }
    
    for(int i: tempIndex){
     print(i,"... ");
    }
    
    print("\n");
    println("------END SUB TREE------");
    
    subNodes = getNewSubNodes(tempIndex);
    if(count>=30){
      for(int i=0; i<10; i++)
      println("**_**_*_*_*_*_ERROR:: OVERFLOW**_**_*_*_*_*_");
      println("**_**_*_*_*_*_ERROR:: OVERFLOW**_**_*_*_*_*_");
      println("**_**_*_*_*_*_ERROR:: OVERFLOW**_**_*_*_*_*_");
    }
    return subNodes;
  }
  
  //Find nodes of small tree
  void findNodes(int _index){
    count++;
    println("------FINDING", _index,"------");
    int counter = getCurrentCount(tempIndex);
    
    tempIndex[_index] = counter;
    Node currentNode = new Node(nodes.get(_index));
    if(currentNode.getChildren() != null && count<30){
      for(int i=0; i<currentNode.getChildren().length; i++){
        println("COUNTER:",counter);
        println("----",_index,"----");
        
        //for(int _i: tempIndex){
        //  if(_i!=-1){print("[",_i,"]... ");}
        // else{print(_i,"... ");}
        //}
        //print("\n\n");
        for(int _i: currentNode.getChildren()){println("CHILD:",_i);}
        println(currentNode.getChildren()[i]);
        if(currentNode.getChildren()[i]!=_index){
          findNodes(currentNode.getChildren()[i]);
        }
      }
    }
  }
  
  //Find nodes of small tree inverted... So that smallTree + smallTreeInverted = Original Tree 
  int[] findNodesInvert(int _index, int[] _subIndex, int _avoidIndex){
    println("------FINDING", _index,"------");
    int counter = getCurrentCount(_subIndex);
    
    int[] subIndex = _subIndex;
    subIndex[_index] = counter;
    Node currentNode = nodes.get(_index);
    if(currentNode.getChildren() != null){
      for(int i=0; i<currentNode.getChildren().length; i++){
        subIndex = findNodesInvert(currentNode.getChildren()[i], subIndex, _avoidIndex);
      }
    }
    return subIndex;
  }
  
  ArrayList<Node> getNewSubNodes(int[] _subIndex){
    ArrayList<Node> subNodes = new ArrayList<Node>();
    for(int i=0; i<_subIndex.length; i++){
      if(_subIndex[i]!=-1){
        println("-----",i,"-----");
        Node currentNode = new Node(nodes.get(i));
        
        if(currentNode.getParent() != -1){
          currentNode.setParent(_subIndex[currentNode.getParent()]);
        }
        if(currentNode.getChildren() != null){
          for(int j=0; j<currentNode.getChildren().length; j++){
            println("OLD:",currentNode.getChildren()[j],j,_subIndex[currentNode.getChildren()[j]]);
            currentNode.setChildNode(j,_subIndex[currentNode.getChildren()[j]]); //<>//
            println("NEW:",currentNode.getChildren()[j],j);
          }
        }
        subNodes.add(currentNode);
      }
    }
    return subNodes;
  }
  
  private int getCurrentCount(int[] _subIndex){
    int sum = 0;
    for(int i: _subIndex){
      if(i!=-1){
        sum++;
      }
    }
    return sum;
  }
  
  //---------------GETTERS
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
  
  
  //PRINT ALL NODES
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
  
  void printChildren(){
    for(int i=0; i<nodes.size(); i++){
      Node currentNode = nodes.get(i);
      if(currentNode.getChildren()!=null){
        for(int j: currentNode.getChildren())
        println("NODE",i,": --",j);
      }
    }
  }
  void printParents(){
    for(int i=0; i<nodes.size(); i++){
      Node currentNode = nodes.get(i);
      println("NODE PARENT",i,": --",currentNode.getParent());
    }
  }
  
  int[] getParents(){
    int[] p = new int[nodes.size()];
    for(int i=0; i<p.length; i++){
      p[i] = nodes.get(i).getParent();
    }
    return p;
  }
  
  int[][] getChildren(){
    int[][] c = new int[nodes.size()][3];
    for(int i=0; i<c.length; i++){
      Node cn = nodes.get(i);
      if(cn.getChildren() != null){
        for(int j=0; j<cn.getChildren().length; j++){
          c[i][j] = -2;
          c[i][j] = cn.getChildren()[j];
        }
      }
    }
    return c;
  }
  
}