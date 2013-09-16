

ConversationMaster = function()
{
   //no instance variables.
};

ConversationMaster.create = function( convName )
{
	trace( "ConversationMaster.create " + convName );
	conv = new Conversation();
	switch( convName )
	{
		case "c1" :
		{
			// conversation with whammy
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hi! I am Whammy. I am here to help you, " + SaveMaster.getPlayerName() + ".  Now hit SPACE.", 8);
			conv.addLine(8, LINE_THING);
			conv.addChoice(8, "When you are having a conversation, use SPACE to and the ARROW KEYS.", 9);
			conv.addLine(9, LINE_PLAYER);
			conv.addChoice(9, "Can you repeat that?", 0);
			conv.addChoice(9, "OK, I understand.", 1);
			conv.addChoice(9, "I'm OUTA here.", -1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "How do I talk to people?", 10);
			conv.addChoice(1, "How do I move?", 2);
			conv.addChoice(1, "How do I attack?", 3);
			conv.addChoice(1, "What should I do now?", 4);
			conv.addChoice(1, "Who are the other gnomes with you?", 5);
			conv.addChoice(1, "Can I have that mushroom?", 7);
			conv.addChoice(1, "Scram, shorty.", 6);
			conv.addChoice(1, "See you later.", -1);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "You move using the ARROW KEYS. Anything else?", 1);
			conv.addLine(10, LINE_THING);
			conv.addChoice(10, "You move up right next to them, face them, and hit SPACE. Anything else?", 1);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "You attack by pressing the SPACE bar.  Anything else?", 1);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "Well since you are new around here, go to the town.  Follow the path to the left. Anything else?", 1);
			conv.addLine(5, LINE_THING);
			conv.addChoice(5, "These are my friends Bugle, Meaty, and Tarq. Anything else?", 1);
			conv.addLine(7, LINE_THING);
			conv.addChoice(7, "Sorry, but no.  Meaty is sitting on it!", 1);
			conv.addLine(6, LINE_THING);
			conv.addChoice(6, "Well, fine! I was just trying to be friendly.", -1);
			break;
		}
		case "c2" :
		{
			// conversation with frog
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Ralp! Dude, up yonder is the first dungeon. Ralp!", 1);
			// 1
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "You can talk?", 2);
			conv.addChoice(1, "Thank you, noble frog.", -1);
			// 2
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "Ralp!", -1);
			break;
		}
		case "c3" :
		{
			// conversation with hadrian
			// 0
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "Are you okay?", 1);
			// 1
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Rats.  I forgot to get the key from Oran.", 2);
			// 2
			conv.addLine(2, LINE_PLAYER);
			conv.addChoice(2, "Who's Oran?", 3);
			// 3
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "Oran the dwarf.  He lives in the dwarf cave.", 4);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "Will you go get the key?", 5);
			conv.addLine(5, LINE_PLAYER);
			conv.addChoice(5, "Yes!", 6);
			conv.addChoice(5, "No.", 7);
			conv.addLine(6, LINE_THING);
			conv.addChoice(6, "Great!  I'll be waiting.", -1);
			conv.addLine(7, LINE_THING);
			conv.addChoice(7, "What?  Oh please?", -1);
			break;
		}
		case "c4" :
		{
			// conversation with devil
			// 0
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "Are you dangerous?", 1);
			// 1
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "This island is so BORING. I gotta get off.", -1);
			break;
		}
		case "c5" :
		{
			// conversation with yezmo
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, SaveMaster.getPlayerName() + "!", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "I am Yezmo.", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "I have revived you because your work is not yet complete.", 3);
			break;
		}
		case "c6" :
		{
			// conversation with Gwynelda
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hi, my name is Gwynelda!", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "It's nice to meet you.", 2);
			conv.addChoice(1, "Yeah... That's great.", -1);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "I should warn you about Oscar.  He's always telling fibs.", -1);
			break;
		}
		case "c7" :
		{
			// conversation with Oran
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hi, my name is Oran!", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Hello Oran.", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "I'll give you this here key if you go rid us of that big ole slime.", 3);
			conv.addLine(3, LINE_PLAYER);
			conv.addChoice(3, "Thank you Oran.", 4);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "Now, don't go off and die in there, or I will have to fetch the key back.", 5);
			conv.addLine(5, LINE_THING);
			conv.addChoice(5, "Seriously though, if you beat that slime, I'll give you this here treasure.", 6);
			conv.addLine(6, LINE_THING);
			conv.addChoice(6, "We dwarves hate running into slimes when we are atunnelin'.", -1);
			break;
		}
		case "c8" :
		{
			// conversation with Oran
			// 0
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "Oran, I beat the slime!", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Good job, buddy.  Now here's your reward.", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "I almost forgot.  There's a fake wall in the slime dungeon.  It's in the room with the water.", -1);
			break;
		}
		case "c9" :
		{
			// conversation with hadrian
			// 0
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "I brought the key!", 1);
			// 1
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Whoa!  Aaaahhhhh great.  Now please go defeat that slime.  He's scaring me to death!", -1);
			break;
		}
		case "c10" :
		{
			// conversation with Oscar
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "Whoa.  An Octopus!?", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Yes, my name is Opposite Oscar.", 2);
			conv.addLine(2, LINE_PLAYER);
			conv.addChoice(2, "What's that fountain for?", 3);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "I'm pretty sure it will poison you... or do something bad.  Whatever you do, don't go up to it and hit SPACE.", -1);
			break;
		}
		case "c11" :
		{
			// conversation with Dave
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "I'm Dave.  No one will pass here until the big Slime is defeated.", 1);
			break;
		}
		case "c12" :
		{
			// conversation with Wiznerd
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hi, I'm the Wiznerd.", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Hello, I'm " + SaveMaster.getPlayerName() + ".", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "I can upgrade your weapons.", -1);
			break;
		}
		case "c13" :
		{
			// Gwynelda being attacked.
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Aaaaaaaahhhhhhhhhh!!!!!!", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Help!  I'm being attacked!", -1);
			break;
		}
		case "c14" :
		{
			// Gwynelda thank you.
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Oh thank you! Thank you!  You saved me!", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "No prob.", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "There have been so many attacks by slimes lately, and they are ruining our island.", 3);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "Hadrian went to defeat the slime king, but he hasn't returned.  I'm worried.", -1);
			break;
		}
		case "c15" :
		{
			// Gwynelda thank you 2.
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "The grass is back!  No more swampy ground!  Thank you!", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "You are welcome.", -1);
			break;
		}
		case "c16" :
		{
			// Gwynelda thank you 2.
			// 0
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Good work against the Slime King.  Now our land is returning back to normal.", -1);
			break;
		}
		case "c17" :
		{
			// Afty.
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hi my name is Afty.", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "My name is " + SaveMaster.getPlayerName() + ".", 2);
			conv.addChoice(1, "Get bent Afty.", 6);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "Did you see me riding on a UFO in SparkyLand?", 3);
			conv.addLine(3, LINE_PLAYER);
			conv.addChoice(3, "No.  I have no idea what you're talking about.", 4);
			conv.addChoice(3, "Yeah.  That was awesome!", 5);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "Dude, you need to explore SparkyLand.com a little better then.", -1);
			conv.addLine(5, LINE_THING);
			conv.addChoice(5, "Yeah it was.  I rock the house!", -1);
			conv.addLine(6, LINE_THING);
			conv.addChoice(6, "What!  I never!  The kids these days... So disrespectful.", -1);
			break;
		}
		case "c18" :
		{
			// Beefo.
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "Hey there.", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Hi, I'm Beefo.  I wish we could make a bridge to get to the town.", 2);
			conv.addLine(2, LINE_PLAYER);
			conv.addChoice(2, "Why don't you?", 3);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "Well, I would need 200 gold for the lumber.  I only have 100.", -1);
			break;
		}
		case "c19" :
		{
			// Beefo.
			if ( SaveMaster.isComplete("Bridge1") )
			{
				conv.addLine(0, LINE_THING);
				conv.addChoice(0, "Please leave now and when you come back, I should be done.", -1);
			}
			else
			{
				conv.addLine(0, LINE_THING);
				conv.addChoice(0, "Ooooh!  You have 100 gold!  Do you want me to build the bridge?", 1);
				conv.addLine(1, LINE_PLAYER);
				conv.addChoice(1, "No.", 2);
				conv.addChoice(1, "Yes. <100 gold>", 3);
				conv.addChoice(1, "Why would I need a bridge?", 4);
				conv.addLine(2, LINE_THING);
				conv.addChoice(2, "Ok, well maybe later.", -1);
				conv.addLine(3, LINE_THING);
				conv.addChoice(3, "Great.  Please leave now and when you come back, I should be done.", -1);
				var action = new Object();
				action.go = function ()
				{
					Inventory_remove("Gold",100);
					SaveMaster.complete("Bridge1");
				};
				conv.addAction(3, action );
				conv.addLine(4, LINE_THING);
				conv.addChoice(4, "Why?  So you can travel back to the town more quickly.", -1);
			}
			break;
		}
		case "c20" :
		{
			// Beefo.
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Heeey " + SaveMaster.getPlayerName() + ".  Don't you like the bridge now?", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Yeah baby.", -1);
			break;
		}
		case "c21" :
		{
			// podlie.
			var hpMaxPrice = _root.board.hero.maxHP * 10
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hi, my name is podlie.  What can I get you?", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addLine(2, LINE_THING);

			// potion
			if ( SaveMaster.isComplete("Potions") )
			{
				conv.addChoice(1, "Potion   <30 gold>", 2);
				if ( Inventory_backPackIsFull () )
				{
					conv.addChoice(2, "Your back pack is full.  You should get a bigger one.", -1);
				}
				else
				{
					conv.addChoice(2, "Here you go.", -1);
					var action = new Object();
					action.go = function ()
					{
						Inventory_remove("Gold",30);
						mapMaster_addItem( "Potion", "dontsave", 440, 200, -1, -1, ACTION_LAYER );
					};
					conv.addAction(2, action );
				}
			}
			else
			{
				conv.addChoice(1, "Potion   <...>", 2);
				conv.addChoice(2, "I need 20 mushrooms and 20 watermelons to make a batch of potions.  Will you give me some?  <20 mushrooms> <20 watermelons>.", 5);
				conv.addLine(5, LINE_PLAYER);
				conv.addChoice(5, "Yes", 6);
				conv.addChoice(5, "No", -1);

				if ( Inventory_getQty("Melon") >= 20 && Inventory_getQty("Mushroom1") >= 20 )
				{
					conv.addLine(6, LINE_THING);
					conv.addChoice(6, "Great!  I'll start making potions now.", -1);
					var action = new Object();
					action.go = function ()
					{
						Inventory_remove("Mushroom1",20);
						Inventory_remove("Melon",20);
						SaveMaster.complete("Potions");
					};
					conv.addAction(6, action );
				}
				else
				{
					conv.addLine(6, LINE_THING);
					conv.addChoice(6, "Buddy, you don't have enough.", -1);
				}
			}

			// energy max up
			conv.addChoice(1, "Energy  <" + hpMaxPrice + " gold>", 3);
			conv.addChoice(1, "Trinket <20 gold>", 4);
			conv.addChoice(1, "Nothing right now thanks.", -1);
			conv.addLine(3, LINE_THING);
			if ( Inventory_getQty("Gold") >= hpMaxPrice )
			{
				conv.addChoice(3, "OK.  Here's an energy Max up for ya!", -1);
				var action = new Object();
				action.go = function ()
				{
					Inventory_remove("Gold",hpMaxPrice);
					mapMaster_addItem( "Energy", "dontsave", 440, 200, -1, -1, ACTION_LAYER );
				};
				conv.addAction(3, action );
			}
			else
			{
				conv.addChoice(3, "Dude, you don't have enough gold.", -1);
			}

			// trinket
			conv.addLine(4, LINE_THING);
			if ( Inventory_getQty("Gold") >= 20 )
			{
				conv.addChoice(4, "OK.  Here's a Trinket of Mahjru for ya!", -1);
				var action = new Object();
				action.go = function ()
				{
					Inventory_remove("Gold",20);
					mapMaster_addItem( "Trinket", "dontsave", 440, 200, -1, -1, ACTION_LAYER );
				};
				conv.addAction(4, action );
			}
			else
			{
				conv.addChoice(4, "Dude, you don't have enough gold.", -1);
			}


			break;
		}
		case "c22" :
		{
			// Tokugawa.
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "My name is Tokugawa.  Do you need some help?", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Yes.", 2);
			conv.addChoice(1, "No.", 3);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "Good choice.", 4);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "Suit yourself.", -1);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "First, I have played this game before.  I know all the tricks.  You should talk to me many times.", 5);
			if ( ! SaveMaster.isComplete( "SlimeBoss" ) )
			{
				conv.addLine(5, LINE_THING);
				conv.addChoice(5, "You have to beat the Slime King in the dungeon.", 6);
				conv.addLine(6, LINE_THING);
				conv.addChoice(6, "If you are having trouble beating him, save up and buy Potions and Trinkets.", 7);
				conv.addLine(7, LINE_THING);
				conv.addChoice(7, "You can only hold 3 items until you buy a bigger back pack.", 8);
				conv.addLine(8, LINE_THING);
				conv.addChoice(8, "There are many keys you have to find to get to the Slime King.", 9);
				conv.addLine(9, LINE_THING);
				conv.addChoice(9, "If you ever lose keyboard controls, click the game with your mouse.", 10);
				conv.addLine(10, LINE_THING);
				conv.addChoice(10, "That's enough for now.", -1);
			}
			else if ( ! SaveMaster.isComplete( "caracalla" ) )
			{
				conv.addLine(5, LINE_THING);
				conv.addChoice(5, "Good work defeating the Slime King.", 6);
				conv.addLine(6, LINE_THING);
				conv.addChoice(6, "Now travel through the Dwarf Cave to distant lands.", -1);
			}
			else if ( ! SaveMaster.isComplete( "iceking" ) )
			{
				conv.addLine(5, LINE_THING);
				conv.addChoice(5, "Did Meaty send you here?", 6);
				conv.addLine(6, LINE_THING);
				conv.addChoice(6, "He got lost in the ice cave.", 7);
				conv.addLine(7, LINE_THING);
				conv.addChoice(7, "The only way to get through is RIGHT RIGHT LEFT UP.", -1);
			}
			break;
		}
		case "c23" :
		{
			// Oscar.
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "I found a key, South South South.  But I can't reach it.", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Thanks Opposite Oscar.", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "By the way, carefull of that spring over there.  It will poison you.", -1);
			break;
		}
		case "c24" :
		{
			// Caracalla
			conv.addLine(0, LINE_PLAYER);
			conv.addChoice(0, "Who are you?", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "I am Caracalla.  This is where your silly little adventure ends!", -1);
			// lock the room and warp over to the lava.
			var action = new Object();
			action.go = function ()
			{
				mapMaster_addBlock( "TowerWall", "sealIn", 560, 200, -1, -1, BLOCK_LAYER );
				_root.board.sealIn.attachMovie("TowerWall", "dw2", layerMaster_use(BLOCK_LAYER), {_x:0, _y:40 } );
				_root.board.sealIn.attachMovie("TowerWall", "dw3", layerMaster_use(BLOCK_LAYER), {_x:0, _y:80 } );
				_root.board.sealIn.attachMovie("TowerWall", "dw4", layerMaster_use(BLOCK_LAYER), {_x:0, _y:120 } );

				fatherTime.step = 0;
				fatherTime.updateEvent = function ()
				{
					_root.board.Caracalla._y += 10;
					_root.board.Caracalla._height -= 10;
					if ( this.step >= 7 )
					{
						_root.board.Caracalla.removeMovieClip();
						mapMaster_addActor( "Caracalla", "", 40, 80, -1, -1, ACTION_LAYER );
						fatherTime.updateEvent = null;
					}
				};
			};
			conv.addAction(1, action );

			break;
		}
		case "c25" :
		{
			// BroMtekal.
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "My name is Bromtekal.  Can I help you?", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Where is the dwarf cave?", 2);
			conv.addChoice(1, "What is that warpy thing?", 3);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "It's right over there.  The cave can take you off the island.", -1);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "It's the training ground.  It get's harder every time you do it.", 4);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "Of course, you get rewarded for your training too!", -1);
			break;
		}
		case "c26" :
		{
			// Ice King
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "I am the Ice King.", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Your weapons are useless against me!", -1);
			// lock the room and warp over to the lava.
			var action = new Object();
			action.go = function ()
			{
				mapMaster_addBlock( "BubbleWall2", "sealIn", 560, 280, -1, -1, BLOCK_LAYER );
				_root.board.sealIn.attachMovie("BubbleWall2", "dwX", layerMaster_use(BLOCK_LAYER), {_x:0, _y:40 } );

				fatherTime.step = 0;
				fatherTime.updateEvent = function ()
				{
					if ( this.step >= 5 )
					{
						activeList_removeBlock(_root.board.IceKing);
						_root.board.IceKing.removeMovieClip();
						mapMaster_addActor( "IceKing", "", 80, 80, -1, -1, ACTION_LAYER );
						fatherTime.updateEvent = null;
					}
				};
			};
			conv.addAction(1, action );

			break;
		}
		case "c27" :
		{
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, "Hey there "+SaveMaster.getPlayerName()+".", 1);
			conv.addLine(1, LINE_PLAYER);
			conv.addChoice(1, "Hi.  And your name is?", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "It's Meaty!  Come on man!", 3);
			conv.addLine(3, LINE_PLAYER);
			conv.addChoice(3, "Sorry.", 4);
			conv.addLine(4, LINE_THING);
			conv.addChoice(4, "That's OK.  Be careful in there, man.  It's easy to get lost.  Tokugawa is the only one who knows how to get through.", 5);
			conv.addLine(5, LINE_PLAYER);
			conv.addChoice(5, "Thanks Meaty.", -1);
			break;
		}
		// 2/16/2006
		case "c28" :
		{
			// YOU WIN THE GAME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			conv.addLine(0, LINE_THING);
			conv.addChoice(0, SaveMaster.getPlayerName() + "!", 1);
			conv.addLine(1, LINE_THING);
			conv.addChoice(1, "Congratulations!", 2);
			conv.addLine(2, LINE_THING);
			conv.addChoice(2, "You won the game!", 3);
			conv.addLine(3, LINE_THING);
			conv.addChoice(3, "You beat all 3 enemies and earned " + Inventory_getQty ("Gold") + " gold.", 4);
			break;
		}
	}
	return conv;
};






