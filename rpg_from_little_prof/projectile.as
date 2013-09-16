#initclip 30

#include "Math.as"


function Projectile()
{
	//super();
	// defaults
	this.target = null;
	this.aimMethod = 0;
	this.aimError = 0;
	this.maxTurn = 0;
	this.speed = 5;
}

Projectile.prototype = new Monster();

Projectile.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
}

Projectile.prototype.launch = function(target)
{
	this.target = target;
	trace( "launch @ " + this.target + " speed " + this.speed );

	// the default implementation of a projectile travels in a
	// constant direction at a constant speed.

	// aimTowards target (with no initial maxTurn)
	this.aimTowards(this.target, this.aimMethod, null, this.aimError);
	this._rotation = this.direction;
	trace ( "rot " + this._rotation );
	this.directionToVelocity();
}

Projectile.prototype.launchAtAngle = function(angle)
{
	trace( "launch @ " + angle + " speed " + this.speed );
	// the default implementation of a projectile travels in a
	// constant direction at a constant speed.
	this._rotation = this.direction = angle;
	this.directionToVelocity();
}

Projectile.prototype.isMonster = function ( )
{
	//trace( "---Projectile.prototype.isMonster");
	return false;
};

Projectile.prototype.reactToBlockHit = function( theBlock )
{
	// find out what side of the block we hit.
	trace( " " );
	trace( "_______block hit________" );
	trace( "this " + this._name );
	trace( "   x " + this._x );
	trace( "   y " + this._y );
	trace( "blok " + theBlock._name );
	trace( "   x " + theBlock._x );
	trace( "   y " + theBlock._y );

	// back up by the x velocity and see if we still hit the block.
	this._x -= this.vx;
	var hitInXdirection = true;

	if ( theBlock.hitTest( this ) )
	{
		trace( "still hitting in the x direction.  It must be y." );
		hitInXdirection = false;
	}
	else
	{
		trace( "no more hitting once we reverse x." );
		hitInXdirection = true;
	}
	// now put is back.
	this._x += this.vx;

	var myBumpSide = _root.RIGHT;
	if ( hitInXdirection )
	{
		if ( this._vx < 0 )
		{
			myBumpSide = _root.LEFT;
			trace( "I got hit on my LEFT side." );
		}
		else
		{
			myBumpSide = _root.RIGHT;
			trace( "I got hit on my RIGHT side." );
		}
	}
	else
	{
		if ( this._vy < 0 )
		{
			myBumpSide = _root.UP;
			trace( "I got hit on my UP side." );
		}
		else
		{
			myBumpSide = _root.DOWN;
			trace( "I got hit on my DOWN side." );
		}
	}

	
	//_root.board.createEmptyMovieClip("checker", layerMaster_use(TERRAIN_LAYER) );



	trace( "_________________________" );
	trace( " " );


/*          the old way.
	// default reaction is to bounce
	// UNFINISHED: need better bounce here, like reactToBoundaries
	// step back off of the block.
	this._x -= this.vx;
	this._y -= this.vy;

	// reverse direction.
	this.vx = -this.vx;
	this.vy = -this.vy;
	theta = Math.atan2(-this.vy, this.vx);
	this.direction = convertRadians2Compass(theta);
	this._rotation = this.direction;
*/

	// the new way.
	// now that we know the side, just use the same function as
	// react to boundaries.
	this.reactToBoundaries( myBumpSide );

}

Projectile.prototype.reactToBoundaries = function( side )
{
	trace( this + " hit a boundary." );
	// bounce
	if ( side == _root.LEFT || side == _root.RIGHT )
	{
		this._x -= this.vx; //8/14/2004
		this.vx = -this.vx;
	}
	else
	{
		this._y -= this.vy; //8/14/2004
		this.vy = -this.vy;
	}
	theta = Math.atan2(-this.vy, this.vx);
	this.direction = convertRadians2Compass(theta);
	this._rotation = this.direction;
}


Object.registerClass("Projectile", Projectile);

#endinitclip
