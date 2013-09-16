
function createHPDisplay()
{
	trace("hp display");
	_root.board.attachMovie("HPPanel", "panel1", USE_HP_LAYER, {_x:500, _y:10 } );
	_root.board.panel1.stop();
	_root.board.panel1.attachMovie("RedSquare", "bar", USE_HP_LAYER+1, {_x:20, _y:6 } );
	_root.board.panel1.bar._height = 7;
	_root.board.panel1.bar._width = 44;

	_root.board.panel1.createTextField( "number", USE_HP_LAYER+2, 50, 0, 60, 20 );
	_root.board.panel1.number.text = _root.board.hero.hp; // + " of " + _root.board.hero.maxHP;
	_root.board.panel1.number.textColor = 0xFFFFFF;
	//_root.board.panel1.hp.border = true;
	//_root.board.panel1.hp.borderColor = 0xFFFFFF;
	//_root.board.panel1.hp.background = true;
	//_root.board.panel1.hp.backgroundColor = 0x000000;

}

function updateHPDisplay( newHP )
{
	if ( newHP < 3 )
	{
		_root.board.panel1.gotoAndPlay(1);
	}
	else
	{
		_root.board.panel1.gotoAndPlay(1);
		_root.board.panel1.stop();
	}

	_root.board.panel1.number.text = newHP; //+ " of " + _root.board.hero.maxHP;
	
	_root.board.panel1.bar._width = ( _root.board.hero.hp / _root.board.hero.maxHP ) * 44;
}

function createInvDisplay()
{
	trace("inv display");
	_root.board.attachMovie("DisplayField", "panel2", USE_HP_LAYER+3, {_x:10, _y:10 } );
	_root.board.panel2.attachMovie("SkeletonKey", "skey", USE_HP_LAYER+4, {_x:1, _y:1 } );
	_root.board.panel2.skey._width = 16;
	_root.board.panel2.skey._height = 16;
	_root.board.panel2.createTextField( "skeycount", USE_HP_LAYER+7, 18, 1, 18, 16 );
	_root.board.panel2.skeycount.text = Inventory_getQty( "SkeletonKey" );
	_root.board.panel2.skeycount.textColor = 0xFFFFFF;
	_root.board.panel2.attachMovie("Gold", "gold", USE_HP_LAYER+8, {_x:32, _y:1 } );
	_root.board.panel2.gold._width = 16;
	_root.board.panel2.gold._height = 16;
	_root.board.panel2.createTextField( "goldcount", USE_HP_LAYER+9, 48, 1, 60, 16 );
	_root.board.panel2.goldcount.text = Inventory_getQty( "Gold" );
	_root.board.panel2.goldcount.textColor = 0xFFFFFF;
}

function updateGoldDisplay()
{
	_root.board.panel2.goldcount.text = Inventory_getQty( "Gold" );
}

function updateKeyDisplay()
{
	_root.board.panel2.skeycount.text = Inventory_getQty( "SkeletonKey" );
}

function createMapDisplay()
{
	trace("map display");
	_root.board.createTextField( "mapDisplay", USE_HP_LAYER+5, 520, 355, 60, 20 );
	_root.board.mapDisplay.background = true;
	_root.board.mapDisplay.backgroundColor = 0x000000;
	_root.board.mapDisplay.text = "MAP";
	_root.board.mapDisplay.textColor = 0xFFFF66;
}

function updateMapDisplay( newMap )
{
	trace("map display" + newMap);
	_root.board.mapDisplay.text = newMap;
}

function createLocDisplay()
{
	_root.board.createTextField( "locDisplay", USE_HP_LAYER+6, 520, 375, 60, 20 );
	_root.board.locDisplay.background = true;
	_root.board.locDisplay.backgroundColor = 0x000000;
	_root.board.locDisplay.text = "location";
	_root.board.locDisplay.textColor = 0x66FFFF;
}

function updateLocDisplay()
{
	_root.board.locDisplay.text = "x:"+_root.board.hero._x+"y:"+_root.board.hero._y;
}
