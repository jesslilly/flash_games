FSelectableListClass.prototype.makeDependent = function (multiDataProvider, master) {
  // Set the master menu's change handler to the updateView() method
  // (see following) for the dependent menu.
  master.setChangeHandler("updateView", this);

  // Set the dependent menu's properties to the values passed in as parameters.
  this.multiDataProvider = multiDataProvider;
  this.master = master;
};

// updateView() is called whenever the user selects an item from the master menu.
FSelectableListClass.prototype.updateView = function () {

  // Get the index of the selected menu item from the master menu.
  var selectedIndex = this.master.getSelectedIndex();

  // Get the data provider that corresponds to the selected index.
  var dp = this.multiDataProvider[selectedIndex];

  // Set the data provider for the dependent menu.
  this.setDataProvider(dp);
};

FSelectableListClass.prototype.adjustWidth = function () {

  // maxW stores the largest text extent
  var maxW = 0;

  // w stores the text extent of each label element
  var w;

  // The local variable labels is an array of the string values for each
  // menu item. Assign it the value of the labels property to begin with.
  var labels = this.labels;

  // If the menu was not populated at authoring time, set labels to 
  // an array of the values obtained from the data provider.
  if (labels == undefined) {
    labels = new Array();
  
    // Append the label property for each data provider to the labels array
    for (var i = 0; i < this.dataprovider.getLength(); i++) {
      labels.push(this.dataprovider.getItemAt(i).label);
    }
  }

  // Loop through all the elements of the labels array
  for (i = 0; i < labels.length; i++) {

    // Use textstyle.getTextExtent() to obtain the width of each label (it returns 
    // an object with width and height properties, and we extract width here). 
    w = this.textstyle.getTextExtent(labels[i]).width;

    // Store the width of the widest label in maxW.
    maxW = Math.max(w, maxW);
  }

  // Use setSize() to set the menu width to maxW + 25. The 25 is padding so that 
  // menu items are not cut off by scrollbars. Pass the current height to setSize()
  // so as to leave the height unchanged (height does not apply to combo boxes).
  this.setSize(maxW + 25, this._height);
};

FSelectableListClass.prototype.setSelectedItem = function (val) {
  var item, itemVal;

  // Loop through all the items in the menu. The getLength() 
  // method returns the number of items in the menu.
  for (var i = 0; i < this.getLength(); i++) {

    // Get each item using the getItemAt() method.
    item = this.getItemAt(i);

    // If the data property is not undefined, use it for testing matches.
    // Otherwise, use the label property.
    if (item.data != undefined) {
      itemVal = item.data;
    } else {
      itemVal = item.label;
    }

    // If the data or label property matches the input val, call 
    // setSelectedIndex(), passing it the current for loop index (i).
    // Use a return statement to exit once one item is found and selected.
    if (val == itemVal) {
      this.setSelectedIndex(i);
      return;
    }
  }
};

FSelectableListClass.prototype.setSelectedItems = function (vals) {
  var item, itemVal;

  // Create an array to holds the indices of the items to select.
  var selectedIndices = new Array();

  // Loop through all the menu items. This uses similar 
  // logic as the setSelectedItem() method.
  for (var i = 0; i < this.getLength(); i++) {
    item = this.getItemAt(i);
    if (item.data != undefined) {
      itemVal = item.data;
    } else {
      itemVal = item.label;
    }

    // The vals parameter is an array of values, so we loop through each
    // element to see if it matches with data or label. If so, it's a match,
    // so add the current for statement index (i) to the selectedIndices array.
    for (var j = 0; j < vals.length; j++) {
      if (vals[j] == itemVal) {
        selectedIndices.push(i);
      }
    }
  }

  // Call the setSelectedIndices() method for this list box, and pass it the
  // selectedIndices array that was populated in the preceding for statement.
  this.setSelectedIndices(selectedIndices);
};

FRadioButtonGroupClass.prototype.adjustWidth = function () {
  var tf;

  // Loop through all the radio buttons in the group.
  for (var i = 0; i < this.radioInstances.length; i++) {

    // Set each label text field to auto size.
    tf = this.radioInstances[i].fLabel_mc.labelField;
    tf.autoSize = true;

    // Set the width of each radio button to the width of the text field 
    // plus 13. The 13 pixels account for the width of the button graphic.
    this.radioInstances[i].setSize(tf._width + 13);
  }
};

FRadioButtonGroupClass.prototype.setPositions = function (x, y, cols, spacing) {
  
  // Set the spacing to 15 pixels if undefined.
  if (spacing == undefined) {
    spacing = 15;
  }

  // If the value of cols is either undefined or greater than
  // the number of items, use one column.
  if ( (cols == undefined) || (cols > this.radioInstances.length) ) {
    cols = 1;
  }

  // The itemsPerColumn array is used to determine how many items
  // are placed into each column. Initialize remainingItems to the 
  // number of elements in the radioInstances array.
  var itemsPerColumn = new Array();
  var remainingItems = this.radioInstances.length;

  // Determine how many items to place in each column.
  for (var i = 0; i < cols; i++) {

    // Divide the number of items remaining by the number of columns
    // minus i. This tells you how many items should go into the column.
    itemsPerColumn[i] = Math.round(remainingItems / (cols - i));

    // Update the number of remaining items for the next iteration.
    remainingItems -= itemsPerColumn[i];

    // If this is the last column, add all remaining items to the column.
    if (i == (cols - 1)) {
      itemsPerColumn[i] += remainingItems;
    }
  }

  // The index variable is incremented with each iteration through the nested for
  // loop to successfully loop through each element of the radioInstances array.
  var index = 0;

  // maxW stores the maximum width of any item in a column
  var maxW = 0;

  // colStartX is used to track the x coordinate for each column. 
  // The initial x coordinate is specified by the x parameter.
  var colStartX = x;
  var item;

  // Loop through each item in each column using nested for statements. 
  // i is the current column and j is the current item within the current column.
  for (var i = 0; i < itemsPerColumn.length; i++) {
    for (var j = 0; j < itemsPerColumn[i]; j++) {

      // Set item to the current radio button reference.
      item = this.radioInstances[index];

      // Record the width of the widest button in the column so far, in maxW.
      maxW = Math.max(item._width, maxW);

      // The x coordinate is the same for each radio button in a 
      // given column. The y coordinate depends on the y and 
      // spacing parameters, plus the item number within the column.
      item._x = colStartX;
      item._y = (j * spacing) + y;

      // Increment index to refer to the next radio button the next time around.
      index++;
    }
 
    // To set the starting position for the next column, add the maximum width
    // of this column plus 5 pixels to provide some spacing between columns.
    colStartX += maxW + 5;

    // Reset maxW so that it does not carry over to the next column
    maxW = 0;
  }
};

// FCheckBoxGroupClass should be defined globally just as the other UI component
// classes. Set the class to inherit from FRadioButtonGroupClass. This means that
// all the functionality of FRadioButtonGroupClass is accessible to the new class.
_global.FCheckBoxGroupClass = function () {};
FCheckBoxGroupClass.prototype = new FRadioButtonGroupClass();

// Define a setGroupName() method for checkboxes, which 
// is the same as the one for radio buttons.  
FCheckBoxClass.prototype.setGroupName = function (groupName) {
  for (var i = 0; i < this._parent[this.groupName].radioInstances.length; i++) {
    if (this._parent[this.groupName].radioInstances[i] == this) {
      delete this._parent[this.groupName].radioInstances[i];
    }
  }
  this.groupName = groupName;
  this.addToRadioGroup();
};

// Define addToRadioGroup() for checkboxes. This method gets called
// from setGroupName(). It is the same method as the addToRadioGroup()
// method for radio buttons, except that it creates an new instance of 
// FCheckBoxGroupClass instead of FRadioButtonGroupClass.
FCheckBoxClass.prototype.addToRadioGroup = function () {
  if (this._parent[this.groupName] == undefined) {
    this._parent[this.groupName] = new FCheckBoxGroupClass();
  }
  this._parent[this.groupName].addRadioInstance(this);
};

FCheckBoxGroupClass.prototype.getValues = function () {

  // The dataAr array is populated with the objects for each checkbox in the group.
  var dataAr = new Array();

  // Create two local variables for use in the for statement.
  var cb, obj;

  // Loop through every checkbox in the group.
  for (var i = 0; i < this.radioInstances.length; i++) {

    // cb refers to the current checkbox.
    cb = this.radioInstances[i];

    // For each checkbox, create an object with name, label, and value properties. 
    obj = new Object();
    obj.name = cb._name;
    obj.label = cb.getLabel();
    obj.value = cb.getValue();

    // Add the object to the array.
    dataAr.push(obj);
  }

  // Return the array of values.
  return dataAr;
};


// Make sure to include RegExp.as (see Chapter 9) in the Form.as file. The
// validation methods require it.
#include "com/sparkyland/flash/RegExp.as"

_global.Form = function () {
  this.formElements = new Array();

  // Our updated constructor creates the validators associative array
  this.validators = new Object();
};


// The addElement() method adds an element to the formElements array.
Form.prototype.addElement = function (element) {
  this.formElements.push(element);
};

Form.prototype.getValues = function () {

  // Create the associative array to hold the form element names and values.
  var obj = new Array();
  var values, value, elem;

  // Loop through all the form elements in the form.
  for (var i = 0; i < this.formElements.length; i++) {
    elem = this.formElements[i];

    // Process each form element, as appropriate to its type. The instanceof 
    // operator indicates whether the element is of the class indicated.
    if (elem instanceof TextField) {
      // Store text field value in the array with the text field name as the key.
      value = elem.text;
      obj[elem._name] = value;
    }
    else if (elem instanceof FCheckBoxClass) {
      // Get the value of the checkbox, and assign it to an element of the
      // associative array using the checkbox's name as the key.
      value = elem.getValue();
      obj[elem._name] = value;
    }
    else if (elem instanceof FCheckBoxGroupClass) {      
      // Get the values within the checkbox group (requires 
      // custom checkbox group class (see Recipe "Getting Checkbox Values").
      values = elem.getValues();

      // Store each checkbox value in the array, where the key is the 
      // name property of the element returned by the checkbox group.
      for (var j = 0; j < values.length; j++) {
        obj[values[i].name] = values[i].value;
      }
    }
    else if (elem instanceof FRadioButtonGroupClass) {
      // Store the active radio button's value (obtained from
      // getValue()), where the key is the radio button group name.
      value = elem.getValue();
      obj[elem.getGroupName()] = value;
    }
    else if (elem instanceof FComboBoxClass) {
      // For a combo box, retrieve the data property of the 
      // object returned by getSelectedItem() method unless it 
      // is undefined, in which case use the label property.
      value = (elem.getSelectedItem().data == undefined) ?
                 elem.getSelectedItem().label: elem.getSelectedItem().data;

      // If value is an object (and not a primitive string), it means that
      // the data property was assigned a reference to an object. In that
      // case, assign to value the value property from the data object. (See
      // Recipe "Whatever" in Chapter 12 regarding assigning data objects.)
      if (value instanceof Object) {
        value = value.value;
      }

     // Store the value, using a key that is the name of the combo box.
     obj[elem._name] = value;
    }
    else if (elem instanceof FListBoxClass) {

      // Retrieve the values from the list box.
      values = elem.getSelectedItems();

      // Create an element whose key is the list box name. Assign to this element a
      // new array filled with the values from the list box (potentially multiple).
      obj[elem._name] = new Array();

      // For each selected item in the list box, add its value to the array. The 
      // logic for getting each value is the same as used earlier for combo boxes.
      for (var j = 0; j < values.length; j++) {
        value = (values[j].data == undefined) ? values[j].label : values[j].data;
        if (value instanceof Object) {
          value = value.value;
        }
        obj[elem._name].push(value);
      }
    }
  }

  // Return the associative array containing all the form values.
  return obj;
};

// The submitToURL() method should be called from your form 
// object to submit the form data to a URL.
Form.prototype.submitToURL = function (url) {

  // Create a new LoadVars object for sending the form data to the URL.
  var lv = new LoadVars();

  // Get the form values by calling the getValues() method (defined earlier).
  var vals = this.getValues();

  // Add each form element to the LoadVars object so they will be submitted.
  for (var item in vals) {
    lv[item] = vals[item];
  }

  // Send the data to the sever script at the specified URL.
  lv.send(url);
};

// The setValidator() method adds elements to the validators associative array
Form.prototype.setValidator = function (elementName, validator) {
  this.validators[elementName] = validator;
};

// The validate() method attempts to validate the form
Form.prototype.validate = function () {

  // Retrieve the form's values using getValues()
  var values = this.getValues();
  var valid, re;

  // Loop through all the values
  for (var item in values) {

    // Get the validator for the current form element
    valid = this.validators[item];

    // Validate the element based on its validator (true, "email", or a reg exp).
    // Remember that the condition (valid) is the same as (valid == true).
    if (valid) {
      // If the validator is true, check whether the element has some value
      if ( (values[item] == undefined) || (values[item] == null)
           || (values[item] == "")) {
        // If no valid value exists, return this item as an error.
        return item;
      }  
    } else if (valid == "email") {
      // If the validator is "email", make sure it is an email address
      // of the form something@somewhere.topleveldomain
      re = new RegExp("^([\\w\-\\.]+)@(([\\w\\-]+\\.)+[\\w\\-]+)$");
      if (!re.test(values[item])) {
        // If it doesn't match an email pattern, return the item as an error. 
        return item;
      }
    } else if (valid != undefined) {
      // If the validator is not true or "email" assume, it's a regular expression 
      // string. Create a regular expression from the string and test for a match.
      re = new RegExp(valid);
      if (!re.test(values[item])) {
        // If it doesn't match the reg exp, return the item as an error. 
        return item;
      }
    }
  }
  // Return true to indicate successful validation
  return true;
};

// setVisible() accepts a Boolean value--true or false--and uses it to set the  
// _visible property of each element. Thus, it hides or shows an entire form page.
Form.prototype.setVisible = function (visible) {
  for (var i = 0; i < this.formElements.length; i++) {
    
    // If the element is a radio button group (or a checkbox group, which inherits
    // from the same class), set the visibility of each item in the group.
    if (this.formElements[i] instanceof FRadioButtonGroupClass) {
      for (var j = 0; j < this.formElements[i].radioInstances.length; j++) {
        this.formElements[i].radioInstances[j]._visible = visible;
      }
    } else {
     // Otherwise, set the _visible property of the individual element.
      this.formElements[i]._visible = visible;
    }
  }
};

// Create the MultiPageForm class constructor.
_global.MultiPageForm = function () {
  // Initialize currentPage to display the first page of the form.
  this.currentPage = 1;

  // Create an array to hold all the form "pages".
  this.forms = new Array();

  // If the caller passed in any parameters, assume they are references to
  // existing Form objects to add to this multipage form. Therefore, loop through
  // the arguments array and invoke the addForm() method for each argument.
  for (var i = 0; i < arguments.length; i++) {
    this.addForm(arguments[i]);
  }
};

// Add a Form object to the MultiPageForm object.
MultiPageForm.prototype.addForm = function (frm) {
  this.forms.push(frm);
};

// setPage() sets the current page. The first page of the form is 1.
MultiPageForm.prototype.setPage = function (page) {

  // Show the current page and hide all the other pages
  for (var i = 0; i < this.forms.length; i++) {
    if (page == (i + 1)) {
      this.forms[i].setVisible(true);
    } else {
      this.forms[i].setVisible(false);
    }
  }

  // Remember the current page
  this.currentPage = page;
};

// nextPage() goes to the next page (or to the first page if this is the last page) 
MultiPageForm.prototype.nextPage = function () {

  // Increment the current page
  this.currentPage++;

  // If we're past the last page, go to the first page instead
  if (this.currentPage > this.forms.length) {
    this.currentPage = 1;
  }

  // Display the new current page and hide the other pages
  this.setPage(this.currentPage);
};

// prevPage() goes to the previous page (or the last page if this is the first one)
MultiPageForm.prototype.prevPage = function () {

  // Decrement the current page
  this.currentPage--;

  // If we're before the first page, go to the last page instead
  if (this.currentPage < 1) {
    this.currentPage = this.forms.length;
  }

  // Display the new current page and hide the other pages
  this.setPage(this.currentPage);
};

// The multipage version of submitToURL() is the same as the regular Form version.
MultiPageForm.prototype.submitToURL = function (url) {
  var lv = new LoadVars();
  var vals = this.getValues();
  for (var item in vals) {
    lv[item] = vals[item];
  }
  lv.send(url);
};

// MultiPageForm.getValues() uses Form.getValues() to create an 
// object with the elements of all the form pages and their values.
MultiPageForm.prototype.getValues = function () {
  var obj = new Array();
  var formVals, elem;

  // Call the getValues() method of each form page, and add 
  // those results to the multipage values associative array.
  for (var i = 0; i < this.forms.length; i++) {
    formVals = this.forms[i].getValues();
    for (elem in formVals) {
      obj[elem] = formVals[elem];
    }
  }
  return obj;
};

MultiPageForm.prototype.validate = function () {
  var vRes;

  // Loop through all the form pages.
  for (var i = 0; i < this.forms.length; i++) {

    // Call the validate() method for each page of the form. If validate() returns 
    // something other than true, some form element didn't validate. In that case,
    // display that page of the form and return the name of the offending element.
    vRes = this.forms[i].validate();
    if (!vRes) {
      this.setPage(i + 1);
      return vRes;
    }
  }
  return true;
};
