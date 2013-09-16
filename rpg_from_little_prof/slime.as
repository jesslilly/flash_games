#initclip 50

//#include "slime.as"
#include "drunkmonster.as"
#include "Math.as"

function Slime() 
{
}

Slime.prototype = new Monster();

Slime.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	//trace( "new slime" );

	if (this.brain == "boss")
	{
		if (_root.board.slimebabycount == null) _root.board.slimebabycount = 0;
		this.invincible = false;
		this.chooseFightingTechnique();
	}
	else if (this.brain == "smart")
	{
		this.changeAt = -1;
		this.step = 0;
		this.moveSmart();
	}
	else // drunk - pretty random.
	{
		this.changeAt = -1;
		this.step = 0;
		this.moveNormal();
	}	
}

Slime.prototype.defaultInit = function()
{
	this.init( 5,1 );
}

Slime.prototype.bossInit = function()
{
	this._height = 90;
	this._width = 90;
	this.brain = "boss";
	this.target = _root.board.hero;
	this.init( 6, 10 );
}

Slime.prototype.smartInit = function()
{
	this._height = 24;
	this._width = 24;
	this.brain = "smart";
	this.target = _root.board.hero;
	this.init( 5, 1 );
}

Slime.prototype.miniBossInit = function()
{
	this._height = 60;
	this._width = 60;
	this.brain = "smart";
	this.target = _root.board.hero;
	this.init( 6, 6 );
}

Slime.prototype.update = function() 
{
	this.step++;
	this.checkBoundaries();
	if ( this.brain == "boss" )
	{
		this.moveBoss();
	}
	else if ( this.brain == "smart" )
	{
		this.moveSmart();
	}
	else
	{
		this.moveNormal();
	}
	this._x += this.vx;
	this._y += this.vy;
	this.specialUpdate();
}

Slime.prototype.moveNormal = function()
{
	if ( this.step >= this.changeAt )
	{
		// choose a direction
		this.chooseDirection();
		// reset changeAt clock
		this.changeAt = Math.randRange(10,100);
		this.step = 0;
	}
}

Slime.prototype.moveSmart = function()
{
	if ( this.step >= this.changeAt )
	{
		// aim towards target
		// (note: aim using blocky straight aimMethod #1.)
		this.aimTowards(this.target, 1);
		this.directionToVelocity();
		// reset changeAt clock
		this.changeAt = Math.randRange(10,30);
		this.step = 0;
	}
}

Slime.prototype.moveBoss = function ()
{
	switch ( this.fightingTechnique )
	{
		case "flee" :
			this.stopFleeStep++;
			if ( this.stopFleeStep >= this.stopFleeAt )
			{
				this.speed /= 1.5;
				// choose new fighting technique
				this.chooseFightingTechnique();
			}
			else if ( this.step >= this.changeAt )
			{
				// re-aim away from target
				// (note: aim using accurate aimMethod #0, no maxturn, some error.)
				this.aimTowards(this.target, 0, null, 10);
				if ( this.direction >= 180 ) this.direction -= 180; else this.direction += 180;
				this.directionToVelocity();
				// reset changeAt clock
				this.changeAt = 10;
				this.step = 0;
			}
			break;
		case "charge" :
			this.stopChargeStep++;
			if ( this.stopChargeStep >= this.stopChargeAt )
			{
				this.invincible = false;
				this._alpha = 100;
				// choose new fighting technique
				this.chooseFightingTechnique();
			}
			else if ( this.step >= this.changeAt )
			{
				// re-aim towards target
				// (note: aim using accurate aimMethod #0, large turn radius, no error.)
				this.aimTowards(this.target, 0, 10, 0);
				this.directionToVelocity();
				// reset changeAt clock
				this.changeAt = 3;
				this.step = 0;
			}
			break;
		case "spawn" :
			if (this.step >= this.spawnAt)
			{
				babynum = _root.board.slimebabycount;
				_root.board.slimebabycount++;
				//baby = _root.board.attachMovie("Slime", "slimebaby" + babynum, layerMaster_use(ACTION_LAYER), { _x:this._x, _y:this._y, brain:"smart", target:this.target });
				baby = _root.board.attachMovie("Slime", "slimebaby" + babynum, layerMaster_use(ACTION_LAYER), { _x:this._x, _y:this._y} );
				baby.smartInit();
				activeList_addActor( baby );
				// choose new fighting technique
				this.chooseFightingTechnique();
			}
			break;
	}
}

Slime.prototype.reactToWeaponHit = function()
{
	// Now handled in player checkForWeaponHits. if ( ! this.invincible ) 
	this.loseHP(1);
}

Slime.prototype.chooseFightingTechnique = function ()
{
	i = Math.randRange(0, 2, 0);
	switch( i )
	{
		case 0 :
			this.fightingTechnique = "flee";
			this.speed *= 1.5;
			// initial aim away from target
			this.aimTowards(this.target, 0, null, 10);
			if ( this.direction >= 180 ) this.direction -= 180; else this.direction += 180;
			this.directionToVelocity();
			// reset changeAt clock (for adjusting aim)
			this.changeAt = 10;
			this.step = 0;
			// stopFleeAt clock until new fighting technique
			this.stopFleeAt = Math.randRange(30, 50, 0);
			this.stopFleeStep = 0;
			break;
		case 1 :
			this.fightingTechnique = "charge";
			this.invincible = true;
			this._alpha = 50;
			// initial aim towards target (no maxTurn)
			this.aimTowards(this.target, 0, null, 0);
			this.directionToVelocity();
			// reset changeAt clock (for adjusting aim)
			this.changeAt = 3;
			this.step = 0;
			// stopChargeAt clock until new fighting technique
			this.stopChargeAt = Math.randRange(10, 50, 0);
			this.stopChargeStep = 0;
			break;
		case 2 :
			this.fightingTechnique = "spawn";
			this.spawnAt = 10;
			this.vx = 0;
			this.vy = 0;
			this.step = 0;
			break;
	}
	trace("chose unstoppable technique " + this.fightingTechnique);
}
	
Slime.prototype.chooseDirection = function()
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

Slime.prototype.reactToBlockHit = function( theBlock )
{
	// default reaction is to bounce
	// UNFINISHED: need better bounce here, like reactToBoundaries
	/*
	this.vx = -this.vx;
	this.vy = -this.vy;
	*/
	super.reactToBlockHit( theBlock );
	theta = Math.atan2(-this.vy, this.vx);
	this.direction = convertRadians2Compass(theta);
}

Slime.prototype.reactToBoundaries = function( side )
{
	// bounce
	if ( side == _root.LEFT || side == _root.RIGHT )
	{
		this._x -= this.vx;
		this.vx = -this.vx;
	}
	else
	{
		this._y -= this.vy;
		this.vy = -this.vy;
	}
	theta = Math.atan2(-this.vy, this.vx);
	this.direction = convertRadians2Compass(theta);
}

/*
Slime.prototype.checkBoundaries = function() 
{
	//trace("checkBoundaries");
	if ( this._x < _root.boundaryBox_x )
	{
		trace("hit left boundary");
		this._x = _root.boundaryBox_x;
		this.vx = -this.vx;
	}
	if ( ( this._x + this._width ) > _root.boundaryBox_width )
	{
		trace("hit right boundary");
		this._x = _root.boundaryBox_width - this._width;
		this.vx = -this.vx;
	}
	if ( this._y < _root.boundaryBox_y )
	{
		trace("hit top boundary");
		this._y = _root.boundaryBox_y;
		this.vy = -this.vy;
	}
	if ( ( this._y + this._height ) > _root.boundaryBox_height )
	{
		trace("hit bottom boundary");
		this._y = _root.boundaryBox_height - this._height;
		this.vy = -this.vy;
	}
}
*/

/*
Slime.prototype.reactToBlockHit = function() 
{
	this.vx -= this.vx;
	this.vy -= this.vx;
}
*/
/*
Slime.prototype.processKeyDown = function( keyCode )
{
	switch( KeyCode )
	{
		case Key.UP :
			this.vy = -this.speed;
			this.vx = 0;
			this.direction = 0;
			break;
		case Key.DOWN :
			this.vy = this.speed;
			this.vx = 0;
			this.direction = 180;
			break;
		case Key.LEFT :
			this.vx = -this.speed;
			this.vy = 0;
			this.direction = 270;
			break;
		case Key.RIGHT :
			this.vx = this.speed;
			this.vy = 0;
			this.direction = 90;
			break;
		case Key.SPACE :
			trace( "attack" );
			//this._vx = 0;
			//this._vy = 0;
			this.positionWand();
			break;
	}
}
*/

Object.registerClass("Slime", Slime);

#endinitclip
