// @dhdpic

// a text file in only a limited vocabulary

import java.util.*;

String[] allLines; // store all lines from textfile
String completeText; // reformed text as a single string
String[] completeWords; // list of words
ArrayList <WordItem> allWordsUsed; // list of words used

int vocab = 50; // number of words allowed when writing out 

void setup() {
  //
  size(100, 100);
  // load text file into array of lines
  allLines = loadStrings("excerpt1.txt");
  println(allLines.length);
  
  // reform text into single string
  for (int i=0; i<allLines.length; i++) {
    String[] splitLine = split(allLines[i], " ");

    if (splitLine.length == 1) {
      completeText += "\n\n";
    } else {
      completeText += join(splitLine, " ")+" ";
    }
  }

  println(completeText);

  // turn complete text into array of words
  // and an array with punctuation stripped out
  // reform that stripped array into a string file
  println("///");
  println(completeText.length());
  String[] completeTextArray = split(completeText, " ");

  String strippedText = "";
  String[] strippedTextArray = split(completeText, " ");

  // 
  for (int l=0; l < completeTextArray.length; l++) {
    String[][] m = matchAll(completeTextArray[l], "[a-zA-Z0-9]");
    if (m != null) {
      //println(completeTextArray[l]);
      String strippedWord = "";
      for (int i=0; i<m.length; i++) {
        strippedWord += m[i][0];
        //print(m[i]);
      }
      //println(strippedWord);
      strippedText += strippedWord + " ";
      strippedTextArray[l] = strippedWord;
    }
  }

  //println(strippedText.length());

  //for (int i=0; i<strippedTextArray.length; i++) {
    //println(completeTextArray[i] + "  :  " + strippedTextArray[i]);
  //}
  
  
  // gather the total words used into an array
  // each word has a score
  // increase score for each instance of word
  allWordsUsed = new ArrayList<WordItem>();

  for (int i=0; i<strippedTextArray.length; i++) {
    Boolean b = false;
    for (int j=0; j<allWordsUsed.size(); j++) {
      String cw = strippedTextArray[i].toLowerCase();
      String awu = allWordsUsed.get(j).word.toLowerCase();
      if (cw.equals(awu)) {
        WordItem g = allWordsUsed.get(j);
        g.score++;
        b = true;
        break;
      }
    }
    if (b == false) {
      WordItem w = new WordItem(strippedTextArray[i].toLowerCase());
      w.score = 1;
      allWordsUsed.add(w);
    }
  }
  
  // sort words by how high the score is
  Collections.sort(allWordsUsed, new CompareByScore());
  // print top word
  //println(allWordsUsed.get(0).word);
  
  // create a string to write out the final text
  String outputString = "";
  
  // process text
  // check if a word is from the top words list
  // use stripped words for comparison, but unstripped for writing
  // if true write the unstripped version of the word
  // if false write in * as replacement for each character
  // extra processing required to add punctuation into * words
  for (int i=0; i<strippedTextArray.length; i++) {
    //
    Boolean b = false;
    for (int j=0; j<vocab; j++) {
      WordItem wi = allWordsUsed.get(j);
      if (strippedTextArray[i].toLowerCase().equals(wi.word)) {
        b = true;
        break;
      }
    }
    //
    if (b) {
      outputString += completeTextArray[i] + " ";
    } else {
      int l = 0;
      if (completeTextArray[i].length() > 0) {
        if (str(completeTextArray[i].charAt(0)).equals("\n")) {
          outputString += "\n";
          l = 1;
        } else {
          l = 0;
        }
        for (int z=l; z<completeTextArray[i].length(); z++) {
          
          String[] m = match(str(completeTextArray[i].charAt(z)), "[^a-zA-Z0-9]");
          if(m == null) {
            outputString += "*";
          } else {
            outputString += m[0];
          }
        }
        outputString += " ";
      }
    }
  }
  
  // final string can be written to file but first break into line array
  String[] outputStringArr = split(outputString, "\r");
  saveStrings(timeStamp()+".txt", outputStringArr);
  println("D - O - N - E");
  noLoop();
  exit();
}

void draw() {
  // do nothing!
}

String timeStamp() {
  //
  return year() + "_" + month() + "_" + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "_" + millis();
}


class WordItem {

  int score;
  String word;

  WordItem(String w) {
    word = w;
  }
}

public class CompareByScore implements Comparator<WordItem> {
  //@Override
  int compare(WordItem w1, WordItem w2) {
    return int(w2.score - w1.score);
  }
}
