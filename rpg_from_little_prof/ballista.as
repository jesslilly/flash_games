#initclip 50

//#include "Ballista.as"
#include "drunkmonster.as"

function Ballista() 
{
	super();
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:1,_y:1} )
	this.blockHitArea._width = 38;
	this.blockHitArea._height = 38;
	this.blockHitArea._visible = false;
};

Ballista.prototype = new Monster();

Ballista.prototype.defaultInit = function()
{
	this.init( 2,99 );
	this.vy=this.speed;
	this.tcogccw._visible=false;
	this.bcogccw._visible=false;
	this.harmless=true;
	this.invincible=true;
};
Ballista.prototype.getBlockHitArea = function()
{
	//trace("SlideMon.prototype.getBlockHitArea");
	return this.blockHitArea;
};
Ballista.prototype.isMonster = function ( )
{
	return false;
}
Ballista.prototype.update = function()
{
	super.update();
	if ( this.step % 50 == 0 )
	{
		this.launchSpear();
	}
};
Ballista.prototype.launchSpear = function()
{
	mapMaster_addActor( "Spear", "", this._x, this._y + 20, -1, -1, ACTION_LAYER )
	trace("shoot spear. ");
	/*
	baby.speed = 7;
	baby.invincible = true;
	baby.doBlockHitTests = function () {};
	baby.reactToBoundaries = function( side )
	{
		activeList_removeActor( this );
		this.removeMovieClip();
	};
	baby.launch(_root.board.hero);
	*/
};

Ballista.prototype.reactToBlockHit = function( theBlock ) 
{
	super.reactToBlockHit(theBlock);
	if ( this.vy < 0 )
	{
		// going up.
		this.tcogccw._visible=true;
		this.bcogccw._visible=true;
		this.tcogcw._visible=false;
		this.bcogcw._visible=false;
	}
	else
	{
		// going down.
		this.tcogccw._visible=false;
		this.bcogccw._visible=false;
		this.tcogcw._visible=true;
		this.bcogcw._visible=true;
	}
};

Object.registerClass("Ballista", Ballista);

#endinitclip
