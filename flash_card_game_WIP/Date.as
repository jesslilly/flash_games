// There are 1000 milliseconds in a second, 60 seconds in a minute, 60 minutes in
// an hour, 24 hours in a day, and 7 days in a week.
Date.SEC = 1000;
Date.MIN = Date.SEC * 60;
Date.HOUR = Date.MIN * 60;
Date.DAY = Date.HOUR * 24;
Date.WEEK = Date.DAY * 7;

// Create days and months arrays as properties of the Date class.
Date.days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", 
                       "Friday", "Saturday"];
Date.months = ["January", "February", "March", "April", "May", "June", 
                         "July", "August", "September", "October", "November", 
                         "December"];

// This is a custom helper method that converts a number value to a string that is
// always in the format of XX. This is important for values such as hours so that
// single digit values are formatted correctly (i.e. - 5 becomes 05).
Date.toTens = function (val) {
  if(val < 10) {
    return "0" + val;
  }
  else {
    return String(val);
  }
}

// Converts an hour and minute value to a string representing the time on a twelve-
// hour clock. The hour value of the date is always given between 0 and 23, so you
// need to convert it by subtracting 12 if the value is greater than 12, and by
// using 12 if the hour value is 0 (midnight).
Date.toTwelveHour = function (hour, min) {
  var amPm = "AM";
  if(hour > 12) {
    hour = hour - 12;
    amPm = "PM";
  }
  if(hour == 0) {
    hour = 12;
  }
  return Date.toTens(hour) + ":" + Date.toTens(min) + " " + amPm;
}

Date.prototype.format = function (format) {

  // Create local variables with the date's values.
  var day       = this.getDay();
  var monthDate = this.getDate();
  var month     = this.getMonth();
  var year      = this.getFullYear();
  var hour      = this.getHours();
  var min       = this.getMinutes();
  var sec       = this.getSeconds();
  var millis    = this.getMilliseconds();

  // Return a string with the date and/or time in the requested format, such as
  // "MM-dd-yyyy". You may want to add more cases to implement the remaining
  // formats within Table 10-1.
  switch (format) {
    case "MM-dd-yyyy":
      return Date.toTens(month + 1) + "-" + Date.toTens(monthDate) + "-" + year;
    case "MM/dd/yyyy":
      return Date.toTens(month + 1) + "/" + Date.toTens(monthDate) + "/" + year;
    case "dd-MM-yyyy":
      return Date.toTens(monthDate) + "-" + Date.toTens(month + 1) + "-" + year;
    case "dd/MM/yyyy":
      return Date.toTens(monthDate) + "/" + Date.toTens(month + 1) + "/" + year;
    case "hh:mm a":
      return Date.toTwelveHour(hour, min);
    case "EEE, MMM dd, yyyy":
      return Date.days[day].substr(0, 3) + ", " + Date.months[month] + " " + 
             Date.toTens(monthDate) + ", " + year;
    case "E, MMM dd, yyyy":
      return Date.days[day] + ", " + Date.months[month] + " " + 
             Date.toTens(monthDate) + ", " + year;
  }
};

Date.prototype.doMath = function (years, months, days, hours, minutes, 
                                  seconds, milliseconds) {

  // Perform conversions on a copy of the original date,
  // so as not to alter the original
  var d = new Date(this.getTime());

  // Add the specified intervals to the original date
  d.setYear(d.getFullYear() + years);
  d.setMonth(d.getMonth() + months);
  d.setDate(d.getDate() + days);
  d.setHours(d.getHours() + hours);
  d.setMinutes(d.getMinutes() + minutes);
  d.setSeconds(d.getSeconds() + seconds);
  d.setMilliseconds(d.getMilliseconds() + milliseconds);

  // Return the new date value
  return d;
};

Date.prototype.elapsedTime = function (t1) {
  // Calculate the elapsed time relative to the specified Date object.
  if (t1 == undefined) {
    // Calculate the elapsed time from "now" if no object is specified.
    t1 = new Date();
  } else {
    // Make a copy so as not to alter the original.
    t1 = new Date(t1.getTime());
  }
  // Use the original Date object's time as one endpoint. Make a copy
  // so as not to alter the original.
  var t2 = new Date(this.getTime());
  
  // Ensure that the elapsed time is always calculated as a positive value.
  if (t1 < t2) {
   temp = t1;
   t1 = t2;
   t2 = temp;
  }
  // Return the elapsed time as a new Date object
  var t = new Date(t1.getTime() - t2.getTime());
  return t;
};

Date.prototype.elapsedYears = function () {
  return this.getUTCFullYear() - 1970;
};

Date.prototype.elapsedDays = function () {
  return this.getUTCDate() - 1;
};
