class Node{
  
  private int parent; //int pointer to parent in Tree class node
  private int[] children = null; //int pointers to child nodes in Tree class
  private int roomID; //Room id states what room properties it has from 'rooms.json'
  
  //Default constructor
  //Sets parent to -1 and room id to random integer between 0 and 50
  Node(){
    parent = -1;
    roomID = (int)random(50);
  }
  
  //Constructor that takes parent as arguement
  //Sets parent to arguement and room id to random integer between 0 and 50
  Node(int _parent){
    parent = _parent;
    roomID = (int)random(50);
  }
  
  //Constructor that takes parent and room id arguements
  //Sets parent and room id to arguements
  Node(int _parent, int _id){
    parent = _parent;
    roomID = _id;
  }
  
  //Copy constructor
  //Copies all elements of _n to the current node
  Node(Node _n){
    parent = _n.getParent();
    setChildren(_n.getChildren());
    roomID = _n.getRoomID();
  }
  
  //parent setter
  void setParent(int _parent){
    parent = _parent;
  }
  
  //Sets children array length
  void setChildrenArray(int _children){
    children = new int[_children];
  }
  
  //Set specific child node to an integer
  void setChildNode(int _child, int _childNode){
    children[_child] = _childNode;
  }
  
  //Copies arguement to this.children
  void setChildren(int[] _children){
    if(_children != null){
      children = new int[_children.length];
      for(int i=0; i<children.length; i++){
        children[i] = _children[i];
      }
    } else{
      children = null;
    }
  }
  
  //Sets the room id
  void setRoomID(int _id){
    roomID = _id;
  }
  
  //Gets parent of this
  int getParent(){
    return parent;
  }
  
  //Gets children int array of this
  int[] getChildren(){
    if(children != null){
      int[] _c = new int[children.length];
      for(int i=0; i<_c.length; i++){
        _c[i] = children[i];
      }
      return _c;
    }
    return null;
  }
  
  //Get room if of this
  int getRoomID(){
    return roomID;
  }
  
  //Removes a child node from a nodes childNodes int array
  void removeChildNode(int _pos){
    if(children.length-1!=0){
      int[] childNodes = new int[children.length-1];
      int counter = 0;
      for(int i=0; i<children.length; i++){
        if(i!=_pos)
        childNodes[counter++] = children[i];
      }
      setChildren(childNodes);
    }
    else{
      setChildren(null);
    }
  }
  
  //Adds a child node to a nodes childNodes int array
  void addChildNode(int _value){
    int[] childNodes;
    if(children == null){
      childNodes = new int[1];
    }
    else{
      childNodes = new int[children.length+1];
      for(int i=0; i<children.length; i++){
        childNodes[i] = children[i];
      }
    }
    childNodes[childNodes.length-1] = _value;
    setChildren(childNodes);
  }
}