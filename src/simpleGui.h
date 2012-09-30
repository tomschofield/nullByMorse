/***************
simpleGui
 //cc. non commercial share alike Tom Schofield, Source Code licenced under GNU v3 2011
*****************/

#ifndef __simpleGui__
#define __simpleGui__

#include "ofMain.h"
#include "simpleSlider.h"
#include "simpleToggle.h"

using namespace std;


class simpleGui{
    public:
    void setup();
    void addSlider(ofPoint _pos, float _length, float _rangeStart, float _rangeEnd, string name);
    void addToggle(ofPoint _pos, float _width, float _height, string _name);
    void removeSlider();
    void removeToggle();
    void update(ofPoint touch );
    float getSliderValue(string sliderName);
    bool getToggleValue(string toggleName);
    void setToggleValue(string toggleName, bool newValue);
    void draw();
    protected:
    ofTrueTypeFont font;
    vector<simpleSlider> sliders;
    vector<simpleToggle> toggles;
};

#endif

