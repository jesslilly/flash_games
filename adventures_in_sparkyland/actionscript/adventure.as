//#include "com/sparkyland/adventure/slime.as"
//#include "com/sparkyland/flash/Math.as"

trace("let it begin");

#include "com/sparkyland/adventure/hpdisplay.as"
#include "com/sparkyland/adventure/conversation.as"
#include "com/sparkyland/adventure/mapmaster.as"
#include "com/sparkyland/adventure/soundmaster.as"
#include "com/sparkyland/adventure/constants.as"
#include "com/sparkyland/adventure/layermaster.as"
#include "com/sparkyland/adventure/inventory.as"
#include "com/sparkyland/adventure/item.as"
#include "com/sparkyland/adventure/activelist.as"
// savemaster must come after inventory.
#include "com/sparkyland/adventure/savemaster.as"

// load the Shared Object (mega-cookie)
SaveMaster.loadGame();

// because conversations are created ahead of time here, the player name needs to be available.
#include "com/sparkyland/adventure/conversationmaster.as"


var refreshMSeconds = 50;
var mode = "normal";

//getUrl( "javascript:document.all['bgMusicID'].src = 'music/winbattle.mid'" );

// boundaries
//_root.createEmptyMovieClip("boundaryBox", 1 );
boundaryBox_x = 0;
boundaryBox_y = 0;
boundaryBox_height = 400; //_root._height; //400;
boundaryBox_width = 600; //_root._width; //600;

// board could be defined in the intro.
if ( _root.board == undefined )
	_root.createEmptyMovieClip("board", layerMaster_use(BG_LAYER) );

_root.board.attachMovie("Player", "hero", layerMaster_use(HERO_LAYER), {_x:240,_y:60} )
mapMaster_addWeapon("Wand", "weapon", 0,0, -1,-1, WEAPON_LAYER );
_root.board.hero.init();
activeList_addActor( _root.board.hero );

var startingMap = SaveMaster.getLocation();

if ( startingMap == undefined )
{
	startingMap = "island7";
}
//startingMap = "island6";
//startingMap = "trai01";
//startingMap = "trai06";
//startingMap = "island6";
//startingMap = "town3";
//startingMap = "main11";
//startingMap = "main08";
//startingMap = "main03";
//startingMap = "main17";
//startingMap = "snow01";
//startingMap = "snow10";
//startingMap = "snow20";
//startingMap = "snow22";
//startingMap = "icec01";
//startingMap = "dwarf3";
//startingMap = "icec15"; // ice king
//startingMap = "icec16";
//startingMap = "heaven";
//startingMap = "snow04";
//startingMap = "towe01";
//startingMap = "towe13"; // caracalla
//startingMap = "warpzone1";
mapMaster_loadScreenName(startingMap);

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

function stun()
{
	_root.mode = "noinput";
	_root.board.hero.vx = _root.board.hero.vy = 0;
	_root.board.hero.stop();
}
function removeStun()
{
	_root.mode = "normal";
	_root.board.hero.processKeyDown( _root.currentKeyCode );
//	_root.board.hero.play();
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
	crad = mapMaster_addScenery( "WhiteBox", "conversationFade", 0, 0, 600, 400, BLOCK_LAYER );
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

