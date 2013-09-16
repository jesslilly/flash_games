#initclip 30

function Player() 
{
}

Player.prototype = new Mortal();

Player.prototype.init = function()
{
	// Player is and must be 30/50.

	super.init( 8, 6 );
//	this.flickering = false;
	this.maxHP = SaveMaster.getMaxHP(); //6;
	this.hp = this.maxHP;
	_root.updateHPDisplay( this.hp );
	this.attachMovie("Block", "blockHitArea", layerMaster_use(ACTION_LAYER), {_x:0,_y:20} )
	this.blockHitArea._width = 30;
	this.blockHitArea._height = 30;
	this.blockHitArea._visible = false;
	trace( this.blockHitArea );

	this.attachMovie("Block", "hitArea", layerMaster_use(ACTION_LAYER), {_x:0,_y:0} )
	this.hitArea._width = 30;
	this.hitArea._height = 50;
	this.hitArea._visible = false;
	trace( this.hitArea );

}

Player.prototype.incrementHP = function() 
{
	//trace( this.step );
	if ( this.hp < this.maxHP )
	{
		this.hp++;
		_root.updateHPDisplay( this.hp );
	}
}

Player.prototype.healUp = function() 
{
	//trace( this.step );
	// sound effect:  wooooop!
	mapMaster_addScenery("HealUP","", this._x - 5,this._y - 35,-1,-1,SKY_LAYER);
	this.hp = this.maxHP;
	_root.updateHPDisplay( this.hp );
}

Player.prototype.setDirection = function( angle )
{
	super.setDirection( angle );
	switch ( angle )
	{
		case 0:
		{
			//trace( "droog play up" );
			this.gotoAndPlay(37);
			break;
		}
		case 90:
		{
			//trace( "droog play right" );
			this.gotoAndPlay(1);
			break;
		}
		case 180:
		{
			//trace( "droog play down" );
			this.gotoAndPlay(25);
			break;
		}
		case 270:
		{
			//trace( "droog play left" );
			this.gotoAndPlay(13);
			break;
		}
	}
}

Player.prototype.update = function() 
{
	super.update();
};
Player.prototype.normalUpdate = Player.prototype.update;

Player.prototype.iceUpdate = function() 
{
	// instead use iceCurrentArrowKey.
	// make a var called current Arrow Key.
	switch ( _root.iceCurrentArrowKey )
	{
		case Key.UP:
			if ( this.vy > -20 )
				this.vy-=1;
			break;
		case Key.RIGHT:
			if ( this.vx < 20 )
				this.vx+=1;
			break;
		case Key.DOWN:
			if ( this.vy < 20 )
				this.vy+=1;
			break;
		case Key.LEFT:
			if ( this.vx > -20 )
				this.vx-=1;
			break;
		default :
			if ( this.vx > 0 )
			{
				this.vx-=1;
			}
			if ( this.vx < 0 )
			{
				this.vx+=1;
			}
			if ( this.vy > 0 )
			{
				this.vy-=1;
			}
			if ( this.vy < 0 )
			{
				this.vy+=1;
			}
			break;
	}
	super.update();
};

Player.prototype.bugIceUpdate = function() 
{
	switch ( _root.iceCurrentArrowKey )
	{
		case Key.UP:
			this.vy-=1;
		case Key.RIGHT:
			this.vx+=1;
			break;
		case Key.DOWN:
			this.vy+=1;
			break;
		case Key.LEFT:
			this.vx-=1;
			break;
	}
	super.update();
};

Player.prototype.processKeyUp = function( keyCode )
{
	super.processKeyUp(keyCode);
}

Player.prototype.normalProcessKeyUp = Player.prototype.processKeyUp;

Player.prototype.iceProcessKeyUp = function( keyCode )
{
	switch( KeyCode )
	{
		// since you are on ice your vx and vy do ont go to 0 
		// when you key up a arrow key.
		case Key.UP :
		case Key.DOWN :
		case Key.LEFT :
		case Key.RIGHT :
			if ( _root.iceCurrentArrowKey == keyCode )
				_root.iceCurrentArrowKey=null;
			this.stop(); // stop animation.
			break;
		default :
			// space and menu. are like normal.
			super.processKeyUp(keyCode);
			break;
	}
}

Player.prototype.processKeyDown = function( keyCode )
{
	super.processKeyDown( keyCode );
}

Player.prototype.normalProcessKeyDown = Player.prototype.processKeyDown;

Player.prototype.iceProcessKeyDown = function( keyCode )
{
	switch( KeyCode )
	{
		case Key.UP :
			this.vy-=this.speed;
			this.setDirection(0);
			_root.iceCurrentArrowKey=keyCode;
			break;
		case Key.DOWN :
			this.vy+=this.speed;
			this.setDirection(180);
			_root.iceCurrentArrowKey=keyCode;
			break;
		case Key.LEFT :
			this.vx-=this.speed;
			this.setDirection(270);
			_root.iceCurrentArrowKey=keyCode;
			break;
		case Key.RIGHT :
			this.vx+=this.speed;
			this.setDirection(90);
			_root.iceCurrentArrowKey=keyCode;
			break;
		case Key.SPACE :
			trace( "action" );
			this.action();
			break;
	}
	//trace( "processKeyDown " + keyCode + " speed " + this.speed + " vx " + this.vx + " vy " + this.vy );
}


Player.prototype.goToIceSlideMode = function() 
{
	this.speed = 2;
	//this.vx=this.vy=0;
	this.update = this.iceUpdate;
	this.processKeyUp = this.iceProcessKeyUp;
	this.processKeyDown = this.iceProcessKeyDown;
	this.reactToBlockHit = this.iceReactToBlockHit;
	_root.iceCurrentArrowKey=_root.currentKeyCode;
};

Player.prototype.goToNormalWalkMode = function() 
{
	this.update = this.normalUpdate;
	this.processKeyUp = this.normalProcessKeyUp;
	this.processKeyDown = this.normalProcessKeyDown;
	this.reactToBlockHit = this.normalReactToBlockHit;
	this.speed = 8;
	this.processKeyDown(_root.currentKeyCode);
	_root.iceCurrentArrowKey=null;
};

Player.prototype.specialUpdate = function() 
{
	//trace( this.step );
	super.specialUpdate();
	updateLocDisplay();

	if ( this.step > 2 )
		this.stopAttack();

/*
	if ( this.flickering )
	{
		this.flicker();
		if ( this.step > 20 )
		{
			this.stopFlickering();
		}
	}
	*/
}

Player.prototype.getInvincibleTime = function()
{
	return 20;
}

Player.prototype.doMonsterHitTests = function() 
{
	for ( var j = 0; j < actorList.length; j++ )
	{
		if ( actorList[j] instanceof Monster && !actorList[j].harmless )
		{
			//trace("harmless: "+ actorList[j].harmless );
			if ( actorList[j].hitTest( _root.board.hero.blockHitArea ) )
			{
				_root.board.hero.loseHP(1);
				actorList[j].reactToPlayerHit();
			}
		}
		//trace( "all hit tests: " + typeof _root.board[j] + " " + _root.board[j]._target + " " + _root.board[j]._name + " " + _root.board[j]._droptarget );
	}
}

Player.prototype.doItemHitTests = function() 
{
	for ( var j = 0; j < itemList.length; j++ )
	{
		if ( itemList[j].hitTest( _root.board.hero.hitArea ) )
		{
			_root.board.hero.takeItem( itemList[j] );
		}
		//trace( "all hit tests: " + typeof _root.board[j] + " " + _root.board[j]._target + " " + _root.board[j]._name + " " + _root.board[j]._droptarget );
	}
}

Player.prototype.takeItem = function( item ) 
{
	Item_pickUp( item );
}

Player.prototype.doBlockHitTests = function() 
{
	for ( var j = 0; j < blockList.length; j++ )
	{
		if ( blockList[j].hitTest( this.getBlockHitArea() ) )
		{
			if ( ! this.specialBlockHit( blockList[j] ) )
				this.reactToBlockHit( blockList[j] );
		}
		//trace( "all hit tests: " + typeof _root.board[j] + " " + _root.board[j]._target + " " + _root.board[j]._name + " " + _root.board[j]._droptarget );
	}
}

Player.prototype.reactToBlockHit = function( dummy ) 
{
	// step off the block.
	this._x -= this.vx;
	this._y -= this.vy;
}
Player.prototype.normalReactToBlockHit = Player.prototype.reactToBlockHit
Player.prototype.iceReactToBlockHit = function( dummy ) 
{
	// step off the block.
	this.normalReactToBlockHit();
	this.vx=this.vy=0;
}

Player.prototype.specialBlockHit = function( blockMC )
{
	trace( "Hit block " + blockMC + " warp:" + blockMC.warp );
	if ( blockMC.warp != undefined )
	{
		trace( "Warp to " + blockMC.mapName + " from: " + blockMC._name);
		if ( blockMC.newPlayerX != undefined )
		{		
			trace( "Warp loc x:" + blockMC.newPlayerX + " y:" + blockMC.newPlayerY );
			this._x = blockMC.newPlayerX;
			this._y = blockMC.newPlayerY;
		}

		mapMaster_loadScreenName( blockMC.mapName );
		return true;
	}
	if ( blockMC.lockedDoor != undefined
	&& Inventory_check("SkeletonKey") )
	{
		trace( "Unlock with a key");

		// animate the door movie clip.
		blockMC.animateDoor.gotoAndPlay(2);

		// Save that we opened the door.
		SaveMaster.complete( blockMC.saveTask );

		// remove the door block.
		activeList_removeBlock( blockMC );
		blockMC.lock.removeMovieClip();
		blockMC.removeMovieClip();

		Inventory_removeOne("SkeletonKey");

		shrinkKey = _root.board.attachMovie("SkeletonKey", "SkeletonKey", layerMaster_use(SKY_LAYER), {_x:this._x, _y:this._y } );
		shrinkKey.update = function() { this._width-=5; this._height-=5; };
		activeList_addActor( shrinkKey );
		return true;

	}
	if ( blockMC.floorTrigger != undefined )
	{
		blockMC.triggerEvent();
		return true;
	}
}

Player.prototype.reactToBoundaries = function( direction ) 
{
	this.reflectLocation( direction );
	_root.mapMaster_loadNextScreen( direction );
}

Player.prototype.reflectLocation = function( direction ) 
{
	switch ( direction )
	{
		case _root.UP :
		{
			this._y = _root.boundaryBox_height - this._height;
			break;
		}
		case _root.RIGHT :
		{
			this._x = 0;
			break;
		}
		case _root.DOWN :
		{
			this._y = 0;
			break;
		}
		case _root.LEFT :
		{
			this._x = _root.boundaryBox_width - this._width;
			break;
		}
	}
}

Player.prototype.action = function()
{
	if ( ! this.doInteractive() )
	{
		// When step is 4, weapon is auto-removed.
		// I hope this does not conflict with other uses for step.
		this.step = 0;
		this.positionWeapon();
		this.checkForWeaponHits();
	}
}
Player.prototype.stopAttack = function()
{
	_root.board.weapon._x = -100
	_root.board.weapon._y = 0
	_root.board.weapon._visible = false;
	//this.stopFlickering();
}

// rewrite: Awesome dupe code for weapons....
// ==============================================================
Player.prototype.positionWand = function()
{
	_root.wandSound.start();
	_root.board.weapon._visible = true;
	effect = mapMaster_addScenery( "Bubbles", "", 0, 0, -1, -1, ACTION_LAYER );

	switch( this.direction )
	{
		case 0 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x + 8;
			_root.board.weapon._y = this._y - this._height + 8;
			effect._x = _root.board.weapon._x;
			effect._y = _root.board.weapon._y;
			break;
		case 180 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x + 24;
			_root.board.weapon._y = this._y + this._height + _root.board.weapon._height -7;
			effect._x = _root.board.weapon._x - effect._width;
			effect._y = _root.board.weapon._y - effect._height;
			break;
		case 270 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x - _root.board.weapon._width + 7;
			_root.board.weapon._y = this._y + 40;
			effect._x = _root.board.weapon._x;
			effect._y = _root.board.weapon._y - effect._height;
			break;
		case 90 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x + this._width + _root.board.weapon._width - 8;
			_root.board.weapon._y = this._y + 18;
			effect._x = _root.board.weapon._x - effect._width;
			effect._y = _root.board.weapon._y;
			break;
	}
	if ( Inventory_check( "FireBook" ) )
		this.shootFire(this.direction);
}
Player.prototype.positionSword = function()
{
	_root.pickupSound.start();
	_root.board.weapon._visible = true;
	switch( this.direction )
	{
		case 0 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x + 8;
			_root.board.weapon._y = this._y - this._height + 8;
			break;
		case 180 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x + this._width - 10;
			_root.board.weapon._y = this._y + this._height + _root.board.weapon._height -7;
			break;
		case 270 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x - _root.board.weapon._width + 7;
			_root.board.weapon._y = this._y + this._width + 10;
			break;
		case 90 :
			_root.board.weapon._rotation = this.direction;
			_root.board.weapon._x = this._x + this._width + _root.board.weapon._width - 8;
			_root.board.weapon._y = this._y + 18;
			break;
	}
}
// ==============================================================


Player.prototype.shootFire = function( direction )
{
	if ( ! WandFire.reachedMax() )
	{
		fire = mapMaster_addActor( "WandFire", "", 0, 0, -1, -1, ACTION_LAYER );
		fire._x = this._x + 15;
		fire._y = this._y + 35;
		fire._rotation = fire.direction = direction;
		fire.quadDirectionToVelocity();
		// Move it a little out from underneath us.
		fire._x += fire.vx;
		fire._y += fire.vy;
	}
}

Player.prototype.positionWeapon = function()
{
	// assigned another function.  either wand or sword.
}

Player.prototype.equipWeapon = function( weaponName )
{
	switch( weaponName )
	{
		case "Wand" :
			this.positionWeapon = this.positionWand;
			_root.board.weapon.damage = 1;
			break;
		case "Sword" :
			this.positionWeapon = this.positionSword;
			_root.board.weapon.damage = 2;
			break;
	}
}

Player.prototype.checkForWeaponHits = function()
{
	// We need to go through the actor list backwards.
	// Because, if we have 2 slimes, and they are just sitting on top of each other.
	// actorList[0] = slime1;
	// actorList[1] = slime2;
	// We hit slime1, he dies, the actorList shinks and we do not check slime2 not only
	// because slime2 has moved to index 0, but because we have now reached the length.
	// Using a constant length in the for loop does not solve the fact that slime2 has moved.
	// So, we go through the list backwards!
	for ( var j = actorList.length - 1; j >= 0; j-- )
	{
		trace("Check actorList: #" + j + " of " + aSize + ":" + actorList[j]._name );
		if ( actorList[j] instanceof Monster && !actorList[j].invincible )
		{
			if ( actorList[j].hitTest( _root.board.weapon ) )
			{
				trace("We hit monster: #" + j + ": " + actorList[j]._name + "?" );
				actorList[j].reactToWeaponHit();
			}
		}
	}
}

Player.prototype.doInteractive = function()
{

	switch( this.direction )
	{
		// coordinates are relative to the hero.
		case 0 :
			mapMaster_addScenery( "Block", "hand", this._x, this._y + 10, 30, 10, ACTION_LAYER );
			break;
		case 180 :
			mapMaster_addScenery( "Block", "hand", this._x, this._y + 50, 30, 10, ACTION_LAYER );
			break;
		case 270 :
			mapMaster_addScenery( "Block", "hand", this._x - 10, this._y + 20, 10, 30, ACTION_LAYER );
			break;
		case 90 :
			mapMaster_addScenery( "Block", "hand", this._x + 30, this._y + 20, 10, 30, ACTION_LAYER );
			break;
	}
	//_root.board.hand._visible = false;

	trace( _root.board.hand );

	for ( var j = 0; j < blockList.length; j++ )
	{
		if ( blockList[j].interactive && blockList[j].hitTest( _root.board.hand ) )
		{
			blockList[j].interact();
			trace( "Awwwwwww yeessssss!");

			_root.board.hand.removeMovieClip();
			return true;
		}
	}
	_root.board.hand.removeMovieClip();
	return false;
}

Player.prototype.getBlockHitArea = function()
{
	return this.blockHitArea;
}

Player.prototype.reactToDamage = function()
{
	super.reactToDamage();
	_root.hit2Sound.start();
	_root.updateHPDisplay( this.hp );
	this.lowHPAlert();
}

Player.prototype.lowHPAlert = function()
{
	if ( this.hp < 2 )
	{
	}
};

Player.prototype.die = function()
{
	_root.updateHPDisplay( this.hp );
	this.flickering = false;
	this._x=300;
	this._y=180;
	_root.mapMaster_loadScreenName("heaven");
	/*
	trace("You lose.");
	_root.board.createTextField( "youLose", aedfadsf(SKY_LAYER), 300, 200, 100, 20 );
	_root.board.youLose.text = "YOU LOSE!!!";
	_root.board.youLose.textColor = 0xFF0099;
	this.removeMovieClip();
	this = null;
	*/
}

Object.registerClass("Player", Player);

#endinitclip
