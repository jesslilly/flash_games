
#include "Math.as"

function DrunkMonster() 
{
}

DrunkMonster.prototype = new Monster();

DrunkMonster.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	//trace( "new DrunkMonster" );
	this.changeAt = Math.randRange(10,100);
	this.chooseDirection();
	//trace( "constructing the DrunkMonster." );
}

// 8/18/2004 this is the new way.
DrunkMonster.prototype.update = function() 
{
	if ( this.step >= this.changeAt )
	{
		this.chooseDirection();
		this.step = 0;
	}
	// You must choose your direction and possibly new speed
	// BEFORE you move.  You cannot change your speed in between
	// your location update and a possible block hit and step back.
	// you may move onto a block with speed 23 and then step off the block
	// at speed 3.  That's not enough to get you off the block...

	// changing size at this time is also a bad idea.

	// changing size at a block hit is a bad idea too.

	// therefore, it is easier to make a monster smaller than bigger.

	super.update();
}

/* 8/18/2004 This is the old way.  I hope i don't break anything.
DrunkMonster.prototype.specialUpdate = function() 
{
	super.specialUpdate();
	if ( this.step >= this.changeAt )
	{
		this.chooseDirection();
		this.step = 0;
	}
}
*/

/*
DrunkMonster.prototype.checkBoundaries = function() 
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
DrunkMonster.prototype.reactToBlockHit = function() 
{
	this.vx -= this.vx;
	this.vy -= this.vx;
}
*/
/*
DrunkMonster.prototype.processKeyDown = function( keyCode )
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

Object.registerClass("DrunkMonster", DrunkMonster);

