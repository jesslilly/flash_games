#initclip 50

function Tomahawk()
{
	//super();
	this.speed = 10;
	this.maxTurn = 5;
	this.changeAt = 2;
	this.aimError = 0;
}

Tomahawk.prototype = new Missle();

Tomahawk.prototype.reactToBlockHit = function( theBlock )
{
	// "drop" to the ground
	this.target = null;
	this.vx = 0;
	this.vy = 0;
	this._xscale = 50;
	this._yscale = 50;
	this.harmless = true;
	this.swapDepths(layerMaster_use(BLOCK_LAYER));
}

Tomahawk.prototype.reactToPlayerHit = function()
{
	this.reactToBlockHit( null );
}

Tomahawk.prototype.reactToBoundaries = function( side )
{
	this.reactToBlockHit( null );
}


Object.registerClass("Tomahawk", Tomahawk);

#endinitclip
