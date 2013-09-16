#initclip 40

function FallFireShadow() 
{
	super();
}

FallFireShadow.prototype = new Monster();

FallFireShadow.dropTime = 10;

FallFireShadow.prototype.defaultInit = function()
{
	super.init( 0,99 );
	this.invincible = true;
	this.harmless = true;
	this.step = 0;
	this.changeAt = FallFireShadow.dropTime;
	this.mode = "shadow";
	this.fire = this.addFire();
	this.fire._visible = false;
	this._x = Math.randRange(0,560);
	this._y = Math.randRange(0,380);
}

FallFireShadow.prototype.isMonster = function ( )
{
	return false;
}

FallFireShadow.prototype.update = function()
{
	this.step++;
	if ( this.mode == "fire" )
	{
		this.fire._y += 14;

		if ( this._y - this.fire._y < 50 )
		{
			// do a hit test on the hero.
			if ( ! _root.board.hero.isInvincible() && this.hitTest( _root.board.hero.getBlockHitArea() ) )
			{
				_root.board.hero.loseHP(2);
				actorList[j].reactToPlayerHit();
			}
		}
	}

	if ( this.step >= this.changeAt )
	{
		if ( this.mode == "shadow" )
		{
			this.fire._visible = true;
			this.fire._x = this._x;
			this.fire._y = this._y - 160;
			this.step = 0;
			this.mode = "fire";
			this.changeAt = 10;
		}
		else
		{
			this._x = _root.board.hero._x + Math.randRange(-60,60);
			this._y = _root.board.hero._y + Math.randRange(-60,60);
			this.fire._visible = false;
			this.step = 0;
			this.mode = "shadow";
			this.changeAt = FallFireShadow.dropTime;
		}
	}
}

FallFireShadow.prototype.addFire = function()
{
	return mapMaster_addScenery("FallFire","",this._x,this._y,-1,-1,SKY_LAYER);
}

Object.registerClass("FallFireShadow", FallFireShadow);

#endinitclip
