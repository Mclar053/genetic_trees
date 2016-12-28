/*
Name: Tree Genetic Prototype
Author: Matthew Clark
Date Created: 14/12/2016
*/

Tree t = new Tree(3);
Tree[] a = new Tree[3];
Tree[] b = new Tree[3];
Tree[] c = new Tree[3];

float[] player = {0.5,0.5,10,0.5};

int[] oldP;
int[] newP;

int[][] oldC;
int[][] newC;

JSONArray roomValues;

void setup(){
  //Load JSON Array from rooms.json file
  roomValues = loadJSONArray("rooms.json");
  
  t.printNodes();
  oldC = t.getChildren();
  oldP = t.getParents();
  
  println("Combat:",t.getRoomRating("combat"));
  println("Puzzle:",t.getRoomRating("puzzle"));
  println("Size:",t.getSize());
  println("Difficulty:",t.getDifficultyRating());
  println(t.fitness(player));
  
  //for(int i=0; i<2; i++){
  //  t.mutate((int)random(t.getSize()));
  //}
  
  //SUB TREES
  /*
  for(int i=0; i<a.length; i++){
    int r = (int)random(1,t.getSize()-1);
    println("Random Number:", r);
    println(i,"A");
    a[i] = new Tree(t.createSubTree(r, false));
    
    println(i,"B");
    b[i] = new Tree(t.createSubTree(r, true));
    
    int r2 = (int)random(0,b[i].getSize());
    println(i,"C", r2);
    c[i] = combineTrees(b[i],a[i],r2);
    
  }
  */
  
  
  //PRINTING TREES
  /*
  for(int i=0; i<a.length; i++){
    a[i].printNodes();
    println("*******************************");
    b[i].printNodes();
    println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    c[i].printNodes();
    println("-------------------------------");
  }
*/
  //CHECKING TREES
  //checkTree();
}

void draw(){
  
}

void crossover(){
  
}

void fitness(){
  
}

Tree combineTrees(Tree _tOne, Tree _tTwo, int _childRoot){
  ArrayList<Node> nodesOne = _tOne.getNodes();
  ArrayList<Node> nodesTwo = _tTwo.getNodes();
  ArrayList<Node> newNodes = new ArrayList<Node>();
  for(Node n: nodesOne){
    newNodes.add(new Node(n));
  }
  for(Node n: nodesTwo){
    Node currentNode = new Node(n);
    if(currentNode.getParent()!=-1){
      currentNode.setParent(currentNode.getParent()+nodesOne.size());
    }
    else{
      currentNode.setParent(_childRoot);
      Node childRoot = newNodes.get(_childRoot);
      childRoot.addChildNode(nodesOne.size());
    }
    int[] currentNodeChildren = currentNode.getChildren();
    if(currentNodeChildren != null){
      for(int i=0; i<currentNodeChildren.length; i++){
        currentNodeChildren[i]+=nodesOne.size();
      }
    }
    currentNode.setChildren(currentNodeChildren);
    newNodes.add(currentNode);
  }
  return new Tree(newNodes);
}

void checkTree(){
  newC = t.getChildren();
  newP = t.getParents();
  for(int i=0; i<newC.length; i++){
    for(int j=0; j<newC[i].length; j++){
      if(oldC[i][j] != newC[i][j]){
        println("NODE",i,"-- CHILD",j,"-- OLD",oldC[i][j],"-- NEW",newC[i][j]);
      }
    }
  }
  println("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*");
  for(int i=0; i<newP.length; i++){
    if(oldP[i] != newP[i]){
      println("NODE",i,"-- OLD",oldP[i],"-- NEW",newP[i]);
    }
  }
}