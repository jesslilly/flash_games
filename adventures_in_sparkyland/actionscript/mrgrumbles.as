#initclip 50

//#include "com/sparkyland/adventure/MrGrumbles.as"
#include "com/sparkyland/adventure/drunkmonster.as"

function MrGrumbles() 
{
	super();
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:1,_y:1} )
	this.blockHitArea._width = 58;
	this.blockHitArea._height = 58;
	this.blockHitArea._visible = false;
	this.frozen=false;
	this.chooseDirection();
};

MrGrumbles.prototype = new Monster();

MrGrumbles.prototype.defaultInit = function()
{
	this.init( 6,7 );
};

MrGrumbles.prototype.getBlockHitArea = function()
{
	//trace("MrGrumbles.prototype.getBlockHitArea");
	return this.blockHitArea;
};

MrGrumbles.prototype.update = function() 
{
	if ( this.frozen && this.step > 20 )
		this.chooseDirection();
	super.update();
};

MrGrumbles.prototype.reactToBlockHit = function( theBlock ) 
{
	super.reactToBlockHit();
	this.chooseDirection();
};

MrGrumbles.prototype.chooseDirection = function()
{
	if ( ! this.frozen )
	{
		//freeze!
		this.flickering=false;
		this.frozenColor();
		this._alpha=60;
		this.speed = 0;
		this.stop();
		this.invincible = true;
		this.frozen = true;
		this.step=0;
		//thow a tomahawk.
		this.throwTomahawk();
	}
	else
	{
		//un-freeze
		this.resetColor();
		this._alpha=100;
		this.speed = 6;
		this.play();
		this.invincible = false;
		this.frozen = false;
	}
	super.chooseDirection();
};

MrGrumbles.prototype.throwTomahawk = function()
{
	var tom = mapMaster_add( "Tomahawk", "", this._x+30, this._y+30, -1, -1, ACTION_LAYER )
	tom.speed = 4;
	tom.launch(_root.board.hero);
	activeList_addActor( tom );
};

MrGrumbles.prototype.frozenColor = function()
{
	colorObj = new Color(this);
	colorObj.setRGB(0x99CCFF);
};

Object.registerClass("MrGrumbles", MrGrumbles);
Object.registerClass("Tomahawk", Projectile);

#endinitclip
