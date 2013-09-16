
// rewrite: I wanted to make this an object, but oh well.
// I couldn't get it to work right now, so who cares.


// WANRING: If you use more than 1000 items per layer, the other layers will start to dissapear.
var bgLayer = 1000;
var blockLayer = 2000;
var actionLayer = 3000;
var skyLayer = 5000;
var soundLayer = 6000;
var USE_HP_LAYER = 7000;

var BG_LAYER = 0;
var BLOCK_LAYER = 1;
var ACTION_LAYER = 3;
var WEAPON_LAYER = 7;
var HERO_LAYER = 4;
var SKY_LAYER = 5;
var SOUND_LAYER = 6;

function layerMaster_reset()
{
	bgLayer = 1000;
	blockLayer = 2000;
	actionLayer = 3000;
	skyLayer = 5000;
	//soundLayer = 6000;  The sounds never get reset.
}

function layerMaster_use( whichLayer )
{
	var layer = 0;
	switch ( whichLayer )
	{
		case BG_LAYER :
		{
			layer = bgLayer++;
			break;
		}
		case BLOCK_LAYER :
		{
			layer = blockLayer++;
			break;
		}
		case ACTION_LAYER :
		{
			layer = actionLayer++;
			break;
		}
		case WEAPON_LAYER :
		{
			layer = 3999;
			break;
		}
		case HERO_LAYER :
		{
			layer = 4000;
			break;
		}
		case SKY_LAYER :
		{
			layer = skyLayer++;
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
