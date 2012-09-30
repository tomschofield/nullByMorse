#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxSimpleTimer.h"
#include "simpleGui.h"

class testApp : public ofxiPhoneApp{
	
	public:
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
		
        void loadMorseFromFile();
        string getCharacterFromMorse(string morse);
		ofVideoGrabber grabber;
		ofTexture tex;
		unsigned char * pix;
        ofxSimpleTimer timer;
    ///the touch point centre
        ofPoint aOi;
        float rad;
        ofTrueTypeFont monaco;
        bool lampIsOn;
        float onDuration;
        float offDuration;
    float baseBrightness;
    bool _touch;
    int baseUnitOfTime;
    string currentMorse;
    string translation;
    string morseSentence;
    
    //look up table for the morse
    vector<string> morseCode;
    vector<string> textTranslation;
    
    simpleGui gui;
};
