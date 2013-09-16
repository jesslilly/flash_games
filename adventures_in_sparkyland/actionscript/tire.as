#initclip 50

function Tire()
{
	//super();
}

Tire.prototype = new Sprite();

Tire.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	this.canKick = true;
}

Tire.prototype.defaultInit = function()
{
	this.init( 0,1 );
}

Tire.prototype.isMonster = function ( )
{
	return false;
}

Tire.prototype.update = function()
{
	super.update();
}

Tire.prototype.kick = function()
{
	trace("kick");
	this.vx=(_root.board.hero.vx/_root.board.hero.speed*15);
	this.vy=(_root.board.hero.vy/_root.board.hero.speed*15);
	if ( this.vx != 0 || this.vy != 0 )
	{
		activeList_removeItem( this );
		activeList_addActor( this );
	}
}

Object.registerClass("Tire", Tire);

#endinitclip
