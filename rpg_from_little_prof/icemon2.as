#initclip 50

//#include "Icemon2.as"
#include "drunkmonster.as"

function Icemon2() 
{
	super();
	//this.runStep = 0;
	this.changeAt = Math.randRange(10,30);
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:0,_y:0} )
	this.blockHitArea._width = 40;
	this.blockHitArea._height = 40;
	this.blockHitArea._visible = false;

};

Icemon2.prototype = new DrunkMonster();

Icemon2.prototype.defaultInit = function()
{
	this.init( 1,5 );
};

Icemon2.prototype.getBlockHitArea = function()
{
	//trace("Icemon2.prototype.getBlockHitArea");
	return this.blockHitArea;
};
Icemon2.prototype.reactToWeaponHit = function()
{
	this.step=0;
	this.speed = 23;
	this.running = false;
	super.chooseDirection();
	super.reactToWeaponHit();
};
Icemon2.prototype.getInvincibleTime = function()
{
	return 20;
};
Icemon2.prototype.chooseDirection = function()
{
	if ( this.running )
	{
		this.speed = 23;
		this.running = false;
	}
	else
	{
		this.speed = 3;
		this.running = true;
	}
	super.chooseDirection();
};

Object.registerClass("Icemon2", Icemon2);

#endinitclip
