
/* from here XXX to the next XXX is bolsolete I THINK!


var itemList = new Array();

// rewrite: Curse me for this evil implementation.  I repent!

// Adding a new Item?
// 1. Add it to the itemList.  Sort by most common first.  That will speed up searches.
// 2. If it is a monster bonus item, add it to the Item_randomMonsterItem function.
// 3. If it is an item that goes in inventory, change inventoryItemList.
itemList = [ "Gold", "Heart", "SkeletonKey", "Treasure", "Melon", "Mushroom1" ];

function Item_isAnItem( object )
{
	isAnItem = false;

	for ( itemIdx = 0; itemIdx < itemList.length; itemIdx++ )
	{
		//trace( object._name + " " + itemList[itemIdx] );
		// If the item at the index matches the name of the object...
		if ( object._name.indexOf( itemList[itemIdx] ) == 0 )
		{
			isAnItem = true;

			// rewrite: ?  This is a real hack right here.
			object.realName = itemList[itemIdx];

			break;
		}
	}

	return isAnItem;
}
XXX*/

function Item_pickUp( item )
{
	var itemName = item.realName;

	switch ( itemName )
	{
		case "Gold" : 
			Inventory_add( itemName );
			Item_remove( item );
			break;
		case "Heart" :
			_root.board.hero.incrementHP();
			Item_remove( item );
			trace("HP++");
			break;
		case "SkeletonKey" : 
		case "Melon" : 
		case "Mushroom1" : 
			Inventory_add( itemName );
			Item_remove( item );
			break;
		case "Ice" : 
		case "Tire" : 
			item.kick();
			break;
		case "Treasure" : 
			// rewrite:
			Inventory_add( "Gold" );
			Inventory_add( "Gold" );
			Item_remove( item );
			break;
		case "Energy" :
			_root.board.hero.maxHP++;
			SaveMaster.saveMaxHP( _root.board.hero.maxHP );
			_root.board.hero.incrementHP();
			Item_remove( item );
			trace("HPMAX++");
			break;
		case "Diskette" : 
			SaveMaster.saveLocation( MapMaster.currentMap );
			Item_remove( item );
			break;
		case "Potion" :
		case "Trinket" :
		{
			if ( Inventory_addToBackPack( itemName ) )
			{
				Item_remove( item );
			}
			else
			{
				trace("The backpack is full.");
			}
			break;
		}
		case "Sword" : 
			//equip the sword when it is picked up.
			mapMaster_addWeapon("Sword", "weapon", 0,0, -1,-1, ACTION_LAYER );
			Inventory_add( itemName );
			Item_remove( item );
			break;
		case "FireBook" : 
			//equip the wand when it is picked up.
			mapMaster_addWeapon("Wand", "weapon", 0,0, -1,-1, ACTION_LAYER );
			Inventory_add( itemName );
			Item_remove( item );
			break;
		case "IceBook" : 
			//equip the wand when it is picked up.
			//mapMaster_addWeapon("Wand", "weapon", 0,0, -1,-1, ACTION_LAYER );
			Inventory_add( itemName );
			Item_remove( item );
			break;
	}
}

function Item_remove( item )
{
	SaveMaster.completeMC( item );
	_root.pickupSound.start();
	activeList_removeItem( item );
	item.removeMovieClip();
}

/*
function Item_isInventory( object )
{
	isInventory = false;

	for ( itemIdx = 0; itemIdx < inventoryItemList.length; itemIdx++ )
	{
		//trace( object._name + " " + itemList[itemIdx] );
		// If the item at the index matches the name of the object...
		if ( object._name.indexOf( inventoryItemList[itemIdx] ) == 0 )
		{
			isInventory = true;

			// rewrite: ?  This is a real hack right here.
			object.realName = inventoryItemList[itemIdx];

			break;
		}
	}

	return isInventory;
}
*/

function Item_randomMonsterItem()
{
	var itemName;

	var itemOccurance = Math.randRange(1,16);

	switch ( itemOccurance )
	{
		case 1:
			itemName = "Treasure";
			break;
		case 2:
			itemName = "Melon";
			break;
		case 3:
			itemName = "Mushroom1";
			break;
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
			itemName = "Heart";
			break;
		default:
			itemName = "Gold";
			break;
	}
	//trace ( "itemName + " + itemOccurance + " " + itemName );

	return itemName;
}

/*
function Item()
{

}

Item.prototype = new Sprite();

Item.prototype.attach = function()
{
	var layer = layerMaster_use(ACTION_LAYER);
	_root.board.attachMovie(this.movieName, this.itemName + layer, layer, {_x:this._x, _y:this._y } );

Object.registerClass("Item", Item);
}*/

