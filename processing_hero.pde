import ddf.minim.*;

//wybrany utwor

String TRACK = "Outcast"; // <- nazwa pliku muzycznego i tekstowego do gry

//zmienne do liczenia punktów i kliknięć
int points = 0;
int clicks = 0;

Minim minim;
AudioPlayer music;

ArrayList<Note> notes = new ArrayList<Note>();


int[] noteTrack;

int[] noteTime;

int actualNote = 0;

int start;


//stworzenie zmiennych do kontroli czasu trwania włączonego przycisku aby nie trwał on jedną klatkę 
int pressed = 0;
int timePressed = 0;

//zmienna mówiąca czy muzyka jest włączona
boolean play = false;

void setup(){
 
  size(250,610);
  
  frameRate(60);
  
  noStroke();
  
  minim = new Minim(this);
  music = minim.loadFile(TRACK+".mp3");
  
  String[] lines = loadStrings(TRACK+".txt");
  
  noteTime = new int[lines.length];
  noteTrack = new int[lines.length];
  
  int j = 0;
  
  for(int i = 0; i < lines.length; i++){
    

    if(i % 2 == 0){
      
      noteTrack[j] = parseInt(lines[i]);
      j++;
      
    }

    else noteTime[j] = parseInt(lines[i]);
    
    start = millis();
    
  }
  
}

void draw(){
    
  //podtrzymywanie aktywnego przycisku
  if(pressed != 0 && timePressed == 0){
    timePressed = millis();
  }
  if(timePressed + 50 < millis()){
    timePressed = 0;
    pressed = 0;  
  }
  
  //czyszczenie poprzedniej klatki
  background(255,255,255);
  
  //rysowanie tła
  
  //tor
  
  //włączenie obrysu figur
  stroke(0);
  
  line(35,0,35,610);
  line(95,0,95,610);
  line(155,0,155,610);
  line(215,0,215,610);
  
  fill(139,69,19);
  rect(0,0,35,610);
  rect(95,0,60,610);
  rect(215,0,35,610);
  
  fill(205,133,63);
  rect(35,0,60,610);  
  rect(155,0,60,610);  
  
  //wyłączenie obrysu figur
  noStroke();
  
  //aktywatory
  fill(222,184,135);
  ellipse(35,525,50,50);
  ellipse(95,525,50,50);
  ellipse(155,525,50,50);
  ellipse(215,525,50,50);
  
  //napisy na aktywatorach
  fill(0);
  textSize(45);
  text("F",23,542);
  text("G",78,541);
  text("H",139,542);
  text("J",210,538);
  
  stroke(0);
  line(0,500,610,500);
  noStroke();
  
  //rysowanie wciśniętego przycisku
  switch(pressed){
  
  case 1:
    fill(255,100,255);
  ellipse(35,525,50,50);
    
    break;
    
  case 2:
    fill(255,100,255);
  ellipse(95,525,50,50);
    
    break;
    
  case 3:
    fill(255,100,255);
  ellipse(155,525,50,50);
    
    break;
    
  case 4:
    fill(255,100,255);
  ellipse(215,525,50,50);
    
    break;
  
  }
  
  //tworzenie nut i dodawanie ich do listy
  
  text("Wynik: " + points + "/" + noteTime.length,20,290);
  
  //sprawdznie czy utwór się skończył i kiedy ma się pojawić ostatnis nuta (czas trwania utwotu - czas lotu nuty do pola aktywacyjnego)
  if(millis() < music.length() - 3000){
    
    if(actualNote < noteTime.length)
    if(noteTime[actualNote] <= millis() - start){
    
      //tworznie nuty na losowym torze i na wysokości -35
      notes.add(new Note(noteTrack[actualNote],-35));
      
      actualNote++;
    }
    
  }
  
  //wypisywanie wyniku
  if(actualNote == noteTime.length && millis() - 3000 > noteTime[noteTime.length-1]){
    
    fill(0);
    rect(10,250,230,65);
    fill(255);
    textSize(25);
    if(clicks != 0) text("Wynik: " + points + "/" + noteTime.length,20,290);
    else text("Wynik: " + "0" + "/" + noteTime.length,20,295);
    
  }
  
  //aktualizacja nut
  
  //pętla foreach wykonująca aktualizację karzdej nuty na liście
  
  for(Note nuta : notes){
    
    if(nuta != null){
    
      //ruch nuty
      nuta.move();
    
      //rysowanie nuty
      nuta.drawSelf();
    
      //odtworzenie muzyki kiedy pierwsza nuta będzie na pozycji
      if(!play){
      
        nuta.play();
      
      }
      
      if(nuta.check()) points++;
    
      if(nuta.y > 650 || nuta.size == 54){
    
        notes.set(notes.indexOf(nuta), null);
    
      }
    
    }
     
    }
    
  }

//sczytywanie przycisków z klawiatury
void keyPressed(){
  
  //doliczanie kliknięcia
  clicks++;
  
  //wyznaczanie wciśniętego przycisku
  switch(key){
    
  case 'f':
    
    pressed = 1;
    
    break;
    
  case 'g':
    
    pressed = 2;
    
    break;
    
  case 'h':
    
    pressed = 3;
    
    break;
    
  case 'j':
    
    pressed = 4;
    
    break;
  
  }

}

// definiowanie klasy do nut
class Note{

  // czy nuta została trafiona
  boolean hit = false;
  
  // tor nuty
  int track;
  
  // wysokość nuty
  int y;
  
  int size = 25;
  int alpha = 255;
  
  // konstruktor przypisuje podane tor i początkową wysokość
  Note(int ptrack, int py){
  
    track = ptrack;
    y = py;
    
  }
  
  //metoda do opadania nuty
  void move(){
  
    if(!hit && y < height + 30){
      
      y += 5;
      
    }
    
    if(hit){
      
       if(size < 54) size += 2;
       if(alpha > 0) alpha -= 10; else if(alpha == 5)  alpha -= 5;
      
    }
  
  }
  
  //metoda rysująca nutę
  void drawSelf(){
    
    if(y < height + 30){
    
      //zmiana koloru na zielony
      fill(0,255,0,alpha);
    
      //rysowanie nuty jeśli nie jest trafiona

      switch(track){
      case 1:
        ellipse(35,y,size,size);
      break;
      case 2:
        ellipse(95,y,size,size);
      break;
      case 3:
        ellipse(155,y,size,size);
      break;
      case 4:
        ellipse(215,y,size,size);
      break;
      }
    
    }
    
  }
  
  //metoda sprawdza czy nuta została trafionai dolicza punkty jeśli tak
  boolean check(){
  
    if(y>500 && y<550 && track == pressed && hit == false){
      
      hit = true;
      
      return true;
      
    }
    
    return false;
  }
  
  //metoda zagra muzykę kiedy pierwsza nuta pojawi się poniżej y = 400 i ustawi boola play na true przez co ta metoda nie będzie wywoływana podczas aktualizacji
  void play(){
    
      if(y > 450){
        
        music.play();
        play = true;
      
      }
      
    }
    
}