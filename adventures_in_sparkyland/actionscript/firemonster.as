#initclip 50

//#include "com/sparkyland/adventure/FireMonster.as"
#include "com/sparkyland/adventure/drunkmonster.as"

function FireMonster() 
{
}

FireMonster.prototype = new DrunkMonster();

FireMonster.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	//trace( "new FireMonster" );
	this.invincible = true;
	this.changeAt = 5;
}

FireMonster.prototype.isMonster = function ( )
{
	return false;
}

FireMonster.prototype.defaultInit = function()
{
	this.init( 5,1 );
}

FireMonster.prototype.update = function()
{
	super.update();
	this._height -= .3;
	this._width -= .3;

	if ( this._height <= 9 )
		this.die();
}

FireMonster.prototype.monsterDie = function()
{
	// do nothing.
	// don't drop an item, or make a sound.
	// rewrite:  Add a whiff of smoke.
}

Object.registerClass("FireMonster", FireMonster);

#endinitclip
