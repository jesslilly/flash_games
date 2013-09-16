#initclip 40

function MeanRock() 
{
	//super();

//	if (_root.board.meanrockbabycount == null) _root.board.meanrockbabycount = 0;
}

MeanRock.prototype = new Monster();

MeanRock.prototype.update = function() 
{
/*
	this.step++;
	this._x += this.vx;
	this._y += this.vy;
	this.checkBoundaries();
*/

	if ( this._currentframe < 103 && this.launchedbaby )
	{
		this.launchedbaby = false;
	}
	else if ( this._currentframe >= 103 && !this.launchedbaby )
	{
//		babynum = _root.board.meanrockbabycount;
//		_root.board.meanrockbabycount++;
//		baby = mapMaster_addActor( "MeanRockBaby", "meanrockbaby" + babynum, this._x + 68, this._y + 25, -1, -1, ACTION_LAYER )

		// new code to add this guy to actorList.
		baby = mapMaster_addActor( "MeanRockBaby", "", this._x + 68, this._y + 25, -1, -1, ACTION_LAYER )
		/* old code saved just in case:
		baby = _root.board.attachMovie("MeanRockBaby", "meanrockbaby" + babynum, layerMaster_use(ACTION_LAYER) );
		baby._x = this._x + 68;
		baby._y = this._y + 25;
		*/
		baby.aimMethod = 3;
		baby.launch(_root.board.hero);
		this.launchedbaby = true;
	}
}

MeanRock.prototype.defaultInit = function()
{
	this.init( 0,1 );
	this.harmless = true;
	this.launchedbaby = false;
	this.gotoAndPlay( Math.randRange(1,90) );
	trace("set the frame to " + this._currentframe );
}


Object.registerClass("MeanRock", MeanRock);

#endinitclip
