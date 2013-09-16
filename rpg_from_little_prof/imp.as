#initclip 50

//#include "Spark.as"
#include "drunkmonster.as"

function Imp() 
{
}

Imp.prototype = new DrunkMonster();

Imp.defaults = { speed: 4, hp: 2 };

Imp.prototype.defaultInit = function()
{
	this.init( 4,2 );
}

Object.registerClass("Imp", Imp);

#endinitclip
