/*
Name: Tree Genetic Prototype
 Author: Matthew Clark
 Date Created: 14/12/2016
 */

//All chromosomes
Tree[] l = new Tree[100];
int[] order = new int[l.length]; //Fitness order of chromosomes from 'l'
Tree[] lChild = new Tree[10]; //Child chromosomes from crossover
int[] orderChild = new int[lChild.length]; //Fitness order of the child chromosomes from 'orderChild'

//Player profile
//Structure = [combat%, puzzle%, level size, level difficulty%]
float[] player = {0.5, 0.5, 4, 0.2};

//Values received from the room id JSON file 'rooms.json'
JSONArray roomValues;

//Arraylist of levels that were selected as the fitest
ArrayList<Tree> usedLevels = new ArrayList<Tree>();
//Arraylist of all the player profiles for each level
ArrayList<float[]> previousProfiles = new ArrayList<float[]>();

//The current level selected from usedLevels and previousProfiles
int currentProfile;

void setup() {
  //Size of canvas has a width of 600 and height of 600
  size(600,600);
  
  //Load JSON Array from rooms.json file
  roomValues = loadJSONArray("rooms.json");
  
  //Initilise usedLevels and previousProfiles. Create new chromosomes in l and find fitest level
  resetProgram();
}

void draw() {
  //Background = white
  background(255);
  fill(0);
  
  //Get current tree that is selected from usedLevels
  Tree currentTree = usedLevels.get(currentProfile);
  //Get arraylist of nodes from current tree selected
  ArrayList<Node> level = currentTree.getNodes();
  
  //Get current player profile selected from previousProfiles 
  float[] profile = previousProfiles.get(currentProfile);
  
  //----- DRAWING GUI -----
  //States current tree
  text("Tree: "+(currentProfile+1)+"/"+usedLevels.size(),0,10);
  
  //Player profile information
  fill(0,255,255,50);
  rect(100,-1,500,16);
  fill(0);
  text("Player Profile",110,10);
  text("Combat: "+profile[0],200,10);
  text("Puzzle: "+profile[1],300,10);
  text("Size: "+profile[2],400,10);
  text("Difficulty: "+profile[3],490,10);
  
  //Level information
  fill(255,0,255,50);
  rect(0,15,600,16);
  fill(0);
  
  text("Level Fitness: "+nf(currentTree.fitness(profile),1,10),10,28);
  text("Combat: "+nf(currentTree.getRoomRating("combat"),1,2),200,28);
  text("Puzzle:"+ nf(currentTree.getRoomRating("puzzle"),1,2),300,28);
  text("Size: "+nf(currentTree.getSize(),1,2),400,28);
  text("Difficulty: "+nf(currentTree.getDifficultyRating(),1,2),490,28);
  
  //Tree table headings
  text("Node Number",10,43);
  text("Parent Node",110,43);
  text("Child Nodes",210,43);
  text("Room ID",315,43);
  text("Room Type",413,43);
  text("Room Difficulty",505,43);
  
  //Table lines
  line(100,30,100,height);
  line(200,30,200,height);
  line(300,30,300,height);
  line(400,30,400,height);
  line(500,30,500,height);
  line(0,45,width,45);
  line(0,30,width,30);
  
  //Tree information
  for(int i=0; i<level.size(); i++){
    //Node Number
    text(i,50,i*14+59);
    //Parent Node
    text(level.get(i).getParent(),150,i*14+59);
    
    //Checks if the node has children or not
    int[] childNodes = level.get(i).getChildren();
    if(childNodes!=null){
      //Prints the child nodes
      for(int j=0; j<childNodes.length; j++){
        text(childNodes[j]+",",201+j*18,i*14+59);
      }
    } else{
      //If the node does not have children, print null
      text("-null-",230,i*14+59);
    }
    //The nodes room id
    text(level.get(i).getRoomID(),350,i*14+59);
    //The nodes room type (combat or puzzle)
    text(roomValues.getJSONObject(level.get(i).getRoomID()).getString("type"),430,i*14+59);
    //The nodes room difficulty
    text(roomValues.getJSONObject(level.get(i).getRoomID()).getInt("difficulty"),550,i*14+59);
  }
  
  //Display controls on screen
  fill(255);
  rect(0,height-15,width,height);
  fill(0);
  text("Controls ---   Create new tree: 'space'   Previous Tree: LEFT    Next Tree: RIGHT    Reset Program: r",10,height-3);
}

void keyPressed(){
  //Controls for program
  if(keyCode==LEFT){
    //If left arrow is pressed, decrement the current profile by 1
    if(--currentProfile<0){
      //Limit so current profile cannot be reduced passed 0
      currentProfile++;
    }
  }
  else if(keyCode==RIGHT){
    //If right arrow is pressed, increment the current profile by 1
    if(++currentProfile>=usedLevels.size()){
      //Limit so current profile cannot be increased passed the usedLevels array size
      currentProfile--;
    }
  }
  else if(key==' '){
    //If space bar has been pressed, find new levels and select fitest level to usedLevels
    createLevel();
    //Change current profile to the new level selected
    currentProfile= usedLevels.size()-1;
  }
  else if(key=='r'){
    //Reset program
    resetProgram();
  }
}

//Reset Program
void resetProgram(){
  //Create new trees for l and reset order
  for (int i=0; i<l.length; i++) {
    l[i] = new Tree(2);
    order[i] = i;
  }
  
  //Reset usedLevels and previousProfiles arrayList
  usedLevels = new ArrayList<Tree>();
  previousProfiles = new ArrayList<float[]>();
  
  //Reset the player profile values to size=4 and difficulty=0.2
  player[2]=4;
  player[3]=0.2;
  
  //Find fitest level
  createLevel();
  //Select current profile as 0
  currentProfile=0;
}

//Finds the fitest level
void createLevel(){
  //Create new tree for fitest tree
  l[order[0]] = new Tree(2);
  //Order the trees in l by fitness
  order = bubble_srt_fitness(order, l);
  
  //Print the best rooms rating to console
  println("Combat:", l[order[0]].getRoomRating("combat"));
  println("Puzzle:", l[order[0]].getRoomRating("puzzle"));
  println("Size:", l[order[0]].getSize());
  println("Difficulty:", l[order[0]].getDifficultyRating());
  println("Fitness:", l[order[0]].fitness(player));
  println("---------------------------------------------");
  
  //Add the player profile to previous profiles
  float[] prevProfile = new float[player.length];
  for(int i=0; i<player.length; i++){
    prevProfile[i] = player[i];
  }
  previousProfiles.add(prevProfile);
  //Add fitest level to usedLevels
  usedLevels.add(new Tree(l[order[0]].getNodes()));
  
  //Mutate random nodes in trees order[5] to order[l.length] 
  for(int j=5; j<l.length; j++){
    l[order[j]].mutate((int)random(l[order[j]].getSize()));
  }

  //Crossover trees order[0] to order[4]
  for (int j=0; j<orderChild.length/2; j++) {
    Tree[] _t = crossover(l[order[j]],l[order[j+1]]);
    lChild[2*j] = _t[0];
    lChild[2*j+1] = _t[1];
  }
  
  //Find fitest child tree
  for (int k=0; k<orderChild.length; k++) {
    orderChild[k] = k;
  }
  orderChild = bubble_srt_fitness(orderChild,lChild);
  
  //Remove 5 worst trees with new trees
  for(int j=0; j<5; j++){
    l[order[order.length-j-1]] = new Tree(lChild[orderChild[j]].getNodes());
  }
  
  //Print fitest tree
  l[order[0]].printNodes();
  
  //Change player profile to add 1 to size and 0.005 to difficulty
  player[3] += 0.005;
  player[2] ++;
}

//Performs crossover with two trees
Tree[] crossover(Tree _t1, Tree _t2) {
  //Select two random numbers between 0 and the size of the trees
  int random1 = (int)random(1,_t1.getSize());
  int random2 = (int)random(1,_t2.getSize());
  
  //Create two tree arrays, 1 with _t1 parts and the other with _t2 parts
  Tree[] t1Parts = new Tree[2];
  Tree[] t2Parts = new Tree[2];

  //Create subtrees (leftover tree and cutout tree) for _t1 at the random position
  t1Parts[0] = new Tree(_t1.createSubTree(random1, true));
  t1Parts[1] = new Tree(_t1.createSubTree(random1, false));
  
  //Create subtrees (leftover tree and cutout tree) for _t2 at the random position
  t2Parts[0] = new Tree(_t2.createSubTree(random2, true));
  t2Parts[1] = new Tree(_t2.createSubTree(random2, false));
  
  //Combine t1[0] with t2[1] and t2[0] with t1[1] at random positions
  Tree[] children = new Tree[2];
  children[0] = combineTrees(t1Parts[0], t2Parts[1], (int)random(t1Parts[0].getSize()));
  children[1] = combineTrees(t2Parts[0], t1Parts[1], (int)random(t2Parts[0].getSize()));
  
  //Return the children trees
  return children;
}

//Combines two trees together
//_tOne is root whilst _tTwo is attached to _tOne at node at index of _childRoot
Tree combineTrees(Tree _tOne, Tree _tTwo, int _childRoot) {
  //Get nodes from _tOne and _tTwo
  ArrayList<Node> nodesOne = _tOne.getNodes();
  ArrayList<Node> nodesTwo = _tTwo.getNodes();
  
  //Initialise new trees nodes
  ArrayList<Node> newNodes = new ArrayList<Node>();
  
  //Add all nodes from _tOne to new tree node
  for (Node n : nodesOne) {
    newNodes.add(new Node(n));
  }
  
  //Add all nodes from _tTwo to new tree node and change parent/children pointers to correct positions
  for (Node n : nodesTwo) {
    Node currentNode = new Node(n);
    
    //Check if node is not root of _tTwo
    if (currentNode.getParent()!=-1) {
      //Set parent as the current parent + the size of _tOne nodes arraylist
      currentNode.setParent(currentNode.getParent()+nodesOne.size());
    } else {
      //Set nodes parent as _childRoot
      currentNode.setParent(_childRoot);
      
      //Get node[_childRoot] from new nodes
      Node childRoot = newNodes.get(_childRoot);
      //Add the new child node
      childRoot.addChildNode(nodesOne.size());
      //Set node at _childRoot position in new tree nodes
      newNodes.set(_childRoot,childRoot);
    }
    
    //Get current nodes child nodes
    int[] currentNodeChildren = currentNode.getChildren();
    
    //Checks if the node has child nodes
    if (currentNodeChildren != null) {
      //Loops through all child nodes
      for (int i=0; i<currentNodeChildren.length; i++) {
        //Adds the _tOne size to all the child nodes
        currentNodeChildren[i]+=nodesOne.size();
      }
    }
    //Sets the child nodes in currentNode to the new child node positions
    currentNode.setChildren(currentNodeChildren);
    //Add modified node to newNodes arraylist
    newNodes.add(currentNode);
  }
  
  //Create a tree with the newNodes arratlist
  Tree newTree = new Tree(newNodes);
  
  //Return new tree
  return newTree;
}

//--------------- DEBUG --------------- 

//Checks if there is an error with the connections in the tree
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
//Customised to be used with the Tree class I have created
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