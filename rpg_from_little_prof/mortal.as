#initclip 20

function Mortal() 
{
}

Mortal.prototype = new Sprite();

Mortal.prototype.init = function( speed, hp )
{
	super.init( speed );
	this.hp = hp;
	this.flickering = false;
	this.flickerCountDown = -1;
	this.invincible = false;
}

Mortal.prototype.loseHP = function( damage )
{
	this.hp -= damage;
	trace( this._name + ".hp = " + this.hp );
	if ( this.hp <= 0 )
	{
		this.die();
	}
	else
	{
		this.reactToDamage();
	}
}

Mortal.prototype.isInvincible = function ( )
{
	//trace( this + " invinc " + this.invincible + " flik " + this.flickering );
	if ( this.invincible == undefined )
	{
		return true;
	}
	else
	{
		return (this.flickering || this.invincible);
	}
}

Mortal.prototype.isMonster = function ( )
{
	//trace("---Mortal.prototype.isMonster");
	return false;
}

Mortal.prototype.startFlickering = function ( )
{
	trace( "mortal startFlickering" );
	this.flickering = true;
	this.flickerCountDown = this.getInvincibleTime();
	//this.step = 0;
}

Mortal.prototype.startFlickering2 = function ( time )
{
	trace( "mortal startFlickering2" );
	this.flickering = true;
	this.flickerCountDown = time;
	//this.step = 0;
}

Mortal.prototype.stopFlickering = function ( )
{
	this.flickerCountDown=0;
	this.flickering = false;
	//this._alpha = 100;
	this.resetColor();
}

Mortal.prototype.flicker = function ( )
{
	this.flickerCountDown--;
	switch ( this.step % 2 )
	{
		case 0 :
			//this._alpha = 20;
			this.whiteColor();
			break;
		case 1 :
			//this._alpha = 100;
			this.resetColor();
			break;
	}
}

Mortal.prototype.specialUpdate = function()
{
	if ( this.flickering )
	{
		trace( "mortal specialUpdate (flicker)" );
		this.flicker();
		if ( this.flickerCountDown <= 0 )
		{
			this.stopFlickering();
		}
	}
}

Mortal.prototype.getInvincibleTime = function()
{
	return 4;
}

Mortal.prototype.resetColor = function()
{
	//trace("resetColor");
	colorObj = new Color(this);
	colorObj.setTransform( resetTransform );
}

Mortal.prototype.whiteColor = function()
{
	//trace("whiteColor");
	colorObj = new Color(this);
	colorObj.setRGB(0xFFFFFF);
}

Mortal.prototype.reactToDamage = function()
{
	// flash white.
	this.startFlickering();
}

Mortal.prototype.die = function()
{
	this.monsterDie();
	activeList_removeActor( this );
	this.removeMovieClip();
}

/* Defined in sub class.
Mortal.prototype.monsterDie = function()
{
}
*/

Object.registerClass("Mortal", Mortal);

#endinitclip
