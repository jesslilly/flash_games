
var UP = 0;
var RIGHT = 1;
var DOWN = 2;
var LEFT = 3;

var LINE_PLAYER = 0;
var LINE_THING = 1;

var resetTransform = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0};
var whiteTransform = {ra:100,rb:255,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0};

function convertDegrees2Index( degreeDirection )
{
	// 0 -> 0, 90 -> 1, 180 -> 2, etc.
	return Math.round(degreeDirection / 90);
}

function convertCompass2Radians ( degreeDirection )
{
	// compass direction (0 is north, clockwise)
	// into radians (0 is east, counterclockwise)
	d = 90 - degreeDirection;
	return Math.degToRad(d);
}

function convertRadians2Compass ( radians )
{
	// radians (0 is east, counterclockwise)
	// into compass direction (0 is north, clockwise)
	d = 90 - Math.radToDeg(radians);
	if ( d >= 360 )
	{
		d -= 360;
	}
	else if ( d < 0 )
	{
	     	d += 360;
	}
	return d;
}


