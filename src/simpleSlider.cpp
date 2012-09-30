#include "simpleSlider.h"
////////////////////////---------/////////////////////////////////////
void simpleSlider::setup(ofPoint _pos, float _length, float _rangeStart, float _rangeEnd, string _name){
    pos=_pos;
    length=_length;
    rad=10;
    val=0;
    rangeStart=_rangeStart;
    rangeEnd=_rangeEnd;
    name=_name;
}
float simpleSlider::getValue(){
    return ofMap(val, 0, length, rangeStart, rangeEnd);
}
void simpleSlider::update(ofPoint touch){
    float tol=20;
    if(touch.x>=pos.x && touch.x <= pos.x+length && touch.y > pos.y-tol && touch.y < pos.y +tol){
        val = touch.x-pos.x;
    }
}
string simpleSlider::getName(){
    
    return name;
}
void simpleSlider::draw(ofTrueTypeFont &font){
    ofPushStyle();
    ofSetColor(guiColor);
   // ofSetLineWidth(2);
    ofNoFill();
    float arrowTipHyp=20;
    float arrowTipOpp=7;

    ofLine(pos.x, pos.y, pos.x+length, pos.y);
    //arrow
    ofLine(pos.x+length-arrowTipHyp, pos.y-arrowTipOpp, pos.x+length, pos.y);
    ofLine(pos.x+length-arrowTipHyp, pos.y+arrowTipOpp, pos.x+length, pos.y);
    
    
    
    //ofCircle(pos.x+val, pos.y, rad);
    float height = rad*2;
    float width = rad*1.5;
    ofNoFill();
    ofSetColor(255, 255, 255);
    roundedRect(pos.x+val, pos.y-rad, width, height,5);
        
    ofPopStyle();
    font.drawString(name, pos.x, pos.y+25);
}
//these functions courtesy of http://forum.openframeworks.cc/index.php?topic=4448.0
void simpleSlider::roundedRect(float x, float y, float w, float h, float r) {
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

void simpleSlider::quadraticBezierVertex(float cpx, float cpy, float x, float y, float prevX, float prevY) {
    float cp1x = prevX + 2.0/3.0*(cpx - prevX);
    float cp1y = prevY + 2.0/3.0*(cpy - prevY);
    float cp2x = cp1x + (x - prevX)/3.0;
    float cp2y = cp1y + (y - prevY)/3.0;
    
    // finally call cubic Bezier curve function
    ofBezierVertex(cp1x, cp1y, cp2x, cp2y, x, y);
};
