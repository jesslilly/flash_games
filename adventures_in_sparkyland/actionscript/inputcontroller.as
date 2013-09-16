onClipEvent( keyDown )
{
	keyCode = Key.getCode();

	// Here, we are going to use some crappy logic to 
	// convert the keyDown repeater to just a Key Pressed type of event.
	// example 1: KeyDown does this as long as you hold the A key: aaaaaaaaaaa
	// example 2: KeyPressed registers an event only when you press the key down even if you hold it down: a
	// So all we care about are 2 events: key pressed and key up.
	// Using Ket.isDown(keyCode) does not work.  We lose all key events.

	if ( _root.currentKeyCode == keyCode )
	{
		//trace("KeyPressed: " + keyCode + " IGNORED" );
		return;
	}
	else
	{
		//trace("KeyPressed: " + keyCode );
	}

	_root.currentKeyCode = keyCode;

	if ( _root.mode == "normal")
	{
		_root.board.hero.processKeyDown( keyCode );
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

	_root.currentKeyCode = null;

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



