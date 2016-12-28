class Node{
  
  private int parent;
  private int[] children = null;
  private int roomID;
  
  Node(){
    parent = -1;
    roomID = (int)random(50);
  }
  
  Node(int _parent){
    parent = _parent;
    roomID = (int)random(50);
  }
  
  Node(int _parent, int _id){
    parent = _parent;
    roomID = _id;
  }
  
  Node(Node _n){
    parent = _n.getParent();
    setChildren(_n.getChildren());
    roomID = _n.getRoomID();
  }
  
  void setParent(int _parent){
    parent = _parent;
  }
  
  void setChildrenArray(int _children){
    children = new int[_children];
  }
  
  void setChildNode(int _child, int _childNode){
    children[_child] = _childNode;
  }
  
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
  
  void setRoomID(int _id){
    roomID = _id;
  }
  
  int getParent(){
    return parent;
  }
  
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