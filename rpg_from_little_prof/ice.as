#initclip 50

function Ice()
{
	//super();
}

Ice.prototype = new Sprite();

Ice.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	this.canKick = true;
}

Ice.prototype.defaultInit = function()
{
	this.init( 0,1 );
}

Ice.prototype.isMonster = function ( )
{
	return false;
}

Ice.prototype.update = function() {}

Ice.prototype.normalUpdate = function()
{
	super.update();
	this.checkForWeaponHits();
}

Ice.prototype.removeUpate = function()
{
	super.update();
	trace ("ice removeUpdate");
	if ( this._currentframe >= 5 )
	{
		activeList_removeActor( this );
		this.removeMovieClip();
	}
}

Ice.prototype.checkForWeaponHits = function()
{
	// We need to go through the actor list backwards.
	// Because, if we have 2 slimes, and they are just sitting on top of each other.
	// actorList[0] = slime1;
	// actorList[1] = slime2;
	// We hit slime1, he dies, the actorList shinks and we do not check slime2 not only
	// because slime2 has moved to index 0, but because we have now reached the length.
	// Using a constant length in the for loop does not solve the fact that slime2 has moved.
	// So, we go through the list backwards!
	//dupe code in wandfire!
	for ( var j = actorList.length - 1; j >= 0; j-- )
	{
		//trace("Check actorList: #" + j + " of " + aSize + ":" + actorList[j]._name );
		if ( actorList[j] instanceof Monster && !actorList[j].isInvincible() )
		{
			if ( actorList[j].hitTest( this ) )
			{
				//trace("We hit monster: #" + j + ": " + actorList[j]._name + "?" );
				actorList[j].loseHP(3);
				this.reactToBlockHit();
			}
		}
	}
}
Ice.prototype.kick = function()
{
	trace("kick");
	this.vx=(_root.board.hero.vx * 1.4);
	this.vy=(_root.board.hero.vy * 1.4);
	if ( this.vx != 0 || this.vy != 0 )
	{
		activeList_removeItem( this );
		this.update = this.normalUpdate;
		activeList_addActor( this );
	}
}

Ice.prototype.reactToBlockHit = function( theBlock )
{
	this.gotoAndPlay(2);
	this.vx = this.vx / 7;
	this.vy = this.vy / 7;
	this.update = this.removeUpate;
	this.reactToBlockHit = function() {};
}

Ice.prototype.smash = function()
{
	this.reactToBlockHit();
	activeList_removeItem( this );
	activeList_addActor( this );
}

Object.registerClass("Ice", Ice);

#endinitclip
