
// rewrite: I wanted to make this an object, but oh well.
// I couldn't get it to work right now, so who cares.
// static class is starting to work.

MapMaster = function()
{
   //no instance variables.
};

var nextMap = new Array();

MapMaster.currentMap = "island7";
MapMaster.world = new Array();
MapMaster.music = "adventure1";

MapMaster.world.push(["trai01","trai02","trai03","trai04","trai05","trai06","trai07","trai08"]);
MapMaster.world.push(["snow01","snow02","snow03","snow04","snow05","snow06","snow07","snow08"]);
MapMaster.world.push(["snow09","snow10","snow11","snow12","snow13","snow14","snow15","snow16"]);
MapMaster.world.push(["snow17","snow18","snow19","snow20","snow21","snow22","snow23","snow24"]);
MapMaster.world.push(["main07","main06","main04","main03","main05","main14","main15","main16"]);
MapMaster.world.push(["main08","main09","main10","main02","main17","main18","main19","main20"]);
MapMaster.world.push(["main11","main12","main13","main01","main21","main22","main23","main24"]);
MapMaster.world.push(["town1","island1","island2","island3","grass","grass","grass","grass"]);
MapMaster.world.push(["town2","island4","island5","island6","grass","grass","grass","grass"]);
MapMaster.world.push(["town3","island7","island8","island9","grass","grass","grass","grass"]);

/*
This function will set the nextMap array.
Before, we did it like this:
	nextMap[UP]		= "island5";
Now, this function will use the world Array to set this stuff for us.
You can always use the previous notation to override the values in nextMap.
For example, you could use the nextMap[UP]		= "island5"; notation to create a 'lost woods'.
*/
MapMaster.setNextMapArray = function( screenName )
{
	nextMap[UP]		= "heaven";
	nextMap[RIGHT]	= "heaven";
	nextMap[DOWN]	= "heaven";
	nextMap[LEFT]	= "heaven";

	// Yes this is kind of dumb.  We could keep track of the current map indexes.
	// But we will look it up in the 2d array instead.  It' wont take that long.
	var curMapY = curMapX = -1;

	for (iy = 0; iy < MapMaster.world.length && curMapY == -1; iy++ )
	{
		//trace("iy"+iy);
		for (ix = 0; ix < MapMaster.world[iy].length && curMapY == -1; ix++ )
		{
			//trace("ix"+ix+" screen " + MapMaster.world[iy][ix] );
			if ( MapMaster.world[iy][ix] == screenName )
			{
				//trace("found where we are iy"+iy+"ix"+ix);
				curMapY = iy;
				curMapX = ix;
				//break; break was not breaking out of both loops, so I added another loop condition.
			}
		}
	}

	if ( curMapY >= 0 )
	{
		// We found the screenName in the world array.
		nextMap[UP]		= MapMaster.world[curMapY-1][curMapX];
		nextMap[RIGHT]	= MapMaster.world[curMapY][curMapX+1];
		nextMap[DOWN]	= MapMaster.world[curMapY+1][curMapX];
		nextMap[LEFT]	= MapMaster.world[curMapY][curMapX-1];
		trace("nextMap[UP]		= "+nextMap[UP]);
		trace("nextMap[RIGHT]	= "+nextMap[RIGHT]);
		trace("nextMap[DOWN]	= "+nextMap[DOWN]);
		trace("nextMap[LEFT]	= "+nextMap[LEFT]);
	}
	else
	{
		// We did not find the screenName in the world array.
		trace("  Warning: You must explicitly set your nextMap array for screen " + screenName + "." );
	}
};

MapMaster.playMusic = function( musicName )
{
	if ( musicName != MapMaster.music )
	{
		MapMaster.music = musicName;
		trace("Play music " + MapMaster.music );
		fscommand( "loop", MapMaster.music );
	}
};

MapMaster.setEarthQuake = function( yes )
{
	if ( yes )
		_root.fatherTime.updateEvent = MapMaster.earthQuake;
	else
		_root.fatherTime.updateEvent = null;		
}
MapMaster.earthQuake = function()
{
	var roundy = this.step % 4;
	switch ( roundy )
	{
		case 0:
			_root.board._x +=4;
			break;
		case 1:
			_root.board._x -=4;
			break;
		case 2:
			_root.board._y +=4;
			break;
		case 3:
			_root.board._y -=4;
			break;
	}
}

function mapMaster_clearScreen()
{
	trace("clear screen");
	
	for ( var j in _root.board )
	{

		if ( _root.board[j] instanceof Player
		|| _root.board[j]._name == "weapon"
		|| _root.board[j] == _root.board.panel1
		|| _root.board[j] == _root.board.panel2 )
		{
			// keep it on the screen;
		}
		else
		{
			// remove it.
			_root.board[j].removeMovieClip();
			//_root.board[j] = null;
		}
	}
	MapMaster.floorTriggerNum=0;
	layerMaster_reset();
	activeList_clearAll();
	activeList_addActor( _root.board.hero );
}

function mapMaster_loadNextScreen( nextMapIndex )
{
	//trace( "load map degree direction: " + direction );
	//var nextMapIndex = convertDegrees2Index( direction );
	trace( "load map index direction: " + nextMapIndex );
	mapMaster_loadScreenName( nextMap[ nextMapIndex ] );
}


function mapMaster_fillEdge( object, side )
{
	switch ( side )
	{
		case "left" :
		{
			mapMaster_fill( 0, 0, 0, 360, object, BLOCK_LAYER )
			break;
		}
		case "right" :
		{
			mapMaster_fill( 560, 0, 560, 360, object, BLOCK_LAYER )
			break;
		}
		case "top" :
		{
			mapMaster_fill( 0, 0, 560, 0, object, BLOCK_LAYER )
			break;
		}
		case "bottom" :
		{
			mapMaster_fill( 0, 360, 560, 360, object, BLOCK_LAYER )
			break;
		}
	}
}


function mapMaster_fill( startX, startY, endX, endY, object, layer )
{
	trace("Fill from " + startX + "," + startY + " to " + endX + "," + endY + " with " + object + ".");

	var solid = false;
	switch ( object )
	{
		case "BrennenRock" :
		case "Water" :
		case "PineTree" :
		case "BubbleWall" :
		case "Fence" :
		case "IceCube" :
		case "BrickWall" :
		case "RockWall" :
		case "Rock" :
		case "Stump" :
		case "CliffEdgeT" :
		case "Cliff" :
		case "Lava" :
		case "TowerWall" :
		case "IceWall" :
			solid = true;
			trace( object + " is a solid object.");
			break;
	}

	var objectWidth = 40;
	var objectHeight = 40;
	var blockZ;

	if ( solid )
	{
		var blockLayer = layerMaster_use(BLOCK_LAYER);
		blockZ = _root.board.attachMovie("Block", "block" + blockLayer, blockLayer );
		blockZ._x = startX;
		blockZ._y = startY;
		blockZ._width = endX - startX + objectWidth;
		blockZ._height = endY - startY + objectHeight;
		blockZ._visible = false;
		activeList_addBlock( blockZ );
	}

	for (var ix = startX; ix <= endX; ix = ix + objectWidth)
	{
		for (var iy = startY; iy <= endY; iy = iy + objectHeight)
		{
			
			var movieZ = _root.board.attachMovie( object, object + ix + iy, layerMaster_use(layer) );

			movieZ._x = ix;
			movieZ._y = iy;
			if ( object == "BubbleWall2" )
			{
				movieZ.beatAllMonsters = true;
			}
			if ( object == "FloorTrigger" )
			{
				movieZ.clickDown = MapMaster.floorTriggerNum;
			}
		}
	}
}

function mapMaster_add( object, tag, x, y, w, h, layer )
{
	var layer = layerMaster_use(layer);
	if ( tag == "" )
		tag = object + layer;
	var bizzle = _root.board.attachMovie(object, tag, layer, {_x:x, _y:y } );
	if ( h != -1 )
		bizzle._height = h;
	if ( w != -1 )
		bizzle._width = w;
	trace( "adding " + object + layer + " @ x:" + x + " y: " + y + " h:" + bizzle._height + " w: " + bizzle._width + ".");
	return bizzle;
}

function mapMaster_addActor( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	bizzle.defaultInit();
	activeList_addActor( bizzle );
	return bizzle;
}

function mapMaster_addActiveScenery( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	activeList_addScenery( bizzle );
	return bizzle;
}

function mapMaster_addScenery( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );

	if ( object == "PineTree" )
	{
		mapMaster_addBlock("Block","", x,y,40,60,BLOCK_LAYER);
	}

	return bizzle;
}

function mapMaster_addSaveItem( object, tag, x, y, w, h, layer )
{
	// very important for save Items.  The item name must be unique.  (2nd parameter)
	if ( ! SaveMaster.isComplete( tag ) )
	{
		var saveItem = mapMaster_addItem( object, tag, x, y, w, h, layer );
		saveItem.saveTask = tag;
		trace( "Adding save item " + saveItem.saveTask );
		return saveItem;
	}
	else
	{
		trace( "Dont add " + tag + ".  Already complete." );
	}
}

MapMaster.addPerson = function( object, conv, x, y, w, h, layer)
{
	dude = mapMaster_addBlock( object, object, x, y, w, h, layer );
	dude.interactive = true;
	dude.conversationName = conv;
	dude.interact = function()
	{
		var conversation = ConversationMaster.create(this.conversationName);
		conversation.converse( _root.board.hero, this );
	}
	return dude;
}

MapMaster.addFloorTrigger = function( ftx1, fty1, ftx2, fty2, dx1, dy1, dx2, dy2 )
{
	// ftx is floor trigger x
	// dx is door x
	// This function adds floor triggers, animates them and adds a door.  40x40 only.
	MapMaster.floorTriggerNum++;

	mapMaster_fill(ftx1,fty1,ftx2,fty2,"FloorTrigger",BLOCK_LAYER);
	var floorTriggerBlock1 = mapMaster_addBlock("Block","",ftx1+15,fty1+15,ftx2-ftx1+10,fty2-fty1+10,BLOCK_LAYER);
	floorTriggerBlock1.floorTrigger = true;
	floorTriggerBlock1.floorTriggerNum = MapMaster.floorTriggerNum;
	floorTriggerBlock1.triggerEvent = function()
	{
		activeList_removeBlock( this );

		for ( var mci in _root.board )
		{
			var xClip = _root.board[mci];
			//trace("  BAM: " + xClip._name );
			if ( xClip.clickDown == this.floorTriggerNum )
			{
				xClip.gotoAndPlay(2);
				//trace( "activate " + xClip._name );
			}	
		}
		mapMaster_fill(dx1,dy1,dx2,dy2,"BubbleWall2",BLOCK_LAYER);
		var doogis = mapMaster_addBlock("Block","",dx1,dy1,dx2-dx1+40,dy2-dy1+40,BLOCK_LAYER);
		doogis.removeWhenBeatAllMonsters=true;
	};

};

MapMaster.scrollClouds = function()
{
	trace("doing it");

	var cloudX;
	var startX, startY, percent;
	/*
	. . . . ... . . ...
	ooo o o  ooo o o o o
	O O OO O OO O O OO O 
	*/
	for ( var jkl=0; jkl < 60; jkl++ )
	{
		percent=Math.randRange(1,100);
		percent = percent / 100; // .50 is 50 %
		percent = percent * percent; // square it.  .5 becomes .25.  1 becomes 1.  To get more small clouds.
		trace( "     %    " + percent );
		startY=(260 * percent) + 100;
		startX=Math.randRange(-40,560);
		cloudX = mapMaster_addActiveScenery( "Cloud", "", startX, startY, -1, -1, BG_LAYER );
		cloudX._width *= percent;
		cloudX._height *= percent;
		cloudX._alpha = 100;
		cloudX.speed=(percent*4);
		cloudX._currentframe=Math.randRange(1,cloudX._totalframes)
		cloudX.update = function()
		{
			this._x+=this.speed;
			this.doEdgeHitTest();
		};
		cloudX.doEdgeHitTest = function()
		{
			if ( this._x > 600 )
			{
				this._x=-this._width;
			}
		};
	}
};

function mapMaster_addItem( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	bizzle.realName = object;
	activeList_addItem( bizzle );
	return bizzle;
}

function mapMaster_addWeapon( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, "weapon", x, y, w, h, WEAPON_LAYER );
	bizzle.realName = object;
	bizzle._visible = false;
	_root.board.hero.equipWeapon( object );
	return bizzle;
}

function mapMaster_addBlock( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	if ( object == "Block" )
		bizzle._visible = false;
	activeList_addBlock( bizzle );
	return bizzle;
}

MapMaster.addDoor = function( mc, tag, x, y, w, h, layer )
{
	if ( mc == "BrennenDoor" )
	{
		var theDoor = mapMaster_addScenery("BrennenDoor", tag, x - 10, y, -1, -1, ACTION_LAYER);
		mapMaster_addScenery( "BlackDoor", "", x, y, 40, 40, BLOCK_LAYER );
		if ( SaveMaster.isComplete( tag ) )
		{
			theDoor.gotoAndPlay(2);
		}
		else
		{
			doorBlock = mapMaster_addBlock( "Block", "", x, y, 40, 40, BLOCK_LAYER );
			doorBlock.lockedDoor = true;
			doorBlock.saveTask = tag;
			doorBlock.animateDoor = theDoor;
			//doorBlock.attachMovie("Lock", tag, layer, {_x:x, _y:y } );
			lock1 = mapMaster_addScenery("Lock", "", x + 10, y +15, -1, -1, ACTION_LAYER);
			doorBlock.lock = lock1;
		}
	}
};

MapMaster.bigTileBackground = function( tile )
{
	for ( jx = 0; jx < 600; jx += 120 )
	{
		for ( jy = 0; jy < 400; jy += 80 )
		{
			mapMaster_addScenery( tile, "", jx, jy, -1, -1, BG_LAYER );
		}
	}
};

MapMaster.islandBackground = function()
{
	if ( SaveMaster.isComplete( "SlimeBoss" ) )
		MapMaster.bigTileBackground( "Grass", "", 0, 0, -1, -1, BG_LAYER );
	else
		MapMaster.bigTileBackground( "SlimeBG", "", 0, 0, -1, -1, BG_LAYER );
};


// this only works for pictures that are 40x40.
MapMaster.addWarp = function( mc, tag, x, y, w, h, layer, newMap, warpLoc, newX, newY )
{
	theDoor = mapMaster_addScenery( mc, tag, x, y, w, h, ACTION_LAYER );
	doorWarp = mapMaster_addBlock( "Block", "", x, y, 40, 40, ACTION_LAYER );
	switch ( warpLoc )
	{
		case "left" :
		{
			doorWarp._width -= 30;
			break;
		}
		case "right" :
		{
			doorWarp._x += 30;
			doorWarp._width -= 30;
			break;
		}
		case "top" :
		{
			doorWarp._height -= 30;
			break;
		}
		case "bottom" :
		{
			doorWarp._y += 30;
			doorWarp._height -= 30;
			break;
		}
		case "center" :
		{
			doorWarp._y += 18;
			doorWarp._x += 18;
			doorWarp._height = 4;
			doorWarp._width = 4;
			break;
		}
	}
	doorWarp.warp = true;
	doorWarp.mapName = newMap;
	doorWarp.newPlayerX=newX;
	doorWarp.newPlayerY=newY;

};

/*
Well Flash is cool and all, but I found a bug in Flash MX.
This function at one time had ALL the screens in a giant switch
statement.  About 1800 lines of code and 70 case stmts.
Flash was crashing when it got to the end.  It couldn't handle it.
I am going to rewrite this code and make smaller sub reoutines
grouped by map areas.

This might turn out to be a good thing after all.
*/
function mapMaster_loadScreenName( screenName )
{
	mapMaster_clearScreen();

	var numSlimes = 4;

	WandFire.count = 0;

	trace( "mapMaster_loadScreen: " + screenName );

	updateMapDisplay( screenName );

	MapMaster.setNextMapArray(screenName);
	MapMaster.currentMap = screenName;

	switch ( screenName.substr(0,4) )
	{
		case "isla" :
			mapMaster_loadIsland( screenName );
			break;
		case "slim" :
			mapMaster_loadSlime( screenName );
			break;
		case "main" :
			mapMaster_loadMain( screenName );
			break;
		case "snow" :
			mapMaster_loadSnow( screenName );
			break;
		case "trai" :
			mapMaster_loadTrain( screenName );
			break;
		case "towe" :
			mapMaster_loadTower( screenName );
			break;
		case "icec" :
			mapMaster_loadIceCave( screenName );
			break;
		default :
			mapMaster_loadOther( screenName );
			break;
	}
}

function mapMaster_loadTower ( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advtower" );

	var intFloor = 1;

	// towe01-04 = 1, towe05-08 = 2, etc.
	intFloor = Math.ceil( ( screenName.substr(4,2)) / 4 );

	trace( "You are on the tower floor " + intFloor );

	//intFloor = 0;

	switch( intFloor )
	{
		case 1:
			FallFireShadow.dropTime = 12;
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			break;
		case 2:
			FallFireShadow.dropTime = 9;
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			break;
		case 3:
			FallFireShadow.dropTime = 6;
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			break;
		case 4:
			trace( "You are at the top of the tower" );
	}

	switch ( screenName )
	{
		case "towe01" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );

			// right side
			mapMaster_fill(560,0,560,120,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(560,240,560,360,"TowerWall",BLOCK_LAYER);

			//bottom
			mapMaster_fill(40,360,240,360,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(320,360,560,360,"TowerWall",BLOCK_LAYER);
			MapMaster.addWarp( "BlackDoor", "", 280, 360, -1, -1, ACTION_LAYER, "main07", "bottom", 168, 261 );

			//wall
			mapMaster_fill(40,160,200,160,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(200,0,200,120,"TowerWall",BLOCK_LAYER);

			MapMaster.addWarp( "StairUp", "", 80, 80, -1, -1, ACTION_LAYER, "towe05", "center", 121, 69 );

			nextMap[UP]		= "towe02";
			nextMap[RIGHT]	= "towe04";
			break;
		}
		case "towe02" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );

			//-
			mapMaster_fill(200,240,200,360,"TowerWall",BLOCK_LAYER);
			//|
			mapMaster_fill(240,240,560,240,"TowerWall",BLOCK_LAYER);

			mapMaster_addActor( "FireBug", "", 100, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireBug", "", 320, 120, -1, -1, ACTION_LAYER );

			//corner
			mapMaster_fill(560,360,560,360,"TowerWall",BLOCK_LAYER);

			nextMap[DOWN]	= "towe01";
			nextMap[RIGHT]	= "towe03";
			break;
		}
		case "towe03" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );

			//-
			mapMaster_fill(0,240,120,240,"TowerWall",BLOCK_LAYER);
			//|
			mapMaster_fill(120,280,120,360,"TowerWall",BLOCK_LAYER);

			mapMaster_addActor( "FireBug", "", 400, 160, -1, -1, ACTION_LAYER );

			//corner
			mapMaster_fill(0,360,0,360,"TowerWall",BLOCK_LAYER);

			nextMap[DOWN]	= "towe04";
			nextMap[LEFT]	= "towe02";
			break;
		}
		case "towe04" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );
			//left
			mapMaster_fill(0,0,0,120,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(0,240,0,360,"TowerWall",BLOCK_LAYER);

			// |
			mapMaster_fill(120,0,120,120,"TowerWall",BLOCK_LAYER);
			//-
			mapMaster_fill(40,120,80,120,"TowerWall",BLOCK_LAYER);

			MapMaster.addWarp( "StairUp", "", 80, 80, -1, -1, ACTION_LAYER, "towe08", "center", 121, 69 );

			mapMaster_addActor( "FireMonster", "", 160, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireMonster", "", 160, 260, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireMonster", "", 280, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireMonster", "", 440, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireMonster", "", 280, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireMonster", "", 60, 280, -1, -1, ACTION_LAYER );

			nextMap[UP]		= "towe03";
			nextMap[LEFT]	= "towe01";
			break;
		}
		case "towe05" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );

			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );
			//top
			mapMaster_fill(360,0,560,0,"TowerWall",BLOCK_LAYER);

			//-
			mapMaster_fill(40,0,120,0,"TowerWall",BLOCK_LAYER);
			//|
			mapMaster_fill(160,0,160,320,"TowerWall",BLOCK_LAYER);

			MapMaster.addWarp( "StairDown", "", 80, 80, -1, -1, ACTION_LAYER, "towe01", "center", 41, 69 );

			MapMaster.addWarp( "StairUp", "", 80, 280, -1, -1, ACTION_LAYER, "towe09", "center", 121, 269 );

			mapMaster_addActor( "FireBug", "", 320, 160, -1, -1, ACTION_LAYER );

			nextMap[UP]		= "towe06";
			nextMap[RIGHT]	= "towe08";
			break;
		}
		case "towe06" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			MapMaster.addWarp( "StairUp", "", 80, 80, -1, -1, ACTION_LAYER, "towe10", "center", 121, 69 );
			//-
			mapMaster_fill(40,120,560,120,"TowerWall",BLOCK_LAYER);
			//-
			mapMaster_fill(40,360,160,360,"TowerWall",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );
			//bottom
			mapMaster_fill(360,360,560,360,"TowerWall",BLOCK_LAYER);

			var raz;
			for ( index = 0; index < 5; index++ )
			{
				raz = mapMaster_addActor( "FireMonster", "", 360, (40 * index + 160), -1, -1, ACTION_LAYER );
				raz.vx = raz.vy = raz.speed = 0;
			}
			mapMaster_addActor( "FireBug", "", 240, 200, -1, -1, ACTION_LAYER );

			nextMap[DOWN]	= "towe05";
			nextMap[RIGHT]	= "towe07";
			break;
		}
		case "towe07" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );
			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );

			//-
			mapMaster_fill(0,120,320,120,"TowerWall",BLOCK_LAYER);
			//-
			mapMaster_fill(440,120,520,120,"TowerWall",BLOCK_LAYER);

			var raz;
			for ( index = 0; index < 5; index++ )
			{
				raz = mapMaster_addActor( "FireMonster", "", 280, (40 * index + 160), -1, -1, ACTION_LAYER );
				raz.vx = raz.vy = raz.speed = 0;
			}
			mapMaster_addActor( "FireBug", "", 220, 220, -1, -1, ACTION_LAYER );

			nextMap[DOWN]	= "towe08";
			nextMap[LEFT]	= "towe06";
			break;
		}
		case "towe08" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//top
			mapMaster_fillEdge( "TowerWall", "top" );
			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );

			var raz = mapMaster_addActor( "FireBug", "", 500, 240, -1, -1, ACTION_LAYER );
			raz.item = "Potion";

			MapMaster.addWarp( "StairDown", "", 80, 80, -1, -1, ACTION_LAYER, "towe04", "center", 41, 69 );

			nextMap[UP]		= "towe07";
			nextMap[LEFT]	= "towe05";
			break;
		}
		case "towe09" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );

			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );

			// -
			mapMaster_fill(40,200,160,200,"TowerWall",BLOCK_LAYER);
			//  |
			mapMaster_fill(200,200,200,320,"TowerWall",BLOCK_LAYER);
			
			mapMaster_addSaveItem( "SkeletonKey", "towerKey2", 160, 280, -1, -1, ACTION_LAYER );

			var raz;
			raz = mapMaster_addActor( "FireMonster", "", 240, 200, -1, -1, ACTION_LAYER );
			raz.vx = raz.vy = raz.speed = 0;
			raz = mapMaster_addActor( "FireMonster", "", 280, 200, -1, -1, ACTION_LAYER );
			raz.vx = raz.vy = raz.speed = 0;

			//-
			mapMaster_fill(320,200,480,200,"TowerWall",BLOCK_LAYER);
			//||
			mapMaster_fill(520,0,560,200,"TowerWall",BLOCK_LAYER);

			MapMaster.addWarp( "StairDown", "", 80, 280, -1, -1, ACTION_LAYER, "towe05", "center", 41, 269 );

			nextMap[UP]		= "towe10";
			nextMap[RIGHT]	= "towe12";
			break;
		}
		case "towe10" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			MapMaster.addWarp( "StairDown", "", 80, 80, -1, -1, ACTION_LAYER, "towe06", "center", 41, 69 );

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );

			mapMaster_addActor( "SpikeTop", "", 280, 200, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 400, 200, -1, -1, ACTION_LAYER )

			//||
			mapMaster_fill(520,40,560,360,"TowerWall",BLOCK_LAYER);

			nextMap[DOWN]	= "towe09";
			nextMap[RIGHT]	= "towe11";
			break;
		}
		case "towe11" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );

			//|| left
			mapMaster_fill(0,40,40,360,"TowerWall",BLOCK_LAYER);

			// bottom
			mapMaster_fill(80,360,320,360,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(400,360,520,360,"TowerWall",BLOCK_LAYER);

			MapMaster.addWarp( "StairUp", "", 120, 80, -1, -1, ACTION_LAYER, "towe15", "center", 161, 69 );

			mapMaster_addActor( "FireBug", "", 240, 190, -1, -1, ACTION_LAYER );

			nextMap[DOWN]	= "towe12";
			nextMap[LEFT]	= "towe10";
			break;
		}
		case "towe12" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );
			//|| left
			mapMaster_fill(0,0,40,200,"TowerWall",BLOCK_LAYER);

			// top
			mapMaster_fill(80,0,320,0,"TowerWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "towerDoor2", 360, 0, -1, -1, ACTION_LAYER);
			mapMaster_fill(400,0,520,0,"TowerWall",BLOCK_LAYER);

			mapMaster_addActor( "FireBug", "", 300, 190, -1, -1, ACTION_LAYER );

			nextMap[UP]		= "towe11";
			nextMap[LEFT]	= "towe09";
			break;
		}
		case "towe13" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );

			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );
			//left
			mapMaster_fill(560,0,560,160,"TowerWall",BLOCK_LAYER);

			// top
			mapMaster_fill(0,0,240,0,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"TowerWall",BLOCK_LAYER);

			// lava
			mapMaster_fill(40,40,160,320,"Lava",BLOCK_LAYER);
			mapMaster_addScenery("LavaGlow","", 30,30,180,340,BLOCK_LAYER);

			//mapMaster_addScenery("LavaGlow","", 0,0,600,400,SKY_LAYER);

			if ( ! SaveMaster.isComplete( "caracalla" ) )
			{
				//2/16/2006
				MapMaster.playMusic( "advboss" );

				mapMaster_addBlock( "TowerWall", "destroyWall", 280, 0, -1, -1, BLOCK_LAYER );
				_root.board.destroyWall.attachMovie("TowerWall", "dw2", layerMaster_use(BLOCK_LAYER), {_x:40, _y:0 } );

				caracalla1 = MapMaster.addPerson("Caracalla","c24", 240, 160,-1,-1,ACTION_LAYER);
				caracalla1.stop();
			}

			nextMap[UP]		= "towe14";
			nextMap[RIGHT]	= "towe16";
			break;
		}
		case "towe14" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "TowerWall", "left" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );
			//right
			mapMaster_fillEdge( "TowerWall", "right" );

			// bottom
			mapMaster_fill(0,360,240,360,"TowerWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"TowerWall",BLOCK_LAYER);

			// lava
			//----
			mapMaster_fill(40,40,520,80,"Lava",BLOCK_LAYER);
			//|  |
			mapMaster_fill(40,120,80,240,"Lava",BLOCK_LAYER);
			mapMaster_fill(480,120,520,240,"Lava",BLOCK_LAYER);
			//-  -
			mapMaster_fill(40,280,240,320,"Lava",BLOCK_LAYER);
			mapMaster_fill(360,280,520,320,"Lava",BLOCK_LAYER);

			mapMaster_addScenery( "Pedastal","", 300,160,-1,-1,BLOCK_LAYER);
			mapMaster_addSaveItem( "FireBook", "fireBook", 300, 140, -1, -1, ACTION_LAYER );

			mapMaster_addScenery("LavaGlow","", 0,0,600,400,SKY_LAYER);

			nextMap[DOWN]	= "towe13";
			nextMap[RIGHT]	= "towe15";
			break;
		}
		case "towe15" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//top
			mapMaster_fillEdge( "TowerWall", "top" );
			//left
			mapMaster_fillEdge( "TowerWall", "left" );

			MapMaster.addWarp( "StairDown", "", 120, 80, -1, -1, ACTION_LAYER, "towe11", "center", 81, 69 );
			//bottom
			mapMaster_fill(120,360,520,360,"TowerWall",BLOCK_LAYER);

			//-
			mapMaster_fill(40,200,400,200,"TowerWall",BLOCK_LAYER);

			mapMaster_addActor( "SpikeTop", "", 360, 80, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 480, 200, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 280, 280, -1, -1, ACTION_LAYER )


			nextMap[DOWN]	= "towe16";
			nextMap[LEFT]	= "towe14";
			break;
		}
		case "towe16" :
		{
			mapMaster_fill(0,0,560,360,"TowerFloor",BLOCK_LAYER);

			//top
			mapMaster_fill(120,0,520,0,"TowerWall",BLOCK_LAYER);
			//right
			mapMaster_fillEdge( "TowerWall", "right" );
			//bottom
			mapMaster_fillEdge( "TowerWall", "bottom" );
			//left
			mapMaster_fill(0,0,0,160,"TowerWall",BLOCK_LAYER);

			//-
			mapMaster_fill(40,160,240,160,"TowerWall",BLOCK_LAYER);

			mapMaster_addScenery("LavaGlow","", 0,200,40,160,SKY_LAYER);

			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );

			nextMap[UP]		= "towe15";
			nextMap[LEFT]	= "towe13";
			break;
		}

	}
}

function mapMaster_loadSnow( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "adviceland" );

	mapMaster.bigTileBackground("Snow");

	switch ( screenName )
	{
		case "snow01" :
		{
			mapMaster_fillEdge( "Water", "left" );
			//top
			mapMaster_fill(40,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(40,40,560,40,"Cliff",BLOCK_LAYER);

			mapMaster_addSaveItem( "SkeletonKey", "towerKey1", 40, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Spark", "", 180, 80, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 520, 80, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 250, 250, -1, -1, ACTION_LAYER )

			//cliff
			mapMaster_addBlock( "CliffEdgeR", "", 40, 80, -1, -1, BLOCK_LAYER );
			mapMaster_fill(40,120,240,120,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(40,160,240,160,"Cliff",BLOCK_LAYER);
			//ladder
			mapMaster_addScenery("CliffEdgeT","", 280,120,-1,-1,BLOCK_LAYER);
			mapMaster_addScenery("Cliff","", 280,160,-1,-1,BLOCK_LAYER);
			mapMaster_fill(280,120,280,160,"Ladder",BLOCK_LAYER);
			//cliff
			mapMaster_fill(320,120,560,120,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(320,160,560,160,"Cliff",BLOCK_LAYER);

			mapMaster_fill(520,320,560,360,"IceCube",BLOCK_LAYER);

			break;
		}
		case "snow02" :
		{
			//top
			mapMaster_fill(0,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,40,560,40,"Cliff",BLOCK_LAYER);

			//cliff
			mapMaster_fill(0,120,160,120,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,160,160,160,"Cliff",BLOCK_LAYER);

			//mapMaster_fill(180,80,180,80,"CliffEdgeL",BLOCK_LAYER);
			mapMaster_fill(0,320,40,360,"IceCube",BLOCK_LAYER);

			mapMaster_fill(520,320,560,360,"PineTree",BLOCK_LAYER);

			mapMaster_addBlock( "CliffEdgeL", "", 180, 80, -1, -1, BLOCK_LAYER );

			mapMaster_addActor( "Icemon", "", 240, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon", "", 340, 230, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow03" :
		{
			//top
			mapMaster_fill(0,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,40,560,40,"Cliff",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,320,560,360,"PineTree",BLOCK_LAYER);
			mapMaster_addActor( "Icemon2", "", 260, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon2", "", 300, 160, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow04" :
		{
			//top
			mapMaster_fill(0,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,40,560,40,"Cliff",BLOCK_LAYER);
			//bottom left
			mapMaster_fill(0,320,0,360,"PineTree",BLOCK_LAYER);
			//bottom
			mapMaster_fill(200,320,560,360,"IceCube",BLOCK_LAYER);

			mapMaster_addActor( "Icemon", "", 260, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon2", "", 300, 90, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow05" :
		{
			//top
			mapMaster_fill(0,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,40,560,40,"Cliff",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,320,360,360,"IceCube",BLOCK_LAYER);
			//right
			mapMaster_fill(520,80,560,360,"IceCube",BLOCK_LAYER);

			mapMaster_addActor( "Icemon", "", 260, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon2", "", 300, 90, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow06" :
		{
			_root.board.hero.goToNormalWalkMode();

			//right
			mapMaster_fill(440,0,560,360,"IceCube",BLOCK_LAYER);
			//left
			mapMaster_fill(0,0,120,360,"IceCube",BLOCK_LAYER);
			//top
			mapMaster_fill(160,0,400,80,"IceCube",BLOCK_LAYER);
			// top side
			mapMaster_fill(160,120,200,120,"IceCube",BLOCK_LAYER);
			mapMaster_addScenery("BlackDoor","", 240,80,120,80,BLOCK_LAYER);
			mapMaster_fill(360,120,400,120,"IceCube",BLOCK_LAYER);

			bizzle = mapMaster_addBlock( "Block", "warp", 240, 120, 120, 30, ACTION_LAYER );
			bizzle.warp = true;
			bizzle.mapName = "icec01";
			bizzle.newPlayerX=280;
			bizzle.newPlayerY=315;

			break;
		}
		case "snow07" :
		{
			mapMaster_fillEdge( "IceCube", "left" );
			//top
			mapMaster_fill(0,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,40,560,40,"Cliff",BLOCK_LAYER);
			break;
		}
		case "snow08" :
		{
			//top
			mapMaster_fill(0,0,560,0,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(0,40,560,40,"Cliff",BLOCK_LAYER);
			//right
			mapMaster_fill(520,0,520,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",520,0,20,400,BLOCK_LAYER);
			break;
		}
		case "snow09" :
		{
			mapMaster_fillEdge( "Water", "left" );
			mapMaster_fill(40,160,180,360,"Water",BLOCK_LAYER);
			mapMaster_fill(520,0,560,120,"IceCube",BLOCK_LAYER);
			mapMaster_fill(520,240,560,360,"IceCube",BLOCK_LAYER);
			mapMaster_addActor( "Imp", "", 400, 100, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Imp", "", 400, 260, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow10" :
		{
			mapMaster_fill(0,0,40,120,"IceCube",BLOCK_LAYER);
			mapMaster_fill(0,240,40,360,"IceCube",BLOCK_LAYER);
			//island
			mapMaster_fill(160,160,400,200,"IceCube",BLOCK_LAYER);
			mapMaster_fill(520,0,560,120,"PineTree",BLOCK_LAYER);
			mapMaster_fill(520,240,560,360,"PineTree",BLOCK_LAYER);
			mapMaster_addActor( "Icemon", "", 400, 100, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon", "", 300, 270, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow11" :
		{
			//left
			mapMaster_fill(0,0,40,120,"PineTree",BLOCK_LAYER);
			mapMaster_fill(0,240,40,360,"PineTree",BLOCK_LAYER);
			//top
			mapMaster_fill(0,-40,560,0,"PineTree",BLOCK_LAYER);
			//right
			mapMaster_fill(560,0,560,360,"PineTree",BLOCK_LAYER);
			//bottom left
			mapMaster_fill(0,320,40,360,"PineTree",BLOCK_LAYER);
			//bottom right
			mapMaster_fill(280,320,560,360,"PineTree",BLOCK_LAYER);
			//____
			mapMaster_fill(80,240,480,240,"PineTree",BLOCK_LAYER);
			//   |
			mapMaster_fill(480,80,480,240,"PineTree",BLOCK_LAYER);
			mapMaster_fill(160,120,160,120,"Stump",BLOCK_LAYER);
			mapMaster_fill(280,120,280,120,"Stump",BLOCK_LAYER);
			mapMaster_fill(400,120,400,120,"Stump",BLOCK_LAYER);

			mapMaster_addActor( "Icemon", "", 260, 160, -1, -1, ACTION_LAYER );

			break;
		}
		case "snow12" :
		{
			//bottom
			mapMaster_fill(0,360,160,360,"PineTree",BLOCK_LAYER);
			mapMaster_fill(280,360,440,360,"PineTree",BLOCK_LAYER);
			//right
			mapMaster_fill(560,280,560,360,"PineTree",BLOCK_LAYER);
			//left
			mapMaster_fill(0,-40,0,360,"PineTree",BLOCK_LAYER);
			//  |			
			mapMaster_fill(280,200,320,320,"IceCube",BLOCK_LAYER);
			//---
			mapMaster_fill(40,120,320,160,"IceCube",BLOCK_LAYER);
			//top
			mapMaster_fill(200,0,560,40,"IceCube",BLOCK_LAYER);

			mapMaster_addActor( "Icemon2", "", 360, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon", "", 100, 220, -1, -1, ACTION_LAYER );

			break;
		}
		case "snow13" :
		{
			//top
			mapMaster_fill(0,0,360,40,"IceCube",BLOCK_LAYER);
			//right
			mapMaster_fill(520,0,560,360,"IceCube",BLOCK_LAYER);
			//left
			mapMaster_fill(0,280,0,360,"PineTree",BLOCK_LAYER);
			//bottom
			mapMaster_fill(160,360,360,360,"PineTree",BLOCK_LAYER);
			break;
		}
		case "snow14" :
		{
			//right
			mapMaster_fill(520,0,560,360,"IceCube",BLOCK_LAYER);
			//left
			mapMaster_fill(0,0,40,360,"IceCube",BLOCK_LAYER);
			// top --    --
			mapMaster_fill(80,0,120,0,"IceCube",BLOCK_LAYER);
			mapMaster_fill(440,0,480,0,"IceCube",BLOCK_LAYER);
			// top -      -
			mapMaster_fill(80,40,80,40,"IceCube",BLOCK_LAYER);
			mapMaster_fill(480,40,480,40,"IceCube",BLOCK_LAYER);
			//  o   o
			mapMaster_fill(240,80,240,80,"Rock",BLOCK_LAYER);
			mapMaster_fill(320,80,320,80,"Rock",BLOCK_LAYER);
			// o     o
			mapMaster_fill(160,140,160,140,"Rock",BLOCK_LAYER);
			mapMaster_fill(400,140,400,140,"Rock",BLOCK_LAYER);
			// spring
			mapMaster_addScenery("WaterFountain","", 300,200,-1,-1,SKY_LAYER);
			mapMaster_addBlock("Water","spring",280,180,40,40,BLOCK_LAYER);
			_root.board.spring.interactive = true;
			_root.board.spring.interact = function()
			{
				_root.board.hero.healUp();
			};
			// o     o
			mapMaster_fill(160,220,160,220,"Rock",BLOCK_LAYER);
			mapMaster_fill(400,220,400,220,"Rock",BLOCK_LAYER);
			//  o   o
			mapMaster_fill(240,280,240,280,"Rock",BLOCK_LAYER);
			mapMaster_fill(320,280,320,280,"Rock",BLOCK_LAYER);
			// bottom -      -
			mapMaster_fill(80,320,80,320,"IceCube",BLOCK_LAYER);
			mapMaster_fill(480,320,480,320,"IceCube",BLOCK_LAYER);
			// bottom --    --
			mapMaster_fill(80,360,120,360,"IceCube",BLOCK_LAYER);
			mapMaster_fill(440,360,480,360,"IceCube",BLOCK_LAYER);

			MapMaster.addPerson("Meaty","c27", 88,165,-1,-1,ACTION_LAYER);
			break;
		}
		case "snow15" :
		{
			mapMaster_fillEdge( "IceCube", "left" );
			break;
		}
		case "snow16" :
		{
			//right
			mapMaster_fill(520,0,520,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",520,0,20,400,BLOCK_LAYER);
			break;
		}

		case "snow17" :
		{
			
			mapMaster_fillEdge( "Water", "left" );
			mapMaster_fill(40,0,180,80,"Water",BLOCK_LAYER);
			mapMaster_fill(520,320,560,360,"PineTree",BLOCK_LAYER);
			mapMaster_fill(520,0,560,40,"IceCube",BLOCK_LAYER);

			// tower
			mapMaster_fill(80,240,240,360,"TowerWall",ACTION_LAYER);
			mapMaster_addScenery("BlackDoor","", 120,280,-1,-1,ACTION_LAYER);
			mapMaster_addScenery("BlackDoor","", 200,280,-1,-1,ACTION_LAYER);

			mapMaster_addActor( "Spark", "", 360, 90, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SpikeTop", "", 240, 160, -1, -1, ACTION_LAYER );
			break;
		}
		case "snow18" :
		{
			//upper left
			mapMaster_fill(0,0,40,40,"IceCube",BLOCK_LAYER);
			//upper right
			mapMaster_fill(520,-40,560,0,"PineTree",BLOCK_LAYER);

			mapMaster_fill(400,120,400,120,"Stump",BLOCK_LAYER);
			mapMaster_fill(0,320,160,360,"PineTree",BLOCK_LAYER);			
			mapMaster_fill(320,320,560,360,"PineTree",BLOCK_LAYER);
			mapMaster_addActor( "Icemon", "", 250, 170, -1, -1, ACTION_LAYER );

			break;
		}
		case "snow19" :
		{
			//upper left
			mapMaster_fill(0,-40,40,0,"PineTree",BLOCK_LAYER);
			//upper right
			mapMaster_fill(280,-40,560,0,"PineTree",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,320,560,360,"PineTree",BLOCK_LAYER);

			mapMaster_addActor( "Icemon", "", 200, 150, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon", "", 400, 150, -1, -1, ACTION_LAYER );

			break;
		}
		case "snow20" :
		{
			//top
			mapMaster_fill(0,-40,160,0,"PineTree",BLOCK_LAYER);
			mapMaster_fill(280,-40,440,0,"PineTree",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,320,560,360,"PineTree",BLOCK_LAYER);
			//right
			mapMaster_fill(560,-40,560,360,"PineTree",BLOCK_LAYER);
			mapMaster_addActor( "Icemon", "", 300, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon2", "", 340, 200, -1, -1, ACTION_LAYER );

			mapMaster_fill(400,200,400,280,"IceCube",BLOCK_LAYER);			
			mapMaster_fill(400,200,540,200,"IceCube",BLOCK_LAYER);			

			mapMaster_addActor( "Spark", "", 500, 260, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Spark", "", 500, 261, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Spark", "", 500, 263, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Spark", "", 500, 264, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Spark", "", 500, 266, -1, -1, ACTION_LAYER );

			break;
		}
		case "snow21" :
		{
			//top
			mapMaster_fill(160,-40,360,0,"PineTree",BLOCK_LAYER);
			//left
			mapMaster_fill(0,-40,0,360,"PineTree",BLOCK_LAYER);
			//upper right
			mapMaster_fill(520,0,560,120,"IceCube",BLOCK_LAYER);
			//lower right
			// |
			mapMaster_fill(440,280,440,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",440,280,20,120,BLOCK_LAYER);
			mapMaster_fill(400,280,400,360,"SandFloor",BLOCK_LAYER);
			// --
			mapMaster_addBlock("Block","",460,280,140,20,BLOCK_LAYER);
			mapMaster_fill(440,280,560,280,"CliffEdgeB",BLOCK_LAYER);
			mapMaster_fill(400,240,560,240,"SandFloor",BLOCK_LAYER);
			//rock
			mapMaster_fill(480,280,480,280,"Rock",BLOCK_LAYER);

			break;
		}
		case "snow22" :
		{
			//right
			mapMaster_fill(520,0,560,280,"IceCube",BLOCK_LAYER);
			//upper left
			mapMaster_fill(0,0,40,120,"IceCube",BLOCK_LAYER);
			//lower right
			// --
			mapMaster_addBlock("Block","",0,280,600,20,BLOCK_LAYER);
			mapMaster_fill(0,280,480,280,"CliffEdgeB",BLOCK_LAYER);
			mapMaster_fill(0,240,480,240,"SandFloor",BLOCK_LAYER);
			// top -    -
			mapMaster_fill(80,0,120,0,"IceCube",BLOCK_LAYER);
			mapMaster_fill(440,0,480,0,"IceCube",BLOCK_LAYER);
			// o     o
			mapMaster_fill(160,120,160,120,"Rock",BLOCK_LAYER);
			mapMaster_fill(400,120,400,120,"Rock",BLOCK_LAYER);
			// disk
			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );
			
			break;
		}
		case "snow23" :
		{
			//left
			mapMaster_fill(0,0,0,280,"IceCube",BLOCK_LAYER);
			break;
		}
		case "snow24" :
		{
			//right
			mapMaster_fill(520,0,520,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",520,0,20,400,BLOCK_LAYER);
			break;
		}


	}
}

function mapMaster_loadMain( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advover2" );

	switch ( screenName )
	{
		case "main01" :
		{
			// grass
			MapMaster.islandBackground();

			//mapMaster_addActor( "MeanRock", "", 440, 80, -1, -1, ACTION_LAYER )

			// block island
			mapMaster_fill(120,120,240,200,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "Imp", "", 330, 150, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 480, 150, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Bee", "bee0", 460, 200, -1, -1, ACTION_LAYER )
			_root.board.bee0.launch( _root.board.hero );
			mapMaster_addActor( "Spark", "", 50, 160, -1, -1, ACTION_LAYER )

			mapMaster_addScenery( "Cave", "", 120, 190, -1, -1, ACTION_LAYER );
			mapMaster_addBlock( "Block", "", 120, 190, 30, 100, ACTION_LAYER );
			mapMaster_addBlock( "Block", "", 220, 190, 30, 100, ACTION_LAYER );

			bizzle = mapMaster_addBlock( "Block", "warp", 170, 210, -1, -1, ACTION_LAYER );
			bizzle.warp = true;
			bizzle.mapName = "dwarf3";
			bizzle.newPlayerX=201;
			bizzle.newPlayerY=90;

			mapMaster_fillEdge( "Water", "right" );
			// left
			mapMaster_fill(0,0,0,320,"BrennenRock",BLOCK_LAYER);
			// bottom
			mapMaster_fill(0,360,400,360,"Water",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "main02";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "island3";
			nextMap[LEFT]	= "none";
			*/

			break;
		}
		case "main02" :
		{
			// grass
			mapMaster.bigTileBackground("Tundra");

			//top
			mapMaster_fill(0,0,280,0,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(400,0,560,0,"Water",BLOCK_LAYER);

			mapMaster_fillEdge( "BrennenRock", "left" );
			mapMaster_fillEdge( "Water", "right" );

			if ( ! SaveMaster.isComplete( "slimeBoss" ) )
			{
				MapMaster.addPerson("Dave","c11", 300,0,-1,-1,ACTION_LAYER);
			}

			mapMaster_addActor( "Imp", "", 180, 180, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Imp", "", 240, 180, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Imp", "", 300, 180, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Imp", "", 360, 180, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 480, 40, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 480, 200, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 40, 40, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 40, 200, -1, -1, ACTION_LAYER )


			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "main03";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "main01";
			nextMap[LEFT]	= "none";
			*/

			break;
		}
		case "main03" :
		{
			mapMaster.bigTileBackground("Tundra");

			//bottom
			mapMaster_fill(0,360,280,360,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(400,240,560,360,"Water",BLOCK_LAYER);

			mapMaster_fill(0,-40,560,-40,"PineTree",BLOCK_LAYER);
			mapMaster_fillEdge( "PineTree", "top" );

			mapMaster_addScenery("PineTree","", 90,180,-1,-1,BLOCK_LAYER);
			mapMaster_addScenery("PineTree","", 400,180,-1,-1,BLOCK_LAYER);

			mapMaster_addActor( "SpikeTop", "", 180, 70, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spinner", "", 180, 220, -1, -1, ACTION_LAYER )

			// save location
			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );

			break;
		}
		case "main04" :
		{
			// grass
			mapMaster.bigTileBackground("Tundra");

			//bottom
			mapMaster_fillEdge( "BrennenRock", "bottom" );

			mapMaster_fill(0,-40,560,-40,"PineTree",BLOCK_LAYER);
			mapMaster_fillEdge( "PineTree", "top" );

			//ditch
			//left
			mapMaster_fill(80,80,80,280,"CliffEdgeL",BLOCK_LAYER);
			mapMaster_addBlock("Block","",80,80,20,240,BLOCK_LAYER);

			//top
			//mapMaster_addBlock("Block","",80,80,180,80,BLOCK_LAYER);
			//mapMaster_addBlock("Block","",340,80,180,80,BLOCK_LAYER);
			mapMaster_fill(100,80,220,80,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(100,120,220,120,"Cliff",BLOCK_LAYER);

			mapMaster_addScenery("CliffEdgeT","", 260,80,-1,-1,BLOCK_LAYER);
			mapMaster_addScenery("CliffEdgeT","", 300,80,-1,-1,BLOCK_LAYER);
			mapMaster_addScenery("Cliff","", 260,120,-1,-1,BLOCK_LAYER);
			mapMaster_addScenery("Cliff","", 300,120,-1,-1,BLOCK_LAYER);
			mapMaster_fill(260,80,300,120,"Ladder",BLOCK_LAYER);

			mapMaster_fill(340,80,460,80,"CliffEdgeT",BLOCK_LAYER);
			mapMaster_fill(340,120,460,120,"Cliff",BLOCK_LAYER);

			//mapMaster_fill(340,80,460,80,"CliffEdgeT",BLOCK_LAYER);
			//mapMaster_fill(340,120,460,120,"Cliff",BLOCK_LAYER);

			//bottom
			mapMaster_addBlock("Block","",80,315,440,5,BLOCK_LAYER);
			mapMaster_fill(100,320,460,320,"CliffEdgeB",BLOCK_LAYER);
			//right
			mapMaster_fill(500,80,500,280,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",500,80,20,240,BLOCK_LAYER);
			//sand
			mapMaster_fill(100,160,480,280,"SandFloor",BLOCK_LAYER);

			mapMaster_addActor( "SpikeTop", "", 180, 180, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spinner", "", 180, 220, -1, -1, ACTION_LAYER )

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "main03";
			nextMap[DOWN]	= "main02";
			nextMap[LEFT]	= "main06";
			*/

			break;
		}
		case "main05" :
		{
			// grass
			mapMaster.bigTileBackground("Tundra");

			//bottom
			mapMaster_fill(0,240,120,360,"Water",BLOCK_LAYER);

			mapMaster_fill(0,-40,0,-40,"PineTree",BLOCK_LAYER);
			mapMaster_fill(0,0,0,0,"PineTree",BLOCK_LAYER);

			mapMaster_fill(440,0,440,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",440,0,20,400,BLOCK_LAYER);

			mapMaster_fill(400,0,400,360,"SandFloor",BLOCK_LAYER);

			break;
		}
		case "main06" :
		{
			mapMaster_fill(0,-40,160,0,"PineTree",BLOCK_LAYER);
			
			mapMaster_fill(320,-40,560,0,"PineTree",BLOCK_LAYER);
			mapMaster_fill(120,320,120,320,"Stump",BLOCK_LAYER);
			mapMaster_fill(80,160,80,160,"Stump",BLOCK_LAYER);
			mapMaster_fill(320,160,320,320,"PineTree",BLOCK_LAYER);
			mapMaster_addBlock("BrennenRock","",560,360,-1,-1,BLOCK_LAYER);
			mapMaster.bigTileBackground("Tundra");

			//corner
			mapMaster_fill(0,360,0,360,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "Spinner", "", 400, 160, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spinner", "", 440, 160, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spinner", "", 140, 160, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 480, 180, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 180, 180, -1, -1, ACTION_LAYER )
			break;
		}
		case "main07" :
		{
			mapMaster.bigTileBackground("Tundra");
			mapMaster_fill(520,-40,560,0,"PineTree",BLOCK_LAYER);
			mapMaster_fillEdge( "Water", "left" );

			//corner
			mapMaster_fill(560,360,560,360,"BrennenRock",BLOCK_LAYER);

			// tower
			mapMaster_fill(80,0,240,200,"TowerWall",ACTION_LAYER);
			mapMaster_addScenery("BlackDoor","", 120,40,-1,-1,ACTION_LAYER);
			mapMaster_addScenery("BlackDoor","", 200,40,-1,-1,ACTION_LAYER);
			// door
			mapMaster_fill(80,240,120,240,"TowerWall",ACTION_LAYER);
			mapMaster_fill(200,240,240,240,"TowerWall",ACTION_LAYER);
			MapMaster.addWarp( "BlackDoor", "", 160, 240, -1, -1, ACTION_LAYER, "towe01", "top", 280, 330 );
			MapMaster.addDoor("BrennenDoor", "towerDoor1", 160, 240, -1, -1, ACTION_LAYER);

			if ( SaveMaster.isComplete( "SlimeBoss" ) )
			{
				MapMaster.addPerson("Oscar","c23", 90,250,-1,-1,ACTION_LAYER);
			}

			mapMaster_addScenery("Water","", 420,220,80,40,BLOCK_LAYER);
			mapMaster_fill(400,200,480,240,"BrennenRock",BLOCK_LAYER);
			wf1 = mapMaster_addScenery("WaterFountain","", 440,220,-1,-1,SKY_LAYER);
			wf2 = mapMaster_addScenery("WaterFountain","", 480,220,-1,-1,SKY_LAYER);
			wf3 = mapMaster_addScenery("WaterFountain","", 460,260,-1,-1,SKY_LAYER);
			wf1.gotoAndPlay(8);
			wf2.gotoAndPlay(16);

			mapMaster_addBlock("Block","f2",400,200,120,80,BLOCK_LAYER);
			_root.board.f2.interactive = true;
			_root.board.f2.interact = function()
			{
				_root.board.hero.healUp();
			};

			break;
		}
		case "main08" :
		{
			mapMaster.bigTileBackground("Tundra");
			mapMaster_fillEdge( "Water", "left" );
			mapMaster_addActor( "SpikeTop", "", 80, 220, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SpikeTop", "", 300, 160, -1, -1, ACTION_LAYER );
			//sand
			mapMaster_fill(80,80,480,280,"SandFloor",BLOCK_LAYER);

			//right
			mapMaster_fill(560,0,560,80,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(560,240,560,360,"BrennenRock",BLOCK_LAYER);

			break;
		}
		case "main09" :
		{
			mapMaster.bigTileBackground("Tundra");
			mapMaster_addBlock("BrennenRock","",560,0,-1,-1,BLOCK_LAYER);
			mapMaster_fillEdge( "BrennenRock", "right" );

			//left
			mapMaster_fill(0,0,0,80,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(0,240,0,360,"BrennenRock",BLOCK_LAYER);

			// -----
			// -----
			mapMaster_fill(200,120,400,120,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(200,240,400,240,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "Bulb", "", 180, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bulb", "", 480, 180, -1, -1, ACTION_LAYER );

			mapMaster_addActor( "SpikeTop", "", 300, 180, -1, -1, ACTION_LAYER )

			break;
		}
		case "main10" :
		{
			mapMaster.bigTileBackground("Tundra");

			//sand
			mapMaster_fill(0,0,560,180,"SandFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "BrennenRock", "top" );
			mapMaster_fillEdge( "BrennenRock", "right" );
			mapMaster_fillEdge( "BrennenRock", "left" );
			//bottom
			mapMaster_fill(40,360,160,360,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(400,360,520,360,"BrennenRock",BLOCK_LAYER);
			//island
			mapMaster_fill(200,200,360,200,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "SpikeTop", "", 100, 100, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 100, 250, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 460, 100, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 460, 250, -1, -1, ACTION_LAYER )

			mapMaster_addSaveItem( "Treasure", "dwarfTreasure", 300, 40, -1, -1, ACTION_LAYER );


			break;
		}
		case "main11" :
		{
			mapMaster.bigTileBackground("Tundra");
			mapMaster_fillEdge( "Water", "left" );
			// bottom
			MapMaster.addPerson("Afty","c17", 45,160,-1,-1,ACTION_LAYER);

			// save location
			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );

			//corner
			mapMaster_fill(560,0,560,0,"BrennenRock",BLOCK_LAYER);

			if ( ! SaveMaster.isComplete( "Bridge1" ) )
			{
				if ( Inventory_getQty ("Gold") >= 100 )
				{
					MapMaster.addPerson("Beefo","c19", 90,167,-1,-1,ACTION_LAYER);
				}
				else
				{
					MapMaster.addPerson("Beefo","c18", 90,167,-1,-1,ACTION_LAYER);
				}
				mapMaster_fill(0,240,560,360,"Water",BLOCK_LAYER);
			}
			else
			{
				mapMaster_fill(0,240,200,360,"Water",BLOCK_LAYER);
				mapMaster_fill(280,240,560,360,"Water",BLOCK_LAYER);
				mapMaster_fill(240,240,240,360,"WoodFloor",BLOCK_LAYER);
			}
			break;
		}
		case "main12" :
		{
			mapMaster.bigTileBackground("Tundra");
			// bottom
			mapMaster_fill(0,240,80,360,"Water",BLOCK_LAYER);
			mapMaster_fillEdge( "Water", "bottom" );

			// left
			mapMaster_fill(560,0,560,40,"BrennenRock",BLOCK_LAYER);

			//corner
			mapMaster_fill(0,0,0,0,"BrennenRock",BLOCK_LAYER);

			//     -
			mapMaster_fill(440,80,520,80,"BrennenRock",BLOCK_LAYER);
			// ----
			mapMaster_fill(120,120,440,120,"BrennenRock",BLOCK_LAYER);


			mapMaster_fill(160,220,160,220,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(240,220,240,220,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(360,220,360,220,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "Bulb", "", 300, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bulb", "", 200, 200, -1, -1, ACTION_LAYER );

			break;
		}
		case "main13" :
		{
			mapMaster.bigTileBackground("Tundra");
			// right
			mapMaster_fill(560,0,560,320,"BrennenRock",BLOCK_LAYER);
			mapMaster_fillEdge( "Water", "bottom" );
			//top
			mapMaster_fill(0,0,160,40,"BrennenRock",BLOCK_LAYER);
			mapMaster_fill(400,0,520,40,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "SpikeTop", "", 300, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SpikeTop", "", 400, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 460, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 460, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 460, 320, -1, -1, ACTION_LAYER );


			break;
		}
		case "main14" :
		{
			mapMaster.bigTileBackground("Tundra");

			break;
		}
		case "main15" :
		{
			mapMaster.bigTileBackground("Tundra");

			break;
		}
		case "main16" :
		{
			mapMaster.bigTileBackground("Tundra");
			//right
			mapMaster_fill(520,0,520,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",520,0,20,400,BLOCK_LAYER);
			break;
		}
		case "main17" :
		{
			mapMaster.bigTileBackground("JungleFloor");

			//left
			mapMaster_fill(0,0,120,240,"Water",BLOCK_LAYER);
			mapMaster_fill(0,280,0,360,"Water",BLOCK_LAYER);

			mapMaster_fill(440,0,440,160,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",440,0,20,200,BLOCK_LAYER);

			mapMaster_fill(400,0,400,160,"SandFloor",BLOCK_LAYER);

			//island
			mapMaster_fill(280,200,480,320,"SandFloor",BLOCK_LAYER);

			break;
		}
		case "main18" :
		{
			mapMaster.bigTileBackground("JungleFloor");

			break;
		}
		case "main19" :
		{
			mapMaster.bigTileBackground("JungleFloor");

			break;
		}
		case "main20" :
		{
			mapMaster.bigTileBackground("JungleFloor");
			//right
			mapMaster_fill(520,0,520,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",520,0,20,400,BLOCK_LAYER);
			break;
		}
		case "main21" :
		{
			mapMaster.bigTileBackground("JungleFloor");
			mapMaster_fillEdge( "Water", "left" );
			mapMaster_fillEdge( "Fence", "bottom" );
			break;
		}
		case "main22" :
		{
			mapMaster.bigTileBackground("JungleFloor");
			mapMaster_fillEdge( "Fence", "bottom" );
			break;
		}
		case "main23" :
		{
			mapMaster.bigTileBackground("JungleFloor");
			mapMaster_fillEdge( "Fence", "bottom" );
			break;
		}
		case "main24" :
		{
			mapMaster.bigTileBackground("JungleFloor");
			mapMaster_fillEdge( "Fence", "bottom" );
			//right
			mapMaster_fill(520,0,520,360,"CliffEdgeR",BLOCK_LAYER);
			mapMaster_addBlock("Block","",520,0,20,400,BLOCK_LAYER);
			break;
		}
	}
}

function mapMaster_loadSlime( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advslime" );

	switch ( screenName )
	{
		case "slime1" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			numSlimes = 5;

			for( ix = 0; ix < numSlimes; ix++ )
			{
				mapMaster_addActor( "Slime", "", 300, 180, -1, -1, ACTION_LAYER )
			}

			// top
			mapMaster_fill(0,0,240,0,"BrickWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "slimeDoor3", 280, 0, -1, -1, ACTION_LAYER);
			mapMaster_fill(320,0,560,0,"BrickWall",BLOCK_LAYER);
			//mapMaster_addItem( "SkeletonKey", "", 100, 100, -1, -1, ACTION_LAYER );

			// bottom side
			mapMaster_fill(0,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"BrickWall",BLOCK_LAYER);

			// left side
			mapMaster_fillEdge( "BrickWall", "left" );

			// right side
			mapMaster_fill(560,0,560,120,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(560,240,560,360,"BrickWall",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime2";
			nextMap[RIGHT]	= "slime4";
			nextMap[DOWN]	= "island5";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slime2" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			// top
			mapMaster_fill(0,0,240,0,"BrickWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "slimeDoor4", 280, 0, -1, -1, ACTION_LAYER);
			mapMaster_fill(320,0,560,0,"BrickWall",BLOCK_LAYER);

			// sides
			mapMaster_fillEdge( "BrickWall", "left" );
			mapMaster_fillEdge( "BrickWall", "right" );
			// bottom
			mapMaster_fill(0,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(320,360,560,360,"BrickWall",BLOCK_LAYER);
		
			// Knight
			if ( ! SaveMaster.isComplete( "slimeBoss" ) )
			{
				if ( SaveMaster.isComplete( "dwarfKey1" ) )
				{
					MapMaster.addPerson("Hadrian","c9", 120,40,-1,-1,ACTION_LAYER).interact();
				}
				else
				{
					MapMaster.addPerson("Hadrian","c3", 120,40,-1,-1,ACTION_LAYER).interact();
				}
			}

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime3";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "slime1";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slime3" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			if ( ! SaveMaster.isComplete( "slimeMiniBoss" ) )
			{
				miniBoss = mapMaster_addActor( "Slime", "", 100, 100, 60, 60, ACTION_LAYER );

				miniBoss.miniBossInit();
				miniBoss.monsterDie = function()
				{
					mapMaster_addItem( "SkeletonKey", "slimeKey3", this._x, this._y, -1, -1, ACTION_LAYER );
					SaveMaster.complete( "slimeMiniBoss" );
				};
				miniBoss.attachMovie("SkeletonKey", "ghostKey", layerMaster_use(ACTION_LAYER), {_x:5, _y:10 } );
				miniBoss.ghostKey._alpha=30;
				miniBoss.ghostKey._width=20;
				miniBoss.ghostKey._height=20;
			}
			else
			{
				mapMaster_addScenery( "Slime", "", 100, 100, 60, 60, SKY_LAYER )._alpha=30;
			}

			// very important for save Items.  The item name must be unique.  (2nd parameter)
			//mapMaster_addSaveItem( "SkeletonKey", "slimeKey3", 300, 200, -1, -1, ACTION_LAYER );

			// top side
			mapMaster_fill(0,0,240,0,"BrickWall",BLOCK_LAYER);
			// bottom
			mapMaster_fill(0,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(320,360,560,360,"BrickWall",BLOCK_LAYER);

			MapMaster.addDoor("BrennenDoor", "slimeDoor1", 280, 0, -1, -1, ACTION_LAYER);

/*
			var theDoor = mapMaster_addScenery("BrennenDoor", "", 270, 0, -1, -1, ACTION_LAYER);
			mapMaster_addScenery( "BlackDoor", "", 280, 0, 40, 40, BLOCK_LAYER );
			if ( SaveMaster.isComplete( "slimeDoor1" ) )
			{
				theDoor.gotoAndPlay(2);
			}
			else
			{
				doorBlock = mapMaster_addBlock( "Block", "", 280, 0, 40, 40, BLOCK_LAYER );
				doorBlock.lockedDoor = true;
				doorBlock.saveTask = "slimeDoor1";
				doorBlock.animateDoor = theDoor;
			}*/

			mapMaster_fill(320,0,560,0,"BrickWall",BLOCK_LAYER);

			// sides
			mapMaster_fillEdge( "BrickWall", "left" );

			// right side
			mapMaster_fill(560,0,560,120,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(560,240,560,360,"BrickWall",BLOCK_LAYER);


			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime7";
			nextMap[RIGHT]	= "slime6";
			nextMap[DOWN]	= "slime2";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slime4" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);
			/*
			_root.board.attachMovie("Slime", "slime1", layerMaster_use(ACTION_LAYER), {_x:40, _y:40, hp:1 } );
			_root.board.attachMovie("Slime", "slime2", layerMaster_use(ACTION_LAYER), {_x:40, _y:280, hp:1 } );
			_root.board.attachMovie("Slime", "slime3", layerMaster_use(ACTION_LAYER), {_x:480, _y:40, hp:1 } );
			_root.board.attachMovie("Slime", "slime4", layerMaster_use(ACTION_LAYER), {_x:480, _y:280, hp:1 } );
			*/
			mapMaster_addActor( "Slime", "", 60, 60, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Slime", "", 60, 280, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Slime", "", 480, 60, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Slime", "", 480, 280, -1, -1, ACTION_LAYER )

			// top side
			mapMaster_fill(0,0,240,0,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"BrickWall",BLOCK_LAYER);

			// barrier
			mapMaster_fill(40,120,440,120,"BrickWall",BLOCK_LAYER);

			mapMaster_fillEdge( "BrickWall", "bottom" );
			mapMaster_fillEdge( "BrickWall", "right" );

			// left side
			mapMaster_fill(0,0,0,120,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(0,240,0,360,"BrickWall",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime5";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "slime1";

			break;
		}
		case "slime5" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_addActor( "Slime", "", 60, 60, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Slime", "", 60, 280, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Slime", "", 480, 60, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Slime", "", 480, 280, -1, -1, ACTION_LAYER )

			// bottom side
			mapMaster_fill(0,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"BrickWall",BLOCK_LAYER);

			//right
			mapMaster_fill(560,0,560,120,"BrickWall",BLOCK_LAYER);
			_root.board.attachMovie("BrickWall", "brick1", layerMaster_use(SKY_LAYER), {_x:560, _y:120 } );
			_root.board.attachMovie("BrickWall", "brick1", layerMaster_use(SKY_LAYER), {_x:560, _y:160 } );
			_root.board.attachMovie("BrickWall", "brick2", layerMaster_use(SKY_LAYER), {_x:560, _y:200 } );
			mapMaster_fill(560,240,560,360,"BrickWall",BLOCK_LAYER);

			// island
			mapMaster_fill(200,160,360,200,"Water",BLOCK_LAYER);

			mapMaster_addSaveItem( "SkeletonKey", "slimeKey1", 300, 80, -1, -1, ACTION_LAYER )

			mapMaster_fillEdge( "BrickWall", "top" );
			mapMaster_fillEdge( "BrickWall", "left" );

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "slimeX";
			nextMap[DOWN]	= "slime4";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slime6" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_addActor( "Slime", "", 60, 60, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "", 60, 280, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "", 480, 60, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "", 480, 280, -1, -1, ACTION_LAYER );

			mapMaster_fillEdge( "BrickWall", "bottom" );
			mapMaster_fillEdge( "BrickWall", "right" );
			mapMaster_fillEdge( "BrickWall", "top" );

			mapMaster_fill(320,160,320,160,"BrennenRock",BLOCK_LAYER);

			// left side
			mapMaster_fill(0,0,0,120,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(0,240,0,360,"BrickWall",BLOCK_LAYER);

			mapMaster_addSaveItem( "Energy", "slimeEnergy1", 520, 160, -1, -1, ACTION_LAYER );

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "slime3";

			break;
		}
		case "slime7" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_addActor( "Slime", "", 190, 300, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "", 70, 270, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "", 70, 70, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "", 310, 70, -1, -1, ACTION_LAYER );

			// bottom side
			mapMaster_fill(0,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(320,360,560,360,"BrickWall",BLOCK_LAYER);

			// block island
			mapMaster_fill(120,120,560,240,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(360,240,400,320,"BrickWall",BLOCK_LAYER);

			mapMaster_addSaveItem( "SkeletonKey", "slimeKey2", 460, 300, -1, -1, ACTION_LAYER );

			mapMaster_fillEdge( "BrickWall", "top" );
			mapMaster_fillEdge( "BrickWall", "left" );


			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "slime8";
			nextMap[DOWN]	= "slime3";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slime8" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_addActor( "Slime", "sa", 280, 80, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "sb", 280, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "sc", 280, 240, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "sd", 280, 320, -1, -1, ACTION_LAYER );
			_root.board.sa.stopMoving();
			_root.board.sb.stopMoving();
			_root.board.sc.stopMoving();
			_root.board.sd.stopMoving();
			mapMaster_addActor( "Slime", "se", 360, 240, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Slime", "sf", 360, 280, -1, -1, ACTION_LAYER );
			_root.board.se.init(12,1);
			_root.board.sf.init(12,1);
			mapMaster_addActor( "MeanRock", "", 480, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 480, 270, -1, -1, ACTION_LAYER );

			mapMaster_fillEdge( "BrickWall", "right" );
			mapMaster_fillEdge( "BrickWall", "bottom" );
			// island
			mapMaster_fill(0,120,40,240,"BrickWall",BLOCK_LAYER);
			// top
			mapMaster_fill(0,0,400,0,"BrickWall",BLOCK_LAYER);

			MapMaster.addDoor("BrennenDoor", "slimeDoor2", 440, 0, -1, -1, ACTION_LAYER);
/*
			theDoor = mapMaster_addScenery("BrennenDoor", "", 430, 0, -1, -1, ACTION_LAYER);
			mapMaster_addScenery( "BlackDoor", "", 440, 0, 40, 40, BLOCK_LAYER );
			doorBlock = mapMaster_addBlock( "Block", "", 440, 0, 40, 40, BLOCK_LAYER );
			doorBlock.lockedDoor = true;
			doorBlock.animateDoor = theDoor;
			*/
			mapMaster_fill(480,0,520,0,"BrickWall",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime9";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "slime7";

			break;
		}
		case "slime9" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_addActor( "Slime", "sa", 100, 100, -1, -1, ACTION_LAYER );
			_root.board.sa.attachMovie("Slime", "sb", layerMaster_use(ACTION_LAYER), {_x:50, _y:0 } );
			_root.board.sa.attachMovie("Slime", "sc", layerMaster_use(ACTION_LAYER), {_x:100, _y:0 } );
			_root.board.sa.attachMovie("Slime", "sd", layerMaster_use(ACTION_LAYER), {_x:150, _y:0 } );
			_root.board.sa.attachMovie("Slime", "se", layerMaster_use(ACTION_LAYER), {_x:200, _y:0 } );
			_root.board.sa.init(4,8);

			mapMaster_addActor( "Slime", "sf", 100, 100, -1, -1, ACTION_LAYER );
			_root.board.sf.attachMovie("Slime", "sg", layerMaster_use(ACTION_LAYER), {_x:0, _y:0 } );
			_root.board.sf.attachMovie("Slime", "sh", layerMaster_use(ACTION_LAYER), {_x:0, _y:50 } );
			_root.board.sf.attachMovie("Slime", "si", layerMaster_use(ACTION_LAYER), {_x:0, _y:100 } );
			_root.board.sf.attachMovie("Slime", "sj", layerMaster_use(ACTION_LAYER), {_x:0, _y:150 } );
			_root.board.sf.init(4,8);

			mapMaster_fillEdge( "BrickWall", "right" );
			mapMaster_fillEdge( "BrickWall", "top" );

			// left
			mapMaster_fill(0,0,0,160,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(0,280,0,360,"BrickWall",BLOCK_LAYER);

			// bottom
			mapMaster_fill(0,360,400,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(480,360,520,360,"BrickWall",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "slime8";
			nextMap[LEFT]	= "slime10";

			break;
		}
		case "slime10" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "BrickWall", "left" );
			mapMaster_fillEdge( "BrickWall", "bottom" );

			// top
			mapMaster_fill(0,0,240,0,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"BrickWall",BLOCK_LAYER);

			// right
			mapMaster_fill(560,0,560,160,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(560,280,560,360,"BrickWall",BLOCK_LAYER);

			if ( ! SaveMaster.isComplete( "slimeBoss" ) )
			{
				//2/16/2006
				MapMaster.playMusic( "advboss" );

				mapMaster_addBlock( "BrickWall", "destroyWall", 280, 0, -1, -1, ACTION_LAYER );
				_root.board.destroyWall.attachMovie("BrickWall", "dw2", layerMaster_use(ACTION_LAYER), {_x:40, _y:0 } );

				slimeBoss = _root.board.attachMovie("Slime", "nastyslime1", layerMaster_use(ACTION_LAYER), {_x:100, _y:100} );
				slimeBoss.bossInit();
				activeList_addActor( _root.board.nastyslime1 );
				slimeBoss.monsterDie = function()
				{
					SaveMaster.complete( "slimeBoss" );
					_root.board.destroyWall.removeMovieClip();
				};
			}


			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime11";
			nextMap[RIGHT]	= "slime9";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slime11" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "BrickWall", "left" );
			mapMaster_fillEdge( "BrickWall", "right" );
			mapMaster_fillEdge( "BrickWall", "top" );

			mapMaster_fill(0,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"BrickWall",BLOCK_LAYER);

			sword = mapMaster_addSaveItem("Sword","sword1", 300,170,-1,-1,BLOCK_LAYER);
			sword._rotation = 180;
			mapMaster_addScenery("NateRock","", 260,150,100,40,BLOCK_LAYER);
			mapMaster_addBlock("Block","", 260,150,60,40,BLOCK_LAYER);

			mapMaster_fill(80,200,480,240,"Water",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "slime10";
			nextMap[LEFT]	= "none";

			break;
		}
		case "slimeX" :
		{
			mapMaster_fill(0,0,560,360,"BrickFloor",BLOCK_LAYER);

			//left
			mapMaster_fill(0,0,0,120,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(0,240,0,360,"BrickWall",BLOCK_LAYER);

			//island
			mapMaster_fill(320,80,520,280,"BrickWall",BLOCK_LAYER);

			mapMaster_fillEdge( "BrickWall", "top" );
			mapMaster_fillEdge( "BrickWall", "right" );
			mapMaster_fillEdge( "BrickWall", "bottom" );

			mapMaster_addSaveItem( "Energy", "slimeEnergy2", 520, 40, -1, -1, ACTION_LAYER );

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "slime5";

			break;
		}
	}
}

function mapMaster_loadOther( screenName )
{
	switch ( screenName )
	{
		case "town1" :
		{
			//2/16/2006
			MapMaster.playMusic( "advtown" );

			// grass
			MapMaster.islandBackground();

			// left side
			mapMaster_fillEdge( "Water", "left" );

			if ( ! SaveMaster.isComplete( "Bridge1" ) )
			{
				mapMaster_fillEdge( "Water", "top" );				
			}
			else
			{
				mapMaster_fill(0,0,200,0,"Water",BLOCK_LAYER);
				mapMaster_fill(280,0,560,0,"Water",BLOCK_LAYER);
				mapMaster_fill(240,0,240,0,"WoodFloor",BLOCK_LAYER);

				MapMaster.addPerson("Beefo","c20", 330,0,-1,-1,ACTION_LAYER);
			}

			//right fence
			mapMaster_fill(560,120,560,360,"Fence",BLOCK_LAYER);


			mapMaster_fill(160,140,160,140,"BrickFloor2",BLOCK_LAYER);
			mapMaster_fill(160,160,240,160,"BrickFloor2",BLOCK_LAYER);

			mapMaster_addScenery("WeaponShop","", 40,0,-1,-1,BLOCK_LAYER);
			mapMaster_addBlock("Block","",70,40,140,50,BLOCK_LAYER);
			mapMaster_addBlock("Block","",70,90,90,50,BLOCK_LAYER);

			door2 = mapMaster_addBlock("Block","unique3",160,90,10,10,BLOCK_LAYER);
			door2.warp=true;
			door2.mapName="weapons";
			door2.newPlayerX=281;
			door2.newPlayerY=250;

			mapMaster_fill(280,80,560,80,"BrickFloor2",BLOCK_LAYER);

			mapMaster_fill(280,120,280,360,"BrickFloor2",BLOCK_LAYER);


			mapMaster_fill(480,300,480,300,"BrickFloor2",BLOCK_LAYER);
			mapMaster_fill(320,340,480,340,"BrickFloor2",BLOCK_LAYER);

			mapMaster_fill(360,120,560,120,"Fence",BLOCK_LAYER);
			mapMaster_fill(360,160,360,280,"Fence",BLOCK_LAYER);
			mapMaster_fill(400,130,520,130,"Daffodil",BLOCK_LAYER);
			mapMaster_fill(440,240,520,280,"BrickFloor3",BLOCK_LAYER);
			mapMaster_addBlock("Block","", 475,180,70,40,BLOCK_LAYER);
			mapMaster_addScenery("OutHouse","", 470,180,-1,-1,BLOCK_LAYER);
			mapMaster_addScenery("Daffodil","", 530,280,-1,-1,BLOCK_LAYER);
			door1 = mapMaster_addBlock("Block","unique2", 500,220,2,20,BLOCK_LAYER);
			door1.warp=true;
			door1.mapName="outhouse";
			door1.newPlayerX=281;
			door1.newPlayerY=250;

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "island1";
			nextMap[DOWN]	= "town2";
			nextMap[LEFT]	= "none";
*/
			break;
		}
		case "outhouse" :
		{
			mapMaster_fill(160,80,400,280,"BrickFloor3",BLOCK_LAYER);

			// horizontal walls.
			mapMaster_fill(160,80,400,80,"RockWall",BLOCK_LAYER);
			mapMaster_fill(160,280,240,280,"RockWall",BLOCK_LAYER);
			mapMaster_fill(320,280,400,280,"RockWall",BLOCK_LAYER);

			// vertical walls.
			mapMaster_fill(160,80,160,280,"RockWall",BLOCK_LAYER);
			mapMaster_fill(400,80,400,280,"RockWall",BLOCK_LAYER);

			MapMaster.addWarp( "BlackDoor", "", 280, 280, -1, -1, ACTION_LAYER, "town1", "bottom", 490, 250 );

			MapMaster.addPerson("Tokugawa","c22", 350,100,-1,-1,ACTION_LAYER);

			break;
		}
		case "weapons" :
		{
			mapMaster_fill(160,80,400,280,"BrickFloor",BLOCK_LAYER);

			// horizontal walls.
			mapMaster_fill(160,80,400,80,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(160,280,240,280,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(320,280,400,280,"BrickWall",BLOCK_LAYER);

			// vertical walls.
			mapMaster_fill(160,80,160,280,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(400,80,400,280,"BrickWall",BLOCK_LAYER);

			MapMaster.addPerson("Wiznerd","c12", 320,80,-1,-1,ACTION_LAYER);

			MapMaster.addWarp( "BlackDoor", "", 280, 280, -1, -1, ACTION_LAYER, "town1", "bottom", 168, 120 );

			break;
		}
		case "town2" :
		{
			// grass
			MapMaster.islandBackground();

			// left side
			mapMaster_fillEdge( "Water", "left" );

			//right fence
			mapMaster_fillEdge( "Fence", "right" );

			mapMaster_fill(280,0,280,360,"BrickFloor2",BLOCK_LAYER);

			mapMaster_addScenery("Tree","tree", 0,20,-1,-1,SKY_LAYER);
			mapMaster_addBlock("Block","", 120,230,60,30,ACTION_LAYER);

			if ( ! SaveMaster.isComplete( "GwyneldaSlime" ) )
			{
				MapMaster.addPerson("Gwynelda","c13", 40,290,-1,-1,ACTION_LAYER).interact();
				harry = mapMaster_addActor( "Slime", "", 40, 280, -1, -1, ACTION_LAYER );
				harry.vx = harry.vy = harry.speed = 0;
				harry.monsterDie = function()
				{
					_root.board.Gwynelda.conversationName = "c14";
					_root.board.Gwynelda.interact();
					SaveMaster.complete( "GwyneldaSlime" )
				};
			}
			else if ( SaveMaster.isComplete( "SlimeBoss" ) )
			{
				MapMaster.addPerson("Gwynelda","c15", 40,290,-1,-1,ACTION_LAYER);
				MapMaster.addPerson("Hadrian","c16", 80,280,-1,-1,ACTION_LAYER);
			}
			else
			{
				MapMaster.addPerson("Gwynelda","c6", 40,290,-1,-1,ACTION_LAYER);
			}

			mapMaster_addScenery("FachWerkHouses","", 300,70,-1,-1,BLOCK_LAYER);
			mapMaster_addBlock("Block","",500,300,60,40,BLOCK_LAYER);
			mapMaster_addBlock("Block","",310,180,540-310,290-180,BLOCK_LAYER);
			mapMaster_addBlock("Block","",380,100,510-380,150-100,BLOCK_LAYER);
			mapMaster_addBlock("Block","",510,150,550-510,30,BLOCK_LAYER);
			mapMaster_addBlock("Block","",450,70,20,30,BLOCK_LAYER);
			door1 = mapMaster_addBlock( "Block", "unique5", 330, 290, 10, 10, ACTION_LAYER );
			door1.warp=true;
			door1.mapName = "fachwerkhouse";
			door1.newPlayerX=121;
			door1.newPlayerY=300;
			door2 = mapMaster_addBlock( "Block", "unique6", 400, 290, 10, 10, ACTION_LAYER );
			door2.warp=true;
			door2.mapName = "fachwerkhouse";
			door2.newPlayerX=281;
			door2.newPlayerY=300;
			door3 = mapMaster_addBlock( "Block", "unique7", 470, 290, 10, 10, ACTION_LAYER );
			door3.warp=true;
			door3.mapName = "fachwerkhouse";
			door3.newPlayerX=441;
			door3.newPlayerY=300;

			break;
		}
		case "fachwerkhouse" :
		{
			mapMaster_fill(0,0,560,360,"WoodFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "BrickWall", "right" );
			mapMaster_fillEdge( "BrickWall", "left" );
			mapMaster_fillEdge( "BrickWall", "top" );
			mapMaster_fill(200,40,200,320,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(400,200,400,320,"BrickWall",BLOCK_LAYER);

			//bottom wall
			mapMaster_fill(0,360,80,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(160,360,240,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(320,360,400,360,"BrickWall",BLOCK_LAYER);
			mapMaster_fill(480,360,520,360,"BrickWall",BLOCK_LAYER);

			MapMaster.addWarp( "BlackDoor", "", 120, 360, 40, 40, ACTION_LAYER, "town2", "bottom", 331, 310 );
			MapMaster.addWarp( "BlackDoor", "", 280, 360, 40, 40, ACTION_LAYER, "town2", "bottom", 401, 310 );
			MapMaster.addWarp( "BlackDoor", "", 440, 360, 40, 40, ACTION_LAYER, "town2", "bottom", 461, 310 );

			break;
		}
		case "town3" :
		{
			//2/16/2006
			MapMaster.playMusic( "advtown" );

			// grass
			MapMaster.islandBackground();

			// left side
			mapMaster_fillEdge( "Water", "left" );
			mapMaster_fillEdge( "Water", "bottom" );

			mapMaster_fill(280,0,280,280,"BrickFloor2",BLOCK_LAYER);
			mapMaster_fill(320,280,560,280,"BrickFloor2",BLOCK_LAYER);

			//right fence
			mapMaster_fill(560,0,560,240,"Fence",BLOCK_LAYER);

			mapMaster_addScenery("DrugStore","", 40,80,-1,-1,BLOCK_LAYER);
			mapMaster_addBlock("Block","",80,130,170,100,BLOCK_LAYER);
			mapMaster_addBlock("Block","",80,220,120,80,BLOCK_LAYER);
			door1 = mapMaster_addBlock( "Block", "unique8", 210, 240, 20, 48, ACTION_LAYER );
			door1.warp=true;
			door1.mapName = "drugstore";
			door1.newPlayerX=465;
			door1.newPlayerY=189;

			if ( ! SaveMaster.isComplete( "SlimeBoss" ) )
			{
				MapMaster.addPerson("Oscar","c10", 360,130,-1,-1,ACTION_LAYER);
			}

			mapMaster_addScenery("Fountain","", 320,40,-1,-1,ACTION_LAYER);
			mapMaster_addBlock("Block","f1",390,130,100,50,BLOCK_LAYER);
			mapMaster_addBlock("Block","f2",370,180,140,50,BLOCK_LAYER);
			mapMaster_addScenery("WaterFountain","", 444,113,7,7,SKY_LAYER);
			_root.board.f1.interactive = true;
			_root.board.f2.interactive = true;
			_root.board.f1.interact = function()
			{
				_root.board.hero.healUp();
			};
			_root.board.f2.interact = _root.board.f1.interact;


			break;
		}
		case "drugstore" :
		{
		
			mapMaster_fill(120,80,440,280,"BrickFloor",BG_LAYER);

			// top
			mapMaster_fill(80,40,480,40,"RockWall",BLOCK_LAYER);
			// bottom
			mapMaster_fill(80,320,480,320,"RockWall",BLOCK_LAYER);

			// left
			mapMaster_fill(80,80,80,280,"RockWall",BLOCK_LAYER);

			// right
			mapMaster_fill(480,80,480,160,"RockWall",BLOCK_LAYER);
			MapMaster.addWarp( "BlackDoor", "", 480, 200, -1, -1, BLOCK_LAYER, "town3", "right", 243, 264 );
			mapMaster_addScenery("RockWall", "", 480, 200, -1, -1,BG_LAYER);
			mapMaster_fill(480,240,480,280,"RockWall",BLOCK_LAYER);

			MapMaster.addPerson( "Podlie", "c21", 200, 40, -1, -1, ACTION_LAYER);

			break;
		}
		case "warpzone1" :
		{
		
			mapMaster_addScenery( "BrickFloor3", "", 0, 0, 600, 400, BG_LAYER );
			mapMaster_addScenery( "Amethyst", "", 0, 0, 600, 400, BG_LAYER )._alpha = 20;


			//mapMaster_addScenery( "DrugStore", "", 0, 0, -1, -1, BG_LAYER );


			_root.board.createEmptyMovieClip("textMC", layerMaster_use(BG_LAYER) );
			_root.board.textMC.createTextField( "message", layerMaster_use(ACTION_LAYER), 0, 0, 240, 100 );
			//_root.board.textMC.message.border = true;
			//_root.board.textMC.message.borderColor = 0x33FF66;
			_root.board.textMC.message.background = true;
			_root.board.textMC.message.backgroundColor = 0xFFFFFF
			_root.board.textMC.message.text = "Welcome to Warp ZONE!\nThis is where monsters are tested.\nUp slime boss.  down start.\nAll else is naught!";
			_root.board.textMC.message.textColor = 0x339900;

			
			s1 = mapMaster_addActor( "Slime", "", 0, 0, 600, 400, ACTION_LAYER );
			s2 = mapMaster_addActor( "Slime", "", 0, 0, -1, -1, ACTION_LAYER );

			s1.speed = s1.vx = s1.vy = 0;
			s2.speed = s2.vx = s2.vy = 0;
			s1.invincible = true;
			s1._visible = false;

			mapMaster_addActor( "Slime", "", 0, 260, -1, -1, ACTION_LAYER )

			//mapMaster_fill(120,0,120,360,"BrennenRock",BLOCK_LAYER);

			mapMaster_addActor( "Spark", "", 400, 160, -1, -1, ACTION_LAYER )
			//mapMaster_addActor( "Bee", "", 400, 260, -1, -1, ACTION_LAYER ).launch( _root.board.hero );
			mapMaster_addActor( "Imp", "", 40, 160, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 500, 20, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 500, 320, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 0, 320, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "MeanRock", "", 0, 20, -1, -1, ACTION_LAYER )

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime3";
			nextMap[RIGHT]	= "warpzone2";
			nextMap[DOWN]	= "island8";
			nextMap[LEFT]	= "none";

			break;
		}
		case "dwarf1" :
		{
			//2/16/2006
			MapMaster.playMusic( "advdwarfcave" );

			mapMaster_fill(0,0,560,360,"RockFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "RockWall", "left" );
			mapMaster_fillEdge( "RockWall", "right" );

			// top
			mapMaster_fill(0,0,320,120,"RockWall",BLOCK_LAYER);
			mapMaster_fill(440,0,560,80,"RockWall",BLOCK_LAYER);

			// bottom
			mapMaster_fill(0,360,120,360,"RockWall",BLOCK_LAYER);
			MapMaster.addWarp( "BlackDoor", "", 160, 360, -1, -1, ACTION_LAYER, "island6", "bottom", 176, 260 );
			mapMaster_fill(200,320,560,360,"RockWall",BLOCK_LAYER);

			mapMaster_addScenery( "Amethyst", "", 40, 40, -1, -1, ACTION_LAYER )._width=30;
			mapMaster_addScenery( "Amethyst", "", 130, 50, -1, -1, ACTION_LAYER )._alpha=80;
			mapMaster_addScenery( "Amethyst", "", 220, 10, -1, -1, ACTION_LAYER )._height=30;
			mapMaster_addScenery( "Amethyst", "", 500, 340, -1, -1, ACTION_LAYER )._alpha=60;

			mapMaster_addItem( "Tire", "", 100, 240, -1, -1, ACTION_LAYER );
			mapMaster_addItem( "Tire", "", 140, 240, -1, -1, ACTION_LAYER );
			mapMaster_addItem( "Tire", "", 180, 240, -1, -1, ACTION_LAYER );
			mapMaster_addItem( "Tire", "", 220, 240, -1, -1, ACTION_LAYER );
			mapMaster_addItem( "Tire", "", 260, 240, -1, -1, ACTION_LAYER );

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "dwarf2";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "none";

			break;
		}
		case "dwarf2" :
		{
			mapMaster_fill(0,0,560,360,"RockFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "RockWall", "left" );
			mapMaster_fillEdge( "RockWall", "right" );

			//treasure room:
			mapMaster_fill(40,0,320,40,"RockWall",BLOCK_LAYER);
			mapMaster_fill(280,80,320,120,"RockWall",BLOCK_LAYER);
			mapMaster_fill(40,160,120,160,"RockWall",BLOCK_LAYER);
			//MapMaster.addDoor("BrennenDoor", "dwarfDoor1", 160, 160, -1, -1, ACTION_LAYER);
			mapMaster_fill(200,160,320,160,"RockWall",BLOCK_LAYER);
			//treasure
			for ( j=1; j<=6; j++ )
			{
				mapMaster_addSaveItem( "Treasure", "dwarfTreasure" + j, j*40, 80, -1, -1, ACTION_LAYER );
			}
			mapMaster_addSaveItem( "SkeletonKey", "dwarfKey1", 40, 280, -1, -1, ACTION_LAYER );


			if ( SaveMaster.isComplete( "slimeBoss" ) )
			{
				MapMaster.addPerson( "Oran", "c8", 50, 190, -1, -1, ACTION_LAYER ).interact();
			}
			else
			{
				mapMaster_addBlock("BrennenDoor","", 150,160,-1,-1,BLOCK_LAYER);
				MapMaster.addPerson( "Oran", "c7", 50, 190, -1, -1, ACTION_LAYER );
			}

			// bottom
			mapMaster_fill(0,320,320,360,"RockWall",BLOCK_LAYER);
			mapMaster_fill(440,280,560,360,"RockWall",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "dwarf3";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "dwarf1";
			nextMap[LEFT]	= "none";

			break;
		}
		case "dwarf3" :
		{
			//2/16/2006
			MapMaster.playMusic( "advdwarfcave" );

			mapMaster_fill(0,0,560,360,"RockFloor",BLOCK_LAYER);

			mapMaster_fillEdge( "RockWall", "top" );
			mapMaster_fillEdge( "RockWall", "left" );
			mapMaster_fillEdge( "RockWall", "right" );

			mapMaster_fill(120,160,320,240,"RockWall",BLOCK_LAYER);
			mapMaster_fill(120,120,160,120,"RockWall",BLOCK_LAYER);
			mapMaster_fill(240,120,320,120,"RockWall",BLOCK_LAYER);
			mapMaster_addScenery( "RockWall", "", 200, 120, -1, -1, ACTION_LAYER );
			MapMaster.addWarp( "BlackDoor", "", 200, 120, -1, -1, ACTION_LAYER, "main01", "bottom", 176, 268 );

			// bottom
			mapMaster_fill(40,360,320,360,"RockWall",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "dwarf2";
			nextMap[LEFT]	= "none";

			break;
		}
		case "heaven" :
		{
			// in case you die from the ice cave.
			_root.board.hero.goToNormalWalkMode();

			//mapMaster_addScenery( "Grass", "", 0, 0, -1, -1, BG_LAYER );	
			//this looks cool for some reason. mapMaster_fill(0,0,560,360,"Sky",BG_LAYER);	
			mapMaster_addScenery( "Sky", "", 0, 0, -1, -1, BG_LAYER );	
			/*
			mapMaster_fill(0,40,560,40,"SnowCapMtn",BG_LAYER);	
			mapMaster_fill(-40,80,560,360,"MovingPlain",BG_LAYER);	
			mapMaster_addScenery( "Castle", "", 340, 40, 60, 40, BLOCK_LAYER );
			*/

			MapMaster.scrollClouds();

			_root.board.hero._x = 300;
			_root.board.hero._y = 182;
			_root.board.hero.hp = _root.board.hero.maxHP;
			_root.updateHPDisplay( _root.board.hero.hp );

			//left
			mapMaster_addBlock( "Block", "", 0, 0, 120, 400, BLOCK_LAYER );

			mapMaster_addScenery( "Cloud", "", 100, 160, 400, 200, BLOCK_LAYER );

			//mapMaster_fill(80,160,80,280,"CloudFloorL",BLOCK_LAYER);

			//center
			//mapMaster_fill(120,160,440,280,"CloudFloorC",BLOCK_LAYER);

			//bottom
			//mapMaster_fill(120,320,440,320,"CloudFloorB",BLOCK_LAYER);
			mapMaster_addBlock( "Block", "", 0, 240, 600, 160, BLOCK_LAYER );

			//right
			mapMaster_addBlock( "Block", "", 480, 0, 120, 400, BLOCK_LAYER );
			//mapMaster_fill(480,160,480,280,"CloudFloorR",BLOCK_LAYER);

			//top
			mapMaster_addBlock( "Block", "", 0, 0, 600, 200, BLOCK_LAYER );
			//mapMaster_fill(120,120,440,120,"CloudFloorT",BLOCK_LAYER);

			MapMaster.addPerson( "Yezmo", "c5", 300, 165, -1, -1, ACTION_LAYER ).interact();

			mapMaster_addScenery( "Faquarius", "", 80, 120, -1, -1, BLOCK_LAYER );

			MapMaster.addWarp( "Teleport", "", 440, 200, -1, -1, ACTION_LAYER, SaveMaster.getLocation(), "center", 260, 40 );


			//_root.board.attachMovie("DragonOnGround", "dragon", layerMaster_use(SKY_LAYER), {_x:0, _y:100 } );

			//_root.board.attachMovie("DragonFlying", "dragon", layerMaster_use(SKY_LAYER), {_x:300, _y:100 } );

			ig = mapMaster_addActiveScenery( "DragonFlying", "Ignatious", 560, 10, 50, 30, ACTION_LAYER );
			ig.update = function()
			{
				this._x--;
			};

			break;
		}

	}
}

function mapMaster_loadIsland( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advover1" );

	// grass
	MapMaster.islandBackground();
	switch ( screenName )
	{
		case "island8" :
		{
			mapMaster_addActor( "Spark", "", 100, 100, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 460, 100, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 100, 280, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 460, 280, -1, -1, ACTION_LAYER )

			// upper left corner.
			mapMaster_fill(0,0,0,0,"BrennenRock",BLOCK_LAYER);

			mapMaster_addScenery("NateRock","", 40,200,100,40,BLOCK_LAYER);
			mapMaster_addBlock("Block","", 40,200,60,40,BLOCK_LAYER);

			// bottom side
			mapMaster_fillEdge( "Water", "bottom" );

			// upper right corner.
			mapMaster_fill(560,0,560,0,"BrennenRock",BLOCK_LAYER);

			break;
		}
		case "island1" :
		{
			mapMaster_fill(320,160,320,160,"LeafTree",SKY_LAYER);
			mapMaster_addBlock("Block","", 370,280,14,20,BLOCK_LAYER);

			//left fence
			mapMaster_fill(0,120,0,360,"Fence",BLOCK_LAYER);

			// top side
			mapMaster_fillEdge( "Water", "top" );

			// upper right corner.
			mapMaster_fill(560,360,560,360,"BrennenRock",BLOCK_LAYER);

			mapMaster_fill(0,80,120,80,"BrickFloor2",BLOCK_LAYER);

			mapMaster_addActor( "Bee", "bee0", 380, 80, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Bee", "bee1", 250, 80, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Bee", "bee2", 380, 160, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Bee", "bee3", 250, 160, -1, -1, ACTION_LAYER )
			_root.board.bee0.hp = 1;
			_root.board.bee1.hp = 1;
			_root.board.bee2.hp = 1;
			_root.board.bee3.hp = 1;
			_root.board.bee0.launch( _root.board.hero );
			_root.board.bee1.launch( _root.board.hero );
			_root.board.bee2.launch( _root.board.hero );
			_root.board.bee3.launch( _root.board.hero );
			
			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "island2";
			nextMap[DOWN]	= "island4";
			nextMap[LEFT]	= "town1";
			*/

			break;
		}
		case "island4" :
		{
			// Devil
			MapMaster.addPerson( "Devil", "c4", 400, 190, -1, -1, ACTION_LAYER );

			/*
			_root.board.createEmptyMovieClip("textMC", layerMaster_use(ACTION_LAYER) );
			_root.board.textMC.createTextField( "message", layerMaster_use(ACTION_LAYER), 400, 100, 140, 80 );
			_root.board.textMC.message.border = true;
			_root.board.textMC.message.borderColor = 0xFFFFFF;
			_root.board.textMC.message.background = true;
			_root.board.textMC.message.backgroundColor = 0x000000
			_root.board.textMC.message.text = "This island is so BORING!\nI gotta get off.";
			_root.board.textMC.message.textColor = 0x9999FF;
			*/
			
			mapMaster_fill(520,160,520,160,"Daffodil",ACTION_LAYER);
			mapMaster_fill(480,160,480,160,"Daffodil",ACTION_LAYER);
			// left side
			mapMaster_fillEdge( "Fence", "left" );
			mapMaster_fillEdge( "BrennenRock", "right" );

			mapMaster_addScenery("NateRock","", 80,300,100,40,BLOCK_LAYER);
			mapMaster_addBlock("Block","", 80,300,60,40,BLOCK_LAYER);

			for( ix = 0; ix < 4; ix++ )
			{
				mapMaster_addActor( "Imp", "", 50, 130, -1, -1, ACTION_LAYER )
			}

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "island1";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "island7";
			nextMap[LEFT]	= "none";
			*/

			break;
		}
		case "island7" :
		{
			mapMaster_fill(0,280,80,280,"BrickFloor2",BLOCK_LAYER);

			// bottom side
			mapMaster_fillEdge( "Water", "bottom" );

			// save location
			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );

			// upper right corner.
			mapMaster_fill(560,0,560,0,"BrennenRock",BLOCK_LAYER);

			//right fence
			mapMaster_fill(0,0,0,240,"Fence",BLOCK_LAYER);

			// block island
			mapMaster_addScenery("PineTree","", 140,200,80,60,BLOCK_LAYER);

			mapMaster_addScenery("HelpSign","", 300,250,-1,-1,BLOCK_LAYER);

			MapMaster.addPerson( "Whammy", "c1", 300, 300, -1, -1, ACTION_LAYER )
			mapMaster_addScenery( "Bugle", "", 307, 329, -1, -1, ACTION_LAYER )
			mapMaster_addScenery( "Mushroom1", "", 330, 295, -1, -1, BLOCK_LAYER )
			mapMaster_addScenery( "Meaty", "", 340, 280, -1, -1, ACTION_LAYER )
			mapMaster_addScenery( "Tarq", "", 350, 330, -1, -1, ACTION_LAYER )
			// start conversation with whammy
			// (note: don't c1.clear() -- allow it to persist.)
			if ( ! SaveMaster.isComplete( "tutorial" ) )
				_root.board.Whammy.interact();
			SaveMaster.complete("tutorial");

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "island4";
			nextMap[RIGHT]	= "island8";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "town3";
			*/

			break;
		}
		case "island5" :
		{

			numSlimes = 8;
			var hrozPos = 60;

			mapMaster_fill(240,0,360,40,"BrickFloor",BG_LAYER);

			for( ix = 0; ix < numSlimes; ix++ )
			{
				hrozPos += 20;
				mapMaster_addActor( "Slime", "", hrozPos, 130, -1, -1, ACTION_LAYER )
			}

			mapMaster_fillEdge( "BrennenRock", "left" );
			mapMaster_fillEdge( "BrennenRock", "right" );

			// top side
			mapMaster_fill(0,0,240,0,"BrennenRock",BLOCK_LAYER);
			mapMaster_addScenery("BlackDoor","", 280,0,80,40,BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"BrennenRock",BLOCK_LAYER);

			mapMaster_fill(40,240,240,280,"BrennenRock",BLOCK_LAYER);

			// Frog
			//_root.board.attachMovie("Frog", "Frog", layerMaster_use(ACTION_LAYER), {_x:40, _y:340 } );

			/*
			_root.board.createEmptyMovieClip("textMC", layerMaster_use(ACTION_LAYER) );
			_root.board.textMC.createTextField( "message", layerMaster_use(ACTION_LAYER), 100, 280, 140, 80 );
			_root.board.textMC.message.border = true;
			_root.board.textMC.message.borderColor = 0xFFFFFF;
			_root.board.textMC.message.background = true;
			_root.board.textMC.message.backgroundColor = 0x000000
			_root.board.textMC.message.text = "Ralp!\nDude, up yonder is\nthe first dungeon.\nRalp!";
			_root.board.textMC.message.textColor = 0x9999FF;
			*/
			
			// start conversation with frog
			//_root.c2.converse(_root.board.hero, _root.board.Frog);

			MapMaster.addPerson("Frog","c2", 40,310,-1,-1,ACTION_LAYER);
			
			// set the maps that will load when you move off the screen.
			nextMap[UP]		= "slime1";
			/*
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "island8";
			nextMap[LEFT]	= "none";
			*/

			break;
		}
		case "island9" :
		{
			numSlimes = 4;

			for( ix = 0; ix < numSlimes; ix++ )
			{
				mapMaster_addActor( "Slime", "", 400, 160, -1, -1, ACTION_LAYER );
			}

			mapMaster_addActor( "Spark", "", 400, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 440, 300, -1, -1, ACTION_LAYER )

			// block island
			mapMaster_fill(80,80,120,160,"BrennenRock",BLOCK_LAYER);

			mapMaster_fillEdge( "Water", "right" );
			mapMaster_fillEdge( "Water", "bottom" );

			// upper left corner.
			mapMaster_fill(0,0,0,0,"BrennenRock",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "island6";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "island8";
			*/

			break;
		}
		case "island6" :
		{
			//mapMaster_addActor( "MeanRock", "", 440, 80, -1, -1, ACTION_LAYER )

			// block island
			mapMaster_fill(40,120,240,200,"BrennenRock",BLOCK_LAYER);


			mapMaster_addScenery( "Cave", "", 120, 190, -1, -1, ACTION_LAYER );
			mapMaster_addBlock( "Block", "", 120, 190, 30, 100, ACTION_LAYER );
			mapMaster_addBlock( "Block", "", 220, 190, 30, 100, ACTION_LAYER );

			bizzle = mapMaster_addBlock( "Block", "warp", 170, 210, -1, -1, ACTION_LAYER );
			bizzle.warp = true;
			bizzle.mapName = "dwarf1";
			bizzle.newPlayerX=168;
			bizzle.newPlayerY=324;

			mapMaster_fillEdge( "Water", "right" );
			mapMaster_fillEdge( "BrennenRock", "left" );

			// upper left corner.
			mapMaster_fill(0,0,0,0,"BrennenRock",BLOCK_LAYER);

			MapMaster.addPerson("Bromtekal","c25", 480,110,-1,-1,ACTION_LAYER);

			MapMaster.addWarp( "Teleport", "", 500, 210, -1, -1, ACTION_LAYER, "trai01", "center", 50, 180 );

			break;
		}
		case "island3" :
		{
			mapMaster_addActor( "Spark", "", 100, 100, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 500, 240, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 100, 300, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spark", "", 500, 300, -1, -1, ACTION_LAYER )

			mapMaster_fillEdge( "Water", "right" );
			mapMaster_fill(0,0,400,0,"Water",BLOCK_LAYER);
			mapMaster_fill(320,40,400,80,"Water",BLOCK_LAYER);
			mapMaster_fill(320,120,520,160,"Water",BLOCK_LAYER);

			mapMaster_fill(200,120,240,160,"Palm",SKY_LAYER);
			mapMaster_addBlock("Block","", 260,250,50,50,BLOCK_LAYER);

			mapMaster_addSaveItem( "Treasure", "island3Treasure", 440, 80, -1, -1, ACTION_LAYER );

			// lower left corner.
			mapMaster_fill(0,360,0,360,"BrennenRock",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "main01";
			nextMap[RIGHT]	= "none";
			nextMap[DOWN]	= "island6";
			nextMap[LEFT]	= "island2";
			*/

			break;
		}
		case "island2" :
		{
			numSlimes = 4;

			for( ix = 0; ix < numSlimes; ix++ )
			{
				mapMaster_addActor( "Slime", "", 400, 160, -1, -1, ACTION_LAYER )
			}
			mapMaster_addActor( "MeanRock", "", 280, 160, -1, -1, ACTION_LAYER )

			mapMaster_fill(160,40,400,80,"Water",BLOCK_LAYER);
			mapMaster_fillEdge( "Water", "top" );
			mapMaster_fillEdge( "BrennenRock", "bottom" );

			mapMaster_fill(120,0,120,0,"Palm",BLOCK_LAYER);
			mapMaster_fill(240,0,240,0,"Palm",BLOCK_LAYER);
			mapMaster_fill(360,0,360,0,"Palm",BLOCK_LAYER);

			// set the maps that will load when you move off the screen.
			/*
			nextMap[UP]		= "none";
			nextMap[RIGHT]	= "island3";
			nextMap[DOWN]	= "none";
			nextMap[LEFT]	= "island1";
			*/

			break;
		}

	}
}

function mapMaster_loadTrain( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advtrain" );

	mapMaster_fill(0,0,560,360,"WeirdFloor1",BLOCK_LAYER);
	mapMaster_fillEdge( "BubbleWall", "top" );
	mapMaster_fillEdge( "BubbleWall", "bottom" );

	var difficulty = _root.board.hero.maxHP - 5;

	switch ( screenName )
	{
		case "trai01" :
		case "trai02" :
		case "trai03" :
		case "trai04" :
		case "trai05" :
		case "trai06" :
		case "trai07" :
		{
			mapMaster_fillEdge( "BubbleWall2", "right" );
			var wallMC = mapMaster_addBlock("Block","wallMC",560,0,40,400,BLOCK_LAYER);

			activeList_beatAllMonsters2 = function()
			{
				activeList_removeBlock( wallMC );
			}
		}
	}

	switch ( screenName )
	{
		case "trai01" :
		{
			_root.board.createTextField( "message", layerMaster_use(ACTION_LAYER), 200, 370, 200, 20 );
			_root.board.message.background = true;
			_root.board.message.backgroundColor = 0x000000;
			_root.board.message.text = "Training Zone.  Dufficulty: " + difficulty;
			_root.board.message.textColor = 0xFFFFFF;

			mapMaster_fillEdge( "BubbleWall", "left" );
			var evilSlime = mapMaster_addActor( "Slime", "", 500, 180, -1, -1, ACTION_LAYER );
			colorObj = new Color(evilSlime);
			colorObj.setRGB(0x100000);
			mapMaster_addActor( "Spark", "", 360, 90, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Icemon", "", 400, 300, -1, -1, ACTION_LAYER );
			break;
		}
		case "trai02" :
		{
			mapMaster_addActor("Imp", "", 400, 100, -1, -1, ACTION_LAYER );
			mapMaster_addActor("Slime", "", 500, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor("Slime", "", 400,200, -1, -1, ACTION_LAYER ).smartInit();
			break;
		}
		case "trai03" :
		{
			mapMaster_addActor( "Slime", "", 500, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bulb", "", 180, 300, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bulb", "", 300, 180, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bulb", "", 400, 80, -1, -1, ACTION_LAYER );
			break;
		}
		case "trai04" :
		{
			FallFireShadow.dropTime = 9;
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FallFireShadow", "", -1, -1, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireBug", "", 200, 100, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireBug", "", 200, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "FireBug", "", 200, 200, -1, -1, ACTION_LAYER );
			break;
		}
		case "trai05" :
		{
			mapMaster_addActor( "MeanRock", "", 480, 50, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 480, 100, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 480, 150, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MeanRock", "", 480, 240, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bee", "bee0", 460, 200, -1, -1, ACTION_LAYER ).launch( _root.board.hero );
			mapMaster_addActor( "Icemon", "", 400, 200, -1, -1, ACTION_LAYER );
			break;
		}
		case "trai06" :
		{
			mapMaster_addActor( "Bee", "bee0", 260, 100, -1, -1, ACTION_LAYER ).launch( _root.board.hero );
			mapMaster_addActor( "Bee", "bee0", 460, 200, -1, -1, ACTION_LAYER ).launch( _root.board.hero );
			mapMaster_addActor( "Bee", "bee0", 460, 360, -1, -1, ACTION_LAYER ).launch( _root.board.hero );
			mapMaster_addActor( "Spinner", "", 180, 280, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "Spinner", "", 180, 220, -1, -1, ACTION_LAYER )
			mapMaster_addActor( "SpikeTop", "", 400, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Imp", "", 400, 100, -1, -1, ACTION_LAYER );
			break;
		}
		case "trai07" :
		{
			mapMaster_addActor( "SpikeTop", "", 400, 100, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SpikeTop", "", 400, 200, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SpikeTop", "", 400, 300, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Spark", "", 360, 90, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Bulb", "", 180, 180, -1, -1, ACTION_LAYER );
			break;
		}
		case "trai08" :
		{
			mapMaster_fillEdge( "BubbleWall", "right" );
			mapMaster_addItem( "Energy", "", 340, 180, -1, -1, ACTION_LAYER );
			MapMaster.addWarp( "Teleport", "", 400, 180, -1, -1, ACTION_LAYER, "island6", "center", 360, 160 );
			break;
		}
	}

	for ( var idx = 0; idx < actorList.length; idx ++ )
	{
		if ( actorList[idx] instanceof Mortal && actorList[idx].isMonster() )
		{
			// Add more HP to the monster.
			actorList[idx].hp += (difficulty-1) / 4
		}
	}
}

function mapMaster_loadIceCave( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advicecave" );

	// to speed up ice cave, we could make a big floor instead of tiles with masks.
	mapMaster_fill(0,0,560,360,"IceFloor2",BLOCK_LAYER);

	_root.board.hero.goToIceSlideMode();

	switch ( screenName )
	{
		case "icec01" :
		{

			//left
			mapMaster_fill(0,0,0,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(0,280,0,360,"IceWall",BLOCK_LAYER);
			//right
			mapMaster_fill(560,0,560,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(560,280,560,360,"IceWall",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,360,200,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"IceWall",BLOCK_LAYER);
			//top
			mapMaster_fill(0,0,200,0,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"IceWall",BLOCK_LAYER);

			mapMaster_addScenery("BlackDoor","", 240,360,120,40,BLOCK_LAYER);

			mapMaster_addScenery("WarpDestination","", 280,160,-1,-1,BLOCK_LAYER);

			bizzle = mapMaster_addBlock( "Block", "warp", 240, 370, 120, 30, ACTION_LAYER );
			bizzle.warp = true;
			bizzle.mapName = "snow06";
			bizzle.newPlayerX=280;
			bizzle.newPlayerY=135;

			nextMap[UP]			= "icec02";
			nextMap[LEFT]		= "icec03";
			nextMap[RIGHT]		= "icec04";
			break;
		}
		case "icec02" :
		{
			mapMaster_fillEdge( "IceWall", "left" );
			mapMaster_fillEdge( "IceWall", "right" );
			//bottom
			mapMaster_fill(0,360,200,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"IceWall",BLOCK_LAYER);
			//  |   |
			mapMaster_fill(200,280,200,320,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,280,360,320,"IceWall",BLOCK_LAYER);
			MapMaster.addFloorTrigger(240,280,320,280, 240,0,320,0); 
			//top
			mapMaster_fill(0,0,200,0,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"IceWall",BLOCK_LAYER);
			//MapMaster.addFloorTrigger(240,80,320,80, 240,360,320,360); 
			MapMaster.addFloorTrigger(240,120,320,120, 240,40,320,40); 
			//  |   |
			mapMaster_fill(200,40,200,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,40,360,120,"IceWall",BLOCK_LAYER);

			mapMaster_addActor( "SlideMon", "", 400, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 300, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "Ballista", "", 40, 200, -1, -1, SKY_LAYER );
			mapMaster_fill(40,40,40,320,"BallistaTrack",BLOCK_LAYER);

			nextMap[UP]		= "icec05";
			nextMap[DOWN]	= "icec01";
			break;
		}
		case "icec03" :
		{
			mapMaster_fillEdge( "IceWall", "left" );
			mapMaster_fillEdge( "IceWall", "bottom" );

			// top
			mapMaster_fill(40,0,320,0,"IceWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "iceDoor1", 360, 0, -1, -1, ACTION_LAYER);
			mapMaster_fill(400,0,520,0,"IceWall",BLOCK_LAYER);

			//right
			mapMaster_fill(560,0,560,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(560,280,560,360,"IceWall",BLOCK_LAYER);

			//---
			mapMaster_fill(160,240,400,240,"IceWall",BLOCK_LAYER);
			//  |
			mapMaster_fill(440,120,440,240,"IceWall",BLOCK_LAYER);
			//---
			mapMaster_fill(160,120,400,120,"IceWall",BLOCK_LAYER);

			mapMaster_addSaveItem( "SkeletonKey", "iceKey1", 400, 200, -1, -1, ACTION_LAYER );

			mapMaster_fill(40,40,40,320,"BallistaTrack",BLOCK_LAYER);
			mapMaster_addActor( "Ballista", "", 40, 200, -1, -1, SKY_LAYER );

			mapMaster_addActor( "MeanRock", "", 40, 320, -1, -1, SKY_LAYER );

			nextMap[UP]			= "icec12";
			nextMap[RIGHT]		= "icec01";
			break;
		}
		case "icec04" :
		{
			mapMaster_fillEdge( "IceWall", "right" );
			mapMaster_fillEdge( "IceWall", "bottom" );
			//top
			mapMaster_fill(0,0,120,0,"IceWall",BLOCK_LAYER);
			mapMaster_fill(200,0,560,0,"IceWall",BLOCK_LAYER);
			//left
			mapMaster_fill(0,0,0,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(0,280,0,360,"IceWall",BLOCK_LAYER);
			//:
			mapMaster_fill(40,120,80,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(40,280,80,280,"IceWall",BLOCK_LAYER);

			MapMaster.addFloorTrigger(80,160,80,240, 0,160,0,240); 

			mapMaster_addActor( "SlideMon", "", 400, 260, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 300, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 400, 60, -1, -1, ACTION_LAYER );

			activeList_beatAllMonsters2 = function()
			{
				mapMaster_addSaveItem( "SkeletonKey", "iceKey5", 40, 320, -1, -1, ACTION_LAYER );
			}

			nextMap[LEFT]		= "icec01";
			nextMap[UP]			= "icec10";
			break;
		}
		case "icec05" :
		case "icec06" :
		case "icec07" :
		case "icec08" :
		{
			// These screens are all the same.
			// the only difference is the nextMap array which is loaded
			// in a separate switch stmt below.
			//left
			mapMaster_fill(0,0,0,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(0,280,0,360,"IceWall",BLOCK_LAYER);
			//|
			mapMaster_fill(200,0,200,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(200,280,200,360,"IceWall",BLOCK_LAYER);
			//|
			mapMaster_fill(360,0,360,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,280,360,360,"IceWall",BLOCK_LAYER);
			//right
			mapMaster_fill(560,0,560,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(560,280,560,360,"IceWall",BLOCK_LAYER);
			//top
			mapMaster_fill(0,0,200,0,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"IceWall",BLOCK_LAYER);
			//---   ---
			mapMaster_fill(0,120,200,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,120,560,120,"IceWall",BLOCK_LAYER);
			//---   ---
			mapMaster_fill(0,280,200,280,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,280,560,280,"IceWall",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,360,200,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"IceWall",BLOCK_LAYER);

			mapMaster_addActor( "Ballista", "", 40, 60, -1, -1, SKY_LAYER );
			mapMaster_fill(40,40,40,80,"BallistaTrack",BLOCK_LAYER);

			mapMaster_addActor( "SpikeTop", "", 420, 60, -1, -1, SKY_LAYER );
			mapMaster_addActor( "SpikeTop", "", 80, 320, -1, -1, SKY_LAYER );
			mapMaster_addActor( "SpikeTop", "", 420, 320, -1, -1, SKY_LAYER );
			break;
		}
		case "icec09" :
		{

			mapMaster_fillEdge( "IceWall", "right" );
			mapMaster_fillEdge( "IceWall", "left" );

			//bottom
			mapMaster_fill(0,360,200,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"IceWall",BLOCK_LAYER);
			//   |   |
			mapMaster_fill(200,280,200,320,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,280,360,320,"IceWall",BLOCK_LAYER);
			MapMaster.addFloorTrigger(240,280,320,280, 240,360,320,360); 

			// top
			mapMaster_fill(40,0,200,0,"IceWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "iceDoor2", 240, 0, -1, -1, ACTION_LAYER);
			mapMaster_fill(280,0,520,0,"IceWall",BLOCK_LAYER);

			activeList_beatAllMonsters2 = function()
			{
				mapMaster_addSaveItem( "SkeletonKey", "iceKey2", 360, 40, -1, -1, ACTION_LAYER );
			}

			mapMaster_addActor( "MrGrumbles", "", 200, 140, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MrGrumbles", "", 300, 160, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "MrGrumbles", "", 400, 140, -1, -1, ACTION_LAYER );

			nextMap[UP]			= "icec11";
			nextMap[DOWN]		= "icec08";
			break;
		}
		case "icec10" :
		{
			mapMaster_fillEdge( "IceWall", "right" );
			mapMaster_fillEdge( "IceWall", "top" );
			mapMaster_fillEdge( "IceWall", "left" );

			mapMaster_addSaveItem( "Treasure", "iceMegaTreasure1", 80,80, -1, -1, ACTION_LAYER );
			mapMaster_addItem( "Treasure", "", 80,120, -1, -1, ACTION_LAYER );
			mapMaster_addSaveItem( "Treasure", "iceMegaTreasure2", 80,160, -1, -1, ACTION_LAYER );
			mapMaster_addItem( "Treasure", "", 80,200, -1, -1, ACTION_LAYER );
			mapMaster_addSaveItem( "Treasure", "iceMegaTreasure3", 80,240, -1, -1, ACTION_LAYER );

			//---
			mapMaster_fill(120,320,200,320,"IceWall",BLOCK_LAYER);

			for ( var idx=0; idx < 9; idx++ )
			{
				for ( var idy=0; idy < 5; idy++ )
				{
					mapMaster_addItem( "Treasure", "", idx*40+120, idy*40+80, -1, -1, BLOCK_LAYER );
				}
			}

			MapMaster.addWarp( "Teleport", "", 480, 280, -1, -1, ACTION_LAYER, "icec13", "center", 440, 40 );
			mapMaster_addScenery("WarpDestination","", 40,40,-1,-1,BLOCK_LAYER);

			//bottom
			mapMaster_fill(0,360,120,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(200,360,560,360,"IceWall",BLOCK_LAYER);

			nextMap[DOWN]		= "icec04";
			break;
		}
		case "icec11" :
		{
			//top
			mapMaster_fill(0,0,120,0,"IceWall",BLOCK_LAYER);
			mapMaster_fill(240,0,560,0,"IceWall",BLOCK_LAYER);
			//mapMaster_fill(440,40,440,120,"IceWall",BLOCK_LAYER);
			//right
			mapMaster_fill(560,120,560,360,"IceWall",BLOCK_LAYER);
			//bottom
			mapMaster_fill(0,360,200,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(280,360,520,360,"IceWall",BLOCK_LAYER);
			// -----
			mapMaster_fill(160,280,360,280,"IceCube",BLOCK_LAYER);
			//  -
			mapMaster_fill(160,320,160,320,"IceCube",BLOCK_LAYER);
			MapMaster.addFloorTrigger(400,40,400,320, 240,40,240,360); 

			//|
			mapMaster_fill(0,40,0,240,"IceCube",BLOCK_LAYER);
			//-
			mapMaster_fill(40,240,80,240,"IceCube",BLOCK_LAYER);
			MapMaster.addFloorTrigger(80,280,80,320, 0,280,0,320); 

			mapMaster_addActor( "Ballista", "", 40, 80, -1, -1, SKY_LAYER );
			mapMaster_fill(40,40,40,200,"BallistaTrack",BLOCK_LAYER);

			mapMaster_addActor( "MrGrumbles", "", 120, 140, -1, -1, ACTION_LAYER );

			nextMap[UP]				= "icec14";
			nextMap[LEFT]			= "icec15";
			nextMap[RIGHT]			= "icec13";
			nextMap[DOWN]			= "icec09";
			break;
		}
		case "icec12" :
		{
			mapMaster_fillEdge( "IceWall", "top" );
			mapMaster_fillEdge( "IceWall", "left" );
			mapMaster_fillEdge( "IceWall", "right" );
			//bottom
			mapMaster_fill(40,360,320,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(400,360,520,360,"IceWall",BLOCK_LAYER);
			// . .
			mapMaster_fill(320,320,320,320,"IceWall",BLOCK_LAYER);
			mapMaster_fill(400,320,400,320,"IceWall",BLOCK_LAYER);
			MapMaster.addFloorTrigger(320,280,400,280, 360,360,360,360); 

			mapMaster_addSaveItem( "Energy", "iceEnergy2", 40,320, -1, -1, ACTION_LAYER );

			activeList_beatAllMonsters2 = function()
			{
				mapMaster_addSaveItem( "SkeletonKey", "iceKey4", 40, 280, -1, -1, ACTION_LAYER );
			}

			mapMaster_addActor( "MrGrumbles", "", 200, 140, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 400, 140, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 60, 60, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 500, 60, -1, -1, ACTION_LAYER );

			nextMap[DOWN]			= "icec03";
			break;
		}
		case "icec13" :
		{
			mapMaster_fillEdge( "IceWall", "top" );
			mapMaster_fillEdge( "IceWall", "bottom" );
			mapMaster_fillEdge( "IceWall", "right" );
			//left
			mapMaster_fill(0,120,0,360,"IceWall",BLOCK_LAYER);
			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );
			//mapMaster_addItem( "SkeletonKey", "", 240, 100, -1, -1, ACTION_LAYER );

			//box
			mapMaster_fill(40,120,200,120,"IceWall",BLOCK_LAYER);
			mapMaster_fill(40,280,200,280,"IceWall",BLOCK_LAYER);
			mapMaster_fill(200,160,200,240,"IceWall",BLOCK_LAYER);
			mapMaster_addSaveItem( "Trinket", "iceTrinket1", 120,200, -1, -1, ACTION_LAYER );
			MapMaster.addWarp( "Teleport", "", 40, 240, -1, -1, ACTION_LAYER, "icec13", "center", 361, 150 );
			mapMaster_addScenery("WarpDestination","", 360,160,-1,-1,BLOCK_LAYER);

			//|
			mapMaster_fill(320,40,320,280,"IceWall",BLOCK_LAYER);
			// -- --
			mapMaster_fill(360,120,400,120,"IceWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "iceDoor3", 440, 120, -1, -1, ACTION_LAYER);
			mapMaster_fill(480,120,520,120,"IceWall",BLOCK_LAYER);
			// -- --
			mapMaster_fill(360,200,400,200,"IceWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "iceDoor4", 440, 200, -1, -1, ACTION_LAYER);
			mapMaster_fill(480,200,520,200,"IceWall",BLOCK_LAYER);
			// -- --
			mapMaster_fill(360,280,400,280,"IceWall",BLOCK_LAYER);
			MapMaster.addDoor("BrennenDoor", "iceDoor5", 440, 280, -1, -1, ACTION_LAYER);
			mapMaster_fill(480,280,520,280,"IceWall",BLOCK_LAYER);

			if ( SaveMaster.isComplete( "iceMegaTreasure1" ) 
				|| SaveMaster.isComplete( "iceMegaTreasure2" )
				|| SaveMaster.isComplete( "iceMegaTreasure3" ) )
				mapMaster_addScenery("WarpDestination","", 440,40,-1,-1,BLOCK_LAYER);
			else
				MapMaster.addWarp( "Teleport", "", 440, 40, -1, -1, ACTION_LAYER, "icec10", "center", 41, 41 );
			MapMaster.addWarp( "Teleport", "", 520, 160, -1, -1, ACTION_LAYER, "icec13", "center", 41, 161 );
			mapMaster_addScenery("WarpDestination","", 40,160,-1,-1,BLOCK_LAYER);
			mapMaster_addSaveItem( "Energy", "iceEnergy1", 520,240, -1, -1, ACTION_LAYER );

			nextMap[LEFT]			= "icec11";
			break;
		}
		case "icec14" :
		{
			mapMaster_fillEdge( "IceWall", "top" );
			mapMaster_fillEdge( "IceWall", "right" );
			mapMaster_fillEdge( "IceWall", "left" );
			//bottom
			mapMaster_fill(0,360,120,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(240,360,560,360,"IceWall",BLOCK_LAYER);
			//bottom
			mapMaster_fill(120,280,120,320,"IceWall",BLOCK_LAYER);
			mapMaster_fill(240,280,240,320,"IceWall",BLOCK_LAYER);
			MapMaster.addFloorTrigger(160,280,200,280, 160,360,200,360); 

			mapMaster_addActor( "Ballista", "", 40, 40, -1, -1, SKY_LAYER );
			mapMaster_addActor( "Ballista", "", 40, 200, -1, -1, SKY_LAYER );
			mapMaster_addActor( "Ballista", "", 40, 320, -1, -1, SKY_LAYER );
			mapMaster_fill(40,40,40,320,"BallistaTrack",BLOCK_LAYER);

			mapMaster_addActor( "MrGrumbles", "", 400, 140, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 40, 140, -1, -1, ACTION_LAYER );
			mapMaster_addActor( "SlideMon", "", 520, 140, -1, -1, ACTION_LAYER );

			mapMaster_addSaveItem( "SkeletonKey", "iceKey3", 520, 320, -1, -1, ACTION_LAYER );

			nextMap[DOWN]			= "icec11";
			break;
		}
		case "icec15" :
		{
			mapMaster_fillEdge( "IceWall", "bottom" );
			mapMaster_fillEdge( "IceWall", "left" );

			//top
			mapMaster_fill(0,0,200,0,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,0,560,0,"IceWall",BLOCK_LAYER);
			//right
			mapMaster_fill(560,40,560,240,"IceCube",BLOCK_LAYER);

			//jmljml
			if ( ! SaveMaster.isComplete( "iceking" ) )
			{
				//2/16/2006
				MapMaster.playMusic( "advboss" );

				mapMaster_addBlock( "BubbleWall2", "destroyWall", 240, 0, -1, -1, BLOCK_LAYER );
				_root.board.destroyWall.attachMovie("BubbleWall2", "dw2", layerMaster_use(BLOCK_LAYER), {_x:40, _y:0 } );
				_root.board.destroyWall.attachMovie("BubbleWall2", "dw3", layerMaster_use(BLOCK_LAYER), {_x:80, _y:0 } );

				var iceking = MapMaster.addPerson("IceKing","c26", 80, 80,-1,-1,ACTION_LAYER);
				iceking.stop();
			}


			nextMap[RIGHT]			= "icec11";
			nextMap[UP]				= "icec16";
			break;
		}
		case "icec16" :
		{
			mapMaster_fillEdge( "IceWall", "top" );
			mapMaster_fillEdge( "IceWall", "right" );
			mapMaster_fillEdge( "IceWall", "left" );
			//bottom
			mapMaster_fill(0,360,200,360,"IceWall",BLOCK_LAYER);
			mapMaster_fill(360,360,560,360,"IceWall",BLOCK_LAYER);

			mapMaster_addItem( "Ice", "", 100, 240, -1, -1, BLOCK_LAYER );
			mapMaster_addItem( "Ice", "", 140, 240, -1, -1, BLOCK_LAYER );
			mapMaster_addItem( "Ice", "", 180, 240, -1, -1, BLOCK_LAYER );
			mapMaster_addItem( "Ice", "", 220, 240, -1, -1, BLOCK_LAYER );
			mapMaster_addItem( "Ice", "", 260, 240, -1, -1, BLOCK_LAYER );

			MapMaster.addWarp( "Teleport", "", 280, 120, -1, -1, ACTION_LAYER, "icec01", "center", 280, 140 );

			//2/16/2006
			MapMaster.addPerson( "Yezmo", "c28", 300, 165, -1, -1, ACTION_LAYER ).interact();

			nextMap[DOWN]			= "icec15";
			break;
		}
	}
	switch ( screenName )
	{
		case "icec05" :
		{
			nextMap[UP]			= "icec05";
			nextMap[DOWN]		= "icec02";
			nextMap[LEFT]		= "icec05";
			nextMap[RIGHT]		= "icec06";
			break;
		}
		case "icec06" :
		{
			nextMap[UP]			= "icec05";
			nextMap[DOWN]		= "icec02";
			nextMap[LEFT]		= "icec05";
			nextMap[RIGHT]		= "icec07";
			break;
		}
		case "icec07" :
		{
			nextMap[UP]			= "icec05";
			nextMap[DOWN]		= "icec02";
			nextMap[LEFT]		= "icec08";
			nextMap[RIGHT]		= "icec05";
			break;
		}
		case "icec08" :
		{
			nextMap[UP]			= "icec09";
			nextMap[DOWN]		= "icec02";
			nextMap[LEFT]		= "icec05";
			nextMap[RIGHT]		= "icec05";
			break;
		}
	}
}
