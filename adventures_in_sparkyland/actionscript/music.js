<!--
/*
Use this HTML:
<BGSOUND id="bgMusicID" LOOP=-1 SRC="town.mid">
<EMBED NAME="bgMusic" SRC="town.mid"
LOOP=TRUE AUTOSTART=TRUE HIDDEN=TRUE MASTERSOUND>

<EMBED NAME="adventure1" SRC="com/sparkyland/adventure/sounds/adventure1.mid"
LOOP=TRUE AUTOSTART=TRUE HIDDEN=TRUE MASTERSOUND width="128" height="128">
<EMBED NAME="adventure2" SRC="com/sparkyland/adventure/sounds/adventure2.mid"
LOOP=TRUE AUTOSTART=FALSE HIDDEN=TRUE MASTERSOUND width="128" height="128">
<EMBED NAME="adventure3" SRC="com/sparkyland/adventure/sounds/adventure3.mid"
LOOP=TRUE AUTOSTART=FALSE HIDDEN=TRUE MASTERSOUND width="128" height="128">
<EMBED NAME="joyful" SRC="com/sparkyland/adventure/sounds/joyful.mid"
LOOP=TRUE AUTOSTART=FALSE HIDDEN=TRUE MASTERSOUND width="128" height="128">

<EMBED NAME="adventure2" SRC="com/sparkyland/adventure/sounds/adventure2.mid" 
LOOP=TRUE AUTOSTART=FALSE HIDDEN=TRUE MASTERSOUND width="10" height="10">

*/

/*
2/20/2006
Here's the story as I know it.
EMBED works on IE and mozilla.  EMBED is finicky and you need a close tag.
BGsound works really well on ie, so I stick with it.
mozilla has no native midi support, so we have to use quick time.
The quicktime methods are Play() and Stop() (Capitalized)
Now, the FSCommand is used to go from flash to js.
FSCommand appears to work well on flash PC versions, but only works on Mac for flash player version 8.
you use fscommand in flash which called name/id_DoFSCommand in adventure.html.
For IE, the vbscript called the javascript name/id_DoFSCommand.
name/id_DoFSCommand calls flashCommand here in music.js.
*/

ver=parseInt(navigator.appVersion);
ie4=(ver>3  && navigator.appName!="Netscape")?1:0;
ns4=(ver>3  && navigator.appName=="Netscape")?1:0;
ns3=(ver==3 && navigator.appName=="Netscape")?1:0;

var currentSong = "silence.mid";

function parseFlashCommand( command, args )
{
	alert( "music.js: " + command + " " + args );
	if ( command == "loop" && args != currentSong )
	{
		playMusic( args );
	}
}

function playMusic( soundFile )
{
	alert("music.js: " + navigator.appName + " jml " + navigator.appVersion );
	alert( " currentSong " + currentSong + "\n" +
		" soundFile " + soundFile + "\n" +
		" ie4 " + ie4 + "\n" +
		" ns4 " + ns4 + "\n" +
		" ns3 " + ns3 + "\n" +
		" navigator.javaEnabled() " + navigator.javaEnabled() + "\n" +
		" navigator.mimeTypes['audio/x-midi'] " + navigator.mimeTypes['audio/x-midi'] + "\n" +
		" currentSong " + currentSong + "\n"
		);

	if (ie4)
	{
		//alert("ie4");
		document.all['bgMusicID'].src =  "com/sparkyland/adventure/sounds/" + soundFile + ".mid";
	}
	if ((ns4||ns3)
//		&& navigator.javaEnabled() == true
//		&& navigator.mimeTypes['audio/x-midi'] != null
//		&& self.document.bgMusic.IsReady()
		)
	{
		//alert( " self.document.bgMusic.IsReady() " + document.bgMusic.IsReady() + "\n" +
		//	" self.document.bgMusic " + document.bgMusic + "\n"
		//	);
		//alert( "frame " + document.all.musicframe + " " + "com/sparkyland/adventure/sounds/" + soundFile + ".html" );


		//2/18/2006
		// This F'ing works, but shit shit shit, Flash loses keyboard focus.
		//document.all.musicframe.src = "com/sparkyland/adventure/sounds/" + soundFile + ".html";
		//document.all.myFlash.focus();

		//alert("Play" + "com/sparkyland/adventure/sounds/" + soundFile + ".mid");
		//document.all.advboss.Play();
		//document.all.mozilla_music.SetURL("com/sparkyland/adventure/sounds/" + soundFile + ".mid")
		//document.all.mozilla_music.Play();

		// These stop/start commands work on mac/pc all browsers, but this function is not being called on a mac.
		alert ( "music.js: ns " );
		if (currentSong != "silence.mid" )
		{
			alert("document[currentSong].Stop();");
			document[currentSong].Stop();
		}
		document[soundFile].Play();
		alert("document[soundFile].Play();");
	}
	currentSong = soundFile;
}
function stopMusic()
{
	currentSong = "silence.mid";
	if (ie4)
		document.all['bgMusicID'].src='silence.mid';
	if ((ns4||ns3)
		&& navigator.javaEnabled()
		&& navigator.mimeTypes['audio/x-midi']
		)
	{
		self.document.bgMusic.stop();
	}
}

/*
Listing 1-4 Using JavaScript to play, stop, and replace a QuickTime movie
<html>
<head>
<title>Simple QuickTime Movie Controls</title>
</head>
<script language ="JavaScript">
<!--
// define function that calls QuickTime's "Play" method
function PlayIt(anObj)
{
anObj.Play();
}
14 Controlling QuickTime Using JavaScript
2005-10-04 | © 2004, 2005 Apple Computer, Inc. All Rights Reserved.
C H A P T E R 1
QuickTime and JavaScript
// define function that calls QuickTime's "Stop" method
function StopIt(anObj)
{
anObj.Stop();
}
//-->
</script>
<body >
<P>
This page uses JavaScript to control a QuickTime movie...
</P>
<div align=center>
<table>
<tr>
<td width=200>
<OBJECT classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B"
codebase="http://www.apple.com/qtactivex/qtplugin.cab"
width="180" height="160"
id="movie1" >
<PARAM name="src" value="My.mov">
<EMBED width="180" height="160"
src="My.mov"
TYPE="video/quicktime"
PLUGINSPAGE="www.apple.com/quicktime/download"
name="movie1"
enablejavascript="true">
</EMBED>
</OBJECT>
<P> Movie1 </P>
</td>
<td width=200>
<OBJECT classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B"
codebase="http://www.apple.com/qtactivex/qtplugin.cab"
width="180" height="160"
id="movie2" >
<PARAM name="src" value="MyOther.mov">
<EMBED width="180" height="160"
src="MyOther.mov"
TYPE="video/quicktime"
PLUGINSPAGE="www.apple.com/quicktime/download"
name="movie2"
enablejavascript="true">
</EMBED>
</OBJECT>
<P> Movie2 </P>
</td>
</tr>
</table>
</div>
Controlling QuickTime Using JavaScript 15
2005-10-04 | © 2004, 2005 Apple Computer, Inc. All Rights Reserved.
C H A P T E R 1
QuickTime and JavaScript
<P>Pass movie name as a parameter to JavaScript functions defined locally: <br>
<a href="javascript:PlayIt(document.movie1);">PlayIt(movie1)</a><br>
<a href="javascript:StopIt(document.movie1);">StopIt(movie1)</a><br>
<a href="javascript:PlayIt(document.movie2);">PlayIt(movie2)</a><br>
<a href="javascript:StopIt(document.movie2);">StopIt(movie2)</a><br>
</P>
<P>Control movie by name directly: <br>
<a href="javascript:document.movie1.Play();">movie1.Play()</a><br>
<a href="javascript:document.movie1.Stop();">movie1.Stop()</a><br>
<a href="javascript:document.movie2.Play();">movie2.Play()</a><br>
<a href="javascript:document.movie2.Stop();">movie2.Stop()</a><br>
</P>
<P>Replace a movie by name directly: <br>
<a
href="javascript:document.movie1.SetURL('MyOther.mov');">movie1.SetURL(MyOther.mov)</a><br>
<a
href="javascript:document.movie1.SetURL('My.mov');">movie1.SetURL(My.mov)</a><br>
<a
href="javascript:document.movie2.SetURL('MyOther.mov');">movie2.SetURL(MyOther.mov)</a><br>
<a
href="javascript:document.movie2.SetURL('My.mov');">movie2.SetURL(My.mov)</a><br>
</P>
</body>
</html>
*/
//-->
