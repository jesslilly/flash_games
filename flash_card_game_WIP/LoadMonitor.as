// The LoadMonitor constructor accepts a reference to the object it should
// monitor. This object can be a Sound object or a movie clip.
_global.LoadMonitor = function (obj) {

  // Create a property with the value of the monitored object.
  this.monitored = obj;

  // Set the interval.
  this.interval = setInterval(this, "monitor", 100);
};

// The setChangeHandler() method allows you to define a callback 
// function that is invoked automatically each time there is load 
// progress. The method accepts a reference to the callback function.
LoadMonitor.prototype.setChangeHandler = function (callback) {
  this.callback = callback;
};

LoadMonitor.prototype.monitor = function () {

  // If the percent loaded is greater than the last time monitor() 
  // was called, invoke the callback function, passing it a reference to
  // the monitored object. The parameter makes it convenient to reference
  // the monitored object within the callback function.
  var pLoaded = this.monitored.percentLoaded;
  if (pLoaded != this.percent) {
    this.callback(this.monitored);
  }
  this.percent = pLoaded;

  // If the monitored object is fully loaded, delete the interval so as to avoid
  // unnecessarily calling this method again.
  if (this.monitored.isLoaded) {
    clearInterval(this.interval);
  }
};
