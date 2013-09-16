onClipEvent( keyDown )
{
	keyCode = Key.getCode();

	// Here, we are going to use some crappy logic to 
	// convert the keyDown repeater to just a Key Pressed type of event.
	// example 1: KeyDown does this as long as you hold the A key: aaaaaaaaaaa
	// example 2: KeyPressed registers an event only when you press the key down even if you hold it down: a
	// So all we care about are 2 events: key pressed and key up.
	// Using Ket.isDown(keyCode) does not work.  We lose all key events.
	// 2/27/2006 I think we can keep this for RPG.  No need to repeat keys all day.
	// preventRapidFireKey is not the currentKey and should not be used as such.
	// Evaluate what key is down instead using isUpKeyDown, etc.
	if ( _root.preventRapidFireKey == keyCode )
	{
		//trace("KeyPressed: " + keyCode + " IGNORED" );
		return;
	}
	else
	{
		trace("KeyPressed: " + keyCode );
	}

	switch( KeyCode )
	{
		case Key.UP :
			_root.isUpKeyDown = true;
			break;
		case Key.DOWN :
			_root.isDownKeyDown = true;
			break;
		case Key.LEFT :
			_root.isLeftKeyDown = true;
			break;
		case Key.RIGHT :
			_root.isRightKeyDown = true;
			break;
	}

	_root.previousKeyCode = _root.preventRapidFireKey;
	_root.preventRapidFireKey = keyCode;

	if ( _root.mode == "normal")
	{
		if ( _root.board.hero.onASquare() )
		{
			_root.board.hero.processKeyDown( keyCode );
		}
		else
		{
			// If we are in between squares, don't let them change direction until they get there.
			trace( "Keyboard input ignored - not on a square." );
		}
	}
	else if ( _root.mode == "conversation" )
	{
		_root.currentconversation.processKeyDown ( keyCode );
	}
	else if ( _root.mode == "paused")
	{
	}
	else if ( _root.mode == "noinput")
	{
	}
}

onClipEvent( keyUp )
{
	keyCode = Key.getCode();

	switch( KeyCode )
	{
		case Key.UP :
			_root.isUpKeyDown = false;
			break;
		case Key.DOWN :
			_root.isDownKeyDown = false;
			break;
		case Key.LEFT :
			_root.isLeftKeyDown = false;
			break;
		case Key.RIGHT :
			_root.isRightKeyDown = false;
			break;
	}

	_root.previousKeyCode = _root.preventRapidFireKey;
	_root.preventRapidFireKey = null;

	//trace("Key     UP: " + keyCode );

	if  (_root.mode == "normal" )
	{
		_root.board.hero.processKeyUp( keyCode );
	}
	else if  (_root.mode == "paused" )
	{
		_root.processInventoryControls( keyCode );
	}
	else if  ( _root.mode == "noinput" )
	{
	}
	else if ( _root.mode == "conversation" )
	{
	}
}



