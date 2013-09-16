MovieClip.prototype.fade = function (rate, up) {

  // Create a new, nested movie clip to monitor the fade progress. This avoids
  // interfering with any existing onEnterFrame() method applied to the movie clip.
  this.createEmptyMovieClip("fadeMonitor_mc", this.getNewDepth());

  // Define a new onEnterFrame() method for the monitor movie clip.
  this.fadeMonitor_mc.onEnterFrame = function () {

    // Set a Boolean property, isFading, so that other methods 
    // know if the movie clip is being faded.
    this._parent.isFading = true;

    // Check whether the movie clip is being faded up or down.
    if (up) {
      // Use an intermediate property to determine the new alpha value.
      this.alphaCount = (this.alphaCount == undefined) ? 0 : 
                         this.alphaCount + rate;

      // If the current _alpha of the clip is under 100, assign the new value;
      // otherwise, set the value to 100 and delete the onEnterFrame() method.
      if (this._parent._alpha < 100) {
        this._parent._alpha = this.alphaCount;
      } else {
        this._parent._alpha = 100;
        delete this.onEnterFrame;

        // Set isFading to false since the fade is completed.
        this._parent.isFading = false;
      }
    }
    else {
      // Use alphaCount as an intermediate property to determine the alpha value.
      this.alphaCount = (this.alphaCount == undefined) ? 100 : 
                         this.alphaCount - rate;

      // If the current _alpha is greater than 0, assign the new value;
      // otherwise, set the value to 0 and delete the onEnterFrame() method.
      if (this._parent._alpha > 0) {
        this._parent._alpha = this.alphaCount;
      } else {
        this._parent._alpha = 0;
        delete this.onEnterFrame;
	
        // Set isFading to false since the fade is completed.
        this._parent.isFading = false;
      }
    }
  }
};

MovieClip.prototype.getMovieClips = function () {

  // Define the array to contain the movie clip references.
  var mcs = new Array();

  // Loop through all the contents of the movie clip.
  for (var i in this) {
    // Add any nested movie clips to the array.
    if (this[i] instanceof MovieClip) {
      mcs.push(this[i]);
    }
  }

  return mcs;
};

MovieClip.prototype.showMovieClips = function () {
  // Loop through all the contents of the movie clip.
  for (var i in this) {
    // Add any nested movie clips to the array.
    if (this[i] instanceof MovieClip) {
      trace (this[i]);
      // Recursively call this function to show any nested clips
      this[i].showMovieClips();
    }
  }
};

MovieClip.prototype.getNewDepth = function () {
  // If no currentDepth is defined, initialize it to 1
  if (this.currentDepth == undefined) {
    this.currentDepth = 1;
  }
  // Return the new depth, and increment it by 1 for next time
  return this.currentDepth++;
};

MovieClip.prototype.outline = function (circleRadius, show) {
  // Use a default radius of 3 pixels.
  if (circleRadius == undefined) {
    circleRadius = 3;
  }

  // Create an array for holding the references to the outline circles.
  this.outlines = new Array();

  // Get the coordinates of the bounding box, and set the x and y variables
  // accordingly. The x variable must be more than the minimum x boundary because
  // otherwise the method will not be able to locate the shape.
  var bounds = this.getBounds(this);
  var x = bounds.xMin + circleRadius;
  var y = bounds.yMin;

  // Begin by outlining the shape from the top, left corner and moving to the right
  // as x increases.
  var dir = "incX";
  goodToGo = true;
  var pnts;
  var i = 0;

  // The goodToGo variable is true until the last circle is drawn.
  while (goodToGo) {
    i++;

    // Create the new circle outline movie clip and draw a circle in it.
    this.createEmptyMovieClip("outline" + i, i);
    var mc = this["outline" + i];
    mc.lineStyle(0, 0x0000FF, 100);
    mc.drawCircle(circleRadius);

    // Set the circle visibility to false unless show is true.
    mc._visible = show ? true : false;

    // Add the circle movie clip to the outlines array for use during the hit test.
    this.outlines.push(mc);

    // Check to see in which direction the outline is being drawn.
    switch (dir) {
      case "incX":

        // Increment the x value by the width of one of the circles to move
        // the next circle just to the right of the previous one.
        x += mc._width;

        // Create a point object and call localToGlobal() to convert
        // the values to the global equivalents.
        pnts = {x: x, y: y};
        this.localToGlobal(pnts);

        // If the center of the circle does not touch the shape within the
        //  movie clip, increment y and calculate the new global equivalents 
        // for another hit test. This moves the circle down until it touches
        // the shape.
        while (!this.hitTest(pnts.x, pnts.y, true)) {
          y += mc._width;
          pnts = {x: x, y: y};
          this.localToGlobal(pnts);
        }

        // If the maximum x boundary has been reached, set the new direction to
        // begin moving in the increasing y direction.
        if (x >= bounds.xMax - (mc._width)) {
          dir = "incY";
        }

        // Set the coordinates of the circle movie clip.
        mc._x = x;
        mc._y = y;

        // Reset y to the minimum y boundary, so that you can move the 
        // next circle down from the top until it touches the shape.
        y = bounds.yMin;
        break;

      case "incY":
        // The remaining cases are much like the first, but they 
        // move in different directions.
        y += mc._width;
        pnts = {x: x, y: y};
        this.localToGlobal(pnts);
        while (!this.hitTest(pnts.x, pnts.y, true)) {
          x -= mc._width;
          pnts = {x: x, y: y};
          this.localToGlobal(pnts);
        }
        if (y >= bounds.yMax - (mc._width)) {
          dir = "decX";
        }
        mc._x = x;
        mc._y = y;
        x = bounds.xMax;
        break;

      case "decX":
        x -= mc._width;
        pnts = {x: x, y: y};
        this.localToGlobal(pnts);
        while (!this.hitTest(pnts.x, pnts.y, true)) {
          y -= mc._width;
          pnts = {x: x, y: y};
          this.localToGlobal(pnts);
        }
        if (x <= bounds.xMin + (mc._width)) {
          dir = "decY";
        }
        mc._x = x;
        mc._y = y;
        y = bounds.yMax;
        break;

      case "decY":
        y -= mc._width;
        pnts = {x: x, y: y};
        this.localToGlobal(pnts);
        while (!this.hitTest(pnts.x, pnts.y, true)) {
          x += mc._width;
          pnts = {x: x, y: y};
          this.localToGlobal(pnts);
        }
        if (y <= bounds.yMin + (mc._width)) {
          goodToGo = false;
        }
        mc._x = x;
        mc._y = y;
        x = bounds.xMin;
        break;
    }
  }
};

// Perform a hit test between a movie clip with outline circles and 
// another movie clip you specify in the parameter.
MovieClip.prototype.hitTestOutline = function (mc) {

  // Loop through all the elements of the outlines array.
  for (var i = 0; i < this.outlines.length; i++) {

    // Create a point object and get the global equivalents.
    var pnts = {x:this.outlines[i]._x, y:this.outlines[i]._y};
    this.localToGlobal(pnts);

    // If the mc movie clip tests true for overlapping with any of the outline
    // circles, then return true. Otherwise, the method returns false.
    if (mc.hitTest(pnts.x, pnts.y, true)) {
      return true;
    }
  }
  return false;
};

MovieClip.prototype.getIsLoaded = function () {
  return ( (this.getBytesLoaded() == this.getBytesTotal()) && 
           (this.getBytesTotal() > 0) );
};
MovieClip.prototype.addProperty("isLoaded", MovieClip.prototype.getIsLoaded, null);

MovieClip.prototype.getPercentLoaded = function () {
  var pLoaded = Math.round((this.getBytesLoaded() / this.getBytesTotal()) * 100);
  if (isNaN(pLoaded)) {
    pLoaded = 0;
  }
  return pLoaded;
};
MovieClip.prototype.addProperty("percentLoaded",
                                 MovieClip.prototype.getPercentLoaded, null);
