import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ArrayList <Blob> blobs = new ArrayList<Blob>();

boolean blobsUpdated = false;


void setup() {
  size(640,480);
  frameRate(25);
  oscP5 = new OscP5(this,12345); // listen for osc on port 12345
   
  textSize(15);
}

void draw() {
  
  // check for incoming blobs and unexpected null state in the ArrayList
  if (blobsUpdated){
    
    // *** ------------ do stuff using the blobs array list here ------------ *** //
    // this updates every time at least one blob was received via OSC message
    background(0);
    text("nr of blobs: " + blobs.size(), 10, 20);
    for (int i = 0; i < blobs.size(); i++){
      ellipse(blobs.get(i).x, blobs.get(i).y, 40, 40);
      text(blobs.get(i).x + " " + blobs.get(i).y + " " + blobs.get(i).id, blobs.get(i).x+25, blobs.get(i).y+25); 
    }
    // *** ------------------------------------------------------------------ *** //
    
    blobsUpdated = false; // reset the blobs updated flag
  }
}




void oscEvent(OscMessage theOscMessage) {
  
  // filter incoming messages, and update the trackers list 
  if(theOscMessage.checkAddrPattern("/BlobXY")==true && !blobsUpdated) {
    blobs.clear();
    blobsUpdated = true; // set the blobs updated flag
    for (int i = 0; i < theOscMessage.typetag().length(); i+=3){
        if (theOscMessage.typetag().substring(i,i+3).equals("iii")){
          blobs.add(new Blob(theOscMessage.get(i).intValue(), theOscMessage.get(i+1).intValue(), theOscMessage.get(i+2).intValue()));
        }
        else println("ERROR on typetag");
    }
  } 
  //println("### received an osc message. with address pattern " + theOscMessage.addrPattern());
  //println("### received an osc message. with type tag " + theOscMessage.typetag());
  //println();
}

class Blob{
  int x, y, id;
  
  Blob(int x_, int y_, int id_){
    x = x_;
    y = y_;
    id = id_;
  }
}
