// Define the TableColumn constructor. 
// spacing defines the amount of space (in pixels) between elements in the column.
_global.TableColumn = function (spacing) {
  // Store the spacing parameter in an instance property of the same name.
  // spacing defaults to 5 if not otherwise specified.
  this.spacing = (spacing == undefined) ? 5 : spacing;

  // The _width and _height properties store the total width and 
  // height of the column. Initialize them to zero.
  this._width  = 0;
  this._height = 0;

  // The elements array holds all the elements of the column.
  this.elements = new Array();

  // If any parameters are passed to the constructor, from the second 
  // position onward, add these values (references to graphical objects 
  // or to a Table object) to the column using the addElement() method.
  for (var i = 1; i < arguments.length; i++) {
    this.addElement(arguments[i]);
  }
};

// The addElement() method adds elements to a column.
TableColumn.prototype.addElement = function (element) {

  if (element instanceof Table) {
    // If the element is a Table object, set the containsTable 
    // property to true. Reinitialize elements to ensure that 
    // the table is the only element in the column.
    this.containsTable = true;
    this.elements = new Array();
    this.elements.push(element);

    // Reset the width and height of the column.
    this._width  = 0;
    this._height = 0;
  }
  else {
    // Otherwise, the element is not a table. Reinitialize all 
    // the properties if the column previously held a table.
    if (this.containsTable) {
      this.containsTable = false;
      this.elements = new Array();
      this._width  = 0;
      this._height = 0;
    }

    // Add the element to the elements array.
    this.elements.push(element);
  }

  // Make sure the column's width reflects the width of the widest element.
  this._width = Math.max(this._width, element._width);

  // Increment the column's height by the height of the element plus the spacing 
  this._height += element._height + this.spacing; 
};

// TableColumn.render() positions the elements within the column relative to one
// another. The startx and starty parameters give the x and y coordinates for the
// first element in the column. The TableColumn.render() method is called by the
// render() method of the row in which the column is contained.
TableColumn.prototype.render = function (startx, starty) {

  // The startx and starty parameters default to zero if not specified.
  if (startx == undefined) {
    startx = 0;
  }
  if (starty == undefined) {
    starty = 0;
  }

  // If the column contains a table, call the render() method of that table.
  // Otherwise, set the x and y coordinates for each element in the column.
  if (this.containsTable) {
    this.elements[0].render(true, startx, starty);
  }
  else {
    var bnds;
    for (var i = 0; i < this.elements.length; i++) {

      // Get the bounds of the elements in case the registration 
      // point is not in the upper-left corner.
      bnds = this.elements[i].getBounds();

      // The y coordinate of the element is given by starty plus the 
      // height of the previous element in the column, plus the spacing 
      // between them. To accommodate any offsets due to registration 
      // points, subtract the element's minimum y coordinate.
      this.elements[i]._y = this.elements[i-1]._height + this.spacing +
                            starty - bnds.yMin;

      // The x coordinate of the element is given by startx plus spacing.
      // To accommodate any offsets due to registration points, subtract
      // the element's minimum x coordinate.
      this.elements[i]._x = startx + this.spacing - bnds.xMin;

      // Increment starty each time by the height of the previous element
      // plus the spacing between elements.
      starty += this.elements[i - 1]._height + this.spacing;
    }
  }
};

// removeElementAt() removes an element from a column at the given index. 
// Note that the index is zero-relative (the first column is column 0).
TableColumn.prototype.removeElementAt = function (index) {
  this.elements.splice(index, 1);
};

// The TableColumn.resize() method recalculates the width and 
// height of a column. It is called automatically by 
// TableRow.resize() (which is, in turn, called by Table.resize()).
TableColumn.prototype.resize = function () {

  // Reset the width and height to 0.
  this._width  = 0;
  this._height = 0;

  // If the column contains a table, call the resize() method of the table
  // in order to ensure the correct size of that table has been calculated.
  if (this.containsTable) {
    this.elements[0].resize();
  }

  // Set the column width to the widest element, and calculate the column height.
  for (var i = 0; i < this.elements.length; i++) {
    this._width = Math.max(this._width, this.elements[i]._width);
    this._height += this.elements[i]._height + this.spacing;
  }
};

// Define the TableRow constructor. 
// spacing parameter defines the number of pixels between columns in the row.
_global.TableRow = function (spacing) {
  // Store the spacing parameter in an instance property of the same name.
  // spacing defaults to 5 if not otherwise specified.
  this.spacing = (spacing == undefined) ? 5 : spacing;

  // The columns array contains all the columns in the row.
  this.columns = new Array();

  // Initialize the width and height of the row.
  this._width  = 0;
  this._height = 0;

  // If any parameters are passed to the constructor, from the 
  // second position onward, add these values (references to 
  // columns) to the row using the addColumn() method.
  for (var i = 1; i < arguments.length; i++) {
    this.addColumn(arguments[i]);
  }
};

// The addColumn() method adds columns to the row.
TableRow.prototype.addColumn = function (column) {

  // Add the column to the columns array.
  this.columns.push(column);

  // Increase the row's width by the width of the column plus the 
  // spacing. Also, if the column has a greater height than any of the 
  // existing columns, set the row's height to the height of the column.
  this._width += column._width + this.spacing;
  this._height = Math.max(this._height, column._height);
};

// TableRow.render() positions the columns within a row relative 
// to one another and relative to x and y coordinates given by 
// startx and starty. TableRow.render()is called automatically by
// the render() method of the table that contains the row.
TableRow.prototype.render = function (startx, starty) {

  // Call each column's render() method. Position each 
  // column to the right of the preceding one.
  for (var i = 0; i < this.columns.length; i++) {
    this.columns[i].render(startx, starty);
    startx += this.columns[i]._width + this.spacing;
  }
};

// removeColumnAt() removes a column from a row at the given index.
// Note that the index is zero-relative (the first row is row 0).
TableRow.prototype.removeColumnAt = function (index) {
  this.columns.splice(index, 1);
};

// TableRow.resize() recalculates the height and width of a row. 
// It is called automatically by Table.resize().
TableRow.prototype.resize = function () {

  // Reset the width and height to 0.
  this._width  = 0;
  this._height = 0;

  for (var i = 0; i < this.columns.length; i++) {
    // Recalculate the size of each column and use those values to 
    // calculate the height and width for the row.
    this.columns[i].resize();
    this._width += this.columns[i]._width;
    this._height = Math.max (this._height, this.columns[i]._height);
  }
};

// Define the Table constructor. spacing determines the number of pixels between 
// rows. startx and starty define the position of the table's upper-left corner.
_global.Table = function (spacing, startx, starty) {

  // Store the spacing parameter in an instance property of the
  // same name. spacing defaults to 5 if not otherwise specified.
  this.spacing = (spacing == undefined) ? 5 : spacing;

  // Store the startx and starty parameters in instance properties of the same
  // name. Use Number() to convert undefined values to 0, if necessary.
  this.startx = Number(startx);
  this.starty = Number(starty);

  // The rows array contains the rows in the table.
  this.rows = new Array();

  // Initialize the height and width of the table.
  this._height = 0;
  this._width  = 0;

  // If any parameters are passed to the constructor, from the fourth position
  // onward, add these values (references to rows) to the table using addRows().
  for (var i = 3; i < arguments.length; i++) {
    this.addRow(arguments[i]);
  }

  // Render the table to start.
  this.render(false, this.startx, this.starty);
};

// addRow() adds a new row to the table and recalculates its height and width
Table.prototype.addRow = function (row) {
  this.rows.push(row);
  this._height += row._height + this.spacing;
  this._width = Math.max(this._width, row._width);
};

// Table.render() positions the rows within the table. The doResize parameter
// determines whether it should call Table.resize(). The startx and starty 
// parameters determine the position of the upper-left corner of the table.
Table.prototype.render = function (doResize, startx, starty) {

  // If doResize is true, call the table's resize() method. This is useful 
  // to update the table size after something in the table changes.
  if (doResize) {
    this.resize();
  }

  // Reposition the table at (startx,starty). Position defaults 
  // to previous position if a new position is not specified.
  if (startx != undefined) {
    this.startx = startx;
  }
  if (starty != undefined) {
    this.starty = starty;
  }
  var x = this.startx;
  var y = this.starty;

  // Render the rows of the table (which in turn renders the columns).
  for (var i = 0; i < this.rows.length; i++) {
    this.rows[i].render(x, y);
    y += this.rows[i]._height + this.spacing;
  }
};

// removeRowAt() removes a row from the table at a given index.
// Note that the index is zero-relative (the first row is row 0).
Table.prototype.removeRowAt = function (index) {
  this.rows.splice(index, 1);
};

// The resize() method calculates the height and width for a table.
Table.prototype.resize = function () {
  this._width = 0;
  this._height = 0;
  for (var i = 0; i < this.rows.length; i++) {
    this.rows[i].resize();
    this._width = Math.max(this._width, this.rows[i]._width);
    this._height += this.rows[i]._height + this.spacing;
  }
};
