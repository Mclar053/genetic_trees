class Tree{
  
  //---------------PROPERTIES
  private ArrayList<Node> nodes;
  
  //Only used in initial creation of tree
  private int treeSize;
  private int currentLevel = 0;
  
  //---------------CONSTRUCTORS
  //Default constructor
  Tree(){
    treeSize = 4;
    nodes = new ArrayList<Node>();
    nodes.add(new Node());
    createTree();
  }
  
  //Same as default constructor but tree size is different
  Tree(int _treeSize){
    treeSize = _treeSize;
    nodes = new ArrayList<Node>();
    nodes.add(new Node());
    createTree();
  }
  
  //Copy constructor
  Tree(ArrayList<Node> _nodes){
    nodes = new ArrayList<Node>();
    for(Node n: _nodes){
      nodes.add(new Node(n));
    }
  }
  
  //---------------METHODS
  
  //Create Tree
  void createTree(){
    //Create tree from root node
    createNodes(0);
  }
  
  //Return fitness of the tree
  //Factors affecting: Combat, Puzzle, Size, Difficulty
  float fitness(float[] _player){
    return sqrt(sq(_player[0]-getRoomRating("combat"))+sq(_player[1]-getRoomRating("puzzle"))+sq((_player[2]-getSize())*0.1)+sq(_player[3]-getDifficultyRating()));
  }
  
  //Get % of room type entered as arguement in tree
  float getRoomRating(String _type){
    float count = 0;
    //For all nodes
    for(Node _n: nodes){
      //Get the room type from the nodes room id
      JSONObject room = roomValues.getJSONObject(_n.getRoomID());
      
      //If the room type is equal the arguement passed in then add 1 to count
      if(_type.equals(room.getString("type"))){
        count ++;
      }
    }
    //Return % of rooms in tree that are of the inputted type
    return count/float(getSize());
  }
  
  //Returns average difficulty rating over all nodes in tree
  float getDifficultyRating(){
    float diffSum = 0;
    for(Node _n: nodes){
      JSONObject room = roomValues.getJSONObject(_n.getRoomID());
      diffSum += room.getInt("difficulty");
    }
    diffSum/=100;
    return diffSum/float(getSize());
  }
  
  //Mutate Node
  void mutate(int _index){
    //Get node
    Node currentNode = new Node(nodes.get(_index));
    //Set random room id from 0-50
    currentNode.setRoomID((int)random(50));
    //Set node in nodes arraylist
    nodes.set(_index, currentNode);
  }
  
  //------CREATE NEW TREE
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
  
  
  //------CREATE SUB TREE FROM CURRENT TREE
  ArrayList<Node> createSubTree(int _index, boolean _invert){
    //Create arraylist of nodes for sub tree
    ArrayList<Node> subNodes;
    
    //Create int array with size of this.nodes arraylist
    int[] subIndex = new int[nodes.size()];
    
    //Set all ints to -1 (not found) in subIndex
    for(int i=0; i<subIndex.length; i++){
      subIndex[i] = -1;
    }
    
    //If the subtree requested is inverted (Start from root, ignore _index selected)
    if(_invert){
      //Set current root as root of new subtree
      subIndex[0] = 0;
      //Get order of subIndex for sub tree
      subIndex = findNodesInvert(0, subIndex, _index);
      //Get sub nodes for new sub tree
      subNodes = getNewSubNodesInvert(subIndex, _index);
    } else{ //(Start from _index, get all children from _index node)
      //Set the _index inputted to root of sub tree
      subIndex[_index] = 0;
      //Get order of subIndex for sub tree
      subIndex = findNodes(_index, subIndex);
      //Get sub nodes for new sub tree
      subNodes = getNewSubNodes(subIndex);
    }
    
    //Return nodes for new subtree
    return subNodes;
  }
  
  //------FIND NODES FOR NORMAL SUB TREE
  //Find nodes of small tree
  int[] findNodes(int _index, int[] _subIndex){
    //Set subIndex as _subIndex array parameter inputted
    int[] subIndex = _subIndex;
    //Get current node from _index as inputted parameter
    Node currentNode = nodes.get(_index);
    
    //Check if current node has child nodes
    if(currentNode.getChildren() != null){
      //For each child node
      for(int i=0; i<currentNode.getChildren().length; i++){
        //Set subIndex as a count of all nodes recorded.
        //E.g. subIndex = [-1,-1,0,1,2,3,-1,-1] would return 4
        subIndex[currentNode.getChildren()[i]] = getCurrentCount(subIndex);
      }
      //Find more nodes for each child node
      for(int i=0; i<currentNode.getChildren().length; i++){
        subIndex = findNodes(currentNode.getChildren()[i], subIndex);
      }
    }
    
    //Return subIndex int array
    return subIndex;
  }
  
  //------FIND NODES FOR INVERTED SUB TREE
  //Find nodes of small tree inverted... So that smallTree + smallTreeInverted = all nodes of original tree 
  //Same as findNodes() function except checks to avoid a particular index
  int[] findNodesInvert(int _index, int[] _subIndex, int _avoidIndex){
    int[] subIndex = _subIndex;
    Node currentNode = nodes.get(_index);
    
    if(currentNode.getChildren() != null){
      for(int i=0; i<currentNode.getChildren().length; i++){
        if(currentNode.getChildren()[i] != _avoidIndex){
          subIndex[currentNode.getChildren()[i]] = getCurrentCount(subIndex);
        }
      }
      
      for(int i=0; i<currentNode.getChildren().length; i++){
        if(currentNode.getChildren()[i] != _avoidIndex){
          subIndex = findNodesInvert(currentNode.getChildren()[i], subIndex, _avoidIndex);
        }
      }
    }
    return subIndex;
  }
  
  //------CREATE NEW NODES FOR NORMAL SUB TREE
  //Creates new nodes for sub tree
  ArrayList<Node> getNewSubNodes(int[] _subIndex){
    //Create a new arraylist for new sub tree
    ArrayList<Node> subNodes = new ArrayList<Node>();
    
    //For all elements in subIndex
    for(int i=0; i<_subIndex.length; i++){
      //Find next index to use
      int nextIndex = searchIntArray(_subIndex, subNodes.size());
      
      //If nextIndex is found
      if(nextIndex!=-1){
        //Get that node from that index
        Node currentNode = new Node(nodes.get(nextIndex));
        
        //Set parent to the subIndex[currentNode.parentPointer]
        if(currentNode.getParent() != -1){
          currentNode.setParent(_subIndex[currentNode.getParent()]);
        }
        //If node has child nodes
        if(currentNode.getChildren() != null){
          //Set all child nodes to subIndex[currentNode.childPointer]
          for(int j=0; j<currentNode.getChildren().length; j++){
            currentNode.setChildNode(j,_subIndex[currentNode.getChildren()[j]]); //<>//
          }
        }
        //Add modified node to sub tree nodes
        subNodes.add(currentNode);
      }
    }
    //return sub tree nodes
    return subNodes;
  }
  
  //------CREATE NEW NODES FOR INVERTED SUB TREE
  //Creates new nodes for inverted sub tree. Avoids the a certain node
  //Same as getNewSubNodes but checks to avoid particular index
  ArrayList<Node> getNewSubNodesInvert(int[] _subIndex, int _avoidIndex){
    ArrayList<Node> subNodes = new ArrayList<Node>();
    int avoidPos;
    for(int i=0; i<_subIndex.length; i++){
      int nextIndex = searchIntArray(_subIndex, subNodes.size());
      
      if(nextIndex!=-1 && nextIndex!= _avoidIndex){
        Node currentNode = new Node(nodes.get(nextIndex));
        if(currentNode.getParent() != -1){
          currentNode.setParent(_subIndex[currentNode.getParent()]);
        }
        if(currentNode.getChildren() != null){
          avoidPos = searchIntArray(currentNode.getChildren(),_avoidIndex);
          if(avoidPos!=-1){
            currentNode.removeChildNode(avoidPos);
          }
          if(currentNode.getChildren() != null){
            for(int j=0; j<currentNode.getChildren().length; j++){
              currentNode.setChildNode(j,_subIndex[currentNode.getChildren()[j]]);
            }
          }
        }
        subNodes.add(currentNode);
      }
    }
    return subNodes;
  }
  
  //Returns position of found number in array. If not found, return -1
  private int searchIntArray(int[] _array, int _num){
    for(int i=0; i<_array.length; i++){
      if(_array[i]==_num)
        return i;
    }
    return -1;
  }
  
  //Gets the current counter for an int array
  //It counts the integers that are not equal to -1
  //E.g [-1,-1,-1,0,1,2,-1,3,4] would return [5]
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
    ArrayList<Node> n = new ArrayList<Node>();
    for(Node _n: nodes){
      n.add(new Node(_n));
    }
    return n;
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
  
  //Returns all parent pointers for all nodes of current tree
  int[] getParents(){
    int[] p = new int[nodes.size()];
    for(int i=0; i<p.length; i++){
      p[i] = nodes.get(i).getParent();
    }
    return p;
  }
  
  //Gets all child node pointers for all nodes of current tree
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
  
  //Returns a new copy of this tree
  Tree copyTree(){
    return new Tree(getNodes());
  }
}