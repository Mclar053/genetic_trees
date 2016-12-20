class Node{
  
  private int parent;
  private int[] children = null;
  private int roomID;
  
  Node(){
    parent = -1;
    roomID = (int)random(100);
  }
  
  Node(int _parent){
    parent = _parent;
    roomID = (int)random(100);
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
    return children;
  }
  
  int getRoomID(){
    return roomID;
  }
}