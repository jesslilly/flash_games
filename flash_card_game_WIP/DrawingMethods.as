// Include the custom Math library from Chapter 5 to access Math.degToRad()
#include "com/sparkyland/flash/Math.as"

MovieClip.prototype.drawRectangle = function (width, height, round, rotation, x, y) {
  // Make sure the rectangle is at least as wide and tall as the rounded corners
  if (width < (round * 2)) {
    width = round * 2;
  }
  if (height < (round * 2)) {
    height = round * 2;
  }

  // Convert the rotation from degrees to radians
  rotation = Math.degToRad(rotation);

  // Calculate the distance from the rectangle's center to one of the corners
  // (or where the corner would be in rounded-cornered rectangles).
  // See the line labeled r in Figure 4-2.
  var r = Math.sqrt(Math.pow(width/2, 2) + Math.pow(height/2, 2));

  // Calculate the distance from the rectangle's center to the upper edge of
  // the bottom-right rounded corner. See the line labeled rx in Figure 4-2. 
  // When round is 0, rx is equal to r.
  var rx = Math.sqrt(Math.pow(width/2, 2) + Math.pow((height/2) - round, 2));

  // Calculate the distance from the rectangle's center to the lower edge of
  // the bottom-right rounded corner. See the line labeled ry in Figure 4-2.
  // When round is 0, ry is equal to r.
  var ry = Math.sqrt(Math.pow((width/2) - round, 2) + Math.pow(height/2, 2));

  // Calculate angles. r1Angle is the angle between the X axis that runs through
  // the center of the rectangle and the line rx. r2Angle is the angle between rx
  // and r. r3Angle is the angle between r and ry. And r4Angle is the angle
  // between ry and the Y axis that runs through the center of the rectangle.
  var r1Angle = Math.atan( ((height/2) - round) /( width/2) );
  var r2Angle = Math.atan( (height/2) / (width/2) ) - r1Angle;
  var r4Angle = Math.atan( ((width/2) - round) / (height/2) );
  var r3Angle = (Math.PI/2) - r1Angle - r2Angle - r4Angle;

  // Calculate the distance of the control point from the arc center for the
  // rounded corners.
  var ctrlDist = Math.sqrt(2 * Math.pow(round, 2));

  // Declare the local variables used to calculate the control point.
  var ctrlX, ctrlY;

  // Calculate where to begin drawing the first side segment, and then draw it.
  rotation += r1Angle + r2Angle + r3Angle;
  var x1 = x + ry * Math.cos(rotation);
  var y1 = y + ry * Math.sin(rotation);
  this.moveTo(x1, y1);
  rotation += 2 * r4Angle;
  x1 = x + ry * Math.cos(rotation);
  y1 = y + ry * Math.sin(rotation);
  this.lineTo(x1, y1);

  // Set rotation to the starting point for the next side segment and calculate
  // the x and y coordinates.
  rotation += r3Angle + r2Angle;
  x1 = x + rx * Math.cos(rotation);
  y1 = y + rx * Math.sin(rotation);

  // If the corners are rounded, calculate the control point for the corner's
  // curve and draw it.
  if (round > 0) {
    ctrlX = x + r * Math.cos(rotation - r2Angle);
    ctrlY = y + r * Math.sin(rotation - r2Angle);
    this.curveTo(ctrlX, ctrlY, x1, y1);
  }

  // Calculate the end point of the second side segment and draw the line.
  rotation += 2 * r1Angle;
  x1 = x + rx * Math.cos(rotation);
  y1 = y + rx * Math.sin(rotation);
  this.lineTo(x1, y1);

  // Calculate the next line segment's starting point.
  rotation += r2Angle + r3Angle;
  x1 = x + ry * Math.cos(rotation);
  y1 = y + ry * Math.sin(rotation);

  // Draw the rounded corner, if applicable.
  if (round > 0) {
    ctrlX = x + r * Math.cos(rotation - r3Angle);
    ctrlY = y + r * Math.sin(rotation - r3Angle);
    this.curveTo(ctrlX, ctrlY, x1, y1);
  }

  // Calculate the end point of the third segment and draw the line.
  rotation += 2 * r4Angle;
  x1 = x + ry * Math.cos(rotation);
  y1 = y + ry * Math.sin(rotation);
  this.lineTo(x1, y1);

  // Calculate the starting point of the next segment.
  rotation += r3Angle + r2Angle;
  x1 = x + rx * Math.cos(rotation);
  y1 = y + rx * Math.sin(rotation);

  // If applicable, draw the rounded corner.
  if (round > 0) {
    ctrlX = x + r * Math.cos(rotation - r2Angle);
    ctrlY = y + r * Math.sin(rotation - r2Angle);
    this.curveTo(ctrlX, ctrlY, x1, y1);
  }

  // Calculate the end point for the fourth segment, and draw it.
  rotation += 2 * r1Angle;
  x1 = x + rx * Math.cos(rotation);
  y1 = y + rx * Math.sin(rotation);
  this.lineTo(x1, y1);

  // Calculate the end point for the next corner arc, and if applicable, draw it.
  rotation += r3Angle + r2Angle;
  x1 = x + ry * Math.cos(rotation);
  y1 = y + ry * Math.sin(rotation);
  if (round > 0) {
    ctrlX = x + r * Math.cos(rotation - r3Angle);
    ctrlY = y + r * Math.sin(rotation - r3Angle);
    this.curveTo(ctrlX, ctrlY, x1, y1);
  }
}

MovieClip.prototype.drawCircle = function (radius, x, y) {
  // The angle of each of the eight segments is 45 degrees (360 divided by eight),
  // which equals p/4 radians.
  var angleDelta = Math.PI / 4;

  // Find the distance from the circle's center to the control points
  // for the curves.
  var ctrlDist = radius/Math.cos(angleDelta/2);

  // Initialize the angle to 0 and define local variables that are used for the
  // control and ending points. 
  var angle = 0;
  var rx, ry, ax, ay;

  // Move to the starting point, one radius to the right of the circle's center.
  this.moveTo(x + radius, y);

  // Repeat eight times to create eight segments.
  for (var i = 0; i < 8; i++) {

    // Increment the angle by angleDelta (p/4) to create the whole circle (2p).
    angle += angleDelta;

    // The control points are derived using sine and cosine.
    rx = x + Math.cos(angle-(angleDelta/2))*(ctrlDist);
    ry = y + Math.sin(angle-(angleDelta/2))*(ctrlDist);

    // The anchor points (end points of the curve) can be found similarly to the
    // control points.
    ax = x + Math.cos(angle)*radius;
    ay = y + Math.sin(angle)*radius;

    // Draw the segment.
    this.curveTo(rx, ry, ax, ay);
  }
}

MovieClip.prototype.drawEllipse = function (xRadius, yRadius, x, y) {
  var angleDelta = Math.PI / 4;

  // Whereas the circle has only one distance to the control point 
  // for each segment, the ellipse has two distances: one that 
  // corresponds to xRadius and another that corresponds to yRadius.
  var xCtrlDist = xRadius/Math.cos(angleDelta/2);
  var yCtrlDist = yRadius/Math.cos(angleDelta/2);
  var rx, ry, ax, ay;
  this.moveTo(x + xRadius, y);
  for (var i = 0; i < 8; i++) {
    angle += angleDelta;
    rx = x + Math.cos(angle-(angleDelta/2))*(xCtrlDist);
    ry = y + Math.sin(angle-(angleDelta/2))*(yCtrlDist);
    ax = x + Math.cos(angle)*xRadius;
    ay = y + Math.sin(angle)*yRadius;
    this.curveTo(rx, ry, ax, ay);
  }
}

MovieClip.prototype.drawTriangle = function (ab, ac, angle, rotation, x, y) {

  // Convert the angle between the sides from degrees to radians.
  angle = Math.degToRad(angle);

  // Convert the rotation of the triangle from degrees to radians.
  rotation = Math.degToRad(rotation);

  // Calculate the coordinates of points b and c.
  var bx = Math.cos(angle - rotation) * ab;
  var by = Math.sin(angle - rotation) * ab;
  var cx = Math.cos(-rotation) * ac;
  var cy = Math.sin(-rotation) * ac;

  // Calculate the centroid's coordinates.
  var centroidX = (cx + bx)/3 - x;
  var centroidY = (cy + by)/3 - y;

  // Move to point a, then draw line ac, then line cb, and finally ba (ab).
  this.moveTo(-centroidX, -centroidY);
  this.lineTo(cx - centroidX, cy - centroidY);
  this.lineTo(bx - centroidX, by - centroidY);
  this.lineTo(-centroidX, -centroidY);
}

MovieClip.prototype.drawRegularPolygon = function (sides, length, rotation, x, y) {

  // Convert rotation from degrees to radians
  rotation = Math.degToRad(rotation);

  // The angle formed between the segments from the polygon's center as shown in 
  // Figure 4-5. Since the total angle in the center is 360 degrees (2p radians),
  // each segment's angle is 2p divided by the number of sides.
  var angle = (2 * Math.PI) / sides;

  // Calculate the length of the radius that circumscribes the polygon (which is
  // also the distance from the center to any of the vertices).
  var radius = (length/2)/Math.sin(angle/2);

  // The starting point of the polygon is calculated using trigonometry where 
  // radius is the hypotenuse and rotation is the angle.
  var px = (Math.cos(rotation) * radius) + x;
  var py = (Math.sin(rotation) * radius) + y;

  // Move to the starting point without yet drawing a line.
  this.moveTo(px, py);

  // Draw each side. Calculate the vertex coordinates using the same trigonometric
  // ratios used to calculate px and py earlier.
  for (var i = 1; i <= sides; i++) {
    px = (Math.cos((angle * i) + rotation) * radius) + x;
    py = (Math.sin((angle * i) + rotation) * radius) + y;
    this.lineTo(px, py);
  }
}
