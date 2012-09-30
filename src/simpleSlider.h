/***************
simpleSlider
 //cc. non commercial share alike Tom Schofield, Source Code licenced under GNU v3 2011
*****************/

#ifndef __simpleSlider__
#define __simpleSlider__

#include "ofMain.h"

using namespace std;


class simpleSlider{
    public:
    void setup(ofPoint _pos, float _length, float _rangeStart, float _rangeEnd, string _name);
    float getValue();
    void update(ofPoint touch);
    void draw(ofTrueTypeFont &font);
    string getName();
protected:
    void roundedRect(float x, float y, float w, float h, float r);
    void quadraticBezierVertex(float cpx, float cpy, float x, float y, float prevX, float prevY);

    ofPoint pos;
    float length;
    float rad;
    float val;
    float rangeStart;
    float rangeEnd;
    ofColor guiColor;
    string name;

};

#endif

