
SaveMaster = function()
{
   //no instance variables.
};

SaveMaster.complete = function( task )
{
	trace( "Completed "+task+".");
	SaveMaster.list[ task ] = true;
	// Write the saved info to the SO file.
	SaveMaster.saveAll();
};

SaveMaster.completeMC = function( saveMC )
{
	//trace("Complete " + saveMC + " " + saveMC.saveTask );
	if ( saveMC.saveTask != undefined )
	{
		SaveMaster.complete(saveMC.saveTask);
	}
};

SaveMaster.isComplete = function( task )
{
	var complete = SaveMaster.list[ task ];
	if ( complete )
		trace( task + " is already complete." );
	else
	{
		trace( task + " is NOT yet complete." );
		complete = false;
	}
	return complete;
};

// This function is for a new game or a saved game.
SaveMaster.loadGame = function()
{
	trace( "Check Shared Object.");
	SaveMaster.save1 = SharedObject.getLocal("adventure_save1","/");
	trace( "playerName: " + SaveMaster.getPlayerName() );

	if ( SaveMaster.save1.data.saveList == undefined )
	{
		trace("Beginning a new game.")
		// The map that holds our save info.
		SaveMaster.save1.data.saveList = new Object();
		SaveMaster.save1.data.inventory = new Object();
		SaveMaster.save1.data.backPack = new Array();
		SaveMaster.save1.data.maxHP = 6;
		SaveMaster.save1.data.location = "island7";
		SaveMaster.save1.data.inventory["wand"] = 1;

		// Easter Eggs: Special names give you special stuff.
		if ( SaveMaster.getPlayerName() == "JungleVision" )
		{
			SaveMaster.save1.data.inventory["sword"] = 1;
			SaveMaster.save1.data.inventory["Gold"] = 1000;
			SaveMaster.save1.data.saveList["slimeBoss"] = true;
			SaveMaster.save1.data.saveList["Bridge1"] = true;
			SaveMaster.save1.data.inventory["Melon"] = 300;
			SaveMaster.save1.data.inventory["Mushroom1"] = 300;
			SaveMaster.save1.data.maxHP = 12;
		}
		if ( SaveMaster.getPlayerName() == "Magma"
		|| SaveMaster.getPlayerName() == "Hortence"
		|| SaveMaster.getPlayerName() == "Ultimax"
		|| SaveMaster.getPlayerName() == "Fleagle"
		|| SaveMaster.getPlayerName() == "JerkFace"
		)
		{
			SaveMaster.save1.data.inventory["Gold"] = 100;
			SaveMaster.save1.data.inventory["Melon"] = 30;
			SaveMaster.save1.data.inventory["Mushroom1"] = 30;
		}
	}
	else
	{
		trace("Continuing a saved game.")
	}
	// The static var list is a reference to the Shared Object data.
	SaveMaster.list = SaveMaster.save1.data.saveList;

	// inventory is from inventory.as.  TRIXY!
	inventory = SaveMaster.save1.data.inventory;
	backPack = SaveMaster.save1.data.backPack;

	//_root.debug.text = "Loaded data for player " + SaveMaster.getPlayerName() + " Is dwarfKey1 complete? " + SaveMaster.isComplete("dwarfKey1");

	SaveMaster.saveAll();

	trace( "save list after loading: " + SaveMaster.list );
	trace( "is dwarfKey1 complete? " + SaveMaster.isComplete("dwarfKey1") );
};

SaveMaster.getPlayerName = function()
{
	return SaveMaster.save1.data.playerName;
};

SaveMaster.getMaxHP = function()
{
	return SaveMaster.save1.data.maxHP;
};

SaveMaster.saveAll = function()
{
	SaveMaster.save1.flush();
};

SaveMaster.saveMaxHP = function( number )
{
	SaveMaster.save1.data.maxHP = number;
	SaveMaster.saveAll();
};


SaveMaster.getLocation = function()
{
	return SaveMaster.save1.data.location;
};
SaveMaster.saveLocation = function( mapName )
{
	SaveMaster.save1.data.location = mapName;
	SaveMaster.saveAll();
};

