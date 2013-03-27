/*
 Copyright Tom Schofield 2012
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "testApp.h"


//--------------------------------------------------------------
void testApp::setup(){
    //	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
    
	ofSetFrameRate(30);
    ofEnableSmoothing();
	grabber.initGrabber(480, 360, OF_PIXELS_BGRA);
	
	pix = new unsigned char[ (int)( grabber.getWidth() * grabber.getHeight() * 3.0) ];
    monaco.loadFont("MONACO.TTF", 32);
    monaco.setSpaceSize(0.5f);
    lampIsOn = false;
    onDuration=0;
    offDuration=0;
    baseBrightness=0;
    _touch=false;
    baseUnitOfTime=100;
    rad = 10;
    currentMorse="";
    translation="";
    morseSentence="ICEBERG";
    loadMorseFromFile();
    
    //cout<<ofGetHeight()<<" "<<ofGetWidth()<<endl;
    float guiProportion = 9;
    ofPoint guiPos = ofPoint(ofGetWidth()/guiProportion,ofGetHeight()-(ofGetHeight()/guiProportion));
    
    
    gui.setup();
    gui.addSlider(guiPos, ofGetWidth()/2, 20, 80, "Radius");//ofGetWidth() -((ofGetWidth()/guiProportion)*2), 20, 80, "radius");
    gui.addSlider(ofPoint(guiPos.x,guiPos.y-50), ofGetWidth()/2, 100, 300, "Morse Speed");
    gui.addToggle(ofPoint(guiPos.x,guiPos.y-110), 40,30, "Clear");
    baseBrightness=1000;
    
}

//--------------------------------------------------------------
void testApp::update(){
	ofBackground(0,0,0);
	baseUnitOfTime=gui.getSliderValue("Morse Speed");
    //cout<<baseUnitOfTime<<endl;
    rad = gui.getSliderValue("Radius");
    
    //clear witht eh clear button
    if(gui.getToggleValue("Clear")) {
        morseSentence="";
        gui.setToggleValue("Clear", false);
        //cout<<"clearing";
    }
	grabber.update();
	ofGetElapsedTimeMillis();
}

//--------------------------------------------------------------
void testApp::draw(){
	
	ofSetColor(255);
	grabber.draw(0, 0);
	
	//tex.draw(0, 0, tex.getWidth() / 4, tex.getHeight() / 4);
    
    
    float brightness=0;
    int lowX = aOi.x-rad;
    int lowY = aOi.y-rad;
    int highX = aOi.x+rad;
    int highY = aOi.y+rad;
    int numSamples=(highX-lowX)*(highY-lowY)*3;
    int check=0;
    int capW=grabber.getWidth();
    int rowSize=capW*3;
    
    
    for(int x=lowX;x<highX;x++){
        for(int y=lowY;y<highY;y++){
            
            int i=(x*3)+(rowSize*y);
            brightness+=grabber.getPixels()[i] + grabber.getPixels()[i+1] + grabber.getPixels()[i+2];
            check+=3;
        }
    }
    
    brightness/=numSamples;
    /*if(baseBrightness<brightness){
     baseBrightness=brightness;
     cout<<"RESETTI|NG BASE "<<baseBrightness;
     
     }*/
    if (_touch) {
        baseBrightness=brightness;
        _touch=false;
    }
    
    ////cout<<brightness<<" "<<aOi.x<<" "<<aOi.y<<endl;
    ofNoFill();
    ofCircle(aOi.x, aOi.y, rad);
    float thresh=20;
    if(brightness>thresh+baseBrightness){
        lampIsOn=true;
    }
    else{
        lampIsOn=false;
    }
    //if we've just started a flash
    if(lampIsOn&&!timer.getIsLocked()){
        offDuration = timer.get();
        
        //find the length of the interval
        
        //character space should be 3* baseUnitOfTime
        if (offDuration>baseUnitOfTime*2.5 && offDuration <baseUnitOfTime *5) {
            //this is a character space
            
            //if the character is a space then kill the word and start a new one
            if (getCharacterFromMorse(currentMorse)=="~") {
                morseSentence="";
                currentMorse="";
                ////cout<<"space"<<endl;
                
            }
            else{
                //break line if it's too long for screen
                int maxNumberOfCharacters = 20;
                /*if (morseSentence.size()<maxNumberOfCharacters) {
                 morseSentence+=getCharacterFromMorse(currentMorse);
                 cout<<"short word"<<endl;
                 }
                 else{
                 morseSentence+="\n"+getCharacterFromMorse(currentMorse);
                 cout<<"long word"<<endl;
                 }*/
                if(morseSentence.size() % maxNumberOfCharacters==0 && morseSentence.size()!=0){
                    morseSentence+="\n-"+getCharacterFromMorse(currentMorse);
                }
                else{
                    morseSentence+=getCharacterFromMorse(currentMorse);
                }
                
                currentMorse="";
            }
            
        }
        else if(offDuration>=baseUnitOfTime*6){
            //this is word space
            currentMorse="";
            
        }
        else if(offDuration<=baseUnitOfTime*2){
            //this is an inter dash gap and can be ignored
        }
        
        timer.setIsLocked(true);
        timer.start();
    }
    //if we've just finished a flash
    if(!lampIsOn && timer.getIsLocked()){
        onDuration = timer.get();
        
        //find the length of the interval
        if (onDuration>baseUnitOfTime*0.5 && onDuration <baseUnitOfTime *2) {
            //this is a dot
            currentMorse+=".";
        }
        else if (onDuration>=baseUnitOfTime*2 && onDuration <baseUnitOfTime *5) {
            //this is a dash
            currentMorse+="-";
        }
        timer.setIsLocked(false);
        timer.start();
    }
    
    //  monaco.drawString(currentMorse+" "+ofToString(lampIsOn)+" "+ofToString(offDuration), 50, 50);
    monaco.drawString(morseSentence, 10, 100);
    gui.draw();
}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    gui.update(ofPoint(touch.x, touch.y));
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    gui.update(ofPoint(touch.x, touch.y));
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    aOi.set(touch.x, touch.y);
    _touch=true;
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    //cout<<ofGetHeight()<<" "<<ofGetWidth()<<endl;
    
}

void testApp::loadMorseFromFile(){
    string line;
    const char* filePath=ofToDataPath("morse.txt").c_str();
    ifstream myfile (filePath);
    if (myfile.is_open())
    {
        while ( myfile.good() )
        {
            getline (myfile,line);
            
            vector<string> twoHalves = ofSplitString(line, "\t");
            textTranslation.push_back(twoHalves[0]);
            morseCode.push_back(twoHalves[1]);
            //cout << line << endl;
        }
        myfile.close();
    }
    else{
        
        //cout<<"can't open file \n";
    }
}

string testApp::getCharacterFromMorse(string morse){
    
    for(int i=0;i<morseCode.size();i++){
        if(morseCode[i]==morse){
            return textTranslation[i];
        }
    }
    string NoMatch = "!";
    return  NoMatch;
}