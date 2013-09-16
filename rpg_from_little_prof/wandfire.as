#initclip 20

function WandFire() 
{
}

WandFire.count = 0;

WandFire.reachedMax = function()
{
	return ( WandFire.count > 2 );
}

WandFire.prototype = new Sprite();

WandFire.prototype.init = function( speed )
{
	super.init( speed );
	fire.invincible = true;
	WandFire.count++;
	trace( "WandFire.count " + WandFire.count );
}

WandFire.prototype.defaultInit = function()
{
	this.init( 24 );
}

WandFire.prototype.update = function()
{
	super.update();
	this.checkForWeaponHits();
}

WandFire.prototype.checkForWeaponHits = function()
{
	// We need to go through the actor list backwards.
	// Because, if we have 2 slimes, and they are just sitting on top of each other.
	// actorList[0] = slime1;
	// actorList[1] = slime2;
	// We hit slime1, he dies, the actorList shinks and we do not check slime2 not only
	// because slime2 has moved to index 0, but because we have now reached the length.
	// Using a constant length in the for loop does not solve the fact that slime2 has moved.
	// So, we go through the list backwards!
	// dupe code in ice!
	for ( var j = actorList.length - 1; j >= 0; j-- )
	{
		//trace("Check actorList: #" + j + " of " + aSize + ":" + actorList[j]._name );
		if ( actorList[j] instanceof Monster && !actorList[j].isInvincible() )
		{
			if ( actorList[j].hitTest( this ) )
			{
				//trace("We hit monster: #" + j + ": " + actorList[j]._name + "?" );
				actorList[j].reactToWeaponHit();
			}
		}
	}
}

WandFire.prototype.reactToBlockHit = function( dummy ) 
{
	WandFire.count--;
	trace( "WandFire.count " + WandFire.count );
	activeList_removeActor( this );
	this.removeMovieClip();
}

WandFire.prototype.reactToBoundaries = function( direction ) 
{
	this.reactToBlockHit( null );
}



Object.registerClass("WandFire", WandFire);

#endinitclip
