#include "com/sparkyland/flash/MovieClip.as"

Sound.createNewSound = function (parentClip) {
  if (parentClip == undefined) {
    parentClip = _root;
  }
  if (parentClip.soundCount == undefined) {
  parentClip.soundCount = 0;
  }
  var soundHolder_mc = parentClip.createEmptyMovieClip("soundHolderClip" +
  parentClip.soundCount + "_mc",
  parentClip.getNewDepth( ));
  var soundObj_sound = new Sound(soundHolder_mc);
  soundObj_sound.mc = soundHolder_mc;
  soundHolder_mc.parent = soundObj_sound;
  soundObj_sound.parent = parentClip;
  parentClip.soundCount++;
  if (_global.allSounds == undefined) {
    _global.allSounds = new Array( );
  }
  _global.allSounds.push(soundObj_sound);
  return soundObj_sound;
};

Sound.prototype.play = function (startOffset, loops, maxTime) {

  // Call the start() method with the values for offset and loops.
  this.start(startOffset, loops);

  // If maxTime is undefined, then don't do anything else.
  if (maxTime == undefined) {
    return;
  }
  // Otherwise, we have to detect the elapsed playing time.
  // Record the time when the sound started.
  var startTime = getTimer();

  // Use an interval to monitor the sound by calling
  // the custom monitorPlayback method every 100 ms. Pass the 
  // method the values for startTime and maxTime.
  this.monitorPlaybackInterval = setInterval(this, "monitorPlayback",
                                 100, startTime, maxTime);
};

// Here is the function invoked at each interval
Sound.prototype.monitorPlayback = function (startTime, maxTime) {

  // If the elapsed time exceeds the maxTime, stop the sound,
  // clear the interval, and invoke the callback function.
  if (getTimer() - startTime >= maxTime) {
    this.stop();
    clearInterval(this.monitorPlaybackInterval);
    this.onStopPath[this.onStopCB]();
  }
};

// The setOnStop() method allows you to define a callback function to
// invoke when the sound stops. The parameters are a string specifying 
// the function name and an optional path to the function. If path 
// is undefined, the Sound object's parent property is used instead. 
// The parent property is defined only if you use the custom
// createNewSound() method to create the sound.
Sound.prototype.setOnStop = function (functionName, path) {
  this.onStopPath = (path == undefined) ? this.parent : path;
  this.onStopCB = functionName;
};

Sound.prototype.playToPoint = function (startOffset, loops, outPoint) {
  // If loops is invalid, play the sound once from startOffset to outPoint
  if (loops <= 1) {
    loops = 1;
  }
  // Store the input parameters in object properties of the same name
  this.loops = loops;
  this.startOffset = startOffset;

  // If outPoint is undefined or zero, then just play the sound as usual.
  if (outPoint == undefined || outPoint == 0) {
    // Call the start() method with the values for startOffset and loops.
    this.start(startOffset, loops);
    return;
  }

  // Call the start() method with a starting offset (startOffset) only. 
  // We'll manually loop the sound the sound the specified number of times,
  // from within onSoundComplete( ), each time restarting the sound 
  // at startOffset once it reaches outPoint.
  this.start(startOffset);

  // Initialize the loopCount to zero.
  this.loopCount = 0;

  // Use onSoundComplete() to catch when the sound completes after each loop, 
  // if the specified outPoint happens to be past the duration of the sound.
  this.onSoundComplete = function () {
    this.loopCount++;
    if (this.loopCount < this.loops) {
      this.start(this.startOffSet);
    }
  };

  // Monitor the sound status every 50 ms, pass the interval callback
  // method the values for startOffset, loops and outPoint.
  this.monitorOutpointInterval = setInterval(this, "monitorOutpoint",
                                 50, startOffset, loops, outPoint);
};

// Here is the function invoked at each interval
Sound.prototype.monitorOutpoint = function (startOffset, loops, outPoint) {

  // If the sound's current time exceeds the outPoint, 
  // stop the sound, and increment the loopCount.
  if (this.position >= outPoint) {
    this.stop();
    this.loopCount++;

    // If the total number of loops is reached, stop the sound,
    // clear the interval, and invoke the callback function.
    if (this.loopCount > loops) {
      this.stop();
      clearInterval(this.monitorOutpointInterval);
      this.onStopPath[this.onStopCB]();
    } else {
       // Otherwise, restart the sound from startOffset
       // and wait for it to reach outPoint again
       this.start(startOffset);
    }
  }
};

Sound.prototype.pause = function () {
  // Get the current position, and then stop the sound.
  this.pauseTime = this.position;
  this.stop();
};

Sound.prototype.resume = function () {
  // Start the sound at the point at which it was previously stopped.
  this.start(this.pauseTime/1000);
};

Sound.prototype.fadeIn = function (millis, minVol, maxVol, startFadeTime, 
                                   startSound, startPlayOffset) {

  // If the sound is already at 100 percent volume, set the volume to zero.
  // That is, because sounds default to 100 percent volume, we
  // want to fade from zero (unless minVol specifies otherwise). 
  // If the volume is not already 100 percent, fade up from the current 
  // volume, by default.
  if (this.getVolume() == 100) {
    this.setVolume(0);
  }

  minVol = (minVol == undefined) ? this.getVolume() : minVol;
  maxVol = (maxVol == undefined) ? 100 : maxVol;
  startFadeTime = (startFadeTime == undefined) ? 0 : startFadeTime;

  // If startSound is true, start the playback of the sound.
  if (startSound) {
    this.start(startPlayOffset/1000);
  }

  // Invoke the custom monitorFadeIn() method every 100 ms. 
  // Pass it the parameters needed to make the sound fade calculations.
  this.monitorFadeInInterval = setInterval(this, "monitorFadeIn", 
                       100, millis, minVol, maxVol, startFadeTime);
};

// Invoke this function periodically to monitor the sound fade.
Sound.prototype.monitorFadeIn = function (fadeInMillis, minVol, maxVol, 
                                            startFadeTime) {
  // Once the fade in time is exceeded, make sure the maximum volume
  // is reached and clear the interval to end the fade.
  var pos = this.position;
  if (pos > fadeInMillis + startFadeTime) {

    // Make sure the volume is set to the max before terminating the fade.
    this.setVolume(maxVol);
    clearInterval(this.monitorFadeInInterval);

    // Call the onFadeInStop callback function if one is defined.
    this.onFadeInStopPath[this.onFadeInStopCB]();  
  }

  // Set the volume based on the current sound position, fading from
  // minVol to maxVol over the specified time duration.
  // Make sure the volume doesn't exceed maxVol accidentally.
  var volumePercent = Math.min(minVol + (pos - startFadeTime) / fadeInMillis *
                                (maxVol - minVol), maxVol);
  volumePercent = (volumePercent < 0) ? 0 : volumePercent;

  // Set the volume of the sound repeatedly to simulate a sound fade.
  this.setVolume(volumePercent);
};

// The setOnFadeInStop() method allows you to define a callback function to
// invoke when the sound finishing fading in. The parameters are a string 
// specifying the function name and an optional path to the function. If path 
// is undefined, the Sound object's parent property is used instead. 
// The parent property is defined only if you use the custom createNewSound() 
// method to create the sound.
Sound.prototype.setOnFadeInStop = function (functionName, path) {
  this.onFadeInStopPath = (path == undefined) ? this.parent : path;
  this.onFadeInStopCB = functionName;
};

Sound.prototype.fadeOut = function (millis, minVol, maxVol, startTime, stopSound) {

  // If startTime is undefined, fade the sound out at the very end.
  startFadePos = (startTime == undefined) ? this.duration - millis : startTime;

  minVol = (minVol == undefined) ? 0 : minVol;
  maxVol = (maxVol == undefined) ? this.getVolume() : maxVol;
  
  // The madeCallback property is initialized to false. This property gets set
  // to true when the start fade out callback function has been invoked. It ensures
  // that the callback is called once and only once, when the fade out begins.
  this.madeCallback = false;
  
  // Invoked the custom monitorFadeOut() method every 100 milliseconds
  this.monitorFadeOutInterval = setInterval(this, "monitorFadeOut", 100, millis,
                                     startFadePos, minVol, maxVol, stopSound);
};

Sound.prototype.monitorFadeOut = function (fadeOutMillis, startFadePos, minVol,
                                            maxVol, stopSound) {
  var pos = this.position;
  var dur = this.duration;

  // Execute the fade out once the desired point in the sound is reached.
  if (pos >= startFadePos) {

    // Call the fade out start callback function if it has not been called yet.
    if (!this.madeCallback) {
      this.madeCallback = true;
      this.onFadeOutStartPath[this.onFadeOutStartCB]();
    }

    // If the ending fade out position has been reached, clear the interval so as 
    // not to needlessly monitor the sound anymore.
    if (pos >= dur || pos >= startFadePos + fadeOutMillis) {

      // Make sure the volume is set to the minVol before terminating the fade.
      this.setVolume(minVol);
      clearInterval(this.monitorFadeOutInterval);
    }

    // Set the volume based on the current sound position, fading to minVol over
    // the specified time span. The fade occurs relative to maxVol.
    var volumePercent = ((startFadePos + fadeOutMillis) - pos) / 
                          fadeOutMillis * maxVol;

    // If the volume reaches minVol, call the fade out stop callback, clear
    // the interval, and if appropriate, stop the sound.
    if (volumePercent <= minVol) {
      volumePercent = minVol;
      this.onFadeOutStopPath[this.onFadeOutStopCB]();
      clearInterval(this.monitorFadeOutInterval);
      if (stopSound) {
        this.stop();
      }
    }

    // Set the volume of the sound
    this.setVolume(volumePercent);
  }
};

// The setOnFadeOutStop() and setOnFadeOutStart() methods allow you to define
// callback functions to invoke when the fade starts and stops. The parameters 
// are a string specifying the function name and an optional path to the function.
// If path is undefined, the Sound object's parent property is used instead. 
// The parent property is defined only if you use the custom createNewSound() 
// method to create the sound.
Sound.prototype.setOnFadeOutStop = function (functionName, path) {
  this.onFadeOutStopPath = (path == undefined) ? this.parent : path;
  this.onFadeOutStopCB = functionName;
};

Sound.prototype.setOnFadeOutStart = function (functionName, path) {
  this.onFadeOutStartPath = (path == undefined) ? this.parent : path;
  this.onFadeOutStartCB = functionName;
};

// The getIsLoaded() method returns true if the asset has 
// loaded completely; otherwise, it returns false.
Sound.prototype.getIsLoaded = function () {
  return ( (this.getBytesLoaded() == this.getBytesTotal()) && 
           (this.getBytesTotal() > 0) );
};

// The isLoaded property is created for all Sound objects by calling the 
// addProperty() method from the Sound class's prototype. This code configures
// the isLoaded property to automatically call the getIsLoaded() method.
Sound.prototype.addProperty("isLoaded", Sound.prototype.getIsLoaded, null);

// The getPercentLoaded() method returns the percent that has loaded as a whole
// number. It also makes sure that the returned value is always a valid number.
Sound.prototype.getPercentLoaded = function () {
  var pLoaded = Math.round((this.getBytesLoaded() / this.getBytesTotal()) * 100);
  if (isNaN(pLoaded)) {
    pLoaded = 0;
  }
  return pLoaded;
};

// The percentLoaded property is created for all Sound objects 
// using the addProperty() method. This code configures the
// Sound class so that whenever the percentLoaded property is 
// accessed, the getPercentLoaded() method is called automatically.
Sound.prototype.addProperty("percentLoaded", 
                            Sound.prototype.getPercentLoaded, null);
