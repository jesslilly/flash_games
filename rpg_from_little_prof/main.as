//#include "slime.as"
//#include "Math.as"

trace("let it begin");

trace(_root._quality);
_root._quality = "LOW";
trace(_root._quality);

_root.isDownKeyDown = false;
_root.isUpKeyDown = false;
_root.isLeftKeyDown = false;
_root.isRightKeyDown = false;

#include "hpdisplay.as"
#include "conversation.as"
#include "terrain.as"
#include "mapmaster.as"
#include "soundmaster.as"
#include "constants.as"
#include "layermaster.as"
#include "inventory.as"
#include "item.as"
#include "activelist.as"
// savemaster must come after inventory.
#include "savemaster.as"

// load the Shared Object (mega-cookie)
SaveMaster.loadGame();
MapMaster.initialize();

// because conversations are created ahead of time here, the player name needs to be available.
#include "conversationmaster.as"


var refreshMSeconds = 50;
var mode = "normal";

// board could be defined in the intro.
if ( _root.board == undefined )
	_root.createEmptyMovieClip("board", layerMaster_use(TERRAIN_LAYER) );

_root.board.attachMovie("Player", "hero", layerMaster_use(ACTION_LAYER), {_x:(4*16-8),_y:(4*16-8)} )
mapMaster_addWeapon("Wand", "weapon", 0,0, -1,-1, ACTION_LAYER );
_root.board.hero.init();
activeList_addActor( _root.board.hero );

var startingMap = SaveMaster.getLocation();

if ( startingMap == undefined )
{
	startingMap = "island7";
}
//startingMap = "snow22";
//startingMap = "icec01";
//mapMaster_loadScreenName(startingMap);
mapMaster_setScreenFromMap();

createHPDisplay();
createMapDisplay();
createLocDisplay();
createInvDisplay();

soundMaster_attachAllSoundEffects();

function animationLoop()
{
	//now = new Date();
	//ms = now.getTime();
	//interval = ms - prev_ms;
	//trace("Animation interval " + interval );
	//prev_ms = ms;

	//trace( "updatePlayer" );
	updateAll();
}

animationID = setInterval( animationLoop, refreshMSeconds );
fatherTime = new Object();
fatherTime.step = 0;
fatherTime.update = function () 
{
	this.step++;
	this.updateEvent();
};

function updateAll()
{

	if ( mode == "paused" || mode == "conversation" )
	{

	}
	else
	{
		fatherTime.update();

		for ( var j = 0; j < sceneryList.length; j++ )
		{
			sceneryList[j].update();
		}

		for ( var j = 0; j < actorList.length; j++ )
		{
			// If the actor has an update funciton.  (Interface?)
			// trace( typeof actorList[j].update == "function" );
			//trace( "animation loop: " + actorList[j] + " .update()" );
			actorList[j].update();

			if ( actorList[j] instanceof Player )
			{
				if ( ! actorList[j].isInvincible() )
				{
					actorList[j].doMonsterHitTests();
				}
				actorList[j].doItemHitTests();
			}
			actorList[j].doBlockHitTests();
		}
/*
		for ( var j in _root.board )
		{
			//trace( _root.board[j] );
			//trace( typeof _root.board[j] );

			if ( _root.board[j] instanceof Sprite )
			{
				_root.board[j].update();

				if ( _root.board[j] instanceof Player )
				{
					if ( ! _root.board[j].isInvincible() )
					{
						_root.board[j].doAllHitTests();
					}
				}
				_root.board[j].doBlockHitTests();
			}
		}
		*/
	}
}

function togglePause()
{
	if ( mode == "normal" )
	{
		Inventory_showInventory();
		mode = "paused";
		trace("paused");
	}
	else
	{
		Inventory_hideInventory();
		mode = "normal";
	}
}

function startConversation( c )
{
	// stop player if moving
	//_root.board.hero.vx = 0;
	//_root.board.hero.vy = 0;
	// start conversation mode
	trace("conversation mode");
	mode = "conversation";

	//_root.board._alpha = 50;
	crad = mapMaster_addScenery( "WhiteBox", "conversationFade", 0, 0, 600, 400, TOWN_LAYER );
	crad._alpha = 50;
	//trace(crad);

	currentconversation = c;
}

function stopConversation()
{
	trace("normal mode");
	mode = "normal";
	//_root.board._alpha = 100;
	_root.board.conversationFade.removeMovieClip();

	currentconversation = null;
}

//_root.rabbit.update();
//_root.rabbit.prototype.onClipEvent = _root.rabbit.keyInput;

/*
rabbit.onClipEvent = function( keyDown )
{
	_root.rabbit.keyInput( keyDown );
}
*/

