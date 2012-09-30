#include "simpleGui.h"

void simpleGui::setup(){
    font.loadFont("MONACO.TTF", 12);
    font.setSpaceSize(0.5);
}

////////////////////////---------/////////////////////////////////////
void simpleGui::addSlider(ofPoint _pos, float _length, float _rangeStart, float _rangeEnd, string _name){
    simpleSlider newSlider;
    newSlider.setup( _pos,  _length,  _rangeStart,  _rangeEnd, _name);
    sliders.push_back(newSlider);
    
}
////////////////////////---------/////////////////////////////////////

void simpleGui::addToggle(ofPoint _pos, float _width, float _height, string _name){
    simpleToggle toggle;
    toggle.setup( _pos,  _width,  _height,  _name);
    toggles.push_back(toggle);
}
////////////////////////---------/////////////////////////////////////

void simpleGui::removeSlider(){
    
}
////////////////////////---------/////////////////////////////////////

void simpleGui::removeToggle(){
    
}
////////////////////////---------/////////////////////////////////////

void simpleGui::update(ofPoint touch ){
    for (int i=0; i<sliders.size(); i++) {
        sliders[i].update(touch);
    }
    for (int i=0; i<toggles.size(); i++) {
        toggles[i].update(touch);
    }
    
}
////////////////////////---------/////////////////////////////////////

void simpleGui::draw(){
    for (int i=0; i<sliders.size(); i++) {
        sliders[i].draw(font);
    }
    for (int i=0; i<toggles.size(); i++) {
        toggles[i].draw(font);
    }
}
float simpleGui::getSliderValue(string sliderName){
    float val=0;
    for (int i=0; i<sliders.size(); i++) {
        if (sliders[i].getName()==sliderName) {
            val=sliders[i].getValue();
        }
    }
    return val;
}
bool simpleGui::getToggleValue(string toggleName){
    bool val=false;
    for (int i=0; i<toggles.size(); i++) {
        if (toggles[i].getName()==toggleName) {
            val=toggles[i].getValue();
        }
    }
    return val;
}

void simpleGui::setToggleValue(string toggleName, bool newValue){
    for (int i=0; i<toggles.size(); i++) {
        if (toggles[i].getName()==toggleName) {
            toggles[i].setValue(newValue);
        }
    }
}

