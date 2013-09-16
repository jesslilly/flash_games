
// rewrite: I wanted to make this an object, but oh well.
// I couldn't get it to work right now, so who cares.

var nextMap = new Array();

function soundMaster_attachAllSoundEffects()
{
	trace("soundMaster_attachAllSoundEffects");
	
	_root.createEmptyMovieClip("wandMC", layerMaster_use( SOUND_LAYER ));
	wandSound = new Sound( wandMC );
	wandSound.attachSound("wand.mp3");

	_root.createEmptyMovieClip("pickupMC", layerMaster_use( SOUND_LAYER ));
	pickupSound = new Sound( pickupMC );
	pickupSound.attachSound("pickup.mp3");

	_root.createEmptyMovieClip("blast2MC", layerMaster_use( SOUND_LAYER ));
	blast2Sound = new Sound( blast2MC );
	blast2Sound.attachSound("blast2.mp3");

	_root.createEmptyMovieClip("hit2MC", layerMaster_use( SOUND_LAYER ));
	hit2Sound = new Sound( hit2MC );
	hit2Sound.attachSound("hit2.mp3");

	// ====================================
	
	_root.createEmptyMovieClip("bounce4MC", layerMaster_use( SOUND_LAYER ));
	bounce4Sound = new Sound( bounce4MC );
	bounce4Sound.attachSound("bounce4.mp3");
	
	_root.createEmptyMovieClip("bump2MC", layerMaster_use( SOUND_LAYER ));
	bump2Sound = new Sound( bump2MC );
	bump2Sound.attachSound("bump2.mp3");
	
	_root.createEmptyMovieClip("futurebeep2MC", layerMaster_use( SOUND_LAYER ));
	futurebeep2Sound = new Sound( futurebeep2MC );
	futurebeep2Sound.attachSound("futurebeep2.wav");
	
	_root.createEmptyMovieClip("lazer3MC", layerMaster_use( SOUND_LAYER ));
	lazer3Sound = new Sound( lazer3MC );
	lazer3Sound.attachSound("lazer3.mp3");
}
