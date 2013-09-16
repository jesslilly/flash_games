#initclip 40

function Caracalla() 
{
	super();
}

Caracalla.prototype = new Monster();

Caracalla.prototype.defaultInit = function()
{
	super.init( 0,10 );
	this.harmless = true;
	this.step = 0;
	//8/14/2004 this.flickering = false;
	this._x = 40;
	this._y = _root.board.hero._y;

	trace("defaultInit complete");
}

Caracalla.prototype.update = function()
{
	//trace("Caracalla upd cur frame " + this._currentframe );

	super.update();


	if ( this._currentframe < 23 && this.launchedbaby )
	{
		this.launchedbaby = false;
	}
	else if ( this._currentframe >= 23 && !this.launchedbaby )
	{
		fire = mapMaster_addActor( "CaracallaFire", "", this._x + 80, this._y + 30, -1, -1, ACTION_LAYER );
		trace("shoot fire. " + fire + (fire instanceof Projectile) );
		fire.aimMethod = 1;
		fire.speed = (18 - this.hp);
		fire.invincible = true;
		fire.doBlockHitTests = function () {};
		fire.reactToBoundaries = function()
		{
			if ( this._x > 500 )
			{
				// right side bounce.
				this.vx = -this.vx;
				this.direction = 270;
				this._rotation = this.direction;
			}
			else
			{
				// left side remove.
				activeList_removeActor( this );
				this.removeMovieClip();
			}
		};
		fire.launch(_root.board.hero);
		this.launchedbaby = true;
	}

	if ( ! this.isInvincible() )
	{
		this.checkForFireHits();
		this._y = _root.board.hero._y - 20;
	}
}

Caracalla.prototype.checkForFireHits = function()
{
	trace("checkForFireHits" );
	for ( var j = 0; j < actorList.length; j++ )
	{
		if ( actorList[j] instanceof Projectile )
		{
			if ( actorList[j].hitTest( this ) )
			{
				this.loseHP(1);
			}
		}
	}
}

// Caracalla is invincible for longer than most enemies.
Caracalla.prototype.getInvincibleTime = function()
{
	return 16;
}

Caracalla.prototype.monsterDie = function()
{
	SaveMaster.complete( "caracalla" );
	_root.board.destroyWall.removeMovieClip();
	_root.board.sealIn.removeMovieClip();
};

Object.registerClass("CaracallaFire", Projectile);
Object.registerClass("Caracalla", Caracalla);

#endinitclip
