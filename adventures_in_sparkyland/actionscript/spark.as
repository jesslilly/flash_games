#initclip 50

//#include "com/sparkyland/adventure/Spark.as"
#include "com/sparkyland/adventure/drunkmonster.as"

function Spark() 
{
	super();
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:0,_y:0} )
	this.blockHitArea._width = 40;
	this.blockHitArea._height = 40;
	this.blockHitArea._visible = false;
}

//Spark.defaults = { speed: 3, hp: 2 };

Spark.prototype = new DrunkMonster();

Spark.prototype.defaultInit = function()
{
	this.init( 3,2 );
}

Spark.prototype.getBlockHitArea = function()
{
	//trace("Icemon2.prototype.getBlockHitArea");
	return this.blockHitArea;
};

Object.registerClass("Spark", Spark);

#endinitclip
