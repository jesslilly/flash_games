#initclip 50

//#include "com/sparkyland/adventure/SlideMon.as"
#include "com/sparkyland/adventure/drunkmonster.as"

function SlideMon() 
{
	super();
	//this.runStep = 0;
	this.changeAt = Math.randRange(10,30);
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:0,_y:0} )
	this.blockHitArea._width = 20;
	this.blockHitArea._height = 27;
	this.blockHitArea._visible = false;
};

SlideMon.prototype = new DrunkMonster();

SlideMon.prototype.defaultInit = function()
{
	this.init( 4,5 );
};

SlideMon.prototype.getBlockHitArea = function()
{
	//trace("SlideMon.prototype.getBlockHitArea");
	return this.blockHitArea;
};
SlideMon.prototype.reactToBlockHit = function( theBlock ) 
{
	super.reactToBlockHit(theBlock);
	if ( this.vx > 0 )
	{
		if ( this.vy < 0 )
		{
			// vx + vy - : 45 degrees
			this.gotoAndStop(3);
		}
		else
		{
			// vx + vy + : 135 degrees
			this.gotoAndStop(2);
		}
	}
	else
	{
		if ( this.vy < 0 )
		{
			// vx - vy - : 315 degrees
			this.gotoAndStop(4);
		}
		else
		{
			// vx - vy + : 225 degrees
			this.gotoAndStop(1);
		}
	}
};
SlideMon.prototype.chooseDirection = function()
{
	// Randomly choose a direction.
	switch ( Math.randRange(1,4) )
	{
		case 1:
		{
			this.direction = 135;
			this.vx=this.speed;
			this.vy=this.speed;
			this.gotoAndStop(2);
			break;
		}
		case 2:
		{
			this.direction = 225;
			this.vx=-this.speed;
			this.vy=this.speed;
			this.gotoAndStop(1);
			break;
		}
		case 3:
		{
			this.direction = 315;
			this.vx=-this.speed;
			this.vy=-this.speed;
			this.gotoAndStop(4);
			break;
		}
		default:
		{
			this.direction = 45;
			this.vx=this.speed;
			this.vy=-this.speed;
			this.gotoAndStop(3);
			break;
		}
	}
};

Object.registerClass("SlideMon", SlideMon);

#endinitclip
