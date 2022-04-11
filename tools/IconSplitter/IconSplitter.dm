/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)


// Make objects move 8 pixels per tick when walking

mob
	step_size = 8

obj
	step_size = 8




/client/verb/split_dmi()
	set name = "Split Dmi"
	set desc = "Loads DmiToSplit.dmi and removes the icon_states of user provided input into another .dmi."
	set category = "Here"

	var/icon/DMIToSplit = icon('DmiToSplit.dmi')

	var/icon/RunningOutputCut = new()
	var/icon/RunningOutput = new()

	var/user_input
	while(!user_input)
		user_input = input(usr, "Enter the criteria for the icon_states you wish to be split. For example, doing _d_s will remove all rolled down jumpsuits.","Split Criteria", "")
	to_world("Your split criteria is [user_input]")

	for(var/OriginalState in icon_states(DMIToSplit))
		if(findtext(OriginalState, user_input))
			var/icon/ToAdd = icon(DMIToSplit, OriginalState)
			var/good_name = replacetext(OriginalState, user_input, "")
			good_name = "[good_name]_s"
			RunningOutputCut.Insert(ToAdd, good_name)
		else
			var/icon/ToAdd = icon(DMIToSplit, OriginalState)
			RunningOutput.Insert(ToAdd, OriginalState)

	usr << ftp(RunningOutput,"CutUpDmi.dmi")
	usr << ftp(RunningOutputCut, "CutUpDmiWithCriteria.dmi")