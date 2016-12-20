class Node{
  
  private int parent;
  private int type;
  private int[] children = null;
  
  Node(){
    parent = -1;
    type = (int)random(2);
  }
  
  Node(int _parent){
    parent = _parent;
    type = (int)random(2);
  }
  
  Node(int _parent, int _type){
    parent = _parent;
    type = _type;
  }
  
  void setParent(int _parent){
    parent = _parent;
  }
  
  void setType(int _type){
    type = _type;
  }
  
  void setChildrenArray(int _children){
    children = new int[_children];
  }
  
  void setChildNode(int _child, int _childNode){
    children[_child] = _childNode;
  }
  
  void setChildren(int[] _children){
    children = _children;
  }
  
  int getParent(){
    return parent;
  }
  
  int getType(){
    return type;
  }
  
  int[] getChildren(){
    return children;
  }
}