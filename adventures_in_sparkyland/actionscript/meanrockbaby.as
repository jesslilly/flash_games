#initclip 40

function MeanRockBaby()
{

}

MeanRockBaby.prototype = new Projectile();

MeanRockBaby.prototype.reactToBlockHit = function( dummy )
{
	// "drop" to the ground
	// slight bounce back: looks cool, and stops the blockhit
	//  test from repeating
	this._x -= 2 * this.vx;
	this._y -= 2 * this.vy;
	this.vx = 0;
	this.vy = 0;
	this._xscale = 75;
	this._yscale = 75;
	this.harmless = true;
	this.swapDepths(layerMaster_use(BLOCK_LAYER));
	this.stop();
}

MeanRockBaby.prototype.defaultInit = function()
{
	this.aimError = 10;
	this.speed = Math.randRange(5, 10, 0);
	super.init( this.speed,1 );
	this.item = "";
}

MeanRockBaby.prototype.reactToPlayerHit = function()
{
	this.reactToBlockHit( null );
}

MeanRockBaby.prototype.reactToBoundaries = function( side )
{
	this.reactToBlockHit( null );
}


Object.registerClass("MeanRockBaby", MeanRockBaby);

#endinitclip
