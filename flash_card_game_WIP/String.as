String.prototype.simpleReplace = function (search, replace, working) {

  // temp stores the string value with the replaced substrings.
  var temp;

  // working holds the value of the string.
  var working = this;

  // Perform a case-insensitive search if so directed.
  if (!matchCase) {
    working = this.toLowerCase();
    search = search.toLowerCase();
  }

  // searchIndex holds the starting index of a matches. startIndex stores
  // the value of the index after the replaced substring.
  var searchIndex = -1;
  var startIndex = 0;

  // Find each match to the search substring...
  while ((searchIndex = working.indexOf(search, startIndex)) != -1) {

    // Append to temp the string value from the end of the last match
    // to just before the current match. Then, append the replace string
    // in place of the search substring.
    temp += this.substring(startIndex, searchIndex);
    temp += replace;

    // startIndex holds the index one after the final character 
    // of the matched substring. This starts the next search and
    // replace operation after the substring that is being replaced.
    startIndex = searchIndex + search.length;
  }

  // Return the temp value plus the remainder of the original 
  // string value (after the last match).
  return temp + this.substring(startIndex);
};

String.prototype.toInitialCap = function () {
  // Convert the first character to uppercase and the remainder to lowercase.
  return this.charAt(0).toUpperCase() + this.substr(1).toLowerCase();
};

String.prototype.toTitleCase = function () {
  working = this;
  var words = working.split(" ");
  for (var i = 0; i < words.length; i++) {
    words[i] = words[i].charAt(0).toUpperCase() + words[i].substr(1)
  }
  return (words.join(" "));
};

String.prototype.trim = function () {

  // Split the string into an array of characters.
  var chars = this.split("");

  // Remove any whitespace elements from the beginning of the array using
  // splice(). Use a break statement to exit the loop when you reach a
  // non-whitespace character to prevent it from removing whitespace
  // in the middle of the string.
  for (var i = 0; i < chars.length; i++) {
    if (chars[i] == "\r" ||
        chars[i] == "\n" ||
        chars[i] == "\f" ||
        chars[i] == "\t" ||
        chars[i] == " ") {
      chars.splice(i, 1);
      i--;
    } else {
      break;
    }
  }

  // Loop backward through the removing whitespace elements until a
  // non-whitespace character is encountered. Then break out of the loop.
  for (var i = chars.length - 1; i >= 0; i--) {
    if (chars[i] == "\r" ||
        chars[i] == "\n" ||
        chars[i] == "\f" ||
        chars[i] == "\t" ||
        chars[i] == " ") {
      chars.splice(i, 1);
    } else {
      break;
    }
  }

  // Recreate the string with the join() method and return the result.
  return chars.join("");
};

String.prototype.encode = function () {

  // The codeMap property is assigned to the String class when the encode() method
  // is first run. Therefore, if no codeMap is yet defined, it needs to be created.
  if (String.codeMap == undefined) {

    // The codeMap property is an associative array that maps each original code
    // point to another code point.
    String.codeMap = new Object();

    // Create an array of all the code points from 0 to 255.
    var origMap = new Array();
    for (var i = 0; i <= 255; i++) {
      origMap.push(i);
    }

    var rand;

    // Create a temporary array that is a copy of the origMap array.
    var charTemp = origMap.concat();

    // Loop through all the character code points in origMap.
    for (var i = 0; i < origMap.length; i++) {

      // Create a random number that is between 0 and the last index of charTemp.
      rand = Math.round(Math.random() * (charTemp.length-1));

      // Assign to codeMap values such that the keys are the original code points,
      // and the values are the code points to which they should be mapped.
      String.codeMap[origMap[i]] = charTemp[rand];

      // Remove the elements from charTemp that was just assigned to codeMap. 
      // This prevents duplicates.
      charTemp.splice(rand, 1);
    }
  }

  // Split the string into an array of characters.
  var chars = this.split("");

  // Replace each character in the array with the corresponding value from codeMap.
  for (var i = 0; i < chars.length; i++) {
      chars[i] = String.fromCharCode(String.codeMap[chars[i].charCodeAt(0)]);
  }

  // Return the encoded string.
  return chars.join("");
};

String.prototype.decode = function () {

  // Split the encoded string into an array of characters.
  var chars = this.split("");

  // Create an associative array that reverses the keys and values of codeMap.
  // This allows you to do a reverse lookup based on the encoded character
  // rather than the original character.
  var reverseMap = new Object();
  for (var key in String.codeMap) {
    reverseMap[String.codeMap[key]] = key;
  }

  // Loop through all the characters in the array, and replace them
  // with the corresponding value from reverseMap--thus recovering
  // the original character values.
  for (var i = 0; i < chars.length; i++) {
    chars[i] = String.fromCharCode(reverseMap[chars[i].charCodeAt(0)]);
  }

  // Return the decoded string.
  return chars.join("");
};
