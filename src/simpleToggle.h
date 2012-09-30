/***************
simpleToggle
 //cc. non commercial share alike Tom Schofield, Source Code licenced under GNU v3 2011
*****************/

#ifndef __simpleToggle__
#define __simpleToggle__

#include "ofMain.h"

using namespace std;


class simpleToggle{
public:
    void setup(ofPoint _pos, float _width, float _height, string _name);
    bool getValue();
    void setValue(bool newValue);
    void update(ofPoint touch);
    void draw(ofTrueTypeFont &font);
    string getName();
protected:
    void roundedRect(float x, float y, float w, float h, float r);
    void quadraticBezierVertex(float cpx, float cpy, float x, float y, float prevX, float prevY);
    ofPoint pos;
    float  width, height;
    bool isOn;
    bool lock;
    ofColor guiColor;
    string name;
};

#endif

