//initialise score variable
int score, score1, score2;
int ballSize = 20;
int posXp1;
int posXp2;
int gameStart = 0;
int level;
float ballspeed;
int ballcount;
int teamlive;
int getRandomX()
{
  return int(random(600));
}
int ballx[] = new int[100];
float bally[] = new float[100];
   
void setup()
{    
  //Size
  size (600, 700);
  textSize(20);
  smooth ();  
}
   
void draw()
{
  if (gameStart == 1){
    background (0);
    //player 1
    fill(255);
    stroke (255);
    triangle(posXp1-8, 680, posXp1+8, 680, posXp1, 765);
    
    //player 2
    fill(122);
    stroke (255);
    triangle(posXp2-8, 680, posXp2+8, 680, posXp2, 765);
    
    // display
    fill(255);
    text("Player 1 : "+score1, 60,20);
    text("Player 2 : "+score2, width - 100,20);
    text("Level : "+level, width/2,20);
    text("TeamLive : "+(teamlive - 1), width/2,40);
   
     ballFalling();
     gameFinish();
  } else if (gameStart == 0) {
    fill(color(255,0,0));
    fill(255, 0, 0);
    textAlign(CENTER);
    text("Shooting Ball Multiplayer", width/2, height/2);
    text("Press Enter to Play", width/2, height/2 + 150);
  }
}

void ballFalling()
{ 
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
}
   
void cannon(int shotX, int player)
{
  boolean strike = false;
  for (int i = 0; i < ballcount; i++)
  {
    if((shotX >= (ballx[i]-ballSize/2)) && (shotX <= (ballx[i]+ballSize/2))) {
      strike = true;
      line(shotX, 765, shotX, bally[i]);
      ellipse(ballx[i], bally[i],
              ballSize+25, ballSize+25);
      ballx[i] = getRandomX();
      bally[i] = 0;
      // update score
      score++;
      if (player == 2){
         score2++; 
      }
      if (player == 1){
         score1++; 
      }
    }   
  }
 
  if(strike == false)
  {
    line(shotX, 765, shotX, 0);
  }
  
  if (score >= 10){
     level = level + 1;
     if (level % 4 == 0){
       ballx[ballcount] = getRandomX();
       bally[ballcount] = 0;
       ballcount = ballcount + 1;
     } else {
        ballspeed = ballspeed + 0.3; 
     }
     score = 0;
  }
 
}
   
//GameOver
void gameFinish()
{
  for (int i=0; i<ballcount; i++)
  {
    if(bally[i]>=730)
    {
      teamlive = teamlive - 1;
    }
    if (teamlive <= 0) {
        fill(color(255,0,0));
        fill(255, 0, 0);
        textAlign(CENTER);
        text("GAME OVER", width/2, height/2);
        text("Well done! Player 1 score was : "+ score1, width/2, height/2 + 50);
        text("Well done! Player 2 score was : "+ score2, width/2, height/2 + 100);
        text("Press Enter to Play Again", width/2, height/2 + 150);
        gameStart = 2; 
    }
  }
}

//Play the game

void keyPressed()
{

  if (keyCode == ENTER) {
    if(gameStart == 0 || gameStart == 2) {
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
       gameStart = 1;
       posXp1 = 200;
       posXp2 = 400;
       ballspeed = 1;
       ballcount = 5;
       level = 1;
       score = score1 = score2 = 0;
       teamlive = 5;
    }
  }  
  
  if (gameStart == 1) {
    //player 1
    if (keyCode == 87) {
      cannon(posXp1, 1);
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
