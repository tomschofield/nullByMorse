#include "simpleToggle.h"

////////////////////////---------/////////////////////////////////////
void simpleToggle::setup(ofPoint _pos, float _width, float _height, string _name){
    pos=_pos;
    isOn=false;
    lock=false;
    name=_name;
    width=_width;
    height=_height;
}
bool simpleToggle::getValue(){
    return isOn;
}
void simpleToggle::update(ofPoint touch){
    if(touch.x>=pos.x && touch.x <= pos.x+width && touch.y > pos.y && touch.y < pos.y +height){
        isOn=!isOn;
    }
}
string simpleToggle::getName(){
    
    return name;
}
void simpleToggle::draw(ofTrueTypeFont &font){
    ofPushStyle();

    ofSetColor(guiColor);
    if (!isOn) {
        ofNoFill();
        ofSetColor(255, 255, 255);
        roundedRect(pos.x, pos.y, width, height,6);
       /* ofFill();
        ofSetColor(150, 150, 150,200);
        roundedRect(pos.x, pos.y, width, height,6);
        ofSetColor(100, 100, 100,200);
        roundedRect(pos.x, pos.y+(height*0.5), width, height*0.5,6);*/

    }
    else{
        ofNoFill();
        ofSetColor(255, 255, 255);
        int rounding = 2;
        roundedRect(pos.x, pos.y, width, height,6);
        ofFill();
        ofSetColor(255, 255, 255,200);
        roundedRect(pos.x, pos.y, width, height,6);
        ofSetColor(150, 150, 150,200);
        roundedRect(pos.x, pos.y+(height*0.5), width, height*0.5,6);
    }
    ofSetColor(255, 255, 255);
    font.drawString(name, pos.x+width+5, pos.y+height);
    ofPopStyle();
    //isOn=false;
}

//these functions courtesy of http://forum.openframeworks.cc/index.php?topic=4448.0
void simpleToggle::roundedRect(float x, float y, float w, float h, float r) {
    ofBeginShape();
    ofVertex(x+r, y);
    ofVertex(x+w-r, y);
    quadraticBezierVertex(x+w, y, x+w, y+r, x+w-r, y);
    ofVertex(x+w, y+h-r);
    quadraticBezierVertex(x+w, y+h, x+w-r, y+h, x+w, y+h-r);
    ofVertex(x+r, y+h);
    quadraticBezierVertex(x, y+h, x, y+h-r, x+r, y+h);
    ofVertex(x, y+r);
    quadraticBezierVertex(x, y, x+r, y, x, y+r);
    ofEndShape();
}

void simpleToggle::quadraticBezierVertex(float cpx, float cpy, float x, float y, float prevX, float prevY) {
    float cp1x = prevX + 2.0/3.0*(cpx - prevX);
    float cp1y = prevY + 2.0/3.0*(cpy - prevY);
    float cp2x = cp1x + (x - prevX)/3.0;
    float cp2y = cp1y + (y - prevY)/3.0;
    
     // finally call cubic Bezier curve function
    ofBezierVertex(cp1x, cp1y, cp2x, cp2y, x, y);
};
void simpleToggle::setValue(bool newValue){
    isOn=newValue;
}
