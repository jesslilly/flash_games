#initclip 40

#include "Math.as"

function Spear()
{
/*
	super();
	this.speed = 15;
	this.aimError = 20;
*/
};

Spear.prototype = new Projectile();

/*
Spear.prototype.reactToBlockHit = function( theBlock )
{
	// "drop" to the ground
	// slight bounce back: looks cool, and stops the block test from
	// repeating
	this._x -= 2 * this.vx;
	this._y -= 2 * this.vy;
	this.vx = 0;
	this.vy = 0;
	this._xscale = 66;
	this._yscale = 66;
	this.harmless = true;
	this.swapDepths(layerMaster_use(BLOCK_LAYER));
}

Spear.prototype.reactToPlayerHit = function()
{
	this.reactToBlockHit( null );
}*/
Spear.prototype.update = function()
{
	super.update();
	//trace("spearupd. vx "+this.vx+" sp " + this.speed);
	if (this._x > 650)
		this.remove();
};

Spear.prototype.doBlockHitTests = function() {};

Spear.prototype.reactToBoundaries = function() {};

Spear.prototype.remove = function()
{
	activeList_removeActor( this );
	this.removeMovieClip();
}

Spear.prototype.defaultInit = function()
{
	super.init(10,1);
	this.aimMethod=1;
	this.vx=this.speed;
	this.item = "";
}

Object.registerClass("Spear", Spear);

#endinitclip
