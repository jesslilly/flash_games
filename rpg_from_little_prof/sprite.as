#initclip 10

#include "Math.as"

function Sprite() 
{
}

Sprite.prototype = new MovieClip();

Sprite.prototype.init = function( speed )
{
	this.speed = speed;
	this.vx = 0;
	this.vy = 0;
	this.step = 0;
	this.direction = 0;
	trace( "new sprite speed:" + this.speed );
}

Sprite.prototype.stopMoving = function()
{
	trace ( "Player stop Moving." );
	this.vx = this.vy = 0;
}

Sprite.prototype.update = function() 
{
	this.step++;
	this.updateLocation();
	//this.checkBoundaries();
	this.specialUpdate();
	//trace("sprite.update");
}

Sprite.prototype.updateLocation = function() 
{
	this._x += this.vx;
	this._y += this.vy;
}

Sprite.prototype.doBlockHitTests = function() 
{

	for ( var j = 0; j < blockList.length; j++ )
	{
		if ( blockList[j].hitTest( this.getBlockHitArea() ) )
		{
			this.reactToBlockHit( blockList[j] );
		}
		//trace( "all hit tests: " + typeof _root.board[j] + " " + _root.board[j]._target + " " + _root.board[j]._name + " " + _root.board[j]._droptarget );
	}
}

Sprite.prototype.getBlockHitArea = function()
{
	return this;
}

Sprite.prototype.reactToBlockHit = function( theBlock ) 
{
	// step back off of the block.
	this._x -= this.vx;
	this._y -= this.vy;
	// default reaction is to bounce.
	this.vx = -this.vx;
	this.vy = -this.vy;
}

Sprite.prototype.reactToBoundaries = function( dummy ) 
{
	this.reactToBlockHit( null );
}


/*
Sprite.prototype.checkBoundaries = function() 
{
	//trace("checkBoundaries");
	if ( this._x < _root.boundaryBox_x )
	{
		trace("hit left boundary");
		this.reactToBoundaries(_root.LEFT);
		//this._x = _root.boundaryBox_x;
		//this.vx = 0;
		return;
	}
	if ( ( this._x + this._width ) > _root.boundaryBox_width )
	{
		trace("hit right boundary");
		this.reactToBoundaries(_root.RIGHT);
		//this._x = _root.boundaryBox_width - this._width;
		//this.vx = 0;
		return;
	}
	if ( this._y < _root.boundaryBox_y )
	{
		trace("hit top boundary");
		this.reactToBoundaries(_root.UP);
		//this._y = _root.boundaryBox_y;
		//this.vy = 0;
		return;
	}
	if ( ( this._y + this._height ) > _root.boundaryBox_height )
	{
		trace("hit bottom boundary");
		this.reactToBoundaries(_root.DOWN);
		//this._y = _root.boundaryBox_height - this._height;
		//this.vy = 0;
		return;
	}
}
*/
Sprite.prototype.processKeyDown = function( keyCode )
{
	switch( KeyCode )
	{
		// I made these functions like moveUp() so they could be customized.
		case Key.UP :
			this.moveUp();
			break;
		case Key.DOWN :
			this.moveDown();
			break;
		case Key.LEFT :
			this.moveLeft();
			break;
		case Key.RIGHT :
			this.moveRight();
			break;
		case Key.SPACE :
			trace( "action" );
			this.action();
			break;
		default :
			this.stopMoving();
			break;
	}
	//trace( "processKeyDown " + keyCode + " speed " + this.speed + " vx " + this.vx + " vy " + this.vy );
}
Sprite.prototype.moveUp = function()
{
	this.vy = -this.speed;
	this.vx = 0;
	this.setDirection(0);
};
Sprite.prototype.moveDown = function()
{
	this.vy = this.speed;
	this.vx = 0;
	this.setDirection(180);
};
Sprite.prototype.moveLeft = function()
{
	this.vx = -this.speed;
	this.vy = 0;
	this.setDirection(270);
};
Sprite.prototype.moveRight = function()
{
	this.vx = this.speed;
	this.vy = 0;
	this.setDirection(90);
};
Sprite.prototype.quadDirectionToVelocity = function()
{
	switch( this.direction )
	{
		case 0 :
			this.vy = -this.speed;
			this.vx = 0;
			break;
		case 180 :
			this.vy = this.speed;
			this.vx = 0;
			break;
		case 270 :
			this.vx = -this.speed;
			this.vy = 0;
			break;
		case 90 :
			this.vx = this.speed;
			this.vy = 0;
			break;
	}
}

Sprite.prototype.setDirection = function( angle )
{
	this.direction = angle;
}

Sprite.prototype.processKeyUp = function( keyCode )
{
	switch( KeyCode )
	{
		
		// 2/27/2006 keyup does not stop us anymore.
		// landing on a space stops us.  (momentarily)
		case Key.UP :
			//trace( "droog stop" );
//			this.stop(); // stop animation.
//			if ( this.vy < 0 )
//				this.vy = 0;
			break;
		case Key.DOWN :
			//trace( "droog stop" );
//			this.stop(); // stop animation.
//			if ( this.vy > 0 )
//				this.vy = 0;
			break;
		case Key.LEFT :
			//trace( "droog stop" );
//			this.stop(); // stop animation.
//			if ( this.vx < 0 )
//				this.vx = 0;
			break;
		case Key.RIGHT :
			//trace( "droog stop" );
//			this.stop(); // stop animation.
//			if ( this.vx > 0 )
//				this.vx = 0;
			break;
		case Key.SPACE :
			this.stopAttack();
			break;
		default :
			trace( "pause" );
			_root.togglePause();
			break;
	}
}

Sprite.prototype.action = function()
{
	// defined in sub classes.
	;
}
Sprite.prototype.stopAttack = function()
{
	// defined in sub classes.
	;
}
Sprite.prototype.specialUpdate = function()
{
	// defined in sub classes.
	;
}

Sprite.prototype.hasVelocity = function()
{
	return ( this.vx != 0 || this.vy != 0 );
}

Sprite.prototype.quadFlee = function()
{
	trace("quadFlee");
	// go away from the hero.
	switch ( Math.randRange(1,2) )
	{
		case 1:
			trace("use X ccords.");
			if ( this._x > _root.board.hero._x )
			{
				this.processKeyDown(Key.RIGHT);
			}
			else
			{
				this.processKeyDown(Key.LEFT);
			}
			break;
		default:
			trace("use Y coords.");
			if ( this._y > _root.board.hero._y )
			{
				this.processKeyDown(Key.DOWN);
			}
			else
			{
				this.processKeyDown(Key.UP);
			}
			break;
	}
}

Object.registerClass("Sprite", Sprite);

#endinitclip
