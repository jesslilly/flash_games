#initclip 30

#include "item.as"

function Monster() 
{
}

Monster.prototype = new Mortal();

Monster.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	//trace( "new Monster" );
	this.harmless = false;
	this.item = Item_randomMonsterItem(); //"Heart";
	//trace( this.item );
}

Monster.prototype.isMonster = function ( )
{
	//trace( "---Monster.prototype.isMonster" );
	return true;
}

Monster.prototype.reactToPlayerHit = function()
{
	// defined in sub classes.
	;
}

Monster.prototype.reactToWeaponHit = function()
{
	this.loseHP( _root.board.weapon.damage );
}

Monster.prototype.specialUpdate = function()
{
	super.specialUpdate();
}

// kjv: changed Mortal to Monster
// jml: 8/14/2004 I like KJV.  It's like King James Version.
//Mortal.prototype.monsterDie = function()
Monster.prototype.monsterDie = function()
{
	_root.blast2Sound.start();
	this.dropItem();
}

// kjv: changed Mortal to Monster
//Mortal.prototype.dropItem = function()
Monster.prototype.dropItem = function()
{
	// new code:
	var itemMC = mapMaster_addItem( this.item, "", this._x, this._y, -1, -1, ACTION_LAYER );
	/* old code:
	var layer = layerMaster_use(ACTION_LAYER);
	_root.board.attachMovie(this.item, this.item + layer, layer, {_x:this._x, _y:this._y} );
	*/
}

Monster.prototype.chooseDirection = function()
{
	// Randomly choose a direction.
	var newDirection = Math.randRange(1,4);
	var newKeyCode = Key.UP;
	switch ( newDirection )
	{
		case 1:
		{
			newKeyCode = Key.DOWN;	
			break;
		}
		case 2:
		{
			newKeyCode = Key.LEFT;
			break;
		}
		case 3:
		{
			newKeyCode = Key.RIGHT;
			break;
		}
	}
	this.processKeyDown( newKeyCode );
}

Monster.prototype.aimTowards = function( target, aimMethod, maxTurn, aimError )
{
	// find aiming coordinates
	// (note: usually projectile _x and _y points are the gravitational center, and
	// other _x and _y points are the upper left corners.  make no assumptions, and
	// use the bounding box to calculate center points.)
	// (find target center point)
	targetBounds = target.getBounds(target._parent);
	targetx = targetBounds.xMin + target._width / 2;
	targety = targetBounds.yMin + target._height / 2;
	trace ("target @ " + targetx + " " + targety );
	// (find our center point)
	mebounds = this.getBounds(this._parent);
	thisx = mebounds.xMin + this._width / 2;
	thisy = mebounds.yMin + this._height / 2;
	trace( "me @ " + thisx + " " + thisy );

	if ( aimMethod == 1 )
	{
		// aimMethod 1: aim only up/down/left/right
		// aimError and maxTurn do not affect direction
		if ( Math.abs(thisy - targety) < Math.abs(thisx - targetx) )
		{
			// closer in y than in x (so aim horizontal)
			if ( thisx < targetx )
			{
				this.direction = 90;
			}
			else
			{
				this.direction = 270;
			}
		}
		else
		{
			// closer in x than in y (so aim vertical)
			if ( thisy < targety )
			{
				this.direction = 180;
			}
			else
			{
				this.direction = 0;
			}
		}
	} else if ( aimMethod == 2 ) {
	        // aimMethod 2: aim towards a projected interception point
	        // assuming target maintains constant speed and direction
		// (note: target must be a Sprite.)

	        // calculate angle between target-to-me and target-to-intercept
	        // (that is, the direction the target is heading, in radians,
	        // clockwise-relative to my line of sight)
		// (note: atan2 is useful for returning an angle based on
		// screen coordinates; it returns the angle in radians
		// counter-clockwise-relative to east, PI to -PI.)
		aS_radccwe = Math.atan2(thisy - targety, targetx - thisx);
		//aS_rad = 5 * Math.PI / 2 - aS_radccwe;
		trace("direction to target (radians CCW from east): " + aS_radccwe);
		aT_rad = Math.degToRad(target.direction);
		// theta_rad = aT_rad - (aS_rad - PI)
		// (note: -PI <= aT_rad <= PI, and aS_radccwe same thing.
		// theta might wrap.)
		theta_rad = aT_rad - 3 * Math.PI / 2 + aS_radccwe;
		trace("theta (radians CW from target's line of sight): " + theta_rad);
		// calculate angle between me-to-intercept and me-to-target
		// (that is, the angle i should travel for the intercept, in
		// radians, counter-clockwise-relative to my line of sight
		// to the target.)
		vT = Math.sqrt(target.vx * target.vx + target.vy * target.vy);
		vM = this.speed;
		alpha_rad = this.interceptAngle(vT, vM, theta_rad);
		trace("alpha (radians CCW from my line of sight) " + alpha_rad);
		// translate alpha to absolute direction
		direction_rad = Math.PI + aT_rad - theta_rad - alpha_rad;
		while ( this.direction > 360 ) { this.direction -= 360; }
		while ( this.direction < -360 ) { this.direction += 360; }
		this.direction = Math.radToDeg(direction_rad);
		trace("direction is " + this.direction);

	} else if ( aimMethod == 3 ) {
        // aimMethod 3: aim towards the target's current location.
		// (note: target must be a Sprite.)

	        // calculate angle between target-to-me and target-to-intercept
	        // (that is, the direction the target is heading, in radians,
	        // clockwise-relative to my line of sight)
		// (note: atan2 is useful for returning an angle based on
		// screen coordinates; it returns the angle in radians
		// counter-clockwise-relative to east, PI to -PI.)
		aS_radccwe = Math.atan2(thisy - targety, targetx - thisx);
		//aS_rad = 5 * Math.PI / 2 - aS_radccwe;
		trace("direction to target (radians CCW from east): " + aS_radccwe);
		aT_rad = Math.degToRad(target.direction);
		// theta_rad = aT_rad - (aS_rad - PI)
		// (note: -PI <= aT_rad <= PI, and aS_radccwe same thing.
		// theta might wrap.)
		theta_rad = aT_rad - 3 * Math.PI / 2 + aS_radccwe;
		trace("theta (radians CW from target's line of sight): " + theta_rad);
		// calculate angle between me-to-intercept and me-to-target
		// (that is, the angle i should travel for the intercept, in
		// radians, counter-clockwise-relative to my line of sight
		// to the target.)

		vT = Math.sqrt(target.vx * target.vx + target.vy * target.vy);
		vM = this.speed;
		//alpha_rad = this.interceptAngle(vT, vM, theta_rad);
		alpha_rad = 0;
		trace("alpha (radians CCW from my line of sight) " + alpha_rad);
		// translate alpha to absolute direction
		direction_rad = Math.PI + aT_rad - theta_rad - alpha_rad;
		while ( this.direction > 360 ) { this.direction -= 360; }
		while ( this.direction < -360 ) { this.direction += 360; }
		this.direction = Math.radToDeg(direction_rad);
		trace("direction is " + this.direction);
	}
	else {
		// default aimMethod: aim in any direction
		// random aimError applied (unless null)
		// maxTurn limits the turn (unless null)
		theta = Math.atan2(thisy - targety, targetx - thisx);
		trace ( "theta " + theta );
		if ( aimError != null )
		{
			error = Math.randRange(-aimError, aimError);
		}
		else
		{
			error = 0;
		}
		desiredDirection = convertRadians2Compass(theta) + error;
		trace ( "desiredDirection " + desiredDirection );
		if ( maxTurn != null && maxTurn > 0 )
		{
			this.direction = this.turnTowards(this.direction, desiredDirection, maxTurn);
		}
		else
		{
			this.direction = desiredDirection
		}
	}
}

Monster.prototype.interceptAngle = function( targetVelocity, meVelocity, theta )
{
	// theta is the direction the target is heading, in radians,
	// clockwise-relative to my line of sight
	// (note: test if theta is obtuse.  since the radians value for theta
	// might have wrapped around 2*PI, use cos() function to test: if
	// cos(theta) is negative, then theta is obtuse.)
	if ( targetVelocity > meVelocity && Math.cos(theta) < 0 )
	{
		// mathematical representation does not apply to physical situation; alpha is undefined
		// (note: could also justify returning the parallel course
		// 180 - theta, because that will get us to the finish line
		// with the least lag behind player.  but the finish line is
		// edge of the screen, which means no gain for the monster;
		// the only hope left for the chase is if the player stops
		// or changes direction, and in that case we'd better
		// head straight for the player.)
		trace("simple outrun: run towards target");
		return 0;
	}
	ratio = Math.sin(theta) * targetVelocity / meVelocity;
	if ( ratio > 1 )
	{
		// can't catch up; return alpha 90 degrees
		trace("escape to the positive theta side: return 90");
		return Math.PI / 2;
	}
	else if ( ratio < -1 )
	{
		// can't catch up; return alph 90 degrees
		trace("escape to the negative theta side: return -90");
		return Math.PI / -2;
	}
	else
	{
		return Math.asin(ratio);
	}
}

Monster.prototype.turnTowards = function( startingDirection, desiredDirection, maxTurn )
{
	// unwrap desiredDirection so it can be compared to current
	if ( desiredDirection - startingDirection > 180 )
	{
		desiredDirection -= 360;
	}
	else if ( desiredDirection - startingDirection < -180 )
	{
		desiredDirection += 360;
	}
	// turn only as far as possible
	if ( desiredDirection - startingDirection > maxTurn )
	{
		possibleDirection = startingDirection + maxTurn;
	}
	else if (desiredDirection - startingDirection < -maxTurn)
	{
		possibleDirection = startingDirection - maxTurn;
	}
	else
	{
		possibleDirection = desiredDirection;
	}
	// rewrap direction if necessary
	if ( possibleDirection < 0 )
	{
		possibleDirection += 360;
	}
	else if ( possibleDirection >= 360 )
	{
		possibleDirection -= 360;
	}
	return possibleDirection;
}

Monster.prototype.directionToVelocity = function()
{
	// find vx and vy based on direction and speed
	theta = convertCompass2Radians(this.direction);
	this.vx = Math.cos(theta) * this.speed;
	this.vy = -Math.sin(theta) * this.speed;
}


Object.registerClass("Monster", Monster);

#endinitclip
