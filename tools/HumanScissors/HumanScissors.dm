/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)


// Make objects move 8 pixels per tick when walking
//usr << ftp(usr.working,"[usr.outfile].dmi")
mob
	step_size = 8

obj
	step_size = 8



/client/verb/split_sprites()
	set name = "Begin The Decimation"
	set desc = "Loads SpritesToSnip.dmi and cuts them with CookieCutter.dmi"
	set category = "Here"

	var/icon/SpritesToSnip = icon('SpritesToSnip.dmi')
	var/icon/CookieCutter = icon('CookieCutter.dmi')

	var/icon/RunningOutput = new ()

	//For each original project
	for(var/OriginalState in icon_states(SpritesToSnip))
		//For each piece we're going to cut
		for(var/CutterState in icon_states(CookieCutter))

			//The fully assembled icon to cut
			var/icon/Original = icon(SpritesToSnip,OriginalState)

			//Our cookie cutter sprite
			var/icon/Cutter = icon(CookieCutter,CutterState)

			//We have to make these all black to cut with
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)

			//Blend with AND to cut
			Original.Blend(Cutter,ICON_AND) //AND, not ADD

			//Make a useful name
			var/good_name = "[OriginalState]-[CutterState]"

			//Add to the output with the good name
			RunningOutput.Insert(Original,good_name)

	//Give the output
	usr << ftp(RunningOutput,"CutUpPeople.dmi")
