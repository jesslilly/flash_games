
/*

Track all of the objects on the screen that can bump, attack, 
take or in any way interact with each other.

There are a couple ways to implement this.

1. Using an array and using push to add to it and using splice to remove and not leave a hole.
2. Use an associative array and access each element by name and use for (key in blah ) notation to iterate.
3. Other ways?

I'm not sure which is the best right now.

Also, yes this could be a static class, but I'm not sure who to do it and I don't care.
*/

var sceneryList = new Array();
var actorList = new Array();
var itemList = new Array();
var blockList = new Array();
var activeList_numMonsters = 0;

/*
function activeList_add( movieClip )
{
	if ( movieClip instanceof Mortal )
		activeList.push( movieClip );
}*/

function activeList_addScenery( movieClip )
{
	sceneryList.push( movieClip );
}

function activeList_addActor( movieClip )
{
	actorList.push( movieClip );
	trace( "###+mon <" + movieClip._name + ">");
	if ( activeList_isMonster(movieClip) )
	{
		activeList_numMonsters++;
	}
	//trace( "###+num mons <" + activeList_numMonsters + ">");
}

function activeList_addItem( movieClip )
{
	itemList.push( movieClip );
}

function activeList_addBlock( movieClip )
{
	blockList.push( movieClip );
}

function activeList_removeActor( movieClip )
{
	for ( var idx = 0; idx < actorList.length; idx ++ )
	{
		if ( actorList[idx] == movieClip )
		{
			actorList.splice(idx,1);

			//trace( "###-guy <" + movieClip + " >" );
			trace( "###-num mons <" + activeList_numMonsters + ">" );
			if ( activeList_isMonster(movieClip) )
			{
				activeList_numMonsters--;
				// off by 1 for the Hero who is an actor too.
				if ( activeList_numMonsters == 0 )
				{
					trace( " activeList_beatAllMonsters " );
					activeList_beatAllMonsters();
				}
			}
			// We found and removed the actor.  Break out of the for loop.
			break;
		}
	}
}

function activeList_removeScenery( movieClip )
{
	for ( var idx = 0; idx < sceneryList.length; idx ++ )
	{
		if ( sceneryList[idx] == movieClip )
		{
			sceneryList.splice(idx,1);
			break;
		}
	}
}

function activeList_removeItem( movieClip )
{
	for ( var idx = 0; idx < itemList.length; idx ++ )
	{
		if ( itemList[idx] == movieClip )
		{
			itemList.splice(idx,1);
			trace( "remove " + movieClip )
			break;
		}
	}
}

function activeList_removeBlock( movieClip )
{
	for ( var idx = 0; idx < blockList.length; idx ++ )
	{
		if ( blockList[idx] == movieClip )
		{
			blockList.splice(idx,1);
			trace( "remove " + movieClip )
			break;
		}
	}
}

function activeList_clearAll()
{
	// rewrite: ? This will whack the entire array.  Will it remove the array's allocation too?
	// If so it might be more desireable to leave the array at size X (10?) to keep the memory
	// allocated.  You know, for speed.
	actorList.splice(0);
	itemList.splice(0);
	blockList.splice(0);
	sceneryList.splice(0);
	activeList_numMonsters=0;
}

function activeList_isMonster( movieClip )
{
	var isMon = false;
	if ( movieClip instanceof Mortal && movieClip.isMonster() )
		isMon = true;
	//trace("###? canKill? " + isMon );
	return isMon;
}

function activeList_beatAllMonsters()
{
	for ( var mci in _root.board )
	{
		var xClip = _root.board[mci];
		//trace("  BAM: " + xClip._name );
		if ( xClip.beatAllMonsters == true )
		{
			xClip.gotoAndPlay(2);
			//trace( "activate " + xClip._name );
		}	
		if ( xClip.removeWhenBeatAllMonsters == true )
		{
			activeList_removeBlock( xClip );
			xClip.removeMovieClip();
		}
	}
	activeList_beatAllMonsters2();
}
