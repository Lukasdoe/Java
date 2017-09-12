import java.util.Arrays;

String word;
String[] letters;
String fileurl;
String rawdata[];
ArrayList<String> data;

void setup() {
  word = "";
  size(400, 400);
  fileurl = "./data/text.txt";
  rawdata = loadStrings(fileurl);
  data = clean(rawdata);
}

void draw() {
  if (word != "") {
    background(100);
    textSize(20);
    letters = word.split("");
      for (int i = 0; i < letters.length; i++) {
        String finalword = findword(letters[i], data);
        
        if (finalword != "") {
          textAlign(RIGHT);
          text(finalword.substring(0, finalword.indexOf(letters[i])), width * 0.5 - 20, map(i, 0, letters.length, 20, height - 20));
          //textAlign(CENTER);
          text((letters[i]), width * 0.5, map(i, 0, letters.length, 20, height - 20));
          textAlign(LEFT);
          text(finalword.substring(finalword.indexOf(letters[i]) + 1, finalword.length()), width * 0.5 + 4, map(i, 0, letters.length, 20, height - 20));
        }
      }
    }
  noLoop();
}

void keyPressed() {
  word += key;
  loop();
}

void mousePressed(){
  saveFrame("Acrostic.png");
}

String findword(String input, ArrayList<String> data) {
  String output = "";
  for (int j = 0; j < 100000 && output == ""; j++) {
    int index = (int)random(0, data.size());
    for (int i = 0; i < data.get (index).length(); i++) {
      if (data.get(index).charAt(i) == input.charAt(0)) {
        output = data.get(index);
      }
    }
  }
  return output;
}

ArrayList<String> clean(String[] input) {
  String output = "";
  ArrayList<String> blacklist = new ArrayList();
  blacklist.add("[");
  blacklist.add("]");
  blacklist.add("(");
  blacklist.add(")");
  blacklist.add(".");
  blacklist.add(",");
  blacklist.add(";");
  blacklist.add(":");
  blacklist.add("\"");
  blacklist.add("\'");
  for (int i = -1000; i < 1000; i++) {
    blacklist.add(str(i));
  }

  for (int i = 0; i < input.length; i++) {
    output += input[i];
  }
  for (int i = 0; i < blacklist.size (); i++) {
    output = output.replace(blacklist.get(i), "");
  }

  ArrayList<String> output2 = new ArrayList(Arrays.asList(output.split(" ")));
  for (int i = output2.size ()-1; i >= 0; i--) {
    if (output2.get(i).length() < 5) {
      output2.remove(i);
    }
  }
  return output2;
}