// Main Page : total
// Main Page(key) : 'M'
// Sub Page : specific data
// Sub Page(key): 'S' > 보고싶은 국가를 선택 or SubPage로 들어가는 방식으로

// MainPage  에서는 무엇을 보여줄 것인지? theme : world data
/*
1) main_graph1 : 월별 선택한 속성의 그래프(barchart)
2) main_graph2 : 지진이 발생한 사건(bubble chart)
*/
// SubPage   에서는 무엇을 보여줄 것인지? theme : country data
/*
*/

int page = 0; // Main = 0, Sub = 1
int show_grid = -1; //show_grid=1, dont_show_grid=-1
int grid_gap = 10;
int main_sectNum = 4;
int sub_sectNum = 4;
int[][] main_section = new int [main_sectNum][2];
int[][] sub_section = new int [sub_sectNum][2];

int[] page_tabLeft = new int [2]; // Main page & Sub Page tab button
int[] page_tabRight = new int [2];
int page_tabTop, page_tabBottom;

int tabbox_top, tabbox_bottom, tabbox_width, tabbox_height;
int[] tabboxLeft = new int[2]; // worldmap_control tab box
int[] tabboxRight = new int[2];
int[] texttabboxLeft = new int[2]; // worldmap_control text box
int[] texttabboxRight = new int[2];
int start_year = 2000;
int end_year = 2017;

boolean start_change = false; // boolean param asking to change start_year
boolean end_change = false; // boolean param asking to change end_year

Table[] NOAA_year = new Table[18]; // 선택하는 년도에 따른 데이터
Table[] NOAA_country = new Table[97]; // 선택하는 국가에 따른 데이터

PFont title_font;
PFont tab_font;

color TAB_color = #FA7E7E;
color GRID_color = color(200);
color BOX_color = color(38,177,250);

String[] columnName = {"DH","MS","IN","DD","HT","HM"};
int selectedColumn = 0;

void setup(){
  size(1800,800);
  title_font = loadFont("YDIYGO310-48.vlw");
  tab_font = loadFont("YDIYGO350-10.vlw");
  
  // load NOAA_year Table
  for(int year = 0 ; year<18 ; year++){
    NOAA_year[year] = loadTable("NOAA_year["+year+"].csv","header");
  }
  
  main_section[0][0] = 20;   main_section[0][1] = 100;
  main_section[1][0] = 20;   main_section[1][1] = 480;
  
  main_section[2][0] = 530;  main_section[2][1] = main_section[0][1];
  main_section[3][0] = 530;  main_section[3][1] = main_section[2][1]+460+grid_gap*2;
  
}

void draw(){
  background(0,10);
  show_gridlines(); // main_section을 나눌 때 이용하기 위한 그리드선
  draw_title(); // title을 보여주는 함수
  draw_titletabs(); // title tab을 보여주는 함수
  show_page();
  
  // print("start_year:"+start_year+" | start_change:"+ start_change);
  // print(" end_year:"+end_year+" | end_change:"+ end_change);
}

void show_page(){
  if(page ==0){
    draw_worldmap(); // 세계 지도를 보여주는 함수
    draw_graph1();
    draw_graph2();
  }
  else{
  }
}
    
void show_gridlines(){
  strokeWeight(1);
  if(show_grid == 1){
    for(int i=0 ; i<=width ; i+=grid_gap){
      stroke(255,60);
      line(i,0,i,height);
    }
    for(int i=0 ; i<=height; i+=grid_gap){
      stroke(255,60);
      line(0,i,width,i);
    }
  }
  if(show_grid == -1){
    stroke(0);
  } 
  // println(" x:"+mouseX + " y:" + mouseY);
}

void draw_title(){
  int title_height = 100;
  int title_gap = 20;
  
  fill(255);
  textFont(title_font);
  textSize(50);
  textAlign(LEFT,BOTTOM);
  text("EARTHQUAKES",title_gap,title_height-title_gap);
  
  fill(255);
  strokeWeight(2);
  stroke(200);
  line(title_gap, title_height-title_gap, width-title_gap, title_height-title_gap);
}

void draw_titletabs(){
  int tabHeight = 30;
  String[] title = {"Main Page","Sub Page"};
  
  rectMode(CORNERS);
  noStroke();
  textSize(24);
  textAlign(LEFT,BOTTOM);
  
  page_tabBottom = 70;
  page_tabTop = page_tabBottom - tabHeight;
  page_tabLeft[0] = 370;
  page_tabRight[0] = page_tabLeft[0]+20;
  page_tabLeft[1] = page_tabRight[0]+int(textWidth("Main Page"))+grid_gap*2;
  page_tabRight[1] = page_tabLeft[1]+20;
  
  for(int i=0 ; i<2 ; i++){
    fill( i == page? TAB_color : 255);
    rect(page_tabLeft[i],page_tabTop,page_tabRight[i],page_tabBottom);
    text(title[i], page_tabRight[i]+grid_gap,page_tabBottom);
  }
  stroke(255);
}

void keyPressed(){
  // about visualizing grid lines
  if(key=='V' || key=='v'){
    show_grid *= -1;
  }
  
  // about page changes
  if(key=='M' || key=='m'){ // 'M'ain page
    page = 0;
  }
  if(key=='S' || key=='s'){ // 'S'ub page
    page = 1;
  }
  if(key == '2'){
    selectedColumn += 1;
    if(selectedColumn >= columnName.length-1){
    selectedColumn = columnName.length-1;
    }
  }
  if(key == '3'){
    selectedColumn -= 1;
    if(selectedColumn <= 0 ){
      selectedColumn = 0;
    }
  }
  // about worldmap_control tab button : changing start or end years
  if(start_change == true){
    if(key == 'U' || key == 'u'){
      start_year += 1;
      if(start_year >= 2017){
        start_year = 2017;
      }
      if(start_year >= end_year){
        start_year = end_year-1;
      }
    }
    if(key == 'D' || key == 'd'){
      start_year -= 1;
      if(start_year <=2000){
        start_year = 2000;
      }
    }
  }
  if(end_change == true){
    if(key == 'U' || key == 'u'){
      end_year += 1;
      if(end_year >= 2017){
        end_year = 2017;
      }
    }
    if(key == 'D' || key == 'd'){
      end_year -= 1;
      if(end_year <=2000){
        end_year = 2000;
      }
      if(start_year >= end_year){
        end_year = start_year+1;
      }
    }
  }
}

void mousePressed(){ // graph1 legend를 활성화시키기 위해서는 legend를 전부 배열에 처리..
  // about page_tab button
  if(mouseY > page_tabTop && mouseY < page_tabBottom){
    for(int i=0 ; i<2 ; i++){
      if(mouseX > page_tabLeft[i] && mouseX < page_tabRight[i]){
        page = i;
      }
    }
  }
  
  // about worldmap_control tab button
  if(mouseX > tabboxLeft[0] && mouseX < tabboxRight[0]){
    if(mouseY > tabbox_top && mouseY < tabbox_bottom){
      start_change = true;
      end_change = false;
    }
    else if(mouseY > tabbox_top+tabbox_height+10 && mouseY < tabbox_bottom+tabbox_height+10){
      start_change = false;
      end_change = true;
    }
  }
  else{
    start_change = false;
    end_change = false;
  }
}
