/*
Name: Tree Genetic Prototype
Author: Matthew Clark
Date Created: 14/12/2016
*/

Tree t = new Tree(3);
Tree[] a = new Tree[3];
Tree[] b = new Tree[3];
Tree[] c = new Tree[3];

int[] oldP;
int[] newP;

int[][] oldC;
int[][] newC;

void setup(){
  t.printNodes();
  oldC = t.getChildren();
  oldP = t.getParents();
  //for(int i=0; i<2; i++){
  //  t.mutate((int)random(t.getSize()));
  //}
  for(int i=0; i<a.length; i++){
    int r = (int)random(1,t.getSize()-1);
    println("Random Number:", r);
    a[i] = new Tree(t.createSubTree(r, false));
    println(i,"A");
    b[i] = new Tree(t.createSubTree(r, true));
    println(i,"B");
    int r2 = (int)random(a[i].getSize());
    c[i] = combineTrees(a[i],b[i],r2);
    println(i,"C", r2);
  }
  for(int i=0; i<a.length; i++){
    a[i].printNodes();
    println("*******************************");
    b[i].printNodes();
    println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    c[i].printNodes();
    println("-------------------------------");
  }

  
  checkTree();
}

void draw(){
  
}

void crossover(){
  
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