
var backPack = new Array();
var backPackSize = 3;
var inventory = new Object();
var weaponList = new Array();
var weaponHelp = new Array();
var cursorIndex = 0;
var cursorY = "weapon";
var cursorList;
var backPackDisplayList = new Array();

function Inventory_addToBackPack( item )
{
	trace( "Add " + item + " to back pack.  Size " + backPack.length + " max size " + backPackSize + "." );
	if ( backPack.length >= backPackSize )
	{
		return false;
	}
	else
	{
		backPack.push( item );
		return true;
	}
};

function Inventory_removeFromBackPack( item )
{
	for ( var idx = 0; idx < backPack.length; idx ++ )
	{
		if ( backPack[idx] == item )
		{
			backPack.splice(idx,1);
			trace( "remove " + item )
			break;
		}
	}
};

function Inventory_backPackIsFull()
{
	return ( backPack.length >= backPackSize );
}

function Inventory_add( item )
{
	//trace( "item.realName: " + item.realName );

	inventory[ item ] = inventory[ item ] + 1;
	updateKeyDisplay();
	updateGoldDisplay();
	SaveMaster.saveAll();
	trace( "We gots " + item + " qty: " + inventory[ item ] );
}

function Inventory_check( itemString )
{
	trace( "Do we have a " + itemString + "? :" + (inventory[itemString] > 0 ) );
	return (inventory[itemString] > 0 );
}

function Inventory_getQty( itemString )
{
	var qty = ( inventory[itemString] == undefined ) ? 0 : inventory[itemString];
	trace( "We have " + itemString + " = " + qty );
	return qty;
}

function Inventory_removeOne( itemString )
{
	Inventory_remove( itemString, 1 );
}

function Inventory_remove( itemString, qty )
{
	trace( "Remove " + qty + " " + itemString + " from inventory" );
	inventory[itemString] = inventory[itemString] - qty;
	updateKeyDisplay();
	updateGoldDisplay();
	SaveMaster.saveAll();
}

function Inventory_showInventory()
{
	_root.board.attachMovie( "Inventory", "inventory", layerMaster_use(SKY_LAYER) );
	_root.board.inventory._y = 100;

	_root.board.inventory.createTextField( "status", layerMaster_use(SKY_LAYER), 20, 80, 360, 20 );
	_root.board.inventory.status.border = false;
	_root.board.inventory.status.background = false;
	_root.board.inventory.status.textColor = 0x000000;
	_root.board.inventory.status.text = SaveMaster.getPlayerName() + ".  Energy: " + _root.board.hero.hp + "/" +
		_root.board.hero.maxHP + ".  Back pack holds " + backPackSize + " items.";

	_root.board.inventory.attachMovie( "Gold", "Gold", layerMaster_use(SKY_LAYER), {_x:20, _y:110 } );
	_root.board.inventory.attachMovie( "SkeletonKey", "SkeletonKey", layerMaster_use(SKY_LAYER), {_x:20, _y:150 } );
	_root.board.inventory.attachMovie( "Melon", "Melon", layerMaster_use(SKY_LAYER), {_x:20, _y:190 } );
	_root.board.inventory.attachMovie( "Mushroom1", "Mushroom1", layerMaster_use(SKY_LAYER), {_x:20, _y:230 } );

	_root.board.inventory.createTextField( "golds", layerMaster_use(SKY_LAYER), 80, 110, 60, 20 );
	_root.board.inventory.golds.border = false;
	_root.board.inventory.golds.background = false;
	_root.board.inventory.golds.textColor = 0x000000;
	_root.board.inventory.golds.text = Inventory_getQty( "Gold" );

	_root.board.inventory.createTextField( "keys", layerMaster_use(SKY_LAYER), 80, 150, 60, 20 );
	_root.board.inventory.keys.border = false;
	_root.board.inventory.keys.background = false;
	_root.board.inventory.keys.textColor = 0x000000;
	_root.board.inventory.keys.text = Inventory_getQty( "SkeletonKey" );

	_root.board.inventory.createTextField( "melons", layerMaster_use(SKY_LAYER), 80, 190, 60, 20 );
	_root.board.inventory.melons.border = false;
	_root.board.inventory.melons.background = false;
	_root.board.inventory.melons.textColor = 0x000000;
	_root.board.inventory.melons.text = Inventory_getQty( "Melon" );

	_root.board.inventory.createTextField( "mushroom1s", layerMaster_use(SKY_LAYER), 80, 230, 60, 20 );
	_root.board.inventory.mushroom1s.border = false;
	_root.board.inventory.mushroom1s.background = false;
	_root.board.inventory.mushroom1s.textColor = 0x000000;
	_root.board.inventory.mushroom1s.text = Inventory_getQty( "Mushroom1" );

	// Weapon List (or items that you can use)

	cursorIndex = 0;
	weaponList.splice(0);
	weaponHelp.splice(0);
	backPackDisplayList.splice(0);

	if ( inventory["wand"] == 1 )
	{
		_root.board.inventory.attachMovie( "Wand", "Wand", layerMaster_use(SKY_LAYER), {_x:140, _y:110 } );
		weaponList.push( _root.board.inventory.Wand );
		weaponHelp.push( "Magic wand." );
	}
	if ( inventory["Sword"] == 1 )
	{
		_root.board.inventory.attachMovie( "Sword", "Sword", layerMaster_use(SKY_LAYER), {_x:180, _y:110 } );
		weaponList.push( _root.board.inventory.Sword );
		weaponHelp.push( "Sword." );
	}
	cursorList = weaponList;
	cursorY = "weapon";

	for ( j=0; j < weaponList.length; j++ )
	{
		if ( weaponList[j]._name == _root.board.weapon.realName )
		{
			_root.board.inventory.attachMovie( "Equiped", "Equiped", layerMaster_use(SKY_LAYER) );
			_root.board.inventory.Equiped._x = weaponList[j]._x;
			_root.board.inventory.Equiped._y = weaponList[j]._y + 20;
			break;
		}
	}

	for ( j=0; j < backPack.length; j++ )
	{
		temp = _root.board.inventory.attachMovie( backPack[j], "bp"+j, layerMaster_use(SKY_LAYER) );
		temp._x = ( j * 40 + 160);
		temp._y = 240;
		backPackDisplayList.push(temp);
	}
	_root.board.inventory.attachMovie( "SquareCursor", "cursor", layerMaster_use(SKY_LAYER), {_x:140, _y:110 } );
	Inventory_moveCursor();
}
function Inventory_equipWeapon()
{
	trace( "Equip " + weaponList[ cursorIndex ]._name );
	mapMaster_addWeapon(weaponList[ cursorIndex ]._name, "weapon", 0,0, -1,-1, HERO_LAYER );
	_root.board.inventory.Equiped._x = weaponList[cursorIndex]._x;
	_root.board.inventory.Equiped._y = weaponList[cursorIndex]._y + 20;
}

function Inventory_useItem()
{
	item = backPack[ cursorIndex ];
	trace( "Use " + item );
	switch ( item )
	{
		case "Potion" :
			_root.board.hero.healUp();
			Inventory_removeFromBackPack( item );
			_root.togglePause();
			break;
		case "Trinket" :
			trace("Time for invincible music!");
			_root.board.hero.startFlickering2( 120 );
			Inventory_removeFromBackPack( item );
			_root.togglePause();
			break;
	}

}

function Inventory_moveCursor()
{
//	trace("move cursor");
//	trace(_root.board.inventory.cursor);
//	trace(_root.board.inventory.cursor._x);
	trace(cursorList[cursorIndex]);
	_root.board.inventory.cursor._x = cursorList[cursorIndex]._x - 1;
	_root.board.inventory.cursor._y = cursorList[cursorIndex]._y - 1;
	if ( cursorY == "item" && backPack[cursorIndex] == "Trinket" )
	{
		_root.board.inventory.cursor._height = 42;
		_root.board.inventory.cursor._width = 42;
	}
	else
	{	
		_root.board.inventory.cursor._height = cursorList[cursorIndex]._height + 2;
		_root.board.inventory.cursor._width = cursorList[cursorIndex]._width + 2;
	}
}
function Inventory_incrementCursorIndex()
{
	cursorIndex++;
	if ( cursorIndex >= cursorList.length )
		cursorIndex = 0;
}
function Inventory_decrementCursorIndex()
{
	cursorIndex--;
	if ( cursorIndex < 0 )
		cursorIndex = cursorList.length - 1;
}

function Inventory_hideInventory()
{
	_root.board.inventory.removeMovieClip();
}

function processInventoryControls( keyCode )
{
	switch( KeyCode )
	{
		case Key.UP :
		case Key.DOWN :
			cursorY = ( cursorY == "weapon")? "item":"weapon";
			cursorIndex = 0;
			if ( cursorY == "weapon" )
				cursorList = weaponList;
			else
				cursorList = backPackDisplayList;
			Inventory_moveCursor();
			break;
		case Key.LEFT :
			Inventory_decrementCursorIndex();
			Inventory_moveCursor();
			break;
		case Key.RIGHT :
			Inventory_incrementCursorIndex();
			Inventory_moveCursor();
			break;
		case Key.SPACE :
			if ( cursorY == "weapon" )
				Inventory_equipWeapon();
			else
				Inventory_useItem();
			break;
		default :
			_root.togglePause();
			break;
	}
	trace( "y " + cursorY + " x " + cursorIndex + " len " + cursorList.length );
}


