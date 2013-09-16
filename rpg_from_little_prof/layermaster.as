
// rewrite: I wanted to make this an object, but oh well.
// I couldn't get it to work right now, so who cares.


// WANRING: If you use more than 1000 items per layer, the other layers will start to dissapear.
var terrainLayer = 1000;
var townLayer = 2000;
var actionLayer = 3000;
var skyLayer = 4000;
var displayLayer = 5000;
var soundLayer = 6000;

var TERRAIN_LAYER = 1;
var TOWN_LAYER = 2;
var ACTION_LAYER = 3;
var SKY_LAYER = 4;
var DISPLAY_LAYER = 5;
var SOUND_LAYER = 6;

var ACTION_LAYER = 7;

function layerMaster_reset()
{
	terrainLayer = 1000;
	townLayer = 2000;
	actionLayer = 3000;
	skyLayer = 4000;
	//soundLayer = 6000;  The sounds never get reset.
}

function layerMaster_use( whichLayer )
{
	var layer = 0;
	switch ( whichLayer )
	{
		case TERRAIN_LAYER :
		{
			layer = terrainLayer++;
			break;
		}
		case TOWN_LAYER :
		{
			layer = townLayer++;
			break;
		}
		case ACTION_LAYER :
		{
			layer = actionLayer++;
			break;
		}
		case SKY_LAYER :
		{
			layer = skyLayer++;
			break;
		}
		case DISPLAY_LAYER :
		{
			layer = displayLayer++;
			break;
		}
		case SOUND_LAYER :
		{
			layer = soundLayer++;
			break;
		}
	}
	//trace( whichLayer + " layer " + layer );
	return layer;
}
