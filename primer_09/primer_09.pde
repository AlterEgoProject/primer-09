// 共振モデル(簡易版)

int FRAME_RATE = 60;

float[] wave; // 外力の配列
float[] basal; // 玉の位置の配列
int wave_len = 1024;
int basal_len = 1024;
float x_wave; // 描画用
float x_basal;  // 描画用

float x = 0; // 玉の位置
float v = 0; // 玉の速度

float delta = 1./FRAME_RATE*4; // 折れ線用
float s = 0; // サインカーブ用
float fr = 2*PI/FRAME_RATE; // 角速度の定数(サインカーブ用)

void setup(){
  frameRate(FRAME_RATE);
  size(512, 400, P2D);
  wave = new float[wave_len];
  basal = new float[wave_len];
  x_wave = float(width)/(wave_len);
  x_basal = float(width)/(basal_len);
}


void draw(){
  background(0);
  System.arraycopy(wave, 0, wave, 1, wave.length-1); // 配列をズラす
  
  // 例 定常
  //wave[0] = 0;
  
  // 例 -1~1の折れ線
  //wave[0] = wave[1] + delta; //
  //if (abs(wave[0])>1){delta*=-1;}
  
  // 例 サインカーブ
  s+=1;
  wave[0] = sin(fr*s); // 周波数1の波
  //wave[0] = sin(fr*1.1*s); // 周波数1.1の波
  //wave[0] = sin(fr*s)/2+ sin(3*fr*s); // 周波数1と3の合成波
  
  stroke(255);
  // 外力を描画
  for(int i=0; i < wave.length - 1; i++){
    line(x_wave*i + width/2, 100 + wave[i]*50, x_wave*(i+1) + width/2, 100 + wave[i+1]*50);
  }
  
  float d = wave[0]*100; // 見やすいように実数倍
  
  v = v +(-x*pow(2*PI,2) + d)/FRAME_RATE;
  x = x + v/FRAME_RATE;
  ellipse(width/2, x + 300, 10, 10); // 玉を描画
  System.arraycopy(basal, 0, basal, 1, basal.length-1);
  basal[0] = x;
  // 玉の軌跡を描画
  for(int i=0; i < basal.length - 1; i++){
    line(x_wave*i + width/2, 300 + basal[i], x_wave*(i+1)+ width/2, 300 + basal[i+1]);
  }
  
  // 玉に働く力を描画
  translate(width/2, 300+x); // 玉を基準点に
  stroke(255,0,0);
  line(0,0,0,d); // 外力
  stroke(0,255,0);
  line(0,0,0,-x*pow(2*PI,2)/20); // 復元力
}
