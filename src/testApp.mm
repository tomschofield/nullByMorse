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
<<<<<<< HEAD
 */
    

#include "testApp.h"


//--------------------------------------------------------------
void testApp::setup(){
    //	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
    
	ofSetFrameRate(30);
    ofEnableSmoothing();
    
 	capW = 480;
	capH = 360;
    //480/360
	grabber.initGrabber(capW, capH, OF_PIXELS_BGRA);
	
    capW = grabber.getWidth();
    capH = grabber.getHeight();
    
    colorImg.allocate(capW,capH);
    grayImage.allocate(capW,capH);
    grayBg.allocate(capW,capH);
    grayDiff.allocate(capW,capH);
    
	bLearnBakground = true;
	threshold = 160;
	
	ofSetFrameRate(20);

    
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
    
    trainingMaxBrightness = 0;
    trainingMinBrightness = 1000;
    findCentre=false;
     train = false;
     numberOfFramesToTrainFor =0;
    
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
	//grabber.update();
	//ofGetElapsedTimeMillis();
    
    bool bNewFrame = false;
    grabber.update();
    bNewFrame = grabber.isFrameNew();
    
    if (bNewFrame){
        
        if( grabber.getPixels() != NULL ){  
            
                colorImg.setFromPixels(grabber.getPixels(), capW, capH);
                grayImage = colorImg;
            
                if (bLearnBakground == true){
                    grayBg = grayImage;		// the = sign copys the pixels from grayImage into grayBg (operator overloading)
                    
                    bLearnBakground = false;
                }
                
                // take the abs value of the difference between background and incoming and then threshold:
                grayDiff.absDiff(grayBg, grayImage);
                grayDiff.threshold(threshold);
                
                // find contours which are between the size of 20 pixels and 1/3 the w*h pixels.
                // also, find holes is set to true so we will get interior contours as well....
                contourFinder.findContours(grayDiff, 20, (capW*capH)/3, 10, true);	// find holes
            
            }
        //here check that the area is bright and only if it then make learnbackground false;
        if (findCentre&&contourFinder.blobs.size()>0){
            //cout<<"blob is still dark"<<endl;
            float biggestArea = 0.0f;
            int biggestIndex =0;
            //if (bLearnBakground){
            
            for (int i = 0; i < contourFinder.nBlobs; i++){
                if(contourFinder.blobs[i].area>biggestArea){
                    biggestArea = contourFinder.blobs[i].area;
                    biggestIndex=i;
                }
                //cout<<contourFinder.blobs[i].centroid.x<<" ";
            }
            //cout<<"contourFinder.blobs.size() "<<contourFinder.blobs.size()<<endl;
            if(contourFinder.blobs.size()>0){
                //contourFinder.blobs[biggestIndex].draw(0,0);
                aOi.set(contourFinder.blobs[biggestIndex].centroid.x, contourFinder.blobs[biggestIndex].centroid.y);
                
            }

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
            //cout<<brightness<<" brightness ";
            if (brightness>150) {
                //bLearnBakground=false;
                cout<<"FOUND CENTRE OF LIGHT"<<endl;
                train=true;
                findCentre=false;
                //area of a circle is PI * radius squared
                rad = sqrt( contourFinder.blobs[biggestIndex].area/PI);
                rad*=2;
            }
        }
    }
}

//--------------------------------------------------------------
void testApp::draw(){
	
	ofSetColor(255);
	grabber.draw(0, 0);
    ofPushStyle();
    ofSetHexColor(0xffffff);
//    float biggestArea = 0.0f;
//    int biggestIndex =0;
//    //if (bLearnBakground){
//    
//        for (int i = 0; i < contourFinder.nBlobs; i++){
//            if(contourFinder.blobs[i].area>biggestArea){
//                biggestArea = contourFinder.blobs[i].area;
//                biggestIndex=i;
//            }
//            //cout<<contourFinder.blobs[i].centroid.x<<" ";
//        }
//        if(contourFinder.blobs.size()>0){
//            //contourFinder.blobs[biggestIndex].draw(0,0);
//            aOi.set(contourFinder.blobs[biggestIndex].centroid.x, contourFinder.blobs[biggestIndex].centroid.y);
//
//        }
    //}
	ofPopStyle();
	//tex.draw(0, 0, tex.getWidth() / 4, tex.getHeight() / 4);
	char reportStr[1024];
	sprintf(reportStr, "bg subtraction and blob detection\npress ' ' to capture bg\nthreshold %i\nnum blobs found %i, fps: %f", threshold, contourFinder.nBlobs, ofGetFrameRate());
	//ofDrawBitmapString(reportStr, 4, 380);
    
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
    float thresh=20;
    brightness/=numSamples;
    
    
    if (train) {
        if(numberOfFramesToTrainFor<100){
        //cout<<"training";
            if (brightness>trainingMaxBrightness) {
                trainingMaxBrightness = brightness;
               //cout<<"new max brightness is "<<trainingMaxBrightness<<endl;
            }
            if (brightness<trainingMinBrightness) {
                trainingMinBrightness = brightness;
                //                cout<<"new min brightness is "<<trainingMinBrightness<<endl;

            }
        numberOfFramesToTrainFor++;
        }
        else{
            train =false;
            baseBrightness = trainingMinBrightness;
            cout<<"brightness is "<<baseBrightness<<endl;
            
            cout<<"trainingMaxBrightness "<<trainingMaxBrightness<<" trainingMinBrightness "<<trainingMinBrightness<<endl;
            
            cout<<"brightness difference "<<trainingMaxBrightness - trainingMinBrightness<<endl;
            
            thresh= (trainingMaxBrightness-trainingMinBrightness)/3;
            float allOverThresh =thresh+baseBrightness;
            cout<<" real thresh "<<thresh<<" ";
            cout<<"finished training!";
            numberOfFramesToTrainFor=0;
        }
        //baseBrightness=brightness;
       // _touch=false;
    }
    
    //in training mode we try and define two max and min brightnesses
    
    
    ////cout<<brightness<<" "<<aOi.x<<" "<<aOi.y<<endl;
    ofNoFill();
    ofCircle(aOi.x-(0.5*rad), aOi.y-(0.5*rad), rad);
    
    if(brightness>thresh+baseBrightness){
        lampIsOn=true;
       // cout<<" lamp is ON and brightness is "<<brightness<<endl;
    }
    else{
        lampIsOn=false;
       // cout<<" lamp is OFF and brightness is "<<brightness<<endl;
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
    bLearnBakground = true;
    findCentre=true;
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
    //aOi.set(touch.x, touch.y);
    //_touch=true;
    //train=true;
    bLearnBakground = true;
    findCentre=true;

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