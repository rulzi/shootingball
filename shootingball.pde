import ddf.minim.*;
Minim minim;
AudioPlayer title, playgame, gameover, tembak, bomb;

import procontroll.*;
import java.io.*;

ControllIO controll;
ControllDevice device;
ControllStick stick;
ControllButton buttona, buttonb, buttonstart;

//initialise score variable
int score, scoreplayer, highscore;
int ballSize = 20;
float posX;
int gameStart = 0;
boolean pause = false;
int level;
float ballspeed;
int ballcount;
int ballcountred;
int live;
int bom;
int sequence_bom, sequence_pause;
int getRandomX()
{
  return int(random(600));
}
int getRandomY()
{
  return int(random(-400));
}

//variable ball
int ballx[] = new int[100];
float bally[] = new float[100];
int ballredx[] = new int[100];
float ballredy[] = new float[100];
int ballbomx[] = new int[2];
float ballbomy[] = new float[2];
   
void setup()
{    
  //Size
  size (600, 700);
  textSize(20);
  smooth ();

  minim = new Minim(this);
  title = minim.loadFile("title.mp3");  
  tembak = minim.loadFile("initial.mp3");
  bomb = minim.loadFile("initial.mp3");
  
  controll = ControllIO.getInstance(this);
  device = controll.getDevice("Twin USB Gamepad      ");
  
  stick = device.getStick(0);
  stick.setTolerance(0.05f);
    
  buttona = device.getButton(2);
  buttonb = device.getButton(1);
  buttonstart = device.getButton(9);
}
   
void draw()
{
     
  //play game
  if (gameStart == 1){
    if (pause){
      joystick();
      fill(color(255,0,0));
      fill(255, 0, 0);
      textAlign(CENTER);
      text("PAUSE", width/2, height/2);
    } else {
      background (0);
      //player 1
      fill(255);
      stroke (122);
      triangle(posX-5, 680, posX+5, 680, posX, 670);
      rect(posX-10,680,20,20);
      rect(posX-20,690,40,10);  
   
      // display
      fill(255);
      text("Score : "+scoreplayer, 80,20);
      text("Bom : "+bom, 80,40);
      text("Level : "+level, width/2,20);
      text("Live : "+(live - 1), width/2,40);
      
      //function
       joystick();
       ballFalling();
       levelupdate();
       livereduce();
       gameFinish();
    }
     
  } else if (gameStart == 0) {
    joystick();
    fill(color(255,0,0));
    fill(255, 0, 0);
    textAlign(CENTER);
    text("Shooting Ball Multiplayer", width/2, height/2);
    text("Press Enter to Play", width/2, height/2 + 150);
    title.play();
  } else {
    joystick();  
  }
  
  sequence();
  
}

void ballFalling()
{ 
  //ball regular
  stroke(39, 154, 240);
  fill (39, 154, 240);
  for (int i=0; i<ballcount; i++)
  {
    float y = bally[i];
    int x = ballx[i];
    ellipse(x, y, ballSize, ballSize);
    bally[i] = bally[i] + ballspeed;
    if(bally[i]>=731)
    {
      bally[i] = getRandomY();
    }
  }
  
  //ball red
  stroke(255, 0, 0);
  fill (255, 0, 0);
  for (int i=0; i<ballcountred; i++)
  {
    float y = ballredy[i];
    int x = ballredx[i];
    ellipse(x, y, ballSize, ballSize);
    ballredy[i] = ballredy[i] + ballspeed;
    if(ballredy[i]>=731)
    {
      ballredy[i] = getRandomY()-200;
    }
  }
  
  //ball bom
  stroke(255, 255, 0);
  fill (255, 255, 0);
  for (int i=0; i<1; i++)
  {
    float y = ballbomy[i];
    int x = ballbomx[i];
    ellipse(x, y, ballSize, ballSize);
    ballbomy[i] = ballbomy[i] + 1;
    if(ballbomy[i]>=731)
    {
      ballbomy[i] = -800;
    }
  }
}

//tembak   
void cannon(float shotX)
{
  boolean strike = false;
  
  //ball regular
  for (int i = 0; i < ballcount; i++)
  {
    if(bally[i] > 0 &&  (shotX >= (ballx[i]-ballSize/2)) && (shotX <= (ballx[i]+ballSize/2))) {
      strike = true;
      
      fill(255);
      stroke (255);
      line(shotX, 670, shotX, bally[i]);
      
      stroke(39, 154, 240);
      fill (39, 154, 240);
      ellipse(ballx[i], bally[i], ballSize+25, ballSize+25);
      ballx[i] = getRandomX();
      bally[i] = getRandomY();
      
      // update score
      score++;
      scoreplayer++;
    }
  }
  
  //ball red
  for (int i = 0; i < ballcountred; i++)
  {
    if( ballredy[i] > 0 &&  (shotX >= (ballredx[i]-ballSize/2)) && (shotX <= (ballredx[i]+ballSize/2))) {
      strike = true;
      
      fill(255);
      stroke (255);
      line(shotX, 670, shotX, ballredy[i]);
      
      stroke(255, 0, 0);
      fill (255, 0, 0);
      ellipse(ballredx[i], ballredy[i], ballSize+25, ballSize+25);
      ballredx[i] = getRandomX();
      ballredy[i] = getRandomY()-200;
      // update live
      live = live - 1;
      // update score
      scoreplayer = scoreplayer - 5;
    }
  }
  
  //ball bom
  for (int i = 0; i < 1; i++)
  { 
    if( ballbomy[i] > 0 && (shotX >= (ballbomx[i]-ballSize/2)) && (shotX <= (ballbomx[i]+ballSize/2))) {
      strike = true;
      
      fill(255);
      stroke (255);
      line(shotX, 670, shotX, ballbomy[i]);
      
      stroke(255, 255, 0);
      fill (255, 255, 0);
      ellipse(ballbomx[i], ballbomy[i], ballSize+25, ballSize+25);
      ballbomx[i] = getRandomX();
      ballbomy[i] = -800;
      
      // update bom
      bom++;
    }
    
  }
 
  // jika tembak gak kena
  if(strike == false)
  {
    fill(255);
    stroke (255);
    line(shotX, 670, shotX, 0);
  }
  
  
    tembak.close();
    minim = new Minim(this);
    tembak = minim.loadFile("tembak.mp3");
    tembak.play();
}

//bom
void bom()
{
  for (int i = 0; i < ballcount; i++)
  {  
    //bom ball 
    stroke(39, 154, 240);
    fill (39, 154, 240);
    ellipse(ballx[i], bally[i], ballSize+25, ballSize+25);
    ballx[i] = getRandomX();
    bally[i] = getRandomY()-100;
    // update score
    score++;
    scoreplayer++;
  }
  
  for (int i = 0; i < ballcountred; i++)
  {
      stroke(255, 0, 0);
      fill (255, 0, 0);
      ellipse(ballredx[i], ballredy[i], ballSize+25, ballSize+25);
      ballredx[i] = getRandomX();
      ballredy[i] = getRandomY()-300;
  }
  
  for (int i = 0; i < 1; i++)
  {
    stroke(255, 255, 0);
    fill (255, 255, 0);
    ellipse(ballbomx[i], ballbomy[i], ballSize+25, ballSize+25);
    ballbomx[i] = getRandomX();
    ballbomy[i] = getRandomY()-900;
  }
  
  playgame.shiftGain(-40.0, 0.0, 2000);
  playgame.setGain(-10.0);
  playgame.mute();
  playgame.unmute();

  bomb.close();
  minim = new Minim(this);
  bomb = minim.loadFile("bomb.mp3");
  bomb.play();
  
}

void levelupdate()
{
   if (score >= (5 + (8 * ((level - 1) * 0.3 )) )){
     live = live + 1;
     level = level + 1;
     if (level % 4 == 0){
       ballx[ballcount] = getRandomX();
       bally[ballcount] = getRandomY();
       ballcount = ballcount + 1;
     } else {
        ballspeed = ballspeed + 0.3; 
     }
     if (level % 3 == 0){
       ballredx[ballcountred] = getRandomX();
       ballredy[ballcountred] = getRandomY();
       ballcountred = ballcountred + 1;
     }     
     score = 0;
  }
}
 
void livereduce()
{
  for (int i=0; i<ballcount; i++)
  {
    if(bally[i]>=730)
    {
      live = live - 1;
    }
  } 
}
   
//GameOver
void gameFinish()
{
  if (live <= 0) {
      if(highscore < scoreplayer){
         highscore =  scoreplayer;
      }
      fill(color(255,0,0));
      fill(255, 0, 0);
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
      text("Well done! Player score was : "+ scoreplayer, width/2, height/2 + 50);
      text("High score player : "+ highscore, width/2, height/2 + 100);
      text("Press Enter to Play Again", width/2, height/2 + 150);
      gameStart = 2;
      playgame.close();
      minim = new Minim(this);
      gameover = minim.loadFile("gameover.mp3");
      gameover.loop();    
  }
  
  if (level > 15) {
      if(highscore < scoreplayer){
         highscore =  scoreplayer;
      }
      fill(color(255,0,0));
      fill(255, 0, 0);
      textAlign(CENTER);
      text("GAME COMPLETE", width/2, height/2);
      text("Well done! Player score was : "+ scoreplayer, width/2, height/2 + 50);
      text("High score player : "+ highscore, width/2, height/2 + 100);
      text("Press Enter to Play Again", width/2, height/2 + 150);
      gameStart = 2;
      playgame.close();
      minim = new Minim(this);
      gameover = minim.loadFile("gamefinish.mp3");
      gameover.loop();    
  }
}

//sequence
void sequence(){
   sequence_bom++;
   sequence_pause++; 
}

//Play the game

void keyPressed()
{

  if (keyCode == ENTER) {
    if(gameStart == 0 || gameStart == 2) {
       startgame();
    }  else if (gameStart == 1){
      if (pause){ 
        pause = false;
        playgame.play();
      } else {
         pause = true;
         playgame.pause();
      }
    }
    
  }  
  
  if (gameStart == 1 && pause == false) {
    
    if (keyCode == UP) {
       cannon(posX);    
    }
    
    if (keyCode == DOWN) {
       if (bom > 0){
          bom();
          bom--;
       }
    }
    
    if (keyCode == RIGHT) {
      if(posX < width){
        posX = posX + 12;
      }
    }
    
    if (keyCode == LEFT) {
      if(posX > 0){
         posX = posX - 12; 
      }
    }
  }
}

void joystick(){
  if(gameStart == 1 && pause == false) {
    if(buttona.pressed()){
        cannon(posX);  
    }
    if(buttonb.pressed()){
        if (sequence_bom >= 10){
          if (bom > 0){
              bom();
              bom--;
           }
           sequence_bom = 0;
        }
      }
      
    stick.setMultiplier(4);
  
    posX = posX + stick.getY();
      
    }
  
  if (buttonstart.pressed()) {
    if(gameStart == 0 || gameStart == 2) {
        startgame();
    }  else if (gameStart == 1){
      if(sequence_pause >= 10){
        if (pause){ 
          pause = false;
          playgame.play();
        } else {
           pause = true;
           playgame.pause();
        }
        sequence_pause = 0;
      }
    }
  }  
}

void startgame(){
   if(gameStart == 0){
       title.close(); 
     } else if (gameStart == 2){
       gameover.close(); 
     }
     ballx[0] = getRandomX();
     ballx[1] = getRandomX();
     ballx[2] = getRandomX();
     ballx[3] = getRandomX();
     ballx[4] = getRandomX();
     bally[0] = getRandomY();
     bally[1] = getRandomY();
     bally[2] = getRandomY();
     bally[3] = getRandomY();
     bally[4] = getRandomY();
     ballbomx[0] = getRandomX();
     ballbomy[0] = -800;
     posX = 300;
     ballcount = live = 5;
     gameStart = level = bom = 1;
     ballspeed = 1;
     score = scoreplayer = ballcountred = 0;
     minim = new Minim(this);
//       minim.setVolume(0.5);
     playgame = minim.loadFile("playgame.mp3");
     playgame.loop();
     score = scoreplayer = ballcountred = 0;
     pause = false;
     sequence_pause = 0;
}
