/*
Name: Tree Genetic Prototype
Author: Matthew Clark
Date Created: 14/12/2016
*/

Tree t = new Tree(3);
Tree[] a = new Tree[3];

void setup(){
  t.printNodes();
  //for(int i=0; i<2; i++){
  //  t.mutate((int)random(t.getSize()));
  //}
  for(int i=0; i<a.length; i++){
    int r = (int)random(t.getSize());
    a[i] = new Tree(t.createSubTree(r, false));
  }
  for(Tree _a : a){
    _a.printNodes();
  }
  println("-------------------------------");
  //t.printNodes();
}

void draw(){
  
}

void crossover(){
  
}