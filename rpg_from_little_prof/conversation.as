
function Line() {
	this.choicetext_array = new Array();
	this.choicelink_array = new Array();
	this.choicechosen_array = new Array();
	this.reached = false;
}

function Conversation() {

	this.lines_array = new Array();
	this.player_mc = null;
	this.thing_mc = null;
	this.currentline = -1;

	this.lineformat_fmt = new TextFormat();
	this.lineformat_fmt.font = "arial";
	this.lineformat_fmt.size = 11;
	this.lineformat_fmt.leftMargin = 5;
	this.lineformat_fmt.rightMargin = 5;
	this.lineformat_fmt.bold = true;
	this.lineformat_fmt.leading = 0;
}

/*	addLine
	adds a step to the conversation.  a line is assigned a unique integer which will
	serve to identify it (as a link from other lines).  a line is associated with either
	the player or the "thing" being talked to.
*/
Conversation.prototype.addLine = function(linenum, who) {
	// delete old line, if any
	if (this.lines_array[linenum] != null) {
		trace("addLine: attempt to add duplicate line " + linenum + " in conversation");
		return;
	}
	// create new line
	l = new Line();
	l.who = who;
	// add to array
	this.lines_array[linenum] = l;
};

/*	addChoice
	adds a single dialog "choice" to a certain line that can be selected by the player
	(through the interface) or by the thing (randomly) as the next part of the conversation.
	choicelink is the linenum to which this choice will lead next.
*/
Conversation.prototype.addChoice = function(linenum, choicetext, choicelink) {
	// assert linenum exists
	if (this.lines_array[linenum] == null) {
		trace("addChoice: could not add choice to line " + linenum + "; line doesn't exist.");
		return;
	}
	// add choice to line
	choicenum = this.lines_array[linenum].choicetext_array.length;
	with (this.lines_array[linenum]) {
		choicetext_array[choicenum] = choicetext;
		choicelink_array[choicenum] = choicelink;
		choicechosen_array[choicenum] = false;
	}
};

/*	addAction
	Adds an action to the conversation.
	Pass it an object with a "go" method which will be called to perform the action.
	Examples: remove gold and gain an item for a certain conversation path.
	This is how we are implementing purchases, but you can do any action in the go method.
	Currently we add the action to the entire line, so there can only be 1 choice on the line.
	This has to be enforced by YOU the programmer or map designer.
	See converstaionMaster for more examples.
*/
Conversation.prototype.addAction = function(linenum, actionObject ) {
	// assert linenum exists
	if (this.lines_array[linenum] == null) {
		trace("addAction: could not add action to line " + linenum + "; line doesn't exist.");
		return;
	}

	// add action to line
	this.lines_array[linenum].action = actionObject;
};

/*	converse and terminate
	start and stop the conversation in the gui.
	note kjv: the calls to _root.startConversation and _root.stopConversation are included
	here for the caller's convenience.  it would be easy for the caller to make the start
	call, but a little more irritating to make the stop call (by testing the return value
	of this.processKeyDown) -- so why not do them here, for now.
*/
Conversation.prototype.converse = function(player_mc, thing_mc) {
	// remember participants
	this.player_mc = player_mc;
	this.thing_mc = thing_mc;
	// speak first line
	if (this.lines_array.length > 0 && this.lines_array[0] != null) {
		_root.startConversation(this);
		this.speak(0);
	}
};

Conversation.prototype.terminate = function() {
	// stop conversation in root
	_root.stopConversation();
};

/*	clear
	forgets any choices already made in this conversation.  use this if the conversation
	needs to be repeated from scratch (but the conversation object wasn't deleted and
	recreated).
*/
Conversation.prototype.clear = function () {
	for (i in this.lines_array) {
		for (j in this.lines_array[i].choicechosen_array) {
			this.lines_array[i].choicechosen_array[j] = false;
		}
		this.reached = false;
	}
};

/*	speak
	posts a single line of conversation next to the speaker.  the line is identified by
	its linenum, for the convenience of the caller.  this method checks for end of
	conversation (either linenum == -1, or no remaining unspoken choices for linenum),
	which saves each caller some effort.  the return value indicates what was done:
	-1 means conversation terminated with error; 0 means conversation terminated normally;
	and 1 means at least one choice	was successfully posted for this line.
*/
Conversation.prototype.speak = function(linenum) {
	// check for conversation finished
	if (linenum == -1) {
		this.terminate();
		return 0;
	}
	// assert linenum exists
	if (this.lines_array[linenum] == null) {
		trace("speak: could not speak line " + linenum + "; line doesn't exist.");
		this.terminate();
		return -1;
	}
	// assert line has choices
	if (this.lines_array[linenum].choicetext_array.length == 0) {
		trace("speak: could not speak line " + linenum + "; line has no choices.");
		this.terminate();
		return -1;
	}
	// officially set currentline for the object
	// (note: processKeyDown relies on this being set correctly.)
	this.currentline = linenum;
	l = this.lines_array[this.currentline];

	// begin go 5/26/2004
	// enhanvement: preform the action for a certain line number.
	if ( l.action instanceof Object )
	{
		trace("Perform conversation action.");
		l.action.go();
	}
	// end go 5/26/2004
	
	l.reached = true;
	// set currentchoice
	// (note: for both player and thing, choose one that hasn't previously been chosen.)
	if (l.who == LINE_PLAYER) {
		startchoice = 0;
	} else {
		startchoice = Math.randRange(0, l.choicetext_array.length - 1, 0);
	}
	l.currentchoice = startchoice;
	while (l.choicechosen_array[l.currentchoice]) {
		l.currentchoice++;
		if (l.currentchoice >= l.choicetext_array.length) l.currentchoice = 0;
		/*	(note: any loops in conversation should be designed so that there's always a way
			out -- i.e. at least one of the choices will branch in a way that _must_ lead to
			an end in conversation.  on the other hand, it might not be an error if there's
			no unchosen options available: perhaps the caller wants to allow multiple starts to
			this conversation, without calling this.clear(), so that different branches of
			the conversation will be followed.  terminate cleanly, but return -1 for error.) */
		if (l.currentchoice == startchoice) {
			trace("speak: warning: no choices left in line " + linenum + "; terminating conversation");
			this.terminate();
			return -1;
		}
	}
	// jml: begin 3/29/2004
	// PROBLEM: Hero stops moving when moving from one screen to the next
	// while holding the space bar down.
	// FIX: Do it here instead of in startConversation.
	// PS: This is for an auto initiated conversation.
	// stop player if moving
	_root.board.hero.vx = 0;
	_root.board.hero.vy = 0;
	// jml: end 3/29/2004

	// create conversation movie clip (for textfields)
	_root.createEmptyMovieClip("conversation_mc", layerMaster_use(SKY_LAYER));
	//_root.conversation_mc.attachMovie("ConversationNormal", "bubble_mc", layerMaster_use(SKY_LAYER));
	// create one text field for each choice
	// (note: slightly different situation for thing vs. player choices.  but easy enough
	// to generalize into a loop.)
	trialtfwidth = 160;
	maxtextwidth = 0;
	totaltfheight = 0;
	for (i = 0; i < l.choicetext_array.length; i++) {
		if ((l.who == LINE_PLAYER && !l.choicechosen_array[i]) || (l.who == LINE_THING && i == l.currentchoice)) {
			// create a textfield for the choice
			_root.conversation_mc.createTextField("choice"+i+"_txt", layerMaster_use(SKY_LAYER), 0, 0, 0, 0);
			with (_root.conversation_mc["choice"+i+"_txt"]) {
				selectable = false;
				text = l.choicetext_array[i];
				textColor = 0x000000;
				//border = true;
				//borderColor = 0x000000;
				background = true;
				backgroundColor = 0xFFFFFF;
				setTextFormat(this.lineformat_fmt);
				wordwrap = true;
				multiline = true;
				autosize = true;
			}
			// collect metrics
			// (note kjv: appears to be very important to explicitly set _width before
			// testing textHeight or _height here.  not good enough to provide a width
			// when creating the textfield.)
			with (_root.conversation_mc["choice"+i+"_txt"]) {
				_width = trialtfwidth;
				totaltfheight += _height;
				if (textWidth > maxtextwidth) maxtextwidth = textWidth;
			}
		}
	}
	// (note kjv: can't figure out if textfield gutter is included in leftMargin and rightMargin.
	// in theory, textfield gutter is 2 on each side.)
	realtfwidth = maxtextwidth + this.lineformat_fmt.leftMargin + this.lineformat_fmt.rightMargin + 4;
	// (note kjv: this realtfwidth/textWidth thing was working great for a while on my mac, then
	// decided to start giving the wrong answers.  so at least ensure here that it doesn't
	// get _bigger_ than trial width.)
	if (realtfwidth > trialtfwidth) realtfwidth = trialtfwidth;
	// (note kjv: margin all around textfields within conversation movieclip.)
	mcwidth = realtfwidth + 6;
	mcheight = totaltfheight + 6;
	// choose position metrics relative to speaker
	if (l.who == LINE_PLAYER) {
		speaker_mc = this.player_mc;
	} else {
		speaker_mc = this.thing_mc;
	}
	speakerbounds = speaker_mc.getBounds(speaker_mc._parent);
	// (find a good x)
	speakerx = speakerbounds.xMin + speaker_mc._width / 2;
	if (speakerx < (_root.boundaryBox_width - speakerx)) {
		// close to left edge; display to right of speaker (with pad)
		mcx = speakerbounds.xMax + 7;
		triangleside = "left";
	} else {
		// close to right edge; display to left of speaker (with pad)
		mcx = speakerbounds.xMin - mcwidth - 7;
		triangleside = "right";
	}
	// (find a good y)
	mcy = speakerbounds.yMin;
	if (mcy + mcheight + 5 > _root.boundaryBox_height) {
	      	// close to bottom; display as far down as possible (with pad)
	        mcy = _root.boundaryBox_height - mcheight - 5;
	} else if (mcy < 5) {
	       // close to top; display as far up as possible (with pad);
		mcy = 5;
	}
	//trace("position " + mcx + ", " + mcy + ", " + mcwidth);
	// (reposition movieclip)
	_root.conversation_mc._x = mcx;
	_root.conversation_mc._y = mcy;
	//_root.converstaion_mc._width = mcwidth;
	//_root.converstaion_mc._height = mcheight;
	// (reposition fields within movieclip)
	tfy = 2;
	for (i = 0; i < l.choicetext_array.length; i++) {
		if ((l.who == LINE_PLAYER && !l.choicechosen_array[i]) || (l.who == LINE_THING && i == l.currentchoice)) {
			with (_root.conversation_mc["choice"+i+"_txt"]) {
				_x = 3;
				_y = tfy;
				_width = realtfwidth;
				tfy += _height;
			}
		}
	}
	// draw a speach bubble around textfields
	r = 5;
	tw = 6;
	th = 3;
	with (_root.conversation_mc) {
	     beginFill(0xFFFFFF);
	     lineStyle(2);
	     moveTo(r, 0);
	     lineTo(mcwidth - r, 0);
	     curveTo(mcwidth, 0, mcwidth, r);
	     if (triangleside == "right") {
	     	     lineTo(mcwidth + tw, r + th);
		     lineTo(mcwidth, r + 2 * th);
	     }
	     lineTo(mcwidth, mcheight - r);
	     curveTo(mcwidth, mcheight, mcwidth - r, mcheight);
	     lineTo(r, mcheight);
	     curveTo(0, mcheight, 0, mcheight - r);
	     if (triangleside == "left") {
	     	     lineTo(0, r + 2 * th);
		     lineTo(-tw, r + th);
	     }
	     lineTo(0, r);
	     curveTo(0, 0, r, 0);
	     endFill();
	}
	// set correct appearance for choice(s)
	this.refreshCurrent();
	// (wait for a key event)
	// (note: could start a timer for automatic conversation advancement for thing lines.)
	return 1;
};

/*	refreshcurrent
	updates the appearance of the various choices currently displayed according to which
	is currently selected.  this really only has meaning for the player lines, but the
	method is designed so that it won't hurt to call it on thing lines too.
*/
Conversation.prototype.refreshCurrent = function() {
	l = this.lines_array[this.currentline];
	if (l.who == LINE_THING) return;
	choicecount = 0;
	// dim text for non-current choices
	for (i in l.choicetext_array) {
		// (note: only change choices that were actually drawn.)
		if (!l.choicechosen_array[i]) {
		   	choicecount++;
			if (i == l.currentchoice) {
				with (_root.conversation_mc["choice"+i+"_txt"]) {
				     	textColor = 0x000000;
				}
			} else {
				with (_root.conversation_mc["choice"+i+"_txt"]) {
				     	textColor = 0x909090;
					backgroundColor = 0xFFFFFF;
				}
			}
		}
	}
	// if more than one choice, draw a selection background on the current choice
	if (choicecount > 1) {
		with (_root.conversation_mc["choice"+l.currentchoice+"_txt"]) {
			backgroundColor = 0xCFCFFF;
		}
	}
};

/*	processKeyDown
	reacts to key events, either continuing or ending the conversation.  returns -1 for
	conversation terminated with error, 0 for conversation terminated normally, and 1 for
	conversation continuing.
*/
Conversation.prototype.processKeyDown = function(keyCode) {
	l = this.lines_array[this.currentline];
	if (keyCode == Key.SPACE) {
		// mark chosen
		// UNFINISHED: for now, don't mark -1 links as chosen; need to keep exits for
		// repeated conversations.  but does this end up being consistent in the long run?

		/* Allow repeats in conversation.  jml 5/21/2004
		if (l.choicelink_array[l.currentchoice] != -1) {
			l.choicechosen_array[l.currentchoice] = true;
		}
		*/

		// delete conversation movieclip
		// (note: could remove textfields, and not delete clip until end; but this is easier.)
		_root.conversation_mc.removeMovieClip();
		// speak next line or end conversation
		trace("continuing to line " + l.choicelink_array[l.currentchoice]);
		return this.speak(l.choicelink_array[l.currentchoice]);
	} else if (l.who == LINE_PLAYER) {
		// (note: no risk of infinite loop here; the current currentchoice, at least, must be valid.)
		if (keyCode == Key.UP) {
			// decrement choice
			do {
				l.currentchoice--;
				if (l.currentchoice < 0) l.currentchoice = l.choicetext_array.length - 1;
			} while (l.choicechosen_array[l.currentchoice]);
		} else if (keyCode == Key.DOWN) {
			// increment choice
			do {
				l.currentchoice++;
				if (l.currentchoice >= l.choicetext_array.length) l.currentchoice = 0;
			} while (l.choicechosen_array[l.currentchoice]);
		}
		// highlight currentchoice
		this.refreshCurrent();
	}
	return 1;
};

/*	lineSpoken
	returns a boolean indicating whether or not a certain line number was reached in the
	conversation (since the last clear(), anyway).
*/
Conversation.prototype.lineSpoken = function(linenum) {
	return this.lines_array[linenum].reached;
};
