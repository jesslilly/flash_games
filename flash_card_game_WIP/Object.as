// The startListeners() method calls watch() to start watching a 
// property. If you want an object to listen for multiple properties,
// call startListeners() for each property.
Object.prototype.startListeners = function (propName) {
  this.watch(propName, this.propSet);
};

// The addListener() and removeListener() methods are the same as the 
// preceding example, except that they are applied to the Object class.
Object.prototype.addListener = function (listener) {
  if (this.listeners == undefined) {
    this.listeners = new Array();
  }
  this.listeners.push(listener);
};

Object.prototype.removeListener = function (listener) {
  for (var i = 0; i < this.listeners.length; i++) {
    if (this.listeners[i] == listener) {
      this.listeners.splice(i, 1);
      break;
    }
  }
};

// The propSet() method is the callback function for the watched properties.
// This method is slightly more generic than in the preceding example,
// insofar as it allows for any property to be watched.
Object.prototype.propSet = function (prop, oldVal, newVal) {

  // Loop through all the listeners.
  for (var i = 0; i < this.listeners.length; i++) {

    // This calls the onPropertyNameChange() method on each listener, 
    // where PropertyName is given by the prop parameter.
    this.listeners[i]["on" + prop + "Change"](oldVal, newVal);
  }

  // Return the new value so it is properly assigned to the property.
  return newVal;
};
