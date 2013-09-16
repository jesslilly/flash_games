Math.degToRad = function(deg){
  return (Math.PI * deg) / 180;
}

Math.radToDeg = function(rad){
  return (rad * 180) / Math.PI;
}

Math.roundDecPl = function (num, decPl) {
  var multiplier = Math.pow(10, decPl);
  num = num * multiplier;
  num = Math.round(num);
  num = num/multiplier;
  return num;
}

Math.roundTo = function (num, roundToInterval) {
  // roundToInterval defaults to 1 (round to the nearest integer)
  if (roundToInterval == undefined) {
    roundToInterval = 1;
  }
  // Return the result
  return Math.round(num / roundToInterval) * roundToInterval;
};

Math.zeroFill = function (num, places, trailing) {

  // Convert the number to a string
  var filledVal = String(num);

  // Get the length of the string
  var len = filledVal.length;

  // Use a for statement to add the necessary number of characters.
  for (var i = 0; i < (places - len); i++) {
    // If trailing is true, append the zeros; otherwise, prepend them.
    if (trailing) {
      filledVal += "0";
    } else {
      filledVal = "0" + filledVal;
    }
  }
  // Return the string
  return filledVal;
};


Math.randRange = function (min, max, decPl) {

  // Find the difference in the range and add one (we'll call this the delta).
  var rangeDiff = (max - min) * Math.pow(10, decPl) + 1;

  // Multiply the delta by the result of Math.random() to generate a value between
  // 0 and 0.999 * delta.
  var randVal = Math.random() * rangeDiff;

  // Round the value to the desired number of decimal places.
  // This relies on our custom roundDecPl() method from Recipe 5.3
  randVal = Math.floor(randVal);

  randVal /= Math.pow(10, decPl);
  
  // Add the random offset to min to generate a random number in the correct range.
  randVal += min;

  // Return the random value.
  return randVal;
};

Math.numberFormat = function (num, thousandsDelim, decimalDelim, spaceFill) {
  // Default to a comma for thousands, and a period for decimals
  if (thousandsDelim == undefined) {thousandsDelim = ",";}
  if (decimalDelim   == undefined) {decimalDelim= ".";}

  // Convert the number to a string, and split it at the decimal point.
  parts = String(num).split(".");

  // Take the whole number portion and store it as an array of single characters.
  // This makes it easier to insert the thousands delimiters, as needed.
  partOneAr = parts[0].split("");

  // Reverse the array, so we can process the characters right-to-left.
  partOneAr.reverse();

  // Insert the thousands delimiter after every third character.
  for (var i = 0, counter = 0; i < partOneAr.length; i++) {
    counter++;
    if (counter > 3) {
      counter = 0;
      partOneAr.splice(i, 0, thousandsDelim);
    }
  }

  // Reverse the array again so that it is back in the original order.
  partOneAr.reverse();

  // Create the formatted string, using the decimalDelim if necessary.
  var val = partOneAr.join("");
  if (parts[1] != undefined) {
    val += decimalDelim + parts[1];
  }

  // If spaceFill is defined, add the necessary number of leading spaces.
  if (spaceFill != undefined) {
    // Store the original length before adding spaces.
    var origLength = val.length;
    for (var i = 0; i < spaceFill - origLength; i++) {
      val = " " + val;
    }
  }

  // Return the value.
  return val;
};

Math.currencyFormat = function (num, decimalPl, currencySymbol, thousandsDelim,
                                decimalDelim, truncate, spaceFill) {

  // Default to two decimal places, a dollar sign ($), a comma for thousands,
  // and a period for the decimal point. We implemented the defaults using the
  // conditional operator. Compare with Recipe "Formatting Numbers for Display".
  decimalPl      = (decimalPl == undefined)      ? 2   : decimalPl;
  currencySymbol = (currencySymbol == undefined) ? "$" : currencySymbol;
  thousandsDelim = (thousandsDelim == undefined) ? "," : thousandsDelim;
  decimalDelim   = (decimalDelim == undefined)   ? "." : decimalDelim;

  // Split the number into the whole and decimal (fractional) portions.
  var parts = String(num).split(".");

  // Truncate or round the decimal portion, as directed.
  if (truncate) {
    parts[1] = Number(parts[1]) * Math.pow(10, -(decimalPl - 1));
    parts[1] = String(Math.floor(parts[1]));
  } else {
    // Requires the roundDecPl() method defined in Recipe "Rounding Numbers"
    parts[1] = Math.roundDecPl(Number("." + parts[1]), decimalPl);
    parts[1] = String(parts[1]).split(".")[1];
  }

  // Ensure that the decimal portion has the number of digits indicated. 
  // Requires the zeroFill() method defined in Recipe "Inserting Leading or Trailing Zeros"
  parts[1] = Math.zeroFill(parts[1], decimalPl, true);
  
  // If necessary, use the numberFormat() method from Recipe "Formatting Numbers for Display"
  // to format the number with the proper thousands delimiter and leading spaces.
  if (thousandsDelim != "" || spaceFill != undefined) {
    parts[0] = Math.numberFormat(parts[0], thousandsDelim, "",  spaceFill - decimalPl - currencySymbol.length);
  }

  // Add a currency symbol, and use String.join() to merge the whole (dollar)
  // and decimal (cents) portions using the designated decimal delimiter.
  return currencySymbol + parts.join(decimalDelim);
};

Math.getUniqueID = function (useCached) {

  // If the unique ID has already been created and if useCached is 
  // true, return the previously generated value.
  if (this.uniqueID != undefined && useCached) {
    return this.uniqueID;
  }

  var now = new Date();          // Generate a Date object that represents "now"
  this.uniqueID = now.getTime(); // Get the elapsed milliseconds since Jan 1, 1970
  return this.uniqueID;  
};

Math.getDistance = function (x0, y0, x1, y1) {

  // Calculate the lengths of the legs of the right triangle.
  var dx = x1 - x0;
  var dy = y1 - y0;

  // Find the sum of the squares of the legs of the triangle.
  var sqr = Math.pow(dx, 2) + Math.pow(dy, 2);

  // Return the square root of the sqr value.
  return (Math.sqrt(sqr));
};

Math.convertTemperature = function (fMeasure, tMeasure, val) {
  var centigradeVal = Math.convertToCentigrade (fMeasure, val);
 return Math.convertFromCentigrade (tMeasure, centigradeVal );
};


Math.convertToCentigrade = function (fMeasure, val) {
  fMeasure = fMeasure.toLowerCase();
  if (fMeasure == "kelvin" || fMeasure == "k") {
    return (val - 273.15);
  } else if ( fMeasure == "fahrenheit" || fMeasure == "f" ) { 
    return (val - 32) * 5/9;
  } else if (fMeasure == "centigrade" || fMeasure == "celsius" || fMeasure == "c") {
    return val;
  } else {
    return NaN;
  }
};

Math.convertFromCentigrade = function (tMeasure, val) {
  tMeasure = tMeasure.toLowerCase();
  if (tMeasure == "kelvin" || tMeasure == "k") {
    return (val + 273.15);
  } else if ( tMeasure == "fahrenheit" || tMeasure == "f" ) {
    return (val * 9/5) + 32;
  } else if (tMeasure == "centigrade" || tMeasure == "celsius" || tMeasure == "c") {
    return val;
  } else {
    return NaN;
  }
};

Math.convertWeights = function (fMeasure, tMeasure, val) {
  if (fMeasure == "pounds" && tMeasure == "kilograms") {
    return val / 2.2;
  }
  else if (fMeasure == "kilograms" && tMeasure == "pounds") {
    return val * 2.2;
  } else {
    return "invalid conversion type";
  }
};

Math.bruteFutureValue = function (interest, n, PV) {
  // PV       = initial deposit (present value)  
  // interest = periodic interest rate
  // n        = number of periods
 
  // Start with the future value equal to the present value
  FV = PV;
  
  // Now compound it over n periods at an interest rate of interest
  for (var periods = 1; periods <= n; periods++) {
    FV = FV * (1 + interest);
  }  
  return FV;
};

Math.futureValue = function (interest, n, PV) {
  // PV       = initial deposit (present value)  
  // interest = periodic interest rate
  // n        = number of payment periods  
  multiplier = Math.pow ((1 + interest), n);
  return (PV * multiplier);
};

Math.continuousCompounding = function (interest, n, PV) {
  // PV       = initial deposit (present value)  
  // interest = periodic interest rate
  // n        = number of payment periods  
  multiplier = Math.pow (Math.E, n*interest);
  return (PV * multiplier);
};

Math.FV = function (interest, n, PMT, PV) {
  // PV       = initial deposit (present value)  
  // interest = periodic interest rate
  // n        = number of payment periods
  // PMT      = periodic payment
  // FV       = Future value
 
  // Financial equations for a series of payments compounded over n periods
  // multiplier      = Math.pow ((1 + interest ), n)
  // FV of principle = PV * Math.pow ((1 + interest ), n) 
  //                 = PV * multiplier
  // FV of payments  = PMT * ((Math.pow ((1 + interest ), n) - 1) / interest) 
  //                 = PMT * ((multiplier-1)/interest)
  
  multiplier = Math.pow ((1 + interest), n);
  // Add FV of principle and FV of payments together to get total value
  FV = PV * multiplier + PMT * ( (multiplier-1) / interest);
 
  return FV;
};

Math.bruteFV = function (interest, n, PMT, PV) {
  FV = PV;
  for (var periods = interest; periods <= n; periods++) {
    FV = FV * (1 + interest) + PMT;
  }
  return FV;
};

Math.PV = function (i, n, PMT) {
  // i   = periodic interest rate
  // n   = number of payment periods
  // PMT = periodic payment
  
  // Present Value compounded over n periods 
  // PV = PMT * ( (multiplier-1)/(i*multiplier))
  // where multiplier = Math.pow ((1 + i), n)
  
  multiplier = Math.pow ((1 + i), n);
  PV = PMT * (multiplier-1) / (i*multiplier); 
  return PV;
};

Math.PMT = function (i, n, PV) { 
  // PV  = initial savings deposit or loan amount(present value)  
  // i   = periodic interest rate
  // n   = number of payment periods
  // PMT = periodic payment
  
  // Calculate the periodic payment needed to amortize (pay back) a loan
  multiplier = Math.pow((1 + i), n);
  
  return (PV * i * multiplier / (multiplier - 1));
};

