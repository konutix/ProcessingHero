import ddf.minim.*;

String TRACK = "Pisong";

PrintWriter notes;

IntList noteTrack;
IntList noteLength;

int  time = 0;

Minim minim;
AudioPlayer music;

void setup(){

  notes = createWriter(TRACK+".txt"); 

  minim = new Minim(this);
  music = minim.loadFile(TRACK+".mp3");
  
  noteTrack = new IntList();
  noteLength = new IntList();
}

void draw(){
  
  background(255,255,255);
  
  if(millis() > 5000){
    music.play();
  }
  
  if(millis() < 5000){
    fill(0);
    text(5000 - millis(),50,50);
  }
  
  //if(music.length() + 5000 < millis()){
  if(20000 < millis()){
    
    notes.println("0");
    
    for(int i = 1; i < noteTrack.size(); i++){
    
      notes.println(noteTrack.get(i));
      notes.println(noteLength.get(i));
      
    }
  
    notes.flush(); // Writes the remaining data to the file
    notes.close(); // Finishes the file
  
    exit();
    
  }

}

void keyPressed(){
  
  noteLength.append(millis() - 5000);
  
  time = millis();
  
  switch(key){
  
    case 'f':
    
      noteTrack.append(1);
    
    break;
    
    case 'g':

      noteTrack.append(2);
    
    break;
    
    case 'h':
    
      noteTrack.append(3);
    
    break;    
    
    case 'j':
    
      noteTrack.append(4);
        
    break;
  
  }
}