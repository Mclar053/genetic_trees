/*
Name: Tree Genetic Prototype
 Author: Matthew Clark
 Date Created: 14/12/2016
 */
 
Tree[] l = new Tree[20];
int[] order = new int[l.length];
Tree[] lChild = new Tree[10];
int[] orderChild = new int[lChild.length];

//Player profile
float[] player = {0.5, 0.5, 10, 0.4};

JSONArray roomValues;

ArrayList<Tree> usedLevels = new ArrayList<Tree>();
ArrayList<float[]> previousProfiles = new ArrayList<float[]>();

int levels = 10;
int currentProfile;

void setup() {
  size(600,600);
  
  for (int i=0; i<l.length; i++) {
    l[i] = new Tree(4);
    order[i] = i;
  }
  
  //Load JSON Array from rooms.json file
  roomValues = loadJSONArray("rooms.json");

  createLevel();
  currentProfile=0;
/*
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
    
    l[order[0]].printNodes();
    
    player[3] += 0.05;
  }
  */
  
}

void draw() {
  background(255);
  fill(0);
  
  Tree currentTree = usedLevels.get(currentProfile);
  ArrayList<Node> level = usedLevels.get(currentProfile).getNodes();
  float[] profile = previousProfiles.get(currentProfile);
  text("Tree: "+currentProfile,0,10);
  
  fill(0,255,255,50);
  rect(100,-1,500,16);
  fill(0);
  text("Player Profile",110,10);
  text("Combat: "+profile[0],200,10);
  text("Puzzle: "+profile[1],300,10);
  text("Size: "+profile[2],400,10);
  text("Difficulty: "+profile[3],490,10);
  
  fill(255,0,255,50);
  rect(0,15,600,16);
  fill(0);
  
  text("Level Fitness: "+nf(currentTree.fitness(profile),1,10),10,28);
  text("Combat: "+nf(currentTree.getRoomRating("combat"),1,2),200,28);
  text("Puzzle:"+ nf(currentTree.getRoomRating("puzzle"),1,2),300,28);
  text("Size: "+nf(currentTree.getSize(),1,2),400,28);
  text("Difficulty: "+nf(currentTree.getDifficultyRating(),1,2),490,28);
  
  text("Node Number",10,43);
  text("Parent Node",110,43);
  text("Child Nodes",210,43);
  text("Room ID",315,43);
  text("Room Type",413,43);
  text("Room Difficulty",505,43);
  line(100,30,100,height);
  line(200,30,200,height);
  line(300,30,300,height);
  line(400,30,400,height);
  line(500,30,500,height);
  line(0,45,width,45);
  line(0,30,width,30);
  for(int i=0; i<level.size(); i++){
    text(i,50,i*14+59);
    text(level.get(i).getParent(),150,i*14+59);
    int[] childNodes = level.get(i).getChildren();
    if(childNodes!=null){
      for(int j=0; j<childNodes.length; j++){
        text(childNodes[j]+",",201+j*18,i*14+59);
      }
    } else{
      text("-null-",230,i*14+59);
    }
    text(level.get(i).getRoomID(),350,i*14+59);
    text(roomValues.getJSONObject(level.get(i).getRoomID()).getString("type"),430,i*14+59);
    text(roomValues.getJSONObject(level.get(i).getRoomID()).getInt("difficulty"),550,i*14+59);
  }
}

void keyPressed(){
  if(key==','){
    if(--currentProfile<0){
      currentProfile++;
    }
  }
  else if(key=='.'){
    if(++currentProfile>=usedLevels.size()){
      currentProfile--;
    }
  }
  else if(key==' '){
    createLevel();
    currentProfile= usedLevels.size()-1;
  }
}

void createLevel(){
  l[order[0]] = new Tree(4);
  order = bubble_srt_fitness(order, l);
  println("Combat:", l[order[0]].getRoomRating("combat"));
  println("Puzzle:", l[order[0]].getRoomRating("puzzle"));
  println("Size:", l[order[0]].getSize());
  println("Difficulty:", l[order[0]].getDifficultyRating());
  println("Fitness:", l[order[0]].fitness(player));
  println("---------------------------------------------");
  
  float[] prevProfile = new float[player.length];
  for(int i=0; i<player.length; i++){
    prevProfile[i] = player[i];
  }
  previousProfiles.add(prevProfile);
  usedLevels.add(new Tree(l[order[0]].getNodes()));

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
  
  l[order[0]].printNodes();
  
  player[3] += 0.005;
  player[2] ++;
}

Tree[] crossover(Tree _t1, Tree _t2) {
  int random1 = (int)random(1,_t1.getSize());
  int random2 = (int)random(1,_t2.getSize());
  Tree[] t1Parts = new Tree[2];
  Tree[] t2Parts = new Tree[2];


  t1Parts[0] = new Tree(_t1.createSubTree(random1, true));
  t1Parts[1] = new Tree(_t1.createSubTree(random1, false));
  
  t2Parts[0] = new Tree(_t2.createSubTree(random2, true));
  t2Parts[1] = new Tree(_t2.createSubTree(random2, false));
  
  Tree[] children = new Tree[2];
  children[0] = combineTrees(t1Parts[0], t2Parts[1], (int)random(t1Parts[0].getSize()));
  children[1] = combineTrees(t2Parts[0], t1Parts[1], (int)random(t2Parts[0].getSize()));
  
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
  return newTree;
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