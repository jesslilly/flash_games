#initclip 40

function Bulb() 
{
	this.launchedbaby = false;
}

Bulb.prototype = new Monster();

Bulb.prototype.update = function() 
{
	super.update();

	if ( this._currentframe < 27 && this.launchedbaby )
	{
		this.launchedbaby = false;
	}
	else if ( this._currentframe >= 27 && !this.launchedbaby )
	{

		baby = mapMaster_addActor( "Pollen", "", this._x + 15, this._y, -1, -1, ACTION_LAYER )
		baby.aimMethod = 3;
		baby.doBlockHitTests = function () {};
		baby.launch(_root.board.hero);

		baby = mapMaster_addActor( "Pollen", "", this._x + 15, this._y + 40, -1, -1, ACTION_LAYER )
		baby.doBlockHitTests = function () {};
		baby._rotation = Math.randRange(1,360);
		baby.direction = baby._rotation;
		baby.directionToVelocity();

		this.launchedbaby = true;
	}
}

Bulb.prototype.defaultInit = function()
{
	this.init( 0,8 );
}


Object.registerClass("Bulb", Bulb);
Object.registerClass("Pollen", Projectile);

#endinitclip
