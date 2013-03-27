/*
copyright Tom Schofield 2012
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
//Timer time;
int timeUnit = 100;

//pin 9 for lamp version
int pin=9;
String sentence = "WHAT~HATH~GOD~WROUGHT~"; //"SOS";
String sentence1 = "What hath God wrought";
String sentence2 = "~Come~at~once~We~have~struck~an~iceberg";
int counter=0;

void setup(){
  //time.start();

  sentence.toUpperCase();
  sentence1.toUpperCase();

  sentence2.toUpperCase();
  pinMode(pin, OUTPUT);
  Serial.begin(9600);
  Serial.println(sentence2);
}

void loop(){
  delay(5000);

  //Serial.println(time.get());
  for(int i=0;i<sentence.length();i++){
    if(sentence.charAt(i)==' '){

    }
    else{
      writeCharacter(sentence.charAt(i));//sentence.charAt(0));
    }
  }

}
// dot dash functions adapted from arduino examples at http://arduino.cc/en/Hacking/LibraryTutorial
void dot()
{
  digitalWrite(pin, HIGH);
  delay(timeUnit);
  digitalWrite(pin, LOW);
  delay(timeUnit);
}

void dash()
{
  digitalWrite(pin, HIGH);
  delay(3*timeUnit);
  digitalWrite(pin, LOW);
  delay(timeUnit);
}
//should be 3 units but will follow the end of a dot or dash
void characterSpace(){
  delay(2*timeUnit);
}
void wordSpace(){
  //should be 7 units but will follow the end of a character space
  delay(4*timeUnit);
}

void writeCharacter(char character){
  Serial.println(character);
  switch (character) {
  case 'A':
    //do something when var equals 1
    dot();
    dash();
    characterSpace();
    break;
  case 'B':
    dash();
    dot();
    dot();
    characterSpace();
    break;
  case 'C':
    dash();
    dot();
    dash();
    dot();
    characterSpace();
    break;
  case 'D':
    dash();
    dot();
    dot();
    characterSpace();
    break;
  case 'E':
    dot();
    characterSpace();
    break;
  case 'F':
    dot();
    dot();
    dash();
    dot();
    characterSpace();
    break;
  case 'G':
    dash();
    dash();
    dot();
    characterSpace();
    break;
  case 'H':
    dot();
    dot();
    dot();
    dot();
    characterSpace();
    break;
  case 'I':
    dot();
    dot();
    characterSpace();
    break;
  case 'J':
    dot();
    dash();
    dash();
    dash();
    characterSpace();
    break;
  case 'K':
    dash();
    dot();
    dash();
    characterSpace();
    break;
  case 'L':
    dot();
    dash();
    dot();
    dot();
    characterSpace();
    break;
  case 'M':
    dash();
    dash();
    characterSpace();
    break;
  case 'N':
    dash();
    dot();
    characterSpace();
    break;
  case 'O':
    dash();
    dash();
    dash();
    characterSpace();
    break;
  case 'P':
    dot();
    dash();
    dash();
    dot();
    characterSpace();
    break;
  case 'Q':
    dash();
    dash();
    dot();
    dash();
    characterSpace();
    break;
  case 'R':
    dot();
    dash();
    dot();
    characterSpace();
    break;
  case 'S':
    dot();
    dot();
    dot();
    characterSpace();
    break;
  case 'T':
    dash();
    characterSpace();
    break;
  case 'U':
    dot();
    dot();
    dash();
    characterSpace();
    break;
  case 'V':
    dot();
    dot(); 
    dot();
    dash();
    characterSpace();
    break;
  case 'W':
    dot();
    dash();
    dash();
    characterSpace();
    break;
  case 'X':
    dash();
    dot();
    dot();
    dash();
    characterSpace();
    break;
  case 'Y':
    dash();
    dot();
    dash();
    dash();
    characterSpace();
    break;
  case 'Z':
    dash();
    dash();
    dot();
    dot();
    characterSpace();
    break;
  case '1':
    dash();
    dot();
    dot();
    characterSpace();
    break;
  case '2':
    dot();
    dot();
    dash();
    dash();
    dash();
    characterSpace();
    break;
  case '3':
    dot();
    dot();
    dot();
    dash();
    dash();
    characterSpace();
    break;
  case '4':
    dot();
    dot();
    dot();
    dot();
    dash();
    characterSpace();
    break;
  case '5':
    dot();
    dot(); 
    dot();
    dot();  
    dot();
    characterSpace();
    break;
  case '6':
    dash();
    dot();
    dot();
    dot();
    dot();
    characterSpace();
    break;
  case '7':
    dash();
    dash();
    dot();
    dot();
    dot();
    characterSpace();
    break;
  case '8':
    dash();
    dash();
    dash();
    dot();
    dot();
    characterSpace();
    break;
  case '9':
    dash();
    dash();
    dash();
    dash();
    dot();
    characterSpace();
    break;
  case '.':
    dot();
    dash();
    dot();
    dash();
    dot();
    dash();
    characterSpace();
    break;  
  case ',':
    dash();
    dash();
    dot();
    dot();
    dash();
    dash();
    characterSpace();
    break;  
  case '?':
    dot();
    dot();
    dash();
    dash();
    dot();
    dot();
    characterSpace();
    break;  
  case '~':
    dot();
    dash();
    dash();
    dash();
    dash();
    dot();
    characterSpace();
    break;  
  case '!':
    dash();
    dot();
    dash();
    dot();
    dash();
    dash();
    characterSpace();
    break;  

  default:
    int thi = 2; 
    break;
    // if nothing else matches, do the default
    // default is optional
  }
}






















