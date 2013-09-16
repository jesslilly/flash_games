#initclip 50

function Icemon()
{
	//super();
}

Icemon.prototype = new Missle();

Icemon.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	this._width = 40;
	this._height = 30;
	this.maxTurn = 8;  // degrees
	this.changeAt = 5;
	this.aimError = 10;
	this.launch( _root.board.hero );
	this.fireStep = 0;
}

Icemon.prototype.defaultInit = function()
{
	this.init( 4,5 );
}

Icemon.prototype.isMonster = function ( )
{
	return true;
}

Icemon.prototype.update = function()
{
	super.update();
	this.fireStep++;
	this.moveOrFire();
}

Icemon.prototype.doBlockHitTests = function() {};

Icemon.prototype.moveOrFire = function()
{
	//trace("<<<<<<<<<<<<<<<<<<<" + this.fireStep );
	if ( this.fireStep >= 10 )
	{
		if ( Math.randRange(1,3) == 3 )
		{
			// stop.
			this.vx = this.vy = 0;
			this.step = 20
			// fire spikes.
			//trace("<<<<<<<<<<<<<<<<<<<Fire!!!!!!!!");
			this.gotoAndStop(11);
			var theAngle = this._rotation - 90;
			//trace("<<<<<<<<<<<<<<<<<<<Fire 1");
			for ( var idx = 0; idx < 5; idx ++)
			{
				var spike = mapMaster_add( "Icespike", "", this._x, this._y, -1, -1, ACTION_LAYER )
				spike.speed = 7;
				spike.invincible = true;
				spike.doBlockHitTests = function () {};
				spike.reactToBoundaries = function( side ) {};
				spike.update = function ()
				{
					super.update();
					if ( this.step > 15 )
					{
						activeList_removeActor( this );
						this.removeMovieClip();
					}
				};
				spike.launchAtAngle(theAngle);
				theAngle += 45;
				activeList_addActor( spike );
			}
			trace("<<<<<<<<<<<<<<<<<<<Fire 2");
		}
		else
		{
			this.gotoAndPlay(1);
		}
		this.fireStep=0;
	}
}

Object.registerClass("Icemon", Icemon);
Object.registerClass("Icespike", Projectile);

#endinitclip
