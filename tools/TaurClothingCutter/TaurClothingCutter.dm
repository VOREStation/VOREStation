/*
	Basic settings pls ignore
*/

world
	fps = 25
	icon_size = 32
	view = 6

mob/step_size = 8
obj/step_size = 8


// ============================================================================
// CUT STANDARD TAB
// ============================================================================


/client/verb/header_batchstandard_outfit()
	set name = "BATCH Cut ALL Standard Outfits"
	set category = "Cut Standard"

/client/verb/suit_split()
	set name = "Cut Suits"
	set desc = "Loads fullsuits.dmi and cuts them with SuitCutter.dmi"
	set category = "Cut Standard"
	batch_cut_icons('suitstocovert/standard/fullsuits.dmi', 'SuitCutter.dmi', prefix = "taursuits_")

/client/verb/coat_split()
	set name = "Cut Coats"
	set desc = "Loads coats.dmi and cuts them with CoatCutter.dmi"
	set category = "Cut Standard"
	batch_cut_icons('suitstocovert/standard/coats.dmi', 'CoatCutter.dmi', suffix = "_coats")

/client/verb/dress_split()
	set name = "Cut Dresses"
	set desc = "Loads dresses.dmi and cuts them with DressCutter.dmi"
	set category = "Cut Standard"
	batch_cut_icons('suitstocovert/standard/dresses.dmi', 'DressCutter.dmi', suffix = "_dresses")


// ============================================================================
// CUT LONG TAB
// ============================================================================


/client/verb/header_batchlong_outfit()
	set name = "BATCH Cut ALL Long Outfits"
	set category = "Cut Long"

/client/verb/lsuit_split()
	set name = "Long Cut Suits"
	set desc = "Loads long fullsuit.dmi and cuts them with LongSuitCutter.dmi"
	set category = "Cut Long"
	batch_cut_icons('suitstocovert/long/fullsuits.dmi', 'LongSuitCutter.dmi', prefix = "taursuits_")

/client/verb/lcoat_split()
	set name = "Long Cut Coats"
	set desc = "Loads long coats.dmi and cuts them with LongCoatCutter.dmi"
	set category = "Cut Long"
	batch_cut_icons('suitstocovert/long/coats.dmi', 'LongCoatCutter.dmi', suffix = "_coats")

/client/verb/ldress_split()
	set name = "Long Cut Dresses"
	set desc = "Loads long dresses.dmi and cuts them with LongDressCutter.dmi"
	set category = "Cut Long"
	batch_cut_icons('suitstocovert/long/dresses.dmi', 'LongDressCutter.dmi', suffix = "_dresses")


// ============================================================================
// CUT SINGLE TAB
// ============================================================================


/client/verb/header_single_outfit()
	set name = "Cut Everything in singleoutfit.dmi with Everything in SingleCutter.dmi"
	set category = "Cut Single"

/client/verb/single_outfit_split()
	set name = "Cut Single Outfit"
	set desc = "Loads singleoutfit.dmi and cuts them with SingleCutter.dmi"
	set category = "Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'SingleCutter.dmi', suffix = "_outfit")


// ============================================================================
// BATCH CUT SINGLE TAB
// ============================================================================


/client/verb/header_batchsingle_outfit()
	set name = "Batch Cut a SINGLE Outfit"
	set category = "Batch Cut Single"

/client/verb/single_suit_split()
	set name = "Cut Single Suit (Batch)"
	set desc = "Loads singleoutfit.dmi and cuts them with SuitCutter.dmi"
	set category = "Batch Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'SuitCutter.dmi', suffix = "_suit")

/client/verb/lsingle_suit_split()
	set name = "Cut Single Long Suit (Batch)"
	set desc = "Loads singleoutfit.dmi and cuts them with LongSuitCutter.dmi"
	set category = "Batch Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'LongSuitCutter.dmi', suffix = "_suit")

/client/verb/single_coat_split()
	set name = "Cut Single Coat (Batch)"
	set desc = "Loads singleoutfit.dmi and cuts them with CoatCutter.dmi"
	set category = "Batch Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'CoatCutter.dmi', suffix = "_coat")

/client/verb/lsingle_coat_split()
	set name = "Cut Single Long Coat (Batch)"
	set desc = "Loads singleoutfit.dmi and cuts them with LongCoatCutter.dmi"
	set category = "Batch Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'LongCoatCutter.dmi', suffix = "_coat")

/client/verb/single_dress_split()
	set name = "Cut Single Dress (Batch)"
	set desc = "Loads singleoutfit.dmi and cuts them with DressCutter.dmi"
	set category = "Batch Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'DressCutter.dmi', suffix = "_dress")

/client/verb/lsingle_dress_split()
	set name = "Cut Single Long Dress (Batch)"
	set desc = "Loads singleoutfit.dmi and cuts them with LongDressCutter.dmi"
	set category = "Batch Cut Single"
	batch_cut_icons('suitstocovert/singleoutfit.dmi', 'LongDressCutter.dmi', suffix = "_dress")

/client/proc/batch_cut_icons(source_file, cutter_file, prefix = "", suffix = "")
	if(!source_file || !cutter_file)
		return

	//Our clothes
	var/icon/SourceIcon = icon(source_file)

	//Our Species specific cutter icons
	var/icon/CutterIcon = icon(cutter_file)

	//For each original project, batch it!
	for(var/CutterState in icon_states(CutterIcon))
		var/icon/RunningOutput = new ()

		for(var/SourceState in icon_states(SourceIcon))

			//Our clothing to cut out
			var/icon/Original = icon(SourceIcon, SourceState)

			//Our cookie cutter taur form
			var/icon/Cutter = icon(CutterIcon, CutterState)

			// Convert cutter mask to black
			Cutter.Blend(rgb(0, 0, 0), ICON_MULTIPLY)

			//Blend with AND (NOT ADD) to cut
			Original.Blend(Cutter, ICON_AND)

			//Add to the output with the clothing name
			RunningOutput.Insert(Original, "[SourceState]")

		// Get our custom cut dmi result: [prefix][CutterState][suffix].dmi
		var/out_name = "[prefix][CutterState][suffix].dmi"
		src << ftp(RunningOutput, out_name)
