#initclip 50

function IceKing()
{
	//super();
}

IceKing.prototype = new DrunkMonster();

IceKing.prototype.init = function( speed, hp )
{
	super.init( speed, hp );
	this.currentMode = "wandering";
	this.nextMode = "wandering.";
	this.step = 0;	
	this.changeAt = Math.randRange(20,30);
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:5,_y:3} )
	this.blockHitArea._width = 105;
	this.blockHitArea._height = 100;
	this.blockHitArea._visible = false;
	this.item = "IceBook";
}

// Ice king is not only invinclible, but he can't react to weapons.
// only ice can beat him.
IceKing.prototype.reactToWeaponHit = function()
{
	//this.invincible=true;
	// for testing only: super.reactToWeaponHit();
}
IceKing.prototype.getInvincibleTime = function()
{
	return 8;
}

IceKing.prototype.defaultInit = function()
{
	this.init( 6,20 );
}

IceKing.prototype.getBlockHitArea = function()
{
	return this.blockHitArea;
};

IceKing.prototype.isMonster = function ( )
{
	return true;
}

IceKing.prototype.update = function()
{
	// this can change vx and vy and must be called 
	// BEFORE we update.  because we might never bounce back off a block hit.
	// If I were making an engine, I would call the block hit test from
	// update so there would be no chance to sneek any velocity change
	// in between the calls.
	this.moveOrFire();
	super.update();
	this.doItemHitTests();
}

IceKing.prototype.moveOrFire = function()
{
	if ( this.step >= this.changeAt )
	{
		trace( "old mode" + this.currentMode );
		trace( "new mode" + this.nextMode );
		this.currentMode = this.nextMode;
		switch ( this.currentMode )
		{
			case "wandering" :
			{
				this.cleanUp();
				this.play();
				// no break.  Fall through.
			}
			case "wandering." :
			case "wandering.." :
			case "wandering..." :
			{
				// choose a direction
				this.chooseDirection();
				// reset changeAt clock
				this.changeAt = Math.randRange(20,30);
				if ( this.currentMode == "wandering..." )
					this.nextMode = "charging";
				else
					this.nextMode=this.currentMode + ".";
				break;
			}
			case "charging" :
			{
				this.vy = this.vx = 0;
				this.gotoAndStop(1);
				this.changeAt = 8;
				this.nextMode = "sliding";
				break;
			}
			case "sliding" :
			{
				this.speed=15;
				this.aimTowards( _root.board.hero, 1, 0, 0 );
				this.directionToVelocity();
				this.changeAt = 90; // slide until you hit a wall.
				break;
			}
		}
		this.step = 0;
	}
}

IceKing.prototype.reactToBlockHit = function( theBlock )
{
	super.reactToBlockHit(theBlock);
	trace("block hit currentMode: " + this.currentMode + ".");
	if ( this.currentMode == "sliding" )
	{
		trace( "vel " + this.vx + " " + this.vy );
		_root.board._x -= (this.vx/2);
		_root.board._y -= (this.vy/2);
		this.vx = this.vy = 0;
		MapMaster.setEarthQuake(true);
		this.currentMode = "shaking";
		this.nextMode = "wandering";
		this.step = 0;
		this.changeAt = 20;
		stun();
		mapMaster_addItem( "Ice", "", Math.randRange(40,520), Math.randRange(40,320), -1, -1, BLOCK_LAYER );
		mapMaster_addItem( "Ice", "", Math.randRange(40,520), Math.randRange(40,320), -1, -1, BLOCK_LAYER );
		mapMaster_addItem( "Ice", "", Math.randRange(40,520), Math.randRange(40,320), -1, -1, BLOCK_LAYER );
	}
}

IceKing.prototype.doItemHitTests = function() 
{
	for ( var j = 0; j < itemList.length; j++ )
	{
		if ( itemList[j].hitTest( this.blockHitArea ) )
		{
			trace( "iceking hit item " + itemList[j] );
			if ( itemList[j].realName == "Ice" )
				itemList[j].smash();
		}
		//trace( "all hit tests: " + typeof _root.board[j] + " " + _root.board[j]._target + " " + _root.board[j]._name + " " + _root.board[j]._droptarget );
	}
}

IceKing.prototype.monsterDie = function()
{
	super.monsterDie();
	this.cleanUp();
}

IceKing.prototype.cleanUp = function()
{
	MapMaster.setEarthQuake(false);
	_root.board._x =0;
	_root.board._y =0;
	this.speed=6;
	removeStun();
}

IceKing.prototype.monsterDie = function()
{
	SaveMaster.complete( "iceking" );
	// rewrite: could be cooler if use: activeList_beatAllMonsters.
	activeList_removeBlock(_root.board.destroyWall);
	activeList_removeBlock(_root.board.sealIn);
	_root.board.destroyWall.removeMovieClip();
	_root.board.sealIn.removeMovieClip();
	super.monsterDie();
};

Object.registerClass("IceKing", IceKing);

#endinitclip
