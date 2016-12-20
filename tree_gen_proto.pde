/*
Name: Tree Genetic Prototype
Author: Matthew Clark
Date Created: 14/12/2016
*/

Tree t = new Tree(2);

void setup(){
  t.printNodes();
  for(int i=0; i<2; i++){
    t.mutate((int)random(t.getSize()));
  }
  println("-------------------------------");
  t.printNodes();
}

void draw(){
  
}

void crossover(){
  
}

ArrayList<Node> createSubTree(Tree _t, int _index){
  Node currentNode = _t.getNode(_index);
  ArrayList<Node> subTree = new ArrayList<Node>();
  subTree.add(currentNode);
  int currentLevel = 0;
  
  return gatherNodes(_t, _index, subTree, currentLevel);
}

ArrayList<Node> gatherNodes(Tree _t, int _index, ArrayList<Node> _nodesList, int _currentLevel){
  Node currentNode = _t.getNode(_index);
  return new ArrayList<Node>();
}