#initclip 50

function Bee()
{
	//super();
	this.speed = 4;
	this.maxTurn = 45;
	this.changeAt = 1;
	this.aimError = 10;
}

Bee.prototype = new Missle();

Bee.protoyype.init = function( speed, hp )
{
	super.init( speed, hp );
};

Bee.prototype.defaultInit = function()
{
	this.init( 4,1 );
};

Bee.prototype.isMonster = function()
{
	return true;
};

Object.registerClass("Bee", Bee);

#endinitclip
