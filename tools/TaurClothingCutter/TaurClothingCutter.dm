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


/client/verb/suit_split()
	set name = "Cut Suits"
	set desc = "Loads fullsuits.dmi and cuts them with SuitCutter.dmi"
	set category = "Cut Standard"

	//Our clothes
	var/icon/SuitsToSnip = icon('suitstocovert/standard/fullsuits.dmi')

	//Our Species specific cutter icon
	var/icon/SuitCutter = icon('SuitCutter.dmi')

	var/icon/RunningOutput = new ()

	//For each original project
	for(var/SuitState in icon_states(SuitsToSnip))
		//For each piece we're going to cut
		for(var/CutterState in icon_states(SuitCutter))

			//The fully assembled icon to cut
			var/icon/Original = icon(SuitsToSnip,SuitState)

			//Our cookie cutter sprite
			var/icon/Cutter = icon(SuitCutter,CutterState)

			//We have to make these all black to cut with
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)

			//Blend with AND to cut
			Original.Blend(Cutter,ICON_AND) //AND, not ADD

			//Make a useful name, ideally we want to keep the same name to avoid headaches later.
			var/good_name = "[SuitState]"

			//Add to the output with the good name
			RunningOutput.Insert(Original,good_name)

	//Give the output. dmis get overwritten when exported to. So break up your saves in sequence and then import them all into the main file.
	usr << ftp(RunningOutput,"taursuits_.dmi")

// Lazy duplicate verbs to cut down on micro requirements. Just copy/paste the species into each cutter file, all wolf, all fox, etc.
/client/verb/coat_split()
	set name = "Cut Coats"
	set desc = "Loads coats.dmi and cuts them with CoatCutter.dmi"
	set category = "Cut Standard"

	var/icon/CoatsToSnip = icon('suitstocovert/standard/coats.dmi')
	var/icon/CoatCutter = icon('CoatCutter.dmi')
	var/icon/RunningOutput = new ()
	for(var/CoatState in icon_states(CoatsToSnip))
		for(var/CutterState in icon_states(CoatCutter))
			var/icon/Original = icon(CoatsToSnip,CoatState)
			var/icon/Cutter = icon(CoatCutter,CutterState)
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)
			Original.Blend(Cutter,ICON_AND)
			var/good_name = "[CoatState]"
			RunningOutput.Insert(Original,good_name)

	usr << ftp(RunningOutput,"taursuits_coats.dmi")

/client/verb/dress_split()
	set name = "Cut Dresses"
	set desc = "Loads dresses.dmi and cuts them with DressCutter.dmi"
	set category = "Cut Standard"

	var/icon/DressesToSnip = icon('suitstocovert/standard/dresses.dmi')
	var/icon/DressCutter = icon('DressCutter.dmi')
	var/icon/RunningOutput = new ()
	for(var/DressState in icon_states(DressesToSnip))
		for(var/CutterState in icon_states(DressCutter))
			var/icon/Original = icon(DressesToSnip,DressState)
			var/icon/Cutter = icon(DressCutter,CutterState)
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)
			Original.Blend(Cutter,ICON_AND)
			var/good_name = "[DressState]"
			RunningOutput.Insert(Original,good_name)

	usr << ftp(RunningOutput,"taursuits_dresses.dmi")

/client/verb/lsuit_split()
	set name = "Long Cut Suits"
	set desc = "Loads long fullsuit.dmi and cuts them with SuitCutter.dmi"
	set category = "Long Cut"

	var/icon/SuitsToSnip = icon('suitstocovert/long/fullsuits.dmi')
	var/icon/SuitCutter = icon('SuitCutter.dmi')
	var/icon/RunningOutput = new ()
	for(var/SuitState in icon_states(SuitsToSnip))
		for(var/CutterState in icon_states(SuitCutter))
			var/icon/Original = icon(SuitsToSnip,SuitState)
			var/icon/Cutter = icon(SuitCutter,CutterState)
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)
			Original.Blend(Cutter,ICON_AND)
			var/good_name = "[SuitState]"
			RunningOutput.Insert(Original,good_name)

	usr << ftp(RunningOutput,"taursuits_.dmi")

/client/verb/lcoat_split()
	set name = "Long Cut Coats"
	set desc = "Loads long coats.dmi and cuts them with CoatCutter.dmi"
	set category = "Long Cut"

	var/icon/CoatsToSnip = icon('suitstocovert/long/coats.dmi')
	var/icon/CoatCutter = icon('CoatCutter.dmi')
	var/icon/RunningOutput = new ()
	for(var/CoatState in icon_states(CoatsToSnip))
		for(var/CutterState in icon_states(CoatCutter))
			var/icon/Original = icon(CoatsToSnip,CoatState)
			var/icon/Cutter = icon(CoatCutter,CutterState)
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)
			Original.Blend(Cutter,ICON_AND)
			var/good_name = "[CoatState]"
			RunningOutput.Insert(Original,good_name)

	usr << ftp(RunningOutput,"taursuits_coats.dmi")

/client/verb/ldress_split()
	set name = "Long Cut Dresses"
	set desc = "Loads long dresses.dmi and cuts them with DressCutter.dmi"
	set category = "Long Cut"

	var/icon/DressesToSnip = icon('suitstocovert/long/dresses.dmi')
	var/icon/DressCutter = icon('DressCutter.dmi')
	var/icon/RunningOutput = new ()
	for(var/DressState in icon_states(DressesToSnip))
		for(var/CutterState in icon_states(DressCutter))
			var/icon/Original = icon(DressesToSnip,DressState)
			var/icon/Cutter = icon(DressCutter,CutterState)
			Cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)
			Original.Blend(Cutter,ICON_AND)
			var/good_name = "[DressState]"
			RunningOutput.Insert(Original,good_name)

	usr << ftp(RunningOutput,"taursuits_dresses.dmi")
