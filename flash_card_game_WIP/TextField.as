MovieClip.prototype.createInputTextField = function (name, depth, x, y, w, h) {

  // Define a default width and height for text fields created 
  // with this method (width defaults to 100 and height defaults to 20).
  if (w == undefined) {
    w = 100;
  }
  if (h == undefined) {
    h = 20;
  }

  // Create the text field using the built-in MovieClip.createTextField() method.
  this.createTextField(name, depth, x, y, w, h);

  // Then, assign the necessary values to the object to make it an input field.
  this[name].border = true;
  this[name].background = true;
  this[name].type = "input";
};

MovieClip.prototype.createAutoTextField = function (name, 
                                                    depth, 
                                                    x, y, 
                                                    w, h, 
                                                    val, 
                                                    align) {

  // The align parameter is assigned to the text field's autoSize property.
  // Default to true (same as "left"). Ignored if width, w, is specified.
  if (align == undefined) {
    align = true;
  }

  // Create the text field using the built-in MovieClip.createTextField() method.
  this.createTextField(name, depth, x, y, w, h);

  // If the width, w, was 0 or unspecified, set the autoSize property 
  // so that the text field resizes to fits its contents.
  if (w == undefined || w == 0) {
    this[name].autoSize = align;
  }

  // If a value was provided, assign it to the text field's text property.
  if (val != undefined) {
    this[name].text = val;
  }
};

// Add the custom find() method to the TextField prototype so that it is available
// to all text fields. The methods takes three parameters: search is the search
// string, startIndex is the index from which to perform the search, and matchCase
// is a Boolean that specifies if the search should be case-sensitive. 
// If matchCase is undefined, the search is case-insensitive.
TextField.prototype.find = function (search, startIndex, matchCase) {

  // Initialize the local variable, index.
  var index;

  // If matchCase is false or undefined, perform a case-insensitive
  // search. Otherwise, do a case-sensitive match.
  if (!matchCase) {
    index = this.text.toLowerCase().indexOf(search.toLowerCase(), startIndex);
  } else {
    index = this.text.indexOf(search, startIndex);
  }  

  // Set the focus to the text field, in case it is not already set.
  Selection.setFocus(this);

  // If the search string was found, set the selection to highlight the match 
  // within the text field. Otherwise, position the cursor at the beginning of the
  // text field.
  if (index != -1) {
    Selection.setSelection(index, index + search.length);
  } else {
    Selection.setSelection(0, 0);
  }

  // Return the index of the match so that it can be used to pass the next
  // startIndex value to this method when called again.
  return index;
};
