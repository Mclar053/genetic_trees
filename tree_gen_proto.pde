/*
Name: Tree Genetic Prototype
Author: Matthew Clark
Date Created: 14/12/2016
*/

Tree t = new Tree(3);
Tree[] a = new Tree[3];

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
    int r = (int)random(t.getSize());
    a[i] = new Tree(t.createSubTree(r, false));
  }
  //for(Tree _a : a){
  //  _a.printNodes();
  //}
  println("-------------------------------");
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
  //t.printNodes();
}

void draw(){
  
}

void crossover(){
  
}