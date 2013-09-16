#initclip 40

//#include "com/sparkyland/adventure/Spark.as"
//#include "com/sparkyland/adventure/monster.as"

function Spinner() 
{
}

Spinner.prototype = new Monster();

Spinner.prototype.init = function( speed, hp)
{
	super.init( speed, hp);
	this.changeAt = -1;
	this.step = 0;
	this.move();
	this.invincible = true;
}

/*
Spinner.prototype.reactToWeaponHit = function()
{
	// invincable all the time.
	return;
}
*/

Spinner.prototype.isMonster = function ( )
{
	return false;
}

Spinner.prototype.defaultInit = function()
{
	this.init( 14,4 );
}

Spinner.prototype.move = function()
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

Object.registerClass("Spinner", Spinner);

#endinitclip
