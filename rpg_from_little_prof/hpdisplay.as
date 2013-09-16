
function createHPDisplay()
{
	trace("hp display");
	_root.attachMovie("HPPanel", "panel1", layerMaster_use(DISPLAY_LAYER), {_x:500, _y:10 } );
	_root.panel1.stop();
	_root.panel1.attachMovie("RedSquare", "bar", layerMaster_use(DISPLAY_LAYER), {_x:20, _y:6 } );
	_root.panel1.bar._height = 7;
	_root.panel1.bar._width = 44;

	_root.panel1.createTextField( "number", layerMaster_use(DISPLAY_LAYER), 50, 0, 60, 20 );
	_root.panel1.number.text = _root.board.hero.hp; // + " of " + _root.board.hero.maxHP;
	_root.panel1.number.textColor = 0xFFFFFF;
	//_root.panel1.hp.border = true;
	//_root.panel1.hp.borderColor = 0xFFFFFF;
	//_root.panel1.hp.background = true;
	//_root.panel1.hp.backgroundColor = 0x000000;

}

function updateHPDisplay( newHP )
{
	if ( newHP < 3 )
	{
		_root.panel1.gotoAndPlay(1);
	}
	else
	{
		_root.panel1.gotoAndPlay(1);
		_root.panel1.stop();
	}

	_root.panel1.number.text = newHP; //+ " of " + _root.hero.maxHP;
	
	_root.panel1.bar._width = ( _root.board.hero.hp / _root.board.hero.maxHP ) * 44;
}

function createInvDisplay()
{
	trace("inv display");
	_root.attachMovie("DisplayField", "panel2", layerMaster_use(DISPLAY_LAYER), {_x:10, _y:140 } );
	_root.panel2.attachMovie("SkeletonKey", "skey", layerMaster_use(DISPLAY_LAYER), {_x:1, _y:1 } );
	_root.panel2.skey._width = 16;
	_root.panel2.skey._height = 16;
	_root.panel2.createTextField( "skeycount", layerMaster_use(DISPLAY_LAYER), 18, 1, 18, 16 );
	_root.panel2.skeycount.text = Inventory_getQty( "SkeletonKey" );
	_root.panel2.skeycount.textColor = 0xFFFFFF;
	_root.panel2.attachMovie("Gold", "gold", layerMaster_use(DISPLAY_LAYER), {_x:32, _y:1 } );
	_root.panel2.gold._width = 16;
	_root.panel2.gold._height = 16;
	_root.panel2.createTextField( "goldcount", layerMaster_use(DISPLAY_LAYER), 48, 1, 60, 16 );
	_root.panel2.goldcount.text = Inventory_getQty( "Gold" );
	_root.panel2.goldcount.textColor = 0xFFFFFF;
}

function updateGoldDisplay()
{
	_root.panel2.goldcount.text = Inventory_getQty( "Gold" );
}

function updateKeyDisplay()
{
	_root.panel2.skeycount.text = Inventory_getQty( "SkeletonKey" );
}

function createMapDisplay()
{
	trace("map display");
	_root.createTextField( "mapDisplay", layerMaster_use(DISPLAY_LAYER), 520, 355, 60, 20 );
	_root.mapDisplay.background = true;
	_root.mapDisplay.backgroundColor = 0x000000;
	_root.mapDisplay.text = "MAP";
	_root.mapDisplay.textColor = 0xFFFF66;
}

function updateMapDisplay( newMap )
{
	trace("map display" + newMap);
	_root.mapDisplay.text = newMap;
}

function createLocDisplay()
{
	_root.createTextField( "locDisplay", layerMaster_use(DISPLAY_LAYER), 520, 375, 60, 20 );
	_root.locDisplay.background = true;
	_root.locDisplay.backgroundColor = 0x000000;
	_root.locDisplay.text = "location";
	_root.locDisplay.textColor = 0x66FFFF;
}

function updateLocDisplay()
{
	_root.locDisplay.text = "x:"+_root.board.hero._x+"y:"+_root.board.hero._y;
}
