
/*================================================================
Screen size.
================================================================
size 14 sprites suck.  Let's see if we can get to 16.
Cell phone is
		128
	  +-------+
	  |       |
	  |       |
  160 |pixels |
	  |       |
	  +-------+

160 / 16 = 10
128 / 16 = 8

		  8
	  +-------+
	  |       |
	  |       |
   10 |squares|
	  |       |
	  +-------+

To make the map nice and centered, the top column will be:
8 pix, 16 pix, 16 pix, 16 pix, 16 pix, 16 pix, 16 pix, 16 pix, 8 pix = 128
or
.5 sq, 1 sq, 1 sq, 1 sq, 1 sq, 1 sq, 1 sq, 1 sq, .5 sq, = 9 visable squares ( 2 only .5 visable)
Vertically, we will do the same thing with 2 extra columns at the bottom.

================================================================
Map generation and creation
================================================================
The terrain map is just a 2d array of numbers that represent 
different terrain elements.  See terrain.as for the number/terrain.
Here is an example:
    terrain          number        color
	desert           1             0xFF0066
	plains           2             0x99CC66
Now, I want to create maps in 2 ways.
1. Bitmap Creation
------------------
a. Using paint or photoshop, create a map using the appropriate colors.
b. create a perl program to convert the colors into the 2d actionscript
	array syntax.
c. Copy the array syntax into mapmaster.
2. Random Generation
--------------------
a. create a 2d array.
b. create a strip of plains that is longer than 9 squares in the center.
	this is so that there is enough room to move off the screen and 
	the starting point is not just a small island.
c. find random points in the array to put a mountain, hill, desert, etc.
d. Now work into the array until an element is found.
	If the element is a desert, the square next to it is mor probable to
	be a desert.  Plains are probably, but snow is not.
e. keep filling the array until it is full.
f. towns and caves will have to be put on squares that are not blocks
	(mountains, and ocean).
g. In order to play these types of maps, the user will have to buy boats
	and bridges.  I do not know how to keep the boat from being landlocked
	unless the boat is a canoe that you can take with you.  Amphibious vehicle?
3. Map display
--------------
a. I have not looked into it so much, but I think Actionscript for flash 6
	has drawing tools.  The 2d array can be converted from terrain numbers
	to color numbers and then use the color numbers to draw a single pixel
	for each square of the map.  That way the player has a world map to 
	look at.
================================================================*/

MapMaster = function()
{
   //no instance variables.
};

MapMaster.terrainLayer = new Array();
MapMaster.music = "adventure1";
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);
MapMaster.terrainLayer.push([0,1,2,3,4,5,6,7,8]);

MapMaster.initialize = function()
{
	// MapMaster should really be a subclass of sprite which has vx, vy, speed, etc.
	_root.MapMaster.speed=4; // Change hero speed too.
	_root.MapMaster.vx=0;
	_root.MapMaster.vy=0;
};

function mapMaster_setScreenFromMap()
{
	for (iy = 0; iy < MapMaster.terrainLayer.length; iy++ )
	{
		for (ix = 0; ix < MapMaster.terrainLayer[iy].length; ix++ )
		{
			var terrainString = Terrain.terrainNumberToString( MapMaster.terrainLayer[iy][ix] );
			trace( "setSCreenFromMap: ix " + ix + " iy " + iy + " ter " + terrainString );
			mapMaster_add( terrainString, "", (ix * 16) -8, (iy * 16) - 8, -1, -1, TERRAIN_LAYER );
		}
	}
	mapMaster_add( "cellPhoneFrame", "", 0, 0, -1, -1, DISPLAY_LAYER );
};

/*
	for (iy = 0; iy < MapMaster.terrainLayer.length && curMapY == -1; iy++ )
	{
		//trace("iy"+iy);
		for (ix = 0; ix < MapMaster.terrainLayer[iy].length && curMapY == -1; ix++ )
		{
			//trace("ix"+ix+" screen " + MapMaster.terrainLayer[iy][ix] );
			if ( MapMaster.terrainLayer[iy][ix] == screenName )
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
		// We found the screenName in the terrainLayer array.
		nextMap[UP]		= MapMaster.terrainLayer[curMapY-1][curMapX];
		nextMap[RIGHT]	= MapMaster.terrainLayer[curMapY][curMapX+1];
		nextMap[DOWN]	= MapMaster.terrainLayer[curMapY+1][curMapX];
		nextMap[LEFT]	= MapMaster.terrainLayer[curMapY][curMapX-1];
		trace("nextMap[UP]		= "+nextMap[UP]);
		trace("nextMap[RIGHT]	= "+nextMap[RIGHT]);
		trace("nextMap[DOWN]	= "+nextMap[DOWN]);
		trace("nextMap[LEFT]	= "+nextMap[LEFT]);
	}
	else
	{
		// We did not find the screenName in the terrainLayer array.
		trace("  Warning: You must explicitly set your nextMap array for screen " + screenName + "." );
	}
*/

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
};
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
};

function mapMaster_clearScreen()
{
	trace("clear screen");

	
	// 2/25/2006 todo clear the first and second layer.
	// Keep play on the 3rd layer
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
};

function mapMaster_fillEdge( object, side )
{
	switch ( side )
	{
		case "left" :
		{
			mapMaster_fill( 0, 0, 0, 360, object, TOWN_LAYER )
			break;
		}
		case "right" :
		{
			mapMaster_fill( 560, 0, 560, 360, object, TOWN_LAYER )
			break;
		}
		case "top" :
		{
			mapMaster_fill( 0, 0, 560, 0, object, TOWN_LAYER )
			break;
		}
		case "bottom" :
		{
			mapMaster_fill( 0, 360, 560, 360, object, TOWN_LAYER )
			break;
		}
	}
};


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
		var blockLayer = layerMaster_use(TOWN_LAYER);
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
};

function mapMaster_add( object, tag, x, y, w, h, layer )
{
	var uniqueLayer = layerMaster_use(layer);
	var addToBoard = false;
	if ( tag == "" )
		tag = object + uniqueLayer;
	var bizzle;
	if ( layer <= SKY_LAYER )
	{
		addToBoard = true;
		bizzle = _root.board.attachMovie(object, tag, uniqueLayer, {_x:x, _y:y } );
	}
	else
	{
		bizzle = _root.attachMovie(object, tag, uniqueLayer, {_x:x, _y:y } );
	}
	if ( h != -1 )
		bizzle._height = h;
	if ( w != -1 )
		bizzle._width = w;
	trace( "adding " + object + uniqueLayer + " @ x:" + x + " y: " + y + " h:" + bizzle._height + " w: " + bizzle._width + " added to board? " + addToBoard );
	return bizzle;
};

function mapMaster_addActor( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	bizzle.defaultInit();
	activeList_addActor( bizzle );
	return bizzle;
};

function mapMaster_addActiveScenery( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	activeList_addScenery( bizzle );
	return bizzle;
};

function mapMaster_addScenery( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );

	if ( object == "PineTree" )
	{
		mapMaster_addBlock("Block","", x,y,40,60,TOWN_LAYER);
	}

	return bizzle;
};

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
};

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
};

MapMaster.addFloorTrigger = function( ftx1, fty1, ftx2, fty2, dx1, dy1, dx2, dy2 )
{
	// ftx is floor trigger x
	// dx is door x
	// This function adds floor triggers, animates them and adds a door.  40x40 only.
	MapMaster.floorTriggerNum++;

	mapMaster_fill(ftx1,fty1,ftx2,fty2,"FloorTrigger",TOWN_LAYER);
	var floorTriggerBlock1 = mapMaster_addBlock("Block","",ftx1+15,fty1+15,ftx2-ftx1+10,fty2-fty1+10,TOWN_LAYER);
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
		mapMaster_fill(dx1,dy1,dx2,dy2,"BubbleWall2",TOWN_LAYER);
		var doogis = mapMaster_addBlock("Block","",dx1,dy1,dx2-dx1+40,dy2-dy1+40,TOWN_LAYER);
		doogis.removeWhenBeatAllMonsters=true;
	};

};

function mapMaster_addItem( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	bizzle.realName = object;
	activeList_addItem( bizzle );
	return bizzle;
};

function mapMaster_addWeapon( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, "weapon", x, y, w, h, ACTION_LAYER );
	bizzle.realName = object;
	bizzle._visible = false;
	_root.board.hero.equipWeapon( object );
	return bizzle;
};

function mapMaster_addBlock( object, tag, x, y, w, h, layer )
{
	var bizzle = mapMaster_add( object, tag, x, y, w, h, layer );
	if ( object == "Block" )
		bizzle._visible = false;
	activeList_addBlock( bizzle );
	return bizzle;
};

MapMaster.addDoor = function( mc, tag, x, y, w, h, layer )
{
	if ( mc == "BrennenDoor" )
	{
		var theDoor = mapMaster_addScenery("BrennenDoor", tag, x - 10, y, -1, -1, ACTION_LAYER);
		mapMaster_addScenery( "BlackDoor", "", x, y, 40, 40, TOWN_LAYER );
		if ( SaveMaster.isComplete( tag ) )
		{
			theDoor.gotoAndPlay(2);
		}
		else
		{
			doorBlock = mapMaster_addBlock( "Block", "", x, y, 40, 40, TOWN_LAYER );
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
	for ( jx = 0; jx < 128; jx += 14 )
	{
		for ( jy = 0; jy < 160; jy += 14 )
		{
			mapMaster_addScenery( tile, "", jx, jy, -1, -1, TERRAIN_LAYER );
		}
	}
};

MapMaster.islandBackground = function()
{
	MapMaster.bigTileBackground( "plains", "", 0, 0, -1, -1, TERRAIN_LAYER );
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
};

function mapMaster_loadIsland( screenName )
{
	//2/16/2006
	MapMaster.playMusic( "advover1" );

	// grass
	MapMaster.islandBackground();
	switch ( screenName )
	{
		case "island7" :
		{

			// bottom side
			mapMaster_fillEdge( "Water", "bottom" );

			// save location
			mapMaster_addItem( "Diskette", "", 240, 60, -1, -1, ACTION_LAYER );

			// upper right corner.
			mapMaster_fill(560,0,560,0,"BrennenRock",TOWN_LAYER);

			//right fence
			mapMaster_fill(0,0,0,240,"Fence",TOWN_LAYER);

			MapMaster.addPerson( "Whammy", "c1", 300, 300, -1, -1, ACTION_LAYER )
			// start conversation with whammy
			// (note: don't c1.clear() -- allow it to persist.)
			if ( ! SaveMaster.isComplete( "tutorial" ) )
				_root.board.Whammy.interact();
			SaveMaster.complete("tutorial");

			mapMaster_add( "skeleton", "", 1*16, 1*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "ghoul", "", 1*16, 2*16, -1, -1, ACTION_LAYER );

			mapMaster_add( "grassland", "", 2*16, 1*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "grassland", "", 3*16, 1*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "desert", "", 3*16, 2*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "desert", "", 3*16, 2*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 0, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 1*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 2*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 3*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 4*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 5*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 6*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 7*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 8*16, 0, -1, -1, ACTION_LAYER );
			mapMaster_add( "hill", "", 9*16, 0, -1, -1, ACTION_LAYER );

			mapMaster_add( "town", "", 1*16, 3*16, -1, -1, ACTION_LAYER );

			mapMaster_add( "mountain", "", 2*16, 3*16, -1, -1, ACTION_LAYER );

			mapMaster_add( "ocean", "", 3*16, 3*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "ocean", "", 3*16, 5*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "ocean", "", 3*16, 3*16, -1, -1, ACTION_LAYER );
			mapMaster_add( "ocean", "", 3*16, 5*16, -1, -1, ACTION_LAYER );

			mapMaster_add( "goblin", "", 4*16, 3*16, -1, -1, ACTION_LAYER );

			mapMaster_add( "pines", "", 1*16, 6*16, -1, -1, ACTION_LAYER );

			mapMaster_add( "cellPhoneFrame", "", 0, 0, -1, -1, SKY_LAYER );

			break;
		}
	}
};

