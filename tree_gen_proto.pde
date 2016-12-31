/*
Name: Tree Genetic Prototype
 Author: Matthew Clark
 Date Created: 14/12/2016
 */

Tree t = new Tree(3);
Tree[] a = new Tree[3];
Tree[] b = new Tree[3];
Tree[] c = new Tree[3];

Tree[] l = new Tree[20];
int[] order = new int[l.length];
Tree[] lChild = new Tree[10];
int[] orderChild = new int[lChild.length];

float[] player = {0.5, 0.5, 10, 0.4};

int[] oldP;
int[] newP;

int[][] oldC;
int[][] newC;

JSONArray roomValues;

int levels = 4;

void setup() {
  for (int i=0; i<l.length; i++) {
    l[i] = new Tree(4);
    order[i] = i;
  }
  //Load JSON Array from rooms.json file
  roomValues = loadJSONArray("rooms.json");

  for (int i=0; i<levels; i++) {
    l[order[0]] = new Tree(4);
    order = bubble_srt_fitness(order, l);
    println(i);
    println("Combat:", l[order[0]].getRoomRating("combat"));
    println("Puzzle:", l[order[0]].getRoomRating("puzzle"));
    println("Size:", l[order[0]].getSize());
    println("Difficulty:", l[order[0]].getDifficultyRating());
    println("Fitness:", l[order[0]].fitness(player));
    println("---------------------------------------------");


    for(int j=5; j<l.length; j++){
      l[order[j]].mutate((int)random(l[order[j]].getSize()));
    }

    for (int j=0; j<orderChild.length/2; j++) {
      Tree[] _t = crossover(l[order[j]],l[order[j+1]]);
      lChild[2*j] = _t[0];
      lChild[2*j+1] = _t[1];
    }
    for (int k=0; k<orderChild.length; k++) {
      orderChild[k] = k;
    }
    orderChild = bubble_srt_fitness(orderChild,lChild);
    
    for(int j=0; j<5; j++){
      l[order[order.length-j-1]] = new Tree(lChild[orderChild[j]].getNodes());
    }
    
    player[3] += 0.05;
  }




  //T TREE
  /*
  t.printNodes();
   oldC = t.getChildren();
   oldP = t.getParents();
   
   println("Combat:",t.getRoomRating("combat"));
   println("Puzzle:",t.getRoomRating("puzzle"));
   println("Size:",t.getSize());
   println("Difficulty:",t.getDifficultyRating());
   println(t.fitness(player));
   
   */
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

void draw() {
}

Tree[] crossover(Tree _t1, Tree _t2) {
  int random1 = (int)random(1,_t1.getSize());
  int random2 = (int)random(1,_t2.getSize());
  //println("RANDOM",random1,_t1.getNode(random1).getParent(),random2,_t2.getNode(random2).getParent());
  Tree[] t1Parts = new Tree[2];
  Tree[] t2Parts = new Tree[2];

  //DO ERROR CHECKS HERE

  //println("1");
  t1Parts[0] = new Tree(_t1.createSubTree(random1, true));
  //println("a");
  t1Parts[1] = new Tree(_t1.createSubTree(random1, false));
  
  //println("2");
  t2Parts[0] = new Tree(_t2.createSubTree(random2, true));
  //println("b");
  t2Parts[1] = new Tree(_t2.createSubTree(random2, false));
  
  //println("3");
  Tree[] children = new Tree[2];
  children[0] = combineTrees(t1Parts[0], t2Parts[1], (int)random(t1Parts[0].getSize()));
  children[1] = combineTrees(t2Parts[0], t1Parts[1], (int)random(t2Parts[0].getSize()));
  
  if(errorTree(t1Parts[0]) || errorTree(t1Parts[1]) || errorTree(t2Parts[0]) || errorTree(t2Parts[1]) || errorTree(children[0]) || errorTree(children[0])){
    _t1.printNodes();
    _t1.printSubIndex(true);
    _t1.printSubIndex(false);
    _t2.printNodes();
    _t2.printSubIndex(true);
    _t2.printSubIndex(false);
    println("\n-----T1 PARTS-----");
    t1Parts[0].printNodes();
    t1Parts[0].printSubIndex(true);
    t1Parts[0].printSubIndex(false);
    t1Parts[1].printNodes();
    t1Parts[1].printSubIndex(true);
    t1Parts[1].printSubIndex(false);
    println("\n-----T2 PARTS-----");
    t2Parts[0].printNodes();
    t2Parts[0].printSubIndex(true);
    t2Parts[0].printSubIndex(false);
    t2Parts[1].printNodes();
    t2Parts[1].printSubIndex(true);
    t2Parts[1].printSubIndex(false);
    println("\n-----Children-----");
    children[0].printNodes();
    children[0].printSubIndex(true);
    children[0].printSubIndex(false);
    children[1].printNodes();
    children[1].printSubIndex(true);
    children[1].printSubIndex(false);
  }
  
  //children[0] = combineTrees(t1Parts[0], t2Parts[1], _t1.getNode(random1).getParent());
  //children[1] = combineTrees(t2Parts[0], t1Parts[1], _t2.getNode(random2).getParent());
  return children;
}

Tree combineTrees(Tree _tOne, Tree _tTwo, int _childRoot) {
  ArrayList<Node> nodesOne = _tOne.getNodes();
  ArrayList<Node> nodesTwo = _tTwo.getNodes();
  ArrayList<Node> newNodes = new ArrayList<Node>();
  for (Node n : nodesOne) {
    newNodes.add(new Node(n));
  }
  for (Node n : nodesTwo) {
    Node currentNode = new Node(n);
    if (currentNode.getParent()!=-1) {
      currentNode.setParent(currentNode.getParent()+nodesOne.size());
    } else {
      currentNode.setParent(_childRoot);
      Node childRoot = newNodes.get(_childRoot);
      childRoot.addChildNode(nodesOne.size());
      newNodes.set(_childRoot,childRoot);
    }
    int[] currentNodeChildren = currentNode.getChildren();
    if (currentNodeChildren != null) {
      for (int i=0; i<currentNodeChildren.length; i++) {
        currentNodeChildren[i]+=nodesOne.size();
      }
    }
    currentNode.setChildren(currentNodeChildren);
    newNodes.add(currentNode);
  }
  Tree newTree = new Tree(newNodes);
  //if(errorTree(newTree)){
  //  println("CHILD ROOT:",_childRoot,"NODES ONE:",nodesOne.size(),"NODES TWO:",nodesTwo.size());
  //  _tOne.printNodes();
  //  _tTwo.printNodes();
  //  println("---------------------\n\n");
  //}
  return newTree;
}

void checkTree() {
  newC = t.getChildren();
  newP = t.getParents();
  for (int i=0; i<newC.length; i++) {
    for (int j=0; j<newC[i].length; j++) {
      if (oldC[i][j] != newC[i][j]) {
        println("NODE", i, "-- CHILD", j, "-- OLD", oldC[i][j], "-- NEW", newC[i][j]);
      }
    }
  }
  println("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*");
  for (int i=0; i<newP.length; i++) {
    if (oldP[i] != newP[i]) {
      println("NODE", i, "-- OLD", oldP[i], "-- NEW", newP[i]);
    }
  }
}

boolean errorTree(Tree _t){
  ArrayList<Node> nodes = _t.getNodes();
  boolean error = false;
  int count = 0;
  for(int i=0; i<nodes.size(); i++){
    Node n = nodes.get(i);
    
    //Checking if more than 1 root
    if(n.getParent()==-1 || n.getParent()==i){
      if(count++>1 || n.getParent()==i){
        println("PARENT ERROR:",i,n.getParent());
        error = true;
      }
    }
    
    if(n.getChildren()!=null){
      for(int j: n.getChildren()){
        if(j==i){
          println("CHILD ERROR:",i);
          error=true;
        }
      }
    }
  }
  if(error){
    _t.printNodes();
    println("---------------------------------\n");
  }
  return error;
}

//--------------------------------------------BUBBLE SORT----------------------------------------------

//Bubble sort from http://www.java2novice.com/java-sorting-algorithms/bubble-sort/
//Customised to be used with the Chromosome class I have created
int[] bubble_srt_fitness(int[] array, Tree[] _chr) {
  int n = array.length;
  int k;
  for (int m = n; m >= 0; m--) {
    for (int i = 0; i < n - 1; i++) {
      k = i + 1;
      if (_chr[array[i]].fitness(player) > _chr[array[k]].fitness(player)) {
        int temp;
        temp = array[i];
        array[i] = array[k];
        array[k] = temp;
      }
    }
  }
  return array;
}