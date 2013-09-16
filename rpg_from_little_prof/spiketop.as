#initclip 40

//#include "Spark.as"
//#include "monster.as"

function SpikeTop() 
{
}

SpikeTop.prototype = new Monster();

SpikeTop.prototype.init = function( speed, hp)
{
	super.init( speed, hp);
	this.changeAt = Math.randRange(10,20);
	this.step = 0;
	this.move();
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:1,_y:1} )
	this.blockHitArea._width = 28;
	this.blockHitArea._height = 28;
	this.blockHitArea._visible = false;
	this.hat = this.attachMovie("SpikeTopHat", "hat", layerMaster_use(ACTION_LAYER) );
	this.hat._y += 5;
	this.hat._x += 15;
	this.invincible = true;
}

SpikeTop.prototype.getBlockHitArea = function()
{
	//trace("SpikeTop.prototype.getBlockHitArea");
	return this.blockHitArea;
};

SpikeTop.prototype.defaultInit = function()
{
	this.init( 4,4 );
}

SpikeTop.prototype.update = function()
{
	// this can change vx and vy and must be called 
	// BEFORE we update.  because we might never bounce back off a block hit.
	// If I were making an engine, I would call the block hit test from
	// update so there would be no chance to sneek any velocity change
	// in between the calls.
	this.moveOrFire();
	super.update();
}

SpikeTop.prototype.moveOrFire = function()
{
	if ( this.step >= this.changeAt )
	{
		if ( this.step % 2 == 0 )
		{
			// put on the hat.
			this.hat._visible = true;
			this.invincible = true;
			// choose a direction
			this.chooseDirection();
			// reset changeAt clock
			this.changeAt = Math.randRange(20,30);
		}
		else
		{
			// stop.
			this.vx = this.vy = 0;
			// remove hat.
			this.hat._visible = false;
			this.invincible = false;
			// fire hat.
			baby = mapMaster_add( "SpikeTopHat", "", this._x + 15, this._y + 11, -1, -1, ACTION_LAYER )
			trace("shoot hat. " + baby + (baby instanceof Projectile) );
			baby.aimMethod = 1;
			baby.speed = 7;
			baby.invincible = true;
			baby.doBlockHitTests = function () {};
			baby.reactToBoundaries = function( side )
			{
				activeList_removeActor( this );
				this.removeMovieClip();
			};
			/*baby.isMonster = function ()
			{
				return false;
			};*/
			baby.launch(_root.board.hero);
			activeList_addActor( baby );
			// reset changeAt clock
			this.changeAt = Math.randRange(30,40);
		}
		this.step = 0;
	}
}

SpikeTop.prototype.chooseDirection = function()
{
	this.quadFlee();
}

SpikeTop.prototype.reactToWeaponHit = function()
{
	// invincable all the time.
	super.reactToWeaponHit();
	trace("get slammed back");  // define this function in monster so others can use it too.
}

Object.registerClass("SpikeTopHat", Projectile);
Object.registerClass("SpikeTop", SpikeTop);

#endinitclip
