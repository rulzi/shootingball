import ddf.minim.*;

Minim minim;
AudioPlayer title, playgame, gameover, tembak, bomb;

//initialise score variable
int score, score1, score2, scoreteam;
int ballSize = 20;
int posXp1;
int posXp2;
int gameStart = 0;
int level;
float ballspeed;
int ballcount;
int ballcountred;
int teamlive;
int bomp1, bomp2;
int getRandomX()
{
  return int(random(600));
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
}
   
void draw()
{
  
  //play game
  if (gameStart == 1){
    background (0);
    //player 1
    fill(255);
    stroke (122);
    triangle(posXp1-5, 680, posXp1+5, 680, posXp1, 670);
    rect(posXp1-10,680,20,20);
    rect(posXp1-20,690,40,10);  
    
    //player 2
    fill(122);
    stroke (255);
    triangle(posXp2-5, 680, posXp2+5, 680, posXp2, 670);
    rect(posXp2-10,680,20,20);
    rect(posXp2-20,690,40,10);
 
    // display
    fill(255);
    text("Player 1 : "+score1, 80,20);
    text("Bom : "+bomp1, 80,40);
    text("Player 2 : "+score2, width - 100,20);
    text("bom : "+bomp2, width - 100,40);
    text("Level : "+level, width/2,20);
    text("TeamLive : "+(teamlive - 1), width/2,40);
    text("Score Team : "+scoreteam, width/2,60);
    
    //function
     ballFalling();
     levelupdate();
     livereduce();
     gameFinish();
     
  } else if (gameStart == 0) {
    fill(color(255,0,0));
    fill(255, 0, 0);
    textAlign(CENTER);
    text("Shooting Ball Multiplayer", width/2, height/2);
    text("Press Enter to Play", width/2, height/2 + 150);
    title.play();
  }
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
      bally[i] = 0;
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
      ballredy[i] = -200;
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
void cannon(int shotX, int player)
{
  boolean strike = false;
  
  //ball regular
  for (int i = 0; i < ballcount; i++)
  {
    if((shotX >= (ballx[i]-ballSize/2)) && (shotX <= (ballx[i]+ballSize/2))) {
      strike = true;
      
      fill(255);
      stroke (255);
      line(shotX, 670, shotX, bally[i]);
      
      stroke(39, 154, 240);
      fill (39, 154, 240);
      ellipse(ballx[i], bally[i], ballSize+25, ballSize+25);
      ballx[i] = getRandomX();
      bally[i] = 0;
      
      // update score
      score++;
      scoreteam++;
      if (player == 2){
         score2++; 
      }
      if (player == 1){
         score1++; 
      }
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
      ballredy[i] = -200;
      // update live
      teamlive = teamlive - 1;
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
      if (player == 2){
         bomp2++; 
      }
      if (player == 1){
         bomp1++; 
      }
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
void bom(int player)
{
  for (int i = 0; i < ballcount; i++)
  {  
    //bom ball 
    stroke(39, 154, 240);
    fill (39, 154, 240);
    ellipse(ballx[i], bally[i], ballSize+25, ballSize+25);
    ballx[i] = getRandomX();
    bally[i] = -100;
    // update score
    score++;
    scoreteam++;
    if (player == 2){
       score2++; 
    }
    if (player == 1){
       score1++; 
    }
  }
  
  for (int i = 0; i < ballcountred; i++)
  {
      stroke(255, 0, 0);
      fill (255, 0, 0);
      ellipse(ballredx[i], ballredy[i], ballSize+25, ballSize+25);
      ballredx[i] = getRandomX();
      ballredy[i] = -300;
  }
  
  for (int i = 0; i < 1; i++)
  {
    stroke(255, 255, 0);
    fill (255, 255, 0);
    ellipse(ballbomx[i], ballbomy[i], ballSize+25, ballSize+25);
    ballbomx[i] = getRandomX();
    ballbomy[i] = -900;
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
   if (score >= 10){
     teamlive = teamlive + 1;
     level = level + 1;
     if (level % 4 == 0){
       ballx[ballcount] = getRandomX();
       bally[ballcount] = 0;
       ballcount = ballcount + 1;
     } else {
        ballspeed = ballspeed + 0.3; 
     }
     if (level % 3 == 0){
       ballredx[ballcountred] = getRandomX();
       ballredy[ballcountred] = 0;
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
      teamlive = teamlive - 1;
    }
  } 
}
   
//GameOver
void gameFinish()
{
  if (teamlive <= 0) {
      fill(color(255,0,0));
      fill(255, 0, 0);
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
      text("Well done! Player 1 score was : "+ score1, width/2, height/2 + 50);
      text("Well done! Player 2 score was : "+ score2, width/2, height/2 + 100);
      text("Press Enter to Play Again", width/2, height/2 + 150);
      gameStart = 2;
      playgame.close();
      minim = new Minim(this);
      gameover = minim.loadFile("gameover.mp3");
      gameover.loop();    
  }
}

//Play the game

void keyPressed()
{

  if (keyCode == ENTER) {
    if(gameStart == 0 || gameStart == 2) {
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
       bally[0] = 0;
       bally[1] = -20;
       bally[2] = -40;
       bally[3] = -60;
       bally[4] = -80;
       ballbomx[0] = getRandomX();
       ballbomy[0] = -800;
       posXp1 = 200;
       posXp2 = 400;
       ballcount = teamlive = 5;
       gameStart = level = bomp1 = bomp2 = 1;
       ballspeed = 1;
       score = score1 = score2 = scoreteam = ballcountred = 0;
       minim = new Minim(this);
//       minim.setVolume(0.5);
       playgame = minim.loadFile("playgame.mp3");
       playgame.loop();       
    }
  }  
  
  if (gameStart == 1) {
    //player 1
    if (keyCode == 87) {
      cannon(posXp1, 1);
    }
    
    //player 2
    if (keyCode == 83) {
       if (bomp1 > 0){
          bom(1);
          bomp1--;
       }
    }
    
    if (keyCode == 68) {
      if(posXp1 < width){
        posXp1 = posXp1 + 12;
      }
    }
    
    if (keyCode == 65) {
      if(posXp1 > 0){
        posXp1 = posXp1 - 12;
      }
    }
    
    //player 2
    if (keyCode == UP) {
       cannon(posXp2, 2);    
    }
    
    //player 2
    if (keyCode == DOWN) {
       if (bomp2 > 0){
          bom(2);
          bomp2--;
       }
    }
    
    if (keyCode == RIGHT) {
      if(posXp2 < width){
        posXp2 = posXp2 + 12;
      }
    }
    
    if (keyCode == LEFT) {
      if(posXp2 > 0){
         posXp2 = posXp2 - 12; 
      }
    }
  }
}
