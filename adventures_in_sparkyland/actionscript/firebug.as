#initclip 50

//#include "com/sparkyland/adventure/FireBug.as"
#include "com/sparkyland/adventure/drunkmonster.as"

function FireBug() 
{
}

FireBug.prototype = new DrunkMonster();

FireBug.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	//trace( "new FireBug" );
	this.changeAt = 10;
	this.releaseFire = 12;
}

FireBug.prototype.defaultInit = function()
{
	this.init( 3,8 );
}

FireBug.prototype.update = function()
{
	super.update();
	this.releaseFire++;
	if ( this.releaseFire >= 36 )
	{
		mapMaster_addActor( "FireMonster", "", this._x, this._y, -1, -1, ACTION_LAYER );
		this.releaseFire = 0;
	}
}

Object.registerClass("FireBug", FireBug);

#endinitclip
