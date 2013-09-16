// Create the local shared object at the top level of the domain so that
// all text fields in all Flash movies in the domain can access it.
TextField.so = SharedObject.getLocal("textfieldAutoComplete", "/");

// When the user types into the text field or when she brings focus
// to it (either programmatically, by tab index, or by clicking with
// the  mouse) call the custom makeAutoCompleteOptions() method.
TextField.prototype.onChanged = function () {
  this.makeAutoCompleteOptions();
};

TextField.prototype.onSetFocus = function () {
  this.makeAutoCompleteOptions();
};

TextField.prototype.makeAutoCompleteOptions = function () {

  // Create a copy of the array stored in the shared object 
  // for the text field with the current text field's name.
  var history = TextField.so.data[this._name].concat();

  // If the text is not empty, find any partial matches in the history array
  if (this.text != "") {
    for (var i = 0; i < history.length; i++) {
      // Removes any elements that don't match from the history array.
      if (history[i].indexOf(this.text) != 0) {
        history.splice(i, 1);
        i--;
      }
    }
  }

  // If the history array is undefined or has no elements,
  // remove any existing list box, and exit this method.
  if (history.length == 0 || history.length == undefined) {
    this._parent.autoCompleteHistory.removeMovieClip();
    return;
  }

  // Create a list box and position it just underneath the text field.
  this._parent.attachMovie("FListBoxSymbol", "autoCompleteHistory", 100000);
  this._parent.autoCompleteHistory._x = this._x;
  this._parent.autoCompleteHistory._y = this._y + this._height;

  // Resize the list box to fit the width of the text field.
  this._parent.autoCompleteHistory.setSize(this._width, 50);

  // If history has fewer than three elements, shorten the list box.
  if (history.length < 3) {
    this._parent.autoCompleteHistory.setRowCount(history.length);
  }

  // Fill the list box with the elements from history, and 
  // set the handler to call when any changes occur to the 
  // list box (via changes to the text field's contents.) 
  this._parent.autoCompleteHistory.setDataProvider(history);
  this._parent.autoCompleteHistory.setChangeHandler("setValue", this);
};

// The setValue() method is the change handler function for the list box.
TextField.prototype.setValue = function (lb) {

  // usingArrows indicates whether the method was called due to the user pressing
  // the arrow keys. If she used the arrow keys, exit the function because we 
  // don't want to close the list box until she has actually selected a value.
  if (this.usingArrows) {
    this.usingArrows = false;
    return;
  }

  // Set the text field value to the selected value 
  // from the list box, and then remove the list box.
  this.text = lb.getSelectedItem().label;
  lb.removeMovieClip();
};

TextField.prototype.onKillFocus = function () {

  // Remove the list box when the text field loses focus.
  _root.autoCompletHistory.removeMovieClip();

  // If the text field contains no text, exit the method.
  if (this.text == "") {
    return;
  }

  // Get the array stored in the shared object for the text field. Exit this 
  // method if the array already contains the text field's text value.
  var history = TextField.so.data[this._name];
  for (var i = 0; i < history.length; i++) {
    if (this.text == history[i]) {
      return;
    }
  }

  // If the shared object doesn't already have an 
  // array for this text field, create one.
  if (TextField.so.data[this._name] == undefined) {
    TextField.so.data[this._name] = new Array();
  }

  // Add the text field's text value to the shared object's array.
  TextField.so.data[this._name].push(this.text);
};

// Create a key listener to respond whenever keys are pressed.
keyListener = new Object();

keyListener.onKeyDown = function () {

  // Get the current focus, and create a reference to the list box.
  var focus = eval(Selection.getFocus());
  var ach = focus._parent.autoCompleteHistory;

  // Get the key code for the key that has been pressed.
  var keyCode = Key.getCode();

  if (keyCode == 40) {
    // If the key is the down arrow, set usingArrows to true and set the
    // selected index in the list box to the next value in the list.
    focus.usingArrows = true;
    var index = (ach.getSelectedIndex() == undefined) ? 
                   0 : ach.getSelectedIndex() + 1;
    index = (index == ach.getLength()) ? 0 : index;
    ach.setSelectedIndex(index);

    // Scroll if the selected index is not visible in the list box.
    if (index > ach.getScrollPosition() + 2) {
      ach.setScrollPosition(index);
    } else if (index < ach.getScrollPosition()) {
      ach.setScrollPosition(index);
    }
  } else if (keyCode == 38) {
    // If the key is the up arrow, do a similar thing as when the
    // down arrow is pressed, but move the selected index up instead of down.
    focus.usingArrows = true;
    var index = (ach.getSelectedIndex() == undefined) ? 
                   0 : ach.getSelectedIndex() - 1;
    index = (index == -1) ? ach.getLength() - 1 : index;
    ach.setSelectedIndex(index);
    if (index > ach.getScrollPosition() + 2) {
      ach.setScrollPosition(index);
    } else if (index < ach.getScrollPosition()) {
      ach.setScrollPosition(index);
    }
  } else if (keyCode == Key.ENTER) {
    // If the user has pressed the Enter key, call setValue() 
    // to set the text field's value and close the list box.
    focus.setValue(ach);
  } else {
    // Otherwise, if the user presses any other key, exit the function.
    return;
  }
  
  // Set the focus to the text field.
  Selection.setFocus(focus);
};

// Add the key listener to the Key object.
Key.addListener(keyListener);
