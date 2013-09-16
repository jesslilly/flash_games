#initclip 40

function Missle()
{
	//super();
	this.maxTurn = 25;
	this.changeAt = 1;
	this.stunFactor = 3;

	// because missles re-aim themselves during flight, it becomes
	// interesting to adjust the speed of the projectile during flight.
	// therefore the original speed is considered a maximum, and other
	// parameters are needed to describe how it changes over time.
	// notice aimError leads to a wobble effect over time (because
	// it is randomly chosen each aimTowards).
	this.maxSpeed = this.speed;
}

Missle.prototype = new Projectile();

Missle.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
}

Missle.prototype.update = function() 
{
	if ( this.target != null )
	{
		this.step--;
		if ( this.step <= 0 )
		{
			this.aimTowards(this.target, this.aimMethod, this.maxTurn, this.aimError);
			this._rotation = this.direction;
			// (could change speed here too)
			this.directionToVelocity();
			this.step = this.changeAt;
		}
		// (checkBoundaries might override the last aim, as it should)
		this.checkBoundaries();
		oldx = this._x;
		oldy = this._y;
		this._x += this.vx;
		this._y += this.vy;
	}
	this.specialUpdate();
}

Missle.prototype.reactToBlockHit = function( theBlock )
{
	// default reaction is to bounce
	// UNFINISHED: need better bounce here, like reactToBoundaries
	this.vx = -this.vx;
	this.vy = -this.vy;
	// take a step back: important to bounce all the way off the
	// boundary, or else might get stuck.
	this._x += 2 * this.vx;
	this._y += 2 * this.vy;
	theta = Math.atan2(-this.vy, this.vx);
	this.direction = convertRadians2Compass(theta);
	this._rotation = this.direction;
	// also "stun": take a little while to resume steering
	this.step = this.changeAt * this.stunFactor;
}


Object.registerClass("Missle", Missle);

#endinitclip
