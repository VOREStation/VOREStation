#define VORE_SOUND_FALLOFF 0.1
#define VORE_SOUND_RANGE 3

//
//  Belly system 2.0, now using objects instead of datums because EH at datums.
//	How many times have I rewritten bellies and vore now? -Aro
//

// If you change what variables are on this, then you need to update the copy() proc.

//
// Parent type of all the various "belly" varieties.
//
/obj/belly
	name = "belly"							// Name of this location
	desc = "It's a belly! You're in it!"	// Flavor text description of inside sight/sound/smells/feels.
	var/vore_sound = "Gulp"					// Sound when ingesting someone
	var/vore_verb = "ingest"				// Verb for eating with this in messages
	var/release_verb = "expels"				// Verb for releasing something from a stomach
	var/human_prey_swallow_time = 100		// Time in deciseconds to swallow /mob/living/carbon/human
	var/nonhuman_prey_swallow_time = 30		// Time in deciseconds to swallow anything else
	var/nutrition_percent = 100				// Nutritional percentage per tick in digestion mode
	var/digest_brute = 0.5					// Brute damage per tick in digestion mode
	var/digest_burn = 0.5					// Burn damage per tick in digestion mode
	var/digest_oxy = 0						// Oxy damage per tick in digestion mode
	var/digest_tox = 0						// Toxins damage per tick in digestion mode
	var/digest_clone = 0					// Clone damage per tick in digestion mode
	var/immutable = FALSE					// Prevents this belly from being deleted
	var/escapable = FALSE					// Belly can be resisted out of at any time
	var/escapetime = 10 SECONDS				// Deciseconds, how long to escape this belly
	var/digestchance = 0					// % Chance of stomach beginning to digest if prey struggles
	var/absorbchance = 0					// % Chance of stomach beginning to absorb if prey struggles
	var/escapechance = 0 					// % Chance of prey beginning to escape if prey struggles.
	var/escapechance_absorbed = 0			// % Chance of absorbed prey finishing an escape. Requires a successful escape roll against the above as well.
	var/escape_stun = 0						// AI controlled mobs with a number here will be weakened by the provided var when someone escapes, to prevent endless nom loops
	var/transferchance = 0 					// % Chance of prey being trasnsfered, goes from 0-100%
	var/transferchance_secondary = 0 		// % Chance of prey being transfered to transferchance_secondary, also goes 0-100%
	var/save_digest_mode = TRUE				// Whether this belly's digest mode persists across rounds
	var/can_taste = FALSE					// If this belly prints the flavor of prey when it eats someone.
	var/bulge_size = 0.25					// The minimum size the prey has to be in order to show up on examine.
	var/display_absorbed_examine = FALSE	// Do we display absorption examine messages for this belly at all?
	var/absorbed_desc						// Desc shown to absorbed prey. Defaults to regular if left empty.
	var/shrink_grow_size = 1				// This horribly named variable determines the minimum/maximum size it will shrink/grow prey to.
	var/transferlocation					// Location that the prey is released if they struggle and get dropped off.
	var/transferlocation_secondary			// Secondary location that prey is released to.
	var/release_sound = "Splatter"			// Sound for letting someone out. Replaced from True/false
	var/mode_flags = 0						// Stripping, numbing, etc.
	var/fancy_vore = FALSE					// Using the new sounds?
	var/is_wet = TRUE						// Is this belly's insides made of slimy parts?
	var/wet_loop = TRUE						// Does the belly have a fleshy loop playing?
	var/obj/item/weapon/storage/vore_egg/ownegg	// Is this belly creating an egg?
	var/egg_type = "Egg"					// Default egg type and path.
	var/egg_path = /obj/item/weapon/storage/vore_egg
	var/list/list/emote_lists = list()			// Idle emotes that happen on their own, depending on the bellymode. Contains lists of strings indexed by bellymode
	var/emote_time = 60						// How long between stomach emotes at prey (in seconds)
	var/emote_active = TRUE					// Are we even giving emotes out at all or not?
	var/next_emote = 0						// When we're supposed to print our next emote, as a world.time
	var/selective_preference = DM_DIGEST	// Which type of selective bellymode do we default to?
	var/eating_privacy_local = "default"	//Overrides eating_privacy_global if not "default". Determines if attempt/success messages are subtle/loud
	var/silicon_belly_overlay_preference = "Sleeper" //Selects between placing belly overlay in sleeper or normal vore mode. Exclusive
	var/belly_mob_mult = 1		//Multiplier for how filling mob types are in borg bellies
	var/belly_item_mult = 1 	//Multiplier for how filling items are in borg borg bellies. Items are also weighted on item size
	var/belly_overall_mult = 1	//Multiplier applied ontop of any other specific multipliers

	// Generally just used by AI
	var/autotransferchance = 0 				// % Chance of prey being autotransferred to transfer location
	var/autotransferwait = 10 				// Time between trying to transfer.
	var/autotransferlocation				// Place to send them

	//I don't think we've ever altered these lists. making them static until someone actually overrides them somewhere.
	//Actual full digest modes
	var/tmp/static/list/digest_modes = list(DM_HOLD,DM_DIGEST,DM_ABSORB,DM_DRAIN,DM_SELECT,DM_UNABSORB,DM_HEAL,DM_SHRINK,DM_GROW,DM_SIZE_STEAL,DM_EGG)
	//Digest mode addon flags
	var/tmp/static/list/mode_flag_list = list("Numbing" = DM_FLAG_NUMBING, "Stripping" = DM_FLAG_STRIPPING, "Leave Remains" = DM_FLAG_LEAVEREMAINS, "Muffles" = DM_FLAG_THICKBELLY, "Affect Worn Items" = DM_FLAG_AFFECTWORN, "Jams Sensors" = DM_FLAG_JAMSENSORS, "Complete Absorb" = DM_FLAG_FORCEPSAY)
	//Item related modes
	var/tmp/static/list/item_digest_modes = list(IM_HOLD,IM_DIGEST_FOOD,IM_DIGEST)

	//List of slots that stripping handles strips
	var/tmp/static/list/slots = list(slot_back,slot_handcuffed,slot_l_store,slot_r_store,slot_wear_mask,slot_l_hand,slot_r_hand,slot_wear_id,slot_glasses,slot_gloves,slot_head,slot_shoes,slot_belt,slot_wear_suit,slot_w_uniform,slot_s_store,slot_l_ear,slot_r_ear)

	var/tmp/mob/living/owner					// The mob whose belly this is.
	var/tmp/digest_mode = DM_HOLD				// Current mode the belly is set to from digest_modes (+transform_modes if human)
	var/tmp/list/items_preserved = list()		// Stuff that wont digest so we shouldn't process it again.
	var/tmp/recent_sound = FALSE				// Prevent audio spam

	// Don't forget to watch your commas at the end of each line if you change these.
	var/list/struggle_messages_outside = list(
		"%pred's %belly wobbles with a squirming meal.",
		"%pred's %belly jostles with movement.",
		"%pred's %belly briefly swells outward as someone pushes from inside.",
		"%pred's %belly fidgets with a trapped victim.",
		"%pred's %belly jiggles with motion from inside.",
		"%pred's %belly sloshes around.",
		"%pred's %belly gushes softly.",
		"%pred's %belly lets out a wet squelch.")

	var/list/struggle_messages_inside = list(
		"Your useless squirming only causes %pred's slimy %belly to squelch over your body.",
		"Your struggles only cause %pred's %belly to gush softly around you.",
		"Your movement only causes %pred's %belly to slosh around you.",
		"Your motion causes %pred's %belly to jiggle.",
		"You fidget around inside of %pred's %belly.",
		"You shove against the walls of %pred's %belly, making it briefly swell outward.",
		"You jostle %pred's %belly with movement.",
		"You squirm inside of %pred's %belly, making it wobble around.")

	var/list/absorbed_struggle_messages_outside = list(
		"%pred's %belly wobbles, seemingly on its own.",
		"%pred's %belly jiggles without apparent cause.",
		"%pred's %belly seems to shake for a second without an obvious reason.")

	var/list/absorbed_struggle_messages_inside = list(
		"You try and resist %pred's %belly, but only cause it to jiggle slightly.",
		"Your fruitless mental struggles only shift %pred's %belly a tiny bit.",
		"You can't make any progress freeing yourself from %pred's %belly.")

	var/list/escape_attempt_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	var/list/escape_attempt_messages_prey = list(
		"You start to climb out of %pred's %belly.")

	var/list/escape_messages_owner = list(
		"%prey climbs out of your %belly!")

	var/list/escape_messages_prey = list(
		"You climb out of %pred's %belly.")

	var/list/escape_messages_outside = list(
		"%prey climbs out of %pred's %belly!")

	var/list/escape_item_messages_owner = list(
		"%item suddenly slips out of your %belly!")

	var/list/escape_item_messages_prey = list(
		"Your struggles successfully cause %pred to squeeze your %item out of their %belly.")

	var/list/escape_item_messages_outside = list(
		"%item suddenly slips out of %pred's %belly!")

	var/list/escape_fail_messages_owner = list(
		"%prey's attempt to escape from your %belly has failed!")

	var/list/escape_fail_messages_prey = list(
		"Your attempt to escape %pred's %belly has failed!")

	var/list/escape_attempt_absorbed_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	var/list/escape_attempt_absorbed_messages_prey = list(
		"You try to force yourself out of %pred's %belly.")

	var/list/escape_absorbed_messages_owner = list(
		"%prey forces themselves free of your %belly!")

	var/list/escape_absorbed_messages_prey = list(
		"You manage to free yourself from %pred's %belly.")

	var/list/escape_absorbed_messages_outside = list(
		"%prey climbs out of %pred's %belly!")

	var/list/escape_fail_absorbed_messages_owner = list(
		"%prey's attempt to escape form your %belly has failed!")

	var/list/escape_fail_absorbed_messages_prey = list(
		"Before you manage to reach freedom, you feel yourself getting dragged back into %pred's %belly!")

	var/list/primary_transfer_messages_owner = list(
		"%prey slid into your %dest due to their struggling inside your %belly!")

	var/list/primary_transfer_messages_prey = list(
		"Your attempt to escape %pred's %belly has failed and your struggles only results in you sliding into pred's %dest!")

	var/list/secondary_transfer_messages_owner = list(
		"%prey slid into your %dest due to their struggling inside your %belly!")

	var/list/secondary_transfer_messages_prey = list(
		"Your attempt to escape %pred's %belly has failed and your struggles only results in you sliding into pred's %dest!")

	var/list/digest_chance_messages_owner = list(
		"You feel your %belly beginning to become active!")

	var/list/digest_chance_messages_prey = list(
		"In response to your struggling, %owner's %belly begins to get more active...")

	var/list/absorb_chance_messages_owner = list(
		"You feel your %belly start to cling onto its contents...")

	var/list/absorb_chance_messages_prey = list(
		"In response to your struggling, %owner's %belly begins to cling more tightly...")

	var/list/digest_messages_owner = list(
		"You feel %prey's body succumb to your digestive system, which breaks it apart into soft slurry.",
		"You hear a lewd glorp as your %belly muscles grind %prey into a warm pulp.",
		"Your %belly lets out a rumble as it melts %prey into sludge.",
		"You feel a soft gurgle as %prey's body loses form in your %belly. They're nothing but a soft mass of churning slop now.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your thighs.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your rump.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your belly.",
		"Your %belly groans as %prey falls apart into a thick soup. You can feel their remains soon flowing deeper into your body to be absorbed.",
		"Your %belly kneads on every fiber of %prey, softening them down into mush to fuel your next hunt.",
		"Your %belly churns %prey down into a hot slush. You can feel the nutrients coursing through your digestive track with a series of long, wet glorps.")

	var/list/digest_messages_prey = list(
		"Your body succumbs to %pred's digestive system, which breaks you apart into soft slurry.",
		"%pred's %belly lets out a lewd glorp as their muscles grind you into a warm pulp.",
		"%pred's %belly lets out a rumble as it melts you into sludge.",
		"%pred feels a soft gurgle as your body loses form in their %belly. You're nothing but a soft mass of churning slop now.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's thighs.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's rump.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's belly.",
		"%pred's %belly groans as you fall apart into a thick soup. Your remains soon flow deeper into %pred's body to be absorbed.",
		"%pred's %belly kneads on every fiber of your body, softening you down into mush to fuel their next hunt.",
		"%pred's %belly churns you down into a hot slush. Your nutrient-rich remains course through their digestive track with a series of long, wet glorps.")

	var/list/absorb_messages_owner = list(
		"You feel %prey becoming part of you.")

	var/list/absorb_messages_prey = list(
		"You feel yourself becoming part of %pred's %belly!")

	var/list/unabsorb_messages_owner = list(
		"You feel %prey reform into a recognizable state again.")

	var/list/unabsorb_messages_prey = list(
		"You are released from being part of %pred's %belly.")

	var/list/examine_messages = list(
		"They have something solid in their %belly!",
		"It looks like they have something in their %belly!")

	var/list/examine_messages_absorbed = list(
		"Their body looks somewhat larger than usual around the area of their %belly.",
		"Their %belly looks larger than usual.")

	var/item_digest_mode = IM_DIGEST_FOOD	// Current item-related mode from item_digest_modes
	var/contaminates = FALSE					// Whether the belly will contaminate stuff
	var/contamination_flavor = "Generic"	// Determines descriptions of contaminated items
	var/contamination_color = "green"		// Color of contamination overlay

	// Lets you do a fullscreen overlay. Set to an icon_state string.
	var/belly_fullscreen = ""
	var/disable_hud = FALSE
	var/colorization_enabled = FALSE
	var/belly_fullscreen_color = "#823232"
	var/belly_fullscreen_color_secondary = "#428242"
	var/belly_fullscreen_color_trinary = "#f0f0f0"

//For serialization, keep this updated, required for bellies to save correctly.
/obj/belly/vars_to_save()
	var/list/saving = list(
	"name",
	"desc",
	"absorbed_desc",
	"vore_sound",
	"vore_verb",
	"release_verb",
	"human_prey_swallow_time",
	"nonhuman_prey_swallow_time",
	"emote_time",
	"nutrition_percent",
	"digest_brute",
	"digest_burn",
	"digest_oxy",
	"digest_tox",
	"digest_clone",
	"immutable",
	"can_taste",
	"escapable",
	"escapetime",
	"digestchance",
	"absorbchance",
	"escapechance",
	"escapechance_absorbed",
	"transferchance",
	"transferchance_secondary",
	"transferlocation",
	"transferlocation_secondary",
	"bulge_size",
	"display_absorbed_examine",
	"shrink_grow_size",
	"struggle_messages_outside",
	"struggle_messages_inside",
	"absorbed_struggle_messages_outside",
	"absorbed_struggle_messages_inside",
	"escape_attempt_messages_owner",
	"escape_attempt_messages_prey",
	"escape_messages_owner",
	"escape_messages_prey",
	"escape_messages_outside",
	"escape_item_messages_owner",
	"escape_item_messages_prey",
	"escape_item_messages_outside",
	"escape_fail_messages_owner",
	"escape_fail_messages_prey",
	"escape_attempt_absorbed_messages_owner",
	"escape_attempt_absorbed_messages_prey",
	"escape_absorbed_messages_owner",
	"escape_absorbed_messages_prey",
	"escape_absorbed_messages_outside",
	"escape_fail_absorbed_messages_owner",
	"escape_fail_absorbed_messages_prey",
	"primary_transfer_messages_owner",
	"primary_transfer_messages_prey",
	"secondary_transfer_messages_owner",
	"secondary_transfer_messages_prey",
	"digest_chance_messages_owner",
	"digest_chance_messages_prey",
	"absorb_chance_messages_owner",
	"absorb_chance_messages_prey",
	"digest_messages_owner",
	"digest_messages_prey",
	"absorb_messages_owner",
	"absorb_messages_prey",
	"unabsorb_messages_owner",
	"unabsorb_messages_prey",
	"examine_messages",
	"examine_messages_absorbed",
	"emote_lists",
	"emote_time",
	"emote_active",
	"selective_preference",
	"mode_flags",
	"item_digest_mode",
	"contaminates",
	"contamination_flavor",
	"contamination_color",
	"release_sound",
	"fancy_vore",
	"is_wet",
	"wet_loop",
	"belly_fullscreen",
	"disable_hud",
	"belly_fullscreen_color",
	"belly_fullscreen_color_secondary",
	"belly_fullscreen_color_trinary",
	"colorization_enabled",
	"egg_type",
	"save_digest_mode",
	"eating_privacy_local",
	"silicon_belly_overlay_preference",
	"belly_mob_mult",
	"belly_item_mult",
	"belly_overall_mult",
	)

	if (save_digest_mode == 1)
		return ..() + saving + list("digest_mode")

	return ..() + saving

/obj/belly/Initialize()
	. = ..()
	//If not, we're probably just in a prefs list or something.
	if(ismob(loc))
		owner = loc
		owner.vore_organs |= src
		if(isliving(loc))
			START_PROCESSING(SSbellies, src)

/obj/belly/Destroy()
	STOP_PROCESSING(SSbellies, src)
	owner?.vore_organs?.Remove(src)
	owner = null
	return ..()

// Called whenever an atom enters this belly
/obj/belly/Entered(atom/movable/thing, atom/OldLoc)
	if(OldLoc in contents)
		return //Someone dropping something (or being stripdigested)

	//Generic entered message
	to_chat(owner,"<span class='vnotice'>[thing] slides into your [lowertext(name)].</span>")

	//Sound w/ antispam flag setting
	if(vore_sound && !recent_sound)
		var/soundfile
		if(!fancy_vore)
			soundfile = classic_vore_sounds[vore_sound]
		else
			soundfile = fancy_vore_sounds[vore_sound]
		if(soundfile)
			playsound(src, soundfile, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
			recent_sound = TRUE

	//Messages if it's a mob
	if(isliving(thing))
		var/mob/living/M = thing
		M.updateVRPanel()
		var/raw_desc //Let's use this to avoid needing to write the reformat code twice
		if(absorbed_desc && M.absorbed)
			raw_desc = absorbed_desc
		else if(desc)
			raw_desc = desc

		//Was there a description text? If so, it's time to format it!
		if(raw_desc)
			//Replace placeholder vars
			var/formatted_desc
			formatted_desc = replacetext(raw_desc, "%belly", lowertext(name)) //replace with this belly's name
			formatted_desc = replacetext(formatted_desc, "%pred", owner) //replace with this belly's owner
			formatted_desc = replacetext(formatted_desc, "%prey", M) //replace with whatever mob entered into this belly
			to_chat(M, "<span class='vnotice'><B>[formatted_desc]</B></span>")

		var/taste
		if(can_taste && (taste = M.get_taste_message(FALSE)))
			to_chat(owner, "<span class='vnotice'>[M] tastes of [taste].</span>")
		vore_fx(M)
		//Stop AI processing in bellies
		if(M.ai_holder)
			M.ai_holder.handle_eaten()

	// Intended for simple mobs
	if(!owner.client && autotransferlocation && autotransferchance > 0)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/belly, check_autotransfer), thing, autotransferlocation), autotransferwait)

// Called whenever an atom leaves this belly
/obj/belly/Exited(atom/movable/thing, atom/OldLoc)
	. = ..()
	if(isliving(thing) && !isbelly(thing.loc))
		var/mob/living/L = thing
		L.clear_fullscreen("belly")
		L.clear_fullscreen("belly2")
		L.clear_fullscreen("belly3")
		L.clear_fullscreen("belly4")
		if(L.hud_used)
			if(!L.hud_used.hud_shown)
				L.toggle_hud_vis()
		if((L.stat != DEAD) && L.ai_holder)
			L.ai_holder.go_wake()

/obj/belly/proc/vore_fx(mob/living/L)
	if(!istype(L))
		return
	if(!L.client)
		return
	if(!L.show_vore_fx)
		L.clear_fullscreen("belly")
		return

	if(belly_fullscreen)
		if(colorization_enabled)
			var/obj/screen/fullscreen/F = L.overlay_fullscreen("belly", /obj/screen/fullscreen/belly/colorized)
			F.icon_state = belly_fullscreen
			F.color = belly_fullscreen_color
			if("[belly_fullscreen]_l1" in icon_states('icons/mob/screen_full_colorized_vore_overlays.dmi'))
				var/obj/screen/fullscreen/F2 = L.overlay_fullscreen("belly2", /obj/screen/fullscreen/belly/colorized/overlay)
				F2.icon_state = "[belly_fullscreen]_l1"
				F2.color = belly_fullscreen_color_secondary
			else
				L.clear_fullscreen("belly2")
			if("[belly_fullscreen]_l2" in icon_states('icons/mob/screen_full_colorized_vore_overlays.dmi'))
				var/obj/screen/fullscreen/F3 = L.overlay_fullscreen("belly3", /obj/screen/fullscreen/belly/colorized/overlay)
				F3.icon_state = "[belly_fullscreen]_l2"
				F3.color = belly_fullscreen_color_trinary
			else
				L.clear_fullscreen("belly3")
			if("[belly_fullscreen]_nc" in icon_states('icons/mob/screen_full_colorized_vore_overlays.dmi'))
				var/obj/screen/fullscreen/F4 = L.overlay_fullscreen("belly4", /obj/screen/fullscreen/belly/colorized/overlay)
				F4.icon_state = "[belly_fullscreen]_nc"
			else
				L.clear_fullscreen("belly4")
		else
			var/obj/screen/fullscreen/F = L.overlay_fullscreen("belly", /obj/screen/fullscreen/belly)
			F.icon_state = belly_fullscreen
	else
		L.clear_fullscreen("belly")
		L.clear_fullscreen("belly2")
		L.clear_fullscreen("belly3")
		L.clear_fullscreen("belly4")

	if(disable_hud)
		if(L?.hud_used?.hud_shown)
			to_chat(L, "<span class='vnotice'>((Your pred has disabled huds in their belly. Turn off vore FX and hit F12 to get it back; or relax, and enjoy the serenity.))</span>")
			L.toggle_hud_vis(TRUE)

/obj/belly/proc/vore_preview(mob/living/L)
	if(!istype(L))
		return
	if(!L.client)
		return

	if(belly_fullscreen)
		if(colorization_enabled)
			var/obj/screen/fullscreen/F = L.overlay_fullscreen("belly", /obj/screen/fullscreen/belly/colorized)
			F.icon_state = belly_fullscreen
			F.color = belly_fullscreen_color
			if("[belly_fullscreen]_l1" in icon_states('icons/mob/screen_full_colorized_vore_overlays.dmi'))
				var/obj/screen/fullscreen/F2 = L.overlay_fullscreen("belly2", /obj/screen/fullscreen/belly/colorized/overlay)
				F2.icon_state = "[belly_fullscreen]_l1"
				F2.color = belly_fullscreen_color_secondary
			if("[belly_fullscreen]_l2" in icon_states('icons/mob/screen_full_colorized_vore_overlays.dmi'))
				var/obj/screen/fullscreen/F3 = L.overlay_fullscreen("belly3", /obj/screen/fullscreen/belly/colorized/overlay)
				F3.icon_state = "[belly_fullscreen]_l2"
				F3.color = belly_fullscreen_color_trinary
			if("[belly_fullscreen]_nc" in icon_states('icons/mob/screen_full_colorized_vore_overlays.dmi'))
				var/obj/screen/fullscreen/F4 = L.overlay_fullscreen("belly4", /obj/screen/fullscreen/belly/colorized/overlay)
				F4.icon_state = "[belly_fullscreen]_nc"
		else
			var/obj/screen/fullscreen/F = L.overlay_fullscreen("belly", /obj/screen/fullscreen/belly)
			F.icon_state = belly_fullscreen
	else
		L.clear_fullscreen("belly")
		L.clear_fullscreen("belly2")
		L.clear_fullscreen("belly3")
		L.clear_fullscreen("belly4")

/obj/belly/proc/clear_preview(mob/living/L)
	L.clear_fullscreen("belly")
	L.clear_fullscreen("belly2")
	L.clear_fullscreen("belly3")
	L.clear_fullscreen("belly4")



// Release all contents of this belly into the owning mob's location.
// If that location is another mob, contents are transferred into whichever of its bellies the owning mob is in.
// Returns the number of mobs so released.
/obj/belly/proc/release_all_contents(include_absorbed = FALSE, silent = FALSE)
	//Don't bother if we don't have contents
	if(!contents.len)
		return FALSE

	//Find where we should drop things into (certainly not the owner)
	var/count = 0

	//Iterate over contents and move them all
	for(var/atom/movable/AM as anything in contents)
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.absorbed && !include_absorbed)
				continue
		count += release_specific_contents(AM, silent = TRUE)

	//Clean up our own business
	items_preserved.Cut()
	if(!ishuman(owner))
		owner.update_icons()

	//Determines privacy
	var/privacy_range = world.view
	var/privacy_volume = 100
	switch(eating_privacy_local) //Third case of if("loud") not defined, as it'd just leave privacy_range and volume untouched
		if("default")
			if(owner.eating_privacy_global)
				privacy_range = 1
				privacy_volume = 25
		if("subtle")
			privacy_range = 1
			privacy_volume = 25

	//Print notifications/sound if necessary
	if(!silent && count)
		owner.visible_message("<font color='green'><b>[owner] [release_verb] everything from their [lowertext(name)]!</b></font>", range = privacy_range)
		var/soundfile
		if(!fancy_vore)
			soundfile = classic_release_sounds[release_sound]
		else
			soundfile = fancy_release_sounds[release_sound]
		if(soundfile)
			playsound(src, soundfile, vol = privacy_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)

	return count

// Release a specific atom from the contents of this belly into the owning mob's location.
// If that location is another mob, the atom is transferred into whichever of its bellies the owning mob is in.
// Returns the number of atoms so released.
/obj/belly/proc/release_specific_contents(atom/movable/M, silent = FALSE)
	if (!(M in contents))
		return 0 // They weren't in this belly anyway

	if(istype(M, /mob/living/simple_mob/vore/morph/dominated_prey))
		var/mob/living/simple_mob/vore/morph/dominated_prey/p = M
		p.undo_prey_takeover(FALSE)
		return 0
	for(var/mob/living/L in M.contents)
		L.muffled = FALSE
		L.forced_psay = FALSE

	for(var/obj/item/weapon/holder/H in M.contents)
		H.held_mob.muffled = FALSE
		H.held_mob.forced_psay = FALSE

	if(isliving(M))
		var/mob/living/slip = M
		slip.slip_protect = world.time + 25 // This is to prevent slipping back into your pred if they stand on soap or something.
	//Place them into our drop_location
	M.forceMove(drop_location())
	if(ismob(M))
		var/mob/ourmob = M
		ourmob.reset_view(null)
	items_preserved -= M

	//Special treatment for absorbed prey
	if(isliving(M))
		var/mob/living/ML = M
		var/mob/living/OW = owner
		if(ML.client)
			ML.stop_sound_channel(CHANNEL_PREYLOOP) //Stop the internal loop, it'll restart if the isbelly check on next tick anyway
		if(ML.muffled)
			ML.muffled = FALSE
		if(ML.forced_psay)
			ML.forced_psay = FALSE
		if(ML.absorbed)
			ML.absorbed = FALSE
			handle_absorb_langs(ML, owner)
			if(ishuman(M) && ishuman(OW))
				var/mob/living/carbon/human/Prey = M
				var/mob/living/carbon/human/Pred = OW
				var/absorbed_count = 2 //Prey that we were, plus the pred gets a portion
				for(var/mob/living/P in contents)
					if(P.absorbed)
						absorbed_count++
				Pred.bloodstr.trans_to(Prey, Pred.reagents.total_volume / absorbed_count)

	//Clean up our own business
	if(!ishuman(owner))
		owner.update_icons()

	//Determines privacy
	var/privacy_range = world.view
	var/privacy_volume = 100
	switch(eating_privacy_local) //Third case of if("loud") not defined, as it'd just leave privacy_range and volume untouched
		if("default")
			if(owner.eating_privacy_global)
				privacy_range = 1
				privacy_volume = 25
		if("subtle")
			privacy_range = 1
			privacy_volume = 25

	//Print notifications/sound if necessary
	if(!silent)
		owner.visible_message("<font color='green'><b>[owner] [release_verb] [M] from their [lowertext(name)]!</b></font>",range = privacy_range)
		var/soundfile
		if(!fancy_vore)
			soundfile = classic_release_sounds[release_sound]
		else
			soundfile = fancy_release_sounds[release_sound]
		if(soundfile)
			playsound(src, soundfile, vol = privacy_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
	//Should fix your view not following you out of mobs sometimes!
	if(ismob(M))
		var/mob/ourmob = M
		ourmob.reset_view(null)

	if(!owner.ckey && escape_stun)
		owner.Weaken(escape_stun)

	return 1

// Actually perform the mechanics of devouring the tasty prey.
// The purpose of this method is to avoid duplicate code, and ensure that all necessary
// steps are taken.
/obj/belly/proc/nom_mob(mob/prey, mob/user)
	if(owner.stat == DEAD)
		return
	if(prey.buckled)
		prey.buckled.unbuckle_mob()

	prey.forceMove(src)
	if(ismob(prey))
		var/mob/ourmob = prey
		ourmob.reset_view(owner)
	owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()

	for(var/mob/living/M in contents)
		M.updateVRPanel()

	if(prey.ckey)
		GLOB.prey_eaten_roundstat++
		if(owner.mind)
			owner.mind.vore_prey_eaten++

// Get the line that should show up in Examine message if the owner of this belly
// is examined.   By making this a proc, we not only take advantage of polymorphism,
// but can easily make the message vary based on how many people are inside, etc.
// Returns a string which shoul be appended to the Examine output.
/obj/belly/proc/get_examine_msg()
	if(!(contents.len) || !(examine_messages.len))
		return ""

	var/formatted_message
	var/raw_message = pick(examine_messages)
	var/total_bulge = 0

	var/living_count = 0
	for(var/mob/living/L in contents)
		living_count++

	for(var/mob/living/P in contents)
		if(!P.absorbed) //This is required first, in case there's a person absorbed and not absorbed in a stomach.
			total_bulge += P.size_multiplier

	if(total_bulge < bulge_size || bulge_size == 0)
		return ""

	formatted_message = replacetext(raw_message, "%belly", lowertext(name))
	formatted_message = replacetext(formatted_message, "%pred", owner)
	formatted_message = replacetext(formatted_message, "%prey", english_list(contents))
	formatted_message = replacetext(formatted_message, "%countprey", living_count)
	formatted_message = replacetext(formatted_message, "%count", contents.len)

	return("<span class='vwarning'>[formatted_message]</span>")

/obj/belly/proc/get_examine_msg_absorbed()
	if(!(contents.len) || !(examine_messages_absorbed.len) || !display_absorbed_examine)
		return ""

	var/formatted_message
	var/raw_message = pick(examine_messages_absorbed)

	var/absorbed_count = 0
	var/list/absorbed_victims = list()
	for(var/mob/living/L in contents)
		if(L.absorbed)
			absorbed_victims += L
			absorbed_count++

	if(!absorbed_count)
		return ""

	formatted_message = replacetext(raw_message, "%belly", lowertext(name))
	formatted_message = replacetext(formatted_message, "%pred", owner)
	formatted_message = replacetext(formatted_message, "%prey", english_list(absorbed_victims))
	formatted_message = replacetext(formatted_message, "%countprey", absorbed_count)

	return("<span class='vwarning'>[formatted_message]</span>")

// The next function gets the messages set on the belly, in human-readable format.
// This is useful in customization boxes and such. The delimiter right now is \n\n so
// in message boxes, this looks nice and is easily delimited.
/obj/belly/proc/get_messages(type, delim = "\n\n")
	ASSERT(type == "smo" || type == "smi" || type == "asmo" || type == "asmi" || type == "escao" || type == "escap" || type == "escp" || type == "esco" || type == "escout" || type == "escip" || type == "escio" || type == "esciout" || type == "escfp" || type == "escfo" || type == "aescao" || type == "aescap" || type == "aescp" || type == "aesco" || type == "aescout" || type == "aescfp" || type == "aescfo" || type == "trnspp" || type == "trnspo" || type == "trnssp" || type == "trnsso" || type == "stmodp" || type == "stmodo" || type == "stmoap" || type == "stmoao" || type == "dmo" || type == "dmp" || type == "amo" || type == "amp" || type == "uamo" || type == "uamp" || type == "em" || type == "ema" || type == "im_digest" || type == "im_hold" || type == "im_holdabsorbed" || type == "im_absorb" || type == "im_heal" || type == "im_drain" || type == "im_steal" || type == "im_egg" || type == "im_shrink" || type == "im_grow" || type == "im_unabsorb")

	var/list/raw_messages
	switch(type)
		if("smo")
			raw_messages = struggle_messages_outside
		if("smi")
			raw_messages = struggle_messages_inside
		if("asmo")
			raw_messages = absorbed_struggle_messages_outside
		if("asmi")
			raw_messages = absorbed_struggle_messages_inside
		if("escao")
			raw_messages = escape_attempt_messages_owner
		if("escap")
			raw_messages = escape_attempt_messages_prey
		if("esco")
			raw_messages = escape_messages_owner
		if("escp")
			raw_messages = escape_messages_prey
		if("escout")
			raw_messages = escape_messages_outside
		if("escio")
			raw_messages = escape_item_messages_owner
		if("escip")
			raw_messages = escape_item_messages_prey
		if("esciout")
			raw_messages = escape_item_messages_outside
		if("escfo")
			raw_messages = escape_fail_messages_owner
		if("escfp")
			raw_messages = escape_fail_messages_prey
		if("aescao")
			raw_messages = escape_attempt_absorbed_messages_owner
		if("aescap")
			raw_messages = escape_attempt_absorbed_messages_prey
		if("aesco")
			raw_messages = escape_absorbed_messages_owner
		if("aescp")
			raw_messages = escape_absorbed_messages_prey
		if("aescout")
			raw_messages = escape_absorbed_messages_outside
		if("aescfo")
			raw_messages = escape_fail_absorbed_messages_owner
		if("aescfp")
			raw_messages = escape_fail_absorbed_messages_prey
		if("trnspo")
			raw_messages = primary_transfer_messages_owner
		if("trnspp")
			raw_messages = primary_transfer_messages_prey
		if("trnsso")
			raw_messages = secondary_transfer_messages_owner
		if("trnssp")
			raw_messages = secondary_transfer_messages_prey
		if("stmodo")
			raw_messages = digest_chance_messages_owner
		if("stmodp")
			raw_messages = digest_chance_messages_prey
		if("stmoao")
			raw_messages = absorb_chance_messages_owner
		if("stmoap")
			raw_messages = absorb_chance_messages_prey
		if("dmo")
			raw_messages = digest_messages_owner
		if("dmp")
			raw_messages = digest_messages_prey
		if("em")
			raw_messages = examine_messages
		if("ema")
			raw_messages = examine_messages_absorbed
		if("amo")
			raw_messages = absorb_messages_owner
		if("amp")
			raw_messages = absorb_messages_prey
		if("uamo")
			raw_messages = unabsorb_messages_owner
		if("uamp")
			raw_messages = unabsorb_messages_prey
		if("im_digest")
			raw_messages = emote_lists[DM_DIGEST]
		if("im_hold")
			raw_messages = emote_lists[DM_HOLD]
		if("im_holdabsorbed")
			raw_messages = emote_lists[DM_HOLD_ABSORBED]
		if("im_absorb")
			raw_messages = emote_lists[DM_ABSORB]
		if("im_heal")
			raw_messages = emote_lists[DM_HEAL]
		if("im_drain")
			raw_messages = emote_lists[DM_DRAIN]
		if("im_steal")
			raw_messages = emote_lists[DM_SIZE_STEAL]
		if("im_egg")
			raw_messages = emote_lists[DM_EGG]
		if("im_shrink")
			raw_messages = emote_lists[DM_SHRINK]
		if("im_grow")
			raw_messages = emote_lists[DM_GROW]
		if("im_unabsorb")
			raw_messages = emote_lists[DM_UNABSORB]
	var/messages = null
	if(raw_messages)
		messages = raw_messages.Join(delim)
	return messages

// The next function sets the messages on the belly, from human-readable var
// replacement strings and linebreaks as delimiters (two \n\n by default).
// They also sanitize the messages.
/obj/belly/proc/set_messages(raw_text, type, delim = "\n\n")
	ASSERT(type == "smo" || type == "smi" || type == "asmo" || type == "asmi" || type == "escao" || type == "escap" || type == "escp" || type == "esco" || type == "escout" || type == "escip" || type == "escio" || type == "esciout" || type == "escfp" || type == "escfo" || type == "aescao" || type == "aescap" || type == "aescp" || type == "aesco" || type == "aescout" || type == "aescfp" || type == "aescfo" || type == "trnspp" || type == "trnspo" || type == "trnssp" || type == "trnsso" || type == "stmodp" || type == "stmodo" || type == "stmoap" || type == "stmoao" || type == "dmo" || type == "dmp" || type == "amo" || type == "amp" || type == "uamo" || type == "uamp" || type == "em" || type == "ema" || type == "im_digest" || type == "im_hold" || type == "im_holdabsorbed" || type == "im_absorb" || type == "im_heal" || type == "im_drain" || type == "im_steal" || type == "im_egg" || type == "im_shrink" || type == "im_grow" || type == "im_unabsorb")

	var/list/raw_list = splittext(html_encode(raw_text),delim)
	if(raw_list.len > 10)
		raw_list.Cut(11)
		log_debug("[owner] tried to set [lowertext(name)] with 11+ messages")

	for(var/i = 1, i <= raw_list.len, i++)
		if((length(raw_list[i]) > 160 || length(raw_list[i]) < 10) && !(type == "im_digest" || type == "im_hold" || type == "im_holdabsorbed" || type == "im_absorb" || type == "im_heal" || type == "im_drain" || type == "im_steal" || type == "im_egg" || type == "im_shrink" || type == "im_grow" || type == "im_unabsorb")) //160 is fudged value due to htmlencoding increasing the size
			raw_list.Cut(i,i)
			log_debug("[owner] tried to set [lowertext(name)] with >121 or <10 char message")
		else if((type == "im_digest" || type == "im_hold" || type == "im_holdabsorbed" || type == "im_absorb" || type == "im_heal" || type == "im_drain" || type == "im_steal" || type == "im_egg" || type == "im_shrink" || type == "im_grow" || type == "im_unabsorb") && (length(raw_list[i]) > 510 || length(raw_list[i]) < 10))
			raw_list.Cut(i,i)
			log_debug("[owner] tried to set [lowertext(name)] idle message with >501 or <10 char message")
		else if((type == "em" || type == "ema") && (length(raw_list[i]) > 260 || length(raw_list[i]) < 10))
			raw_list.Cut(i,i)
			log_debug("[owner] tried to set [lowertext(name)] examine message with >260 or <10 char message")
		else
			raw_list[i] = readd_quotes(raw_list[i])
			//Also fix % sign for var replacement
			raw_list[i] = replacetext(raw_list[i],"&#37;","%")

	ASSERT(raw_list.len <= 10) //Sanity

	switch(type)
		if("smo")
			struggle_messages_outside = raw_list
		if("smi")
			struggle_messages_inside = raw_list
		if("asmo")
			absorbed_struggle_messages_outside = raw_list
		if("asmi")
			absorbed_struggle_messages_inside = raw_list
		if("escao")
			escape_attempt_messages_owner = raw_list
		if("escap")
			escape_attempt_messages_prey = raw_list
		if("esco")
			escape_messages_owner = raw_list
		if("escp")
			escape_messages_prey = raw_list
		if("escout")
			escape_messages_outside = raw_list
		if("escio")
			escape_item_messages_owner = raw_list
		if("escip")
			escape_item_messages_prey = raw_list
		if("esciout")
			escape_item_messages_outside = raw_list
		if("escfo")
			escape_fail_messages_owner = raw_list
		if("escfp")
			escape_fail_messages_prey = raw_list
		if("aescao")
			escape_attempt_absorbed_messages_owner = raw_list
		if("aescap")
			escape_attempt_absorbed_messages_prey = raw_list
		if("aesco")
			escape_absorbed_messages_owner = raw_list
		if("aescp")
			escape_absorbed_messages_prey = raw_list
		if("aescout")
			escape_absorbed_messages_outside = raw_list
		if("aescfo")
			escape_fail_absorbed_messages_owner = raw_list
		if("aescfp")
			escape_fail_absorbed_messages_prey = raw_list
		if("trnspo")
			primary_transfer_messages_owner = raw_list
		if("trnspp")
			primary_transfer_messages_prey = raw_list
		if("trnsso")
			secondary_transfer_messages_owner = raw_list
		if("trnssp")
			secondary_transfer_messages_prey = raw_list
		if("stmodo")
			digest_chance_messages_owner = raw_list
		if("stmodp")
			digest_chance_messages_prey = raw_list
		if("stmoao")
			absorb_chance_messages_owner = raw_list
		if("stmoap")
			absorb_chance_messages_prey = raw_list
		if("dmo")
			digest_messages_owner = raw_list
		if("dmp")
			digest_messages_prey = raw_list
		if("amo")
			absorb_messages_owner = raw_list
		if("amp")
			absorb_messages_prey = raw_list
		if("uamo")
			unabsorb_messages_owner = raw_list
		if("uamp")
			unabsorb_messages_prey = raw_list
		if("em")
			examine_messages = raw_list
		if("ema")
			examine_messages_absorbed = raw_list
		if("im_digest")
			emote_lists[DM_DIGEST] = raw_list
		if("im_hold")
			emote_lists[DM_HOLD] = raw_list
		if("im_holdabsorbed")
			emote_lists[DM_HOLD_ABSORBED] = raw_list
		if("im_absorb")
			emote_lists[DM_ABSORB] = raw_list
		if("im_heal")
			emote_lists[DM_HEAL] = raw_list
		if("im_drain")
			emote_lists[DM_DRAIN] = raw_list
		if("im_steal")
			emote_lists[DM_SIZE_STEAL] = raw_list
		if("im_egg")
			emote_lists[DM_EGG] = raw_list
		if("im_shrink")
			emote_lists[DM_SHRINK] = raw_list
		if("im_grow")
			emote_lists[DM_GROW] = raw_list
		if("im_unabsorb")
			emote_lists[DM_UNABSORB] = raw_list

	return

// Handle the death of a mob via digestion.
// Called from the process_Life() methods of bellies that digest prey.
// Default implementation calls M.death() and removes from internal contents.
// Indigestable items are removed, and M is deleted.
/obj/belly/proc/digestion_death(mob/living/M)
	add_attack_logs(owner, M, "Digested in [lowertext(name)]")

	// If digested prey is also a pred... anyone inside their bellies gets moved up.
	if(is_vore_predator(M))
		M.release_vore_contents(include_absorbed = TRUE, silent = TRUE)

	//Drop all items into the belly.
	if(config.items_survive_digestion)
		for(var/obj/item/W in M)
			if(istype(W, /obj/item/organ/internal/mmi_holder/posibrain))
				var/obj/item/organ/internal/mmi_holder/MMI = W
				var/obj/item/device/mmi/brainbox = MMI.removed()
				if(brainbox)
					items_preserved += brainbox
			for(var/slot in slots)
				var/obj/item/I = M.get_equipped_item(slot = slot)
				if(I)
					M.unEquip(I,force = TRUE)
					if(contaminates)
						I.gurgle_contaminate(contents, contamination_flavor, contamination_color) //We do an initial contamination pass to get stuff like IDs wet.
					if(item_digest_mode == IM_HOLD)
						items_preserved |= I
					else if(item_digest_mode == IM_DIGEST_FOOD && !(istype(I,/obj/item/weapon/reagent_containers/food) || istype(I,/obj/item/organ)))
						items_preserved |= I

	//Reagent transfer
	if(ishuman(owner))
		var/mob/living/carbon/human/Pred = owner
		if(ishuman(M))
			var/mob/living/carbon/human/Prey = M
			Prey.bloodstr.del_reagent("numbenzyme")
			Prey.bloodstr.trans_to_holder(Pred.bloodstr, Prey.bloodstr.total_volume, 0.5, TRUE) // Copy=TRUE because we're deleted anyway
			Prey.ingested.trans_to_holder(Pred.bloodstr, Prey.ingested.total_volume, 0.5, TRUE) // Therefore don't bother spending cpu
			Prey.touching.trans_to_holder(Pred.bloodstr, Prey.touching.total_volume, 0.5, TRUE) // On updating the prey's reagents
		else if(M.reagents)
			M.reagents.trans_to_holder(Pred.bloodstr, M.reagents.total_volume, 0.5, TRUE)

	//Incase they have the loop going, let's double check to stop it.
	M.stop_sound_channel(CHANNEL_PREYLOOP)
	// Delete the digested mob
	M.ghostize() // Make sure they're out, so we can copy attack logs and such.
	qdel(M)

// Handle a mob being absorbed
/obj/belly/proc/absorb_living(mob/living/M)
	var/absorb_alert_owner = pick(absorb_messages_owner)
	var/absorb_alert_prey = pick(absorb_messages_prey)

	var/absorbed_count = 0
	for(var/mob/living/L in contents)
		if(L.absorbed)
			absorbed_count++

	//Replace placeholder vars
	absorb_alert_owner = replacetext(absorb_alert_owner, "%pred", owner)
	absorb_alert_owner = replacetext(absorb_alert_owner, "%prey", M)
	absorb_alert_owner = replacetext(absorb_alert_owner, "%belly", lowertext(name))
	absorb_alert_owner = replacetext(absorb_alert_owner, "%countprey", absorbed_count)

	absorb_alert_prey = replacetext(absorb_alert_prey, "%pred", owner)
	absorb_alert_prey = replacetext(absorb_alert_prey, "%prey", M)
	absorb_alert_prey = replacetext(absorb_alert_prey, "%belly", lowertext(name))
	absorb_alert_prey = replacetext(absorb_alert_prey, "%countprey", absorbed_count)

	M.absorbed = TRUE
	if(M.ckey)
		handle_absorb_langs(M, owner)

		GLOB.prey_absorbed_roundstat++

	to_chat(M, "<span class='vnotice'>[absorb_alert_prey]</span>")
	to_chat(owner, "<span class='vnotice'>[absorb_alert_owner]</span>")
	if(M.noisy) //Mute drained absorbee hunger if enabled.
		M.noisy = FALSE

	if(ishuman(M) && ishuman(owner))
		var/mob/living/carbon/human/Prey = M
		var/mob/living/carbon/human/Pred = owner
		//Reagent sharing for absorbed with pred - Copy so both pred and prey have these reagents.
		Prey.bloodstr.trans_to_holder(Pred.ingested, Prey.bloodstr.total_volume, copy = TRUE)
		Prey.ingested.trans_to_holder(Pred.ingested, Prey.ingested.total_volume, copy = TRUE)
		Prey.touching.trans_to_holder(Pred.ingested, Prey.touching.total_volume, copy = TRUE)
		// TODO - Find a way to make the absorbed prey share the effects with the pred.
		// Currently this is infeasible because reagent containers are designed to have a single my_atom, and we get
		// problems when A absorbs B, and then C absorbs A,  resulting in B holding onto an invalid reagent container.

	//This is probably already the case, but for sub-prey, it won't be.
	if(M.loc != src)
		M.forceMove(src)

	if(ismob(M))
		var/mob/ourmob = M
		ourmob.reset_view(owner)

	//Seek out absorbed prey of the prey, absorb them too.
	//This in particular will recurse oddly because if there is absorbed prey of prey of prey...
	//it will just move them up one belly. This should never happen though since... when they were
	//absobred, they should have been absorbed as well!
	for(var/obj/belly/B as anything in M.vore_organs)
		for(var/mob/living/Mm in B)
			if(Mm.absorbed)
				absorb_living(Mm)


	if(absorbed_desc)
		//Replace placeholder vars
		var/formatted_abs_desc
		formatted_abs_desc = replacetext(absorbed_desc, "%belly", lowertext(name)) //replace with this belly's name
		formatted_abs_desc = replacetext(formatted_abs_desc, "%pred", owner) //replace with this belly's owner
		formatted_abs_desc = replacetext(formatted_abs_desc, "%prey", M) //replace with whatever mob entered into this belly
		to_chat(M, "<span class='vnotice'><B>[formatted_abs_desc]</B></span>")

	//Update owner
	owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()

// Handle a mob being unabsorbed
/obj/belly/proc/unabsorb_living(mob/living/M)
	var/unabsorb_alert_owner = pick(unabsorb_messages_owner)
	var/unabsorb_alert_prey = pick(unabsorb_messages_prey)

	var/absorbed_count = 0
	for(var/mob/living/L in contents)
		if(L.absorbed)
			absorbed_count++

	//Replace placeholder vars
	unabsorb_alert_owner = replacetext(unabsorb_alert_owner, "%pred", owner)
	unabsorb_alert_owner = replacetext(unabsorb_alert_owner, "%prey", M)
	unabsorb_alert_owner = replacetext(unabsorb_alert_owner, "%belly", lowertext(name))
	unabsorb_alert_owner = replacetext(unabsorb_alert_owner, "%countprey", absorbed_count)

	unabsorb_alert_prey = replacetext(unabsorb_alert_prey, "%pred", owner)
	unabsorb_alert_prey = replacetext(unabsorb_alert_prey, "%prey", M)
	unabsorb_alert_prey = replacetext(unabsorb_alert_prey, "%belly", lowertext(name))
	unabsorb_alert_prey = replacetext(unabsorb_alert_prey, "%countprey", absorbed_count)

	M.absorbed = FALSE
	handle_absorb_langs(M, owner)
	to_chat(M, "<span class='vnotice'>[unabsorb_alert_prey]</span>")
	to_chat(owner, "<span class='vnotice'>[unabsorb_alert_owner]</span>")

	if(desc)
		to_chat(M, "<span class='vnotice'><B>[desc]</B></span>")

	//Update owner
	owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()

/////////////////////////////////////////////////////////////////////////
/obj/belly/proc/handle_absorb_langs()
	owner.absorb_langs()

////////////////////////////////////////////////////////////////////////


//Digest a single item
//Receives a return value from digest_act that's how much nutrition
//the item should be worth
/obj/belly/proc/digest_item(obj/item/item)
	var/digested = item.digest_act(src, owner)
	if(!digested)
		items_preserved |= item
	else
		owner.adjust_nutrition((nutrition_percent / 100) * 5 * digested)
		if(isrobot(owner))
			var/mob/living/silicon/robot/R = owner
			R.cell.charge += ((nutrition_percent / 100) * 50 * digested)
	return digested

//Determine where items should fall out of us into.
//Typically just to the owner's location.
/obj/belly/drop_location()
	//Should be the case 99.99% of the time
	if(owner)
		return owner.drop_location()
	//Sketchy fallback for safety, put them somewhere safe.
	else
		log_debug("[src] (\ref[src]) doesn't have an owner, and dropped someone at a latespawn point!")
		var/fallback = pick(latejoin)
		return get_turf(fallback)

//Yes, it's ""safe"" to drop items here
/obj/belly/AllowDrop()
	return TRUE

/obj/belly/onDropInto(atom/movable/AM)
	return null

//Handle a mob struggling
// Called from /mob/living/carbon/relaymove()
/obj/belly/proc/relay_resist(mob/living/R, obj/item/C)
	if (!(R in contents))
		if(!C)
			return  // User is not in this belly

	R.setClickCooldown(50)

	var/living_count = 0
	for(var/mob/living/L in contents)
		living_count++

	var/escape_attempt_owner_message = pick(escape_attempt_messages_owner)
	var/escape_attempt_prey_message = pick(escape_attempt_messages_prey)
	var/escape_fail_owner_message = pick(escape_fail_messages_owner)
	var/escape_fail_prey_message = pick(escape_fail_messages_prey)

	escape_attempt_owner_message = replacetext(escape_attempt_owner_message, "%pred", owner)
	escape_attempt_owner_message = replacetext(escape_attempt_owner_message, "%prey", R)
	escape_attempt_owner_message = replacetext(escape_attempt_owner_message, "%belly", lowertext(name))
	escape_attempt_owner_message = replacetext(escape_attempt_owner_message, "%countprey", living_count)
	escape_attempt_owner_message = replacetext(escape_attempt_owner_message, "%count", contents.len)

	escape_attempt_prey_message = replacetext(escape_attempt_prey_message, "%pred", owner)
	escape_attempt_prey_message = replacetext(escape_attempt_prey_message, "%prey", R)
	escape_attempt_prey_message = replacetext(escape_attempt_prey_message, "%belly", lowertext(name))
	escape_attempt_prey_message = replacetext(escape_attempt_prey_message, "%countprey", living_count)
	escape_attempt_prey_message = replacetext(escape_attempt_prey_message, "%count", contents.len)

	escape_fail_owner_message = replacetext(escape_fail_owner_message, "%pred", owner)
	escape_fail_owner_message = replacetext(escape_fail_owner_message, "%prey", R)
	escape_fail_owner_message = replacetext(escape_fail_owner_message, "%belly", lowertext(name))
	escape_fail_owner_message = replacetext(escape_fail_owner_message, "%countprey", living_count)
	escape_fail_owner_message = replacetext(escape_fail_owner_message, "%count", contents.len)

	escape_fail_prey_message = replacetext(escape_fail_prey_message, "%pred", owner)
	escape_fail_prey_message = replacetext(escape_fail_prey_message, "%prey", R)
	escape_fail_prey_message = replacetext(escape_fail_prey_message, "%belly", lowertext(name))
	escape_fail_prey_message = replacetext(escape_fail_prey_message, "%countprey", living_count)
	escape_fail_prey_message = replacetext(escape_fail_prey_message, "%count", contents.len)

	escape_attempt_owner_message = "<span class='vwarning'>[escape_attempt_owner_message]</span>"
	escape_attempt_prey_message = "<span class='vwarning'>[escape_attempt_prey_message]</span>"
	escape_fail_owner_message = "<span class='vwarning'>[escape_fail_owner_message]</span>"
	escape_fail_prey_message = "<span class='vnotice'>[escape_fail_prey_message]</span>"

	if(owner.stat) //If owner is stat (dead, KO) we can actually escape
		escape_attempt_prey_message = replacetext(escape_attempt_prey_message, new/regex("^(<span(?: \[^>]*)?>.*)(</span>)$", ""), "$1 (This will take around [escapetime/10] seconds.)$2")
		to_chat(R, escape_attempt_prey_message)
		to_chat(owner, escape_attempt_owner_message)

		if(do_after(R, escapetime, owner, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
			if((owner.stat || escapable)) //Can still escape?
				if(C)
					release_specific_contents(C)
					return
				if(R.loc == src)
					release_specific_contents(R)
					return
			else if(R.loc != src) //Aren't even in the belly. Quietly fail.
				return
			else //Belly became inescapable or mob revived
				to_chat(R, escape_fail_prey_message)
				to_chat(owner, escape_fail_owner_message)
				return
			return
	var/struggle_outer_message = pick(struggle_messages_outside)
	var/struggle_user_message = pick(struggle_messages_inside)

	struggle_outer_message = replacetext(struggle_outer_message, "%pred", owner)
	struggle_outer_message = replacetext(struggle_outer_message, "%prey", R)
	struggle_outer_message = replacetext(struggle_outer_message, "%belly", lowertext(name))
	struggle_outer_message = replacetext(struggle_outer_message, "%countprey", living_count)
	struggle_outer_message = replacetext(struggle_outer_message, "%count", contents.len)

	struggle_user_message = replacetext(struggle_user_message, "%pred", owner)
	struggle_user_message = replacetext(struggle_user_message, "%prey", R)
	struggle_user_message = replacetext(struggle_user_message, "%belly", lowertext(name))
	struggle_user_message = replacetext(struggle_user_message, "%countprey", living_count)
	struggle_user_message = replacetext(struggle_user_message, "%count", contents.len)

	struggle_outer_message = "<span class='valert'>[struggle_outer_message]</span>"
	struggle_user_message = "<span class='valert'>[struggle_user_message]</span>"

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

	var/sound/struggle_snuggle
	var/sound/struggle_rustle = sound(get_sfx("rustle"))

	if(is_wet)
		if(!fancy_vore)
			struggle_snuggle = sound(get_sfx("classic_struggle_sounds"))
		else
			struggle_snuggle = sound(get_sfx("fancy_prey_struggle"))
		playsound(src, struggle_snuggle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)
	else
		playsound(src, struggle_rustle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)

	if(escapable) //If the stomach has escapable enabled.
		if(prob(escapechance)) //Let's have it check to see if the prey escapes first.
			to_chat(R, escape_attempt_prey_message)
			to_chat(owner, escape_attempt_owner_message)
			if(do_after(R, escapetime))
				if(escapable && C)
					var/escape_item_owner_message = pick(escape_item_messages_owner)
					var/escape_item_prey_message = pick(escape_item_messages_prey)
					var/escape_item_outside_message = pick(escape_item_messages_outside)

					escape_item_owner_message = replacetext(escape_item_owner_message, "%pred", owner)
					escape_item_owner_message = replacetext(escape_item_owner_message, "%prey", R)
					escape_item_owner_message = replacetext(escape_item_owner_message, "%belly", lowertext(name))
					escape_item_owner_message = replacetext(escape_item_owner_message, "%countprey", living_count)
					escape_item_owner_message = replacetext(escape_item_owner_message, "%count", contents.len)
					escape_item_owner_message = replacetext(escape_item_owner_message, "%item", C)

					escape_item_prey_message = replacetext(escape_item_prey_message, "%pred", owner)
					escape_item_prey_message = replacetext(escape_item_prey_message, "%prey", R)
					escape_item_prey_message = replacetext(escape_item_prey_message, "%belly", lowertext(name))
					escape_item_prey_message = replacetext(escape_item_prey_message, "%countprey", living_count)
					escape_item_prey_message = replacetext(escape_item_prey_message, "%count", contents.len)
					escape_item_prey_message = replacetext(escape_item_prey_message, "%item", C)

					escape_item_outside_message = replacetext(escape_item_outside_message, "%pred", owner)
					escape_item_outside_message = replacetext(escape_item_outside_message, "%prey", R)
					escape_item_outside_message = replacetext(escape_item_outside_message, "%belly", lowertext(name))
					escape_item_outside_message = replacetext(escape_item_outside_message, "%countprey", living_count)
					escape_item_outside_message = replacetext(escape_item_outside_message, "%count", contents.len)
					escape_item_outside_message = replacetext(escape_item_outside_message, "%item", C)

					escape_item_owner_message = "<span class='vwarning'>[escape_item_owner_message]</span>"
					escape_item_prey_message = "<span class='vwarning'>[escape_item_prey_message]</span>"
					escape_item_outside_message = "<span class='vwarning'>[escape_item_outside_message]</span>"

					release_specific_contents(C)
					to_chat(R, escape_item_prey_message)
					to_chat(owner, escape_item_owner_message)
					for(var/mob/M in hearers(4, owner))
						M.show_message(escape_item_outside_message, 2)
					return
				if(escapable && (R.loc == src) && !R.absorbed) //Does the owner still have escapable enabled?
					var/escape_owner_message = pick(escape_messages_owner)
					var/escape_prey_message = pick(escape_messages_prey)
					var/escape_outside_message = pick(escape_messages_outside)

					escape_owner_message = replacetext(escape_owner_message, "%pred", owner)
					escape_owner_message = replacetext(escape_owner_message, "%prey", R)
					escape_owner_message = replacetext(escape_owner_message, "%belly", lowertext(name))
					escape_owner_message = replacetext(escape_owner_message, "%countprey", living_count)
					escape_owner_message = replacetext(escape_owner_message, "%count", contents.len)

					escape_prey_message = replacetext(escape_prey_message, "%pred", owner)
					escape_prey_message = replacetext(escape_prey_message, "%prey", R)
					escape_prey_message = replacetext(escape_prey_message, "%belly", lowertext(name))
					escape_prey_message = replacetext(escape_prey_message, "%countprey", living_count)
					escape_prey_message = replacetext(escape_prey_message, "%count", contents.len)

					escape_outside_message = replacetext(escape_outside_message, "%pred", owner)
					escape_outside_message = replacetext(escape_outside_message, "%prey", R)
					escape_outside_message = replacetext(escape_outside_message, "%belly", lowertext(name))
					escape_outside_message = replacetext(escape_outside_message, "%countprey", living_count)
					escape_outside_message = replacetext(escape_outside_message, "%count", contents.len)

					escape_owner_message = "<span class='vwarning'>[escape_owner_message]</span>"
					escape_prey_message = "<span class='vwarning'>[escape_prey_message]</span>"
					escape_outside_message = "<span class='vwarning'>[escape_outside_message]</span>"
					release_specific_contents(R)
					to_chat(R, escape_prey_message)
					to_chat(owner, escape_owner_message)
					for(var/mob/M in hearers(4, owner))
						M.show_message(escape_outside_message, 2)
					return
				else if(!(R.loc == src)) //Aren't even in the belly. Quietly fail.
					return
				else //Belly became inescapable.
					to_chat(R, escape_fail_prey_message)
					to_chat(owner, escape_fail_owner_message)
					return

		else if(prob(transferchance) && transferlocation) //Next, let's have it see if they end up getting into an even bigger mess then when they started.
			var/obj/belly/dest_belly
			for(var/obj/belly/B as anything in owner.vore_organs)
				if(B.name == transferlocation)
					dest_belly = B
					break

			if(!dest_belly)
				to_chat(owner, "<span class='vwarning'>Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution.</span>")
				transferchance = 0
				transferlocation = null
				return
			var/primary_transfer_owner_message = pick(primary_transfer_messages_owner)
			var/primary_transfer_prey_message = pick(primary_transfer_messages_prey)

			primary_transfer_owner_message = replacetext(primary_transfer_owner_message, "%pred", owner)
			primary_transfer_owner_message = replacetext(primary_transfer_owner_message, "%prey", R)
			primary_transfer_owner_message = replacetext(primary_transfer_owner_message, "%belly", lowertext(name))
			primary_transfer_owner_message = replacetext(primary_transfer_owner_message, "%countprey", living_count)
			primary_transfer_owner_message = replacetext(primary_transfer_owner_message, "%count", contents.len)
			primary_transfer_owner_message = replacetext(primary_transfer_owner_message, "%dest", transferlocation)

			primary_transfer_prey_message = replacetext(primary_transfer_prey_message, "%pred", owner)
			primary_transfer_prey_message = replacetext(primary_transfer_prey_message, "%prey", R)
			primary_transfer_prey_message = replacetext(primary_transfer_prey_message, "%belly", lowertext(name))
			primary_transfer_prey_message = replacetext(primary_transfer_prey_message, "%countprey", living_count)
			primary_transfer_prey_message = replacetext(primary_transfer_prey_message, "%count", contents.len)
			primary_transfer_prey_message = replacetext(primary_transfer_prey_message, "%dest", transferlocation)

			primary_transfer_owner_message = "<span class='vwarning'>[primary_transfer_owner_message]</span>"
			primary_transfer_prey_message = "<span class='vwarning'>[primary_transfer_prey_message]</span>"

			to_chat(R, primary_transfer_prey_message)
			to_chat(owner, primary_transfer_owner_message)
			if(C)
				transfer_contents(C, dest_belly)
				return
			transfer_contents(R, dest_belly)
			return

		else if(prob(transferchance_secondary) && transferlocation_secondary) //After the first potential mess getting into, run the secondary one which might be even bigger of a mess.
			var/obj/belly/dest_belly
			for(var/obj/belly/B as anything in owner.vore_organs)
				if(B.name == transferlocation_secondary)
					dest_belly = B
					break

			if(!dest_belly)
				to_chat(owner, "<span class='vwarning'>Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution.</span>")
				transferchance_secondary = 0
				transferlocation_secondary = null
				return

			var/secondary_transfer_owner_message = pick(secondary_transfer_messages_owner)
			var/secondary_transfer_prey_message = pick(secondary_transfer_messages_prey)

			secondary_transfer_owner_message = replacetext(secondary_transfer_owner_message, "%pred", owner)
			secondary_transfer_owner_message = replacetext(secondary_transfer_owner_message, "%prey", R)
			secondary_transfer_owner_message = replacetext(secondary_transfer_owner_message, "%belly", lowertext(name))
			secondary_transfer_owner_message = replacetext(secondary_transfer_owner_message, "%countprey", living_count)
			secondary_transfer_owner_message = replacetext(secondary_transfer_owner_message, "%count", contents.len)
			secondary_transfer_owner_message = replacetext(secondary_transfer_owner_message, "%dest", transferlocation_secondary)

			secondary_transfer_prey_message = replacetext(secondary_transfer_prey_message, "%pred", owner)
			secondary_transfer_prey_message = replacetext(secondary_transfer_prey_message, "%prey", R)
			secondary_transfer_prey_message = replacetext(secondary_transfer_prey_message, "%belly", lowertext(name))
			secondary_transfer_prey_message = replacetext(secondary_transfer_prey_message, "%countprey", living_count)
			secondary_transfer_prey_message = replacetext(secondary_transfer_prey_message, "%count", contents.len)
			secondary_transfer_prey_message = replacetext(secondary_transfer_prey_message, "%dest", transferlocation_secondary)

			secondary_transfer_owner_message = "<span class='vwarning'>[secondary_transfer_owner_message]</span>"
			secondary_transfer_prey_message = "<span class='vwarning'>[secondary_transfer_prey_message]</span>"

			to_chat(R, secondary_transfer_prey_message)
			to_chat(owner, secondary_transfer_owner_message)
			if(C)
				transfer_contents(C, dest_belly)
				return
			transfer_contents(R, dest_belly)
			return

		else if(prob(absorbchance) && digest_mode != DM_ABSORB) //After that, let's have it run the absorb chance.
			var/absorb_chance_owner_message = pick(absorb_chance_messages_owner)
			var/absorb_chance_prey_message = pick(absorb_chance_messages_prey)

			absorb_chance_owner_message = replacetext(absorb_chance_owner_message, "%pred", owner)
			absorb_chance_owner_message = replacetext(absorb_chance_owner_message, "%prey", R)
			absorb_chance_owner_message = replacetext(absorb_chance_owner_message, "%belly", lowertext(name))
			absorb_chance_owner_message = replacetext(absorb_chance_owner_message, "%countprey", living_count)
			absorb_chance_owner_message = replacetext(absorb_chance_owner_message, "%count", contents.len)

			absorb_chance_prey_message = replacetext(absorb_chance_prey_message, "%pred", owner)
			absorb_chance_prey_message = replacetext(absorb_chance_prey_message, "%prey", R)
			absorb_chance_prey_message = replacetext(absorb_chance_prey_message, "%belly", lowertext(name))
			absorb_chance_prey_message = replacetext(absorb_chance_prey_message, "%countprey", living_count)
			absorb_chance_prey_message = replacetext(absorb_chance_prey_message, "%count", contents.len)

			absorb_chance_owner_message = "<span class='vwarning'>[absorb_chance_owner_message]</span>"
			absorb_chance_prey_message = "<span class='vwarning'>[absorb_chance_prey_message]</span>"

			to_chat(R, absorb_chance_prey_message)
			to_chat(owner, absorb_chance_owner_message)
			digest_mode = DM_ABSORB
			return

		else if(prob(digestchance) && digest_mode != DM_DIGEST) //Finally, let's see if it should run the digest chance.
			var/digest_chance_owner_message = pick(digest_chance_messages_owner)
			var/digest_chance_prey_message = pick(digest_chance_messages_prey)

			digest_chance_owner_message = replacetext(digest_chance_owner_message, "%pred", owner)
			digest_chance_owner_message = replacetext(digest_chance_owner_message, "%prey", R)
			digest_chance_owner_message = replacetext(digest_chance_owner_message, "%belly", lowertext(name))
			digest_chance_owner_message = replacetext(digest_chance_owner_message, "%countprey", living_count)
			digest_chance_owner_message = replacetext(digest_chance_owner_message, "%count", contents.len)

			digest_chance_prey_message = replacetext(digest_chance_prey_message, "%pred", owner)
			digest_chance_prey_message = replacetext(digest_chance_prey_message, "%prey", R)
			digest_chance_prey_message = replacetext(digest_chance_prey_message, "%belly", lowertext(name))
			digest_chance_prey_message = replacetext(digest_chance_prey_message, "%countprey", living_count)
			digest_chance_prey_message = replacetext(digest_chance_prey_message, "%count", contents.len)

			digest_chance_owner_message = "<span class='vwarning'>[digest_chance_owner_message]</span>"
			digest_chance_prey_message = "<span class='vwarning'>[digest_chance_prey_message]</span>"

			to_chat(R, digest_chance_prey_message)
			to_chat(owner, digest_chance_owner_message)
			digest_mode = DM_DIGEST
			return

		else //Nothing interesting happened.
			to_chat(R, struggle_user_message)
			to_chat(owner, "<span class='vwarning'>Your prey appears to be unable to make any progress in escaping your [lowertext(name)].</span>")
			return
	to_chat(R, struggle_user_message)

/obj/belly/proc/relay_absorbed_resist(mob/living/R)
	if (!(R in contents) || !R.absorbed)
		return  // User is not in this belly or isn't actually absorbed

	R.setClickCooldown(50)

	var/struggle_outer_message = pick(absorbed_struggle_messages_outside)
	var/struggle_user_message = pick(absorbed_struggle_messages_inside)

	var/absorbed_count = 0
	for(var/mob/living/L in contents)
		if(L.absorbed)
			absorbed_count++

	struggle_outer_message = replacetext(struggle_outer_message, "%pred", owner)
	struggle_outer_message = replacetext(struggle_outer_message, "%prey", R)
	struggle_outer_message = replacetext(struggle_outer_message, "%belly", lowertext(name))
	struggle_outer_message = replacetext(struggle_outer_message, "%countprey", absorbed_count)

	struggle_user_message = replacetext(struggle_user_message, "%pred", owner)
	struggle_user_message = replacetext(struggle_user_message, "%prey", R)
	struggle_user_message = replacetext(struggle_user_message, "%belly", lowertext(name))
	struggle_user_message = replacetext(struggle_user_message, "%countprey", absorbed_count)

	struggle_outer_message = "<span class='valert'>[struggle_outer_message]</span>"
	struggle_user_message = "<span class='valert'>[struggle_user_message]</span>"

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

	var/sound/struggle_snuggle
	var/sound/struggle_rustle = sound(get_sfx("rustle"))

	if(is_wet)
		if(!fancy_vore)
			struggle_snuggle = sound(get_sfx("classic_struggle_sounds"))
		else
			struggle_snuggle = sound(get_sfx("fancy_prey_struggle"))
		playsound(src, struggle_snuggle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)
	else
		playsound(src, struggle_rustle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/client_preference/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)

	//absorb resists
	if(escapable || owner.stat) //If the stomach has escapable enabled or the owner is dead/unconscious
		if(prob(escapechance_absorbed) || owner.stat) //Let's have it check to see if the prey's escape attempt starts.


			var/living_count = 0
			for(var/mob/living/L in contents)
				living_count++

			var/escape_attempt_absorbed_owner_message = pick(escape_attempt_absorbed_messages_owner)
			var/escape_attempt_absorbed_prey_message = pick(escape_attempt_absorbed_messages_prey)

			escape_attempt_absorbed_owner_message = replacetext(escape_attempt_absorbed_owner_message, "%pred", owner)
			escape_attempt_absorbed_owner_message = replacetext(escape_attempt_absorbed_owner_message, "%prey", R)
			escape_attempt_absorbed_owner_message = replacetext(escape_attempt_absorbed_owner_message, "%belly", lowertext(name))
			escape_attempt_absorbed_owner_message = replacetext(escape_attempt_absorbed_owner_message, "%countprey", living_count)
			escape_attempt_absorbed_owner_message = replacetext(escape_attempt_absorbed_owner_message, "%count", contents.len)

			escape_attempt_absorbed_prey_message = replacetext(escape_attempt_absorbed_prey_message, "%pred", owner)
			escape_attempt_absorbed_prey_message = replacetext(escape_attempt_absorbed_prey_message, "%prey", R)
			escape_attempt_absorbed_prey_message = replacetext(escape_attempt_absorbed_prey_message, "%belly", lowertext(name))
			escape_attempt_absorbed_prey_message = replacetext(escape_attempt_absorbed_prey_message, "%countprey", living_count)
			escape_attempt_absorbed_prey_message = replacetext(escape_attempt_absorbed_prey_message, "%count", contents.len)

			escape_attempt_absorbed_owner_message = "<span class='vwarning'>[escape_attempt_absorbed_owner_message]</span>"
			escape_attempt_absorbed_prey_message = "<span class='vwarning'>[escape_attempt_absorbed_prey_message]</span>"

			to_chat(R, escape_attempt_absorbed_prey_message)
			to_chat(owner, escape_attempt_absorbed_owner_message)
			if(do_after(R, escapetime))
				if((escapable || owner.stat) && (R.loc == src) && prob(escapechance_absorbed)) //Does the escape attempt succeed?
					var/escape_absorbed_owner_message = pick(escape_absorbed_messages_owner)
					var/escape_absorbed_prey_message = pick(escape_absorbed_messages_prey)
					var/escape_absorbed_outside_message = pick(escape_absorbed_messages_outside)

					escape_absorbed_owner_message = replacetext(escape_absorbed_owner_message, "%pred", owner)
					escape_absorbed_owner_message = replacetext(escape_absorbed_owner_message, "%prey", R)
					escape_absorbed_owner_message = replacetext(escape_absorbed_owner_message, "%belly", lowertext(name))
					escape_absorbed_owner_message = replacetext(escape_absorbed_owner_message, "%countprey", living_count)
					escape_absorbed_owner_message = replacetext(escape_absorbed_owner_message, "%count", contents.len)

					escape_absorbed_prey_message = replacetext(escape_absorbed_prey_message, "%pred", owner)
					escape_absorbed_prey_message = replacetext(escape_absorbed_prey_message, "%prey", R)
					escape_absorbed_prey_message = replacetext(escape_absorbed_prey_message, "%belly", lowertext(name))
					escape_absorbed_prey_message = replacetext(escape_absorbed_prey_message, "%countprey", living_count)
					escape_absorbed_prey_message = replacetext(escape_absorbed_prey_message, "%count", contents.len)

					escape_absorbed_outside_message = replacetext(escape_absorbed_outside_message, "%pred", owner)
					escape_absorbed_outside_message = replacetext(escape_absorbed_outside_message, "%prey", R)
					escape_absorbed_outside_message = replacetext(escape_absorbed_outside_message, "%belly", lowertext(name))
					escape_absorbed_outside_message = replacetext(escape_absorbed_outside_message, "%countprey", living_count)
					escape_absorbed_outside_message = replacetext(escape_absorbed_outside_message, "%count", contents.len)

					escape_absorbed_owner_message = "<span class='vwarning'>[escape_absorbed_owner_message]</span>"
					escape_absorbed_prey_message = "<span class='vwarning'>[escape_absorbed_prey_message]</span>"
					escape_absorbed_outside_message = "<span class='vwarning'>[escape_absorbed_outside_message]</span>"

					release_specific_contents(R)
					to_chat(R, escape_absorbed_prey_message)
					to_chat(owner, escape_absorbed_owner_message)
					for(var/mob/M in hearers(4, owner))
						M.show_message(escape_absorbed_outside_message, 2)
					return
				else if(!(R.loc == src)) //Aren't even in the belly. Quietly fail.
					return
				else //Belly became inescapable or you failed your roll.

					var/escape_fail_absorbed_owner_message = pick(escape_fail_absorbed_messages_owner)
					var/escape_fail_absorbed_prey_message = pick(escape_fail_absorbed_messages_prey)

					escape_fail_absorbed_owner_message = replacetext(escape_fail_absorbed_owner_message, "%pred", owner)
					escape_fail_absorbed_owner_message = replacetext(escape_fail_absorbed_owner_message, "%prey", R)
					escape_fail_absorbed_owner_message = replacetext(escape_fail_absorbed_owner_message, "%belly", lowertext(name))
					escape_fail_absorbed_owner_message = replacetext(escape_fail_absorbed_owner_message, "%countprey", living_count)
					escape_fail_absorbed_owner_message = replacetext(escape_fail_absorbed_owner_message, "%count", contents.len)

					escape_fail_absorbed_prey_message = replacetext(escape_fail_absorbed_prey_message, "%pred", owner)
					escape_fail_absorbed_prey_message = replacetext(escape_fail_absorbed_prey_message, "%prey", R)
					escape_fail_absorbed_prey_message = replacetext(escape_fail_absorbed_prey_message, "%belly", lowertext(name))
					escape_fail_absorbed_prey_message = replacetext(escape_fail_absorbed_prey_message, "%countprey", living_count)
					escape_fail_absorbed_prey_message = replacetext(escape_fail_absorbed_prey_message, "%count", contents.len)

					escape_fail_absorbed_owner_message = "<span class='vwarning'>[escape_fail_absorbed_owner_message]</span>"
					escape_fail_absorbed_prey_message = "<span class='vnotice'>[escape_fail_absorbed_prey_message]</span>"

					to_chat(R, escape_fail_absorbed_prey_message)
					to_chat(owner, escape_fail_absorbed_owner_message)
					return
	to_chat(R, struggle_user_message)

/obj/belly/proc/get_mobs_and_objs_in_belly()
	var/list/see = list()
	var/list/belly_mobs = list()
	see["mobs"] = belly_mobs
	var/list/belly_objs = list()
	see["objs"] = belly_objs
	for(var/mob/living/L in loc.contents)
		belly_mobs |= L
	for(var/obj/O in loc.contents)
		belly_objs |= O

	return see

//Transfers contents from one belly to another
/obj/belly/proc/transfer_contents(atom/movable/content, obj/belly/target, silent = 0)
	if(!(content in src) || !istype(target))
		return
	content.forceMove(target)
	if(ismob(content))
		var/mob/ourmob = content
		ourmob.reset_view(owner)
	if(isitem(content))
		var/obj/item/I = content
		if(istype(I,/obj/item/weapon/card/id))
			I.gurgle_contaminate(target.contents, target.contamination_flavor, target.contamination_color)
		if(I.gurgled && target.contaminates)
			I.decontaminate()
			I.gurgle_contaminate(target.contents, target.contamination_flavor, target.contamination_color)
	items_preserved -= content
	owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()
	for(var/mob/living/M in contents)
		M.updateVRPanel()
	owner.update_icon()

//Autotransfer callback
/obj/belly/proc/check_autotransfer(var/prey, var/autotransferlocation)
	if(autotransferlocation && (autotransferchance > 0) && (prey in contents))
		if(prob(autotransferchance))
			var/obj/belly/dest_belly
			for(var/obj/belly/B in owner.vore_organs)
				if(B.name == autotransferlocation)
					dest_belly = B
					break
			if(dest_belly)
				transfer_contents(prey, dest_belly)
		else
			// Didn't transfer, so wait before retrying
			// I feel like there's a way to make this timer looping using the normal looping thing, but pass in the ID and cancel it if we aren't looping again
			addtimer(CALLBACK(src, PROC_REF(check_autotransfer), prey, autotransferlocation), autotransferwait)

// Belly copies and then returns the copy
// Needs to be updated for any var changes
/obj/belly/proc/copy(mob/new_owner)
	var/obj/belly/dupe = new /obj/belly(new_owner)

	//// Non-object variables
	dupe.name = name
	dupe.desc = desc
	dupe.absorbed_desc = absorbed_desc
	dupe.vore_sound = vore_sound
	dupe.vore_verb = vore_verb
	dupe.release_verb = release_verb
	dupe.human_prey_swallow_time = human_prey_swallow_time
	dupe.nonhuman_prey_swallow_time = nonhuman_prey_swallow_time
	dupe.emote_time = emote_time
	dupe.nutrition_percent = nutrition_percent
	dupe.digest_brute = digest_brute
	dupe.digest_burn = digest_burn
	dupe.digest_oxy = digest_oxy
	dupe.digest_tox = digest_tox
	dupe.digest_clone = digest_clone
	dupe.immutable = immutable
	dupe.can_taste = can_taste
	dupe.escapable = escapable
	dupe.escapetime = escapetime
	dupe.digestchance = digestchance
	dupe.absorbchance = absorbchance
	dupe.escapechance = escapechance
	dupe.escapechance_absorbed = escapechance_absorbed
	dupe.transferchance = transferchance
	dupe.transferchance_secondary = transferchance_secondary
	dupe.transferlocation = transferlocation
	dupe.transferlocation_secondary = transferlocation_secondary
	dupe.bulge_size = bulge_size
	dupe.shrink_grow_size = shrink_grow_size
	dupe.mode_flags = mode_flags
	dupe.item_digest_mode = item_digest_mode
	dupe.contaminates = contaminates
	dupe.contamination_flavor = contamination_flavor
	dupe.contamination_color = contamination_color
	dupe.release_sound = release_sound
	dupe.fancy_vore = fancy_vore
	dupe.is_wet = is_wet
	dupe.wet_loop = wet_loop
	dupe.belly_fullscreen = belly_fullscreen
	dupe.disable_hud = disable_hud
	dupe.belly_fullscreen_color = belly_fullscreen_color
	dupe.belly_fullscreen_color_secondary = belly_fullscreen_color_secondary
	dupe.belly_fullscreen_color_trinary = belly_fullscreen_color_trinary
	dupe.colorization_enabled = colorization_enabled
	dupe.egg_type = egg_type
	dupe.emote_time = emote_time
	dupe.emote_active = emote_active
	dupe.selective_preference = selective_preference
	dupe.save_digest_mode = save_digest_mode
	dupe.eating_privacy_local = eating_privacy_local
	dupe.silicon_belly_overlay_preference = silicon_belly_overlay_preference
	dupe.belly_mob_mult = belly_mob_mult
	dupe.belly_item_mult = belly_item_mult
	dupe.belly_overall_mult	= belly_overall_mult

	//// Object-holding variables
	//struggle_messages_outside - strings
	dupe.struggle_messages_outside.Cut()
	for(var/I in struggle_messages_outside)
		dupe.struggle_messages_outside += I

	//struggle_messages_inside - strings
	dupe.struggle_messages_inside.Cut()
	for(var/I in struggle_messages_inside)
		dupe.struggle_messages_inside += I

	//absorbed_struggle_messages_outside - strings
	dupe.absorbed_struggle_messages_outside.Cut()
	for(var/I in absorbed_struggle_messages_outside)
		dupe.absorbed_struggle_messages_outside += I

	//absorbed_struggle_messages_inside - strings
	dupe.absorbed_struggle_messages_inside.Cut()
	for(var/I in absorbed_struggle_messages_inside)
		dupe.absorbed_struggle_messages_inside += I

	//escape_attempt_messages_owner - strings
	dupe.escape_attempt_messages_owner.Cut()
	for(var/I in escape_attempt_messages_owner)
		dupe.escape_attempt_messages_owner += I

	//escape_attempt_messages_prey - strings
	dupe.escape_attempt_messages_prey.Cut()
	for(var/I in escape_attempt_messages_prey)
		dupe.escape_attempt_messages_prey += I

	//escape_messages_owner - strings
	dupe.escape_messages_owner.Cut()
	for(var/I in escape_messages_owner)
		dupe.escape_messages_owner += I

	//escape_messages_prey - strings
	dupe.escape_messages_prey.Cut()
	for(var/I in escape_messages_prey)
		dupe.escape_messages_prey += I

	//escape_messages_outside - strings
	dupe.escape_messages_outside.Cut()
	for(var/I in escape_messages_outside)
		dupe.escape_messages_outside += I

	//escape_item_messages_owner - strings
	dupe.escape_item_messages_owner.Cut()
	for(var/I in escape_item_messages_owner)
		dupe.escape_item_messages_owner += I

	//escape_item_messages_prey - strings
	dupe.escape_item_messages_prey.Cut()
	for(var/I in escape_item_messages_prey)
		dupe.escape_item_messages_prey += I

	//escape_item_messages_outside - strings
	dupe.escape_item_messages_outside.Cut()
	for(var/I in escape_item_messages_outside)
		dupe.escape_item_messages_outside += I

	//escape_fail_messages_owner - strings
	dupe.escape_fail_messages_owner.Cut()
	for(var/I in escape_fail_messages_owner)
		dupe.escape_fail_messages_owner += I

	//escape_fail_messages_prey - strings
	dupe.escape_fail_messages_prey.Cut()
	for(var/I in escape_fail_messages_prey)
		dupe.escape_fail_messages_prey += I

	//escape_attempt_absorbed_messages_owner - strings
	dupe.escape_attempt_absorbed_messages_owner.Cut()
	for(var/I in escape_attempt_absorbed_messages_owner)
		dupe.escape_attempt_absorbed_messages_owner += I

	//escape_attempt_absorbed_messages_prey - strings
	dupe.escape_attempt_absorbed_messages_prey.Cut()
	for(var/I in escape_attempt_absorbed_messages_prey)
		dupe.escape_attempt_absorbed_messages_prey += I

	//escape_absorbed_messages_owner - strings
	dupe.escape_absorbed_messages_owner.Cut()
	for(var/I in escape_absorbed_messages_owner)
		dupe.escape_absorbed_messages_owner += I

	//escape_absorbed_messages_prey - strings
	dupe.escape_absorbed_messages_prey.Cut()
	for(var/I in escape_absorbed_messages_prey)
		dupe.escape_absorbed_messages_prey += I

	//escape_absorbed_messages_outside - strings
	dupe.escape_absorbed_messages_outside.Cut()
	for(var/I in escape_absorbed_messages_outside)
		dupe.escape_absorbed_messages_outside += I

	//escape_fail_absorbed_messages_owner - strings
	dupe.escape_fail_absorbed_messages_owner.Cut()
	for(var/I in escape_fail_absorbed_messages_owner)
		dupe.escape_fail_absorbed_messages_owner += I

	//escape_fail_absorbed_messages_prey - strings
	dupe.escape_fail_absorbed_messages_prey.Cut()
	for(var/I in escape_fail_absorbed_messages_prey)
		dupe.escape_fail_absorbed_messages_prey += I

	//primary_transfer_messages_owner - strings
	dupe.primary_transfer_messages_owner.Cut()
	for(var/I in primary_transfer_messages_owner)
		dupe.primary_transfer_messages_owner += I

	//primary_transfer_messages_prey - strings
	dupe.primary_transfer_messages_prey.Cut()
	for(var/I in primary_transfer_messages_prey)
		dupe.primary_transfer_messages_prey += I

	//secondary_transfer_messages_owner - strings
	dupe.secondary_transfer_messages_owner.Cut()
	for(var/I in secondary_transfer_messages_owner)
		dupe.secondary_transfer_messages_owner += I

	//secondary_transfer_messages_prey - strings
	dupe.secondary_transfer_messages_prey.Cut()
	for(var/I in secondary_transfer_messages_prey)
		dupe.secondary_transfer_messages_prey += I

	//digest_chance_messages_owner - strings
	dupe.digest_chance_messages_owner.Cut()
	for(var/I in digest_chance_messages_owner)
		dupe.digest_chance_messages_owner += I

	//digest_chance_messages_prey - strings
	dupe.digest_chance_messages_prey.Cut()
	for(var/I in digest_chance_messages_prey)
		dupe.digest_chance_messages_prey += I

	//absorb_chance_messages_owner - strings
	dupe.absorb_chance_messages_owner.Cut()
	for(var/I in absorb_chance_messages_owner)
		dupe.absorb_chance_messages_owner += I

	//absorb_chance_messages_prey - strings
	dupe.absorb_chance_messages_prey.Cut()
	for(var/I in absorb_chance_messages_prey)
		dupe.absorb_chance_messages_prey += I

	//digest_messages_owner - strings
	dupe.digest_messages_owner.Cut()
	for(var/I in digest_messages_owner)
		dupe.digest_messages_owner += I

	//digest_messages_prey - strings
	dupe.digest_messages_prey.Cut()
	for(var/I in digest_messages_prey)
		dupe.digest_messages_prey += I

	//absorb_messages_owner - strings
	dupe.absorb_messages_owner.Cut()
	for(var/I in absorb_messages_owner)
		dupe.absorb_messages_owner += I

	//absorb_messages_prey - strings
	dupe.absorb_messages_prey.Cut()
	for(var/I in absorb_messages_prey)
		dupe.absorb_messages_prey += I

	//unabsorb_messages_owner - strings
	dupe.unabsorb_messages_owner.Cut()
	for(var/I in unabsorb_messages_owner)
		dupe.unabsorb_messages_owner += I

	//unabsorb_messages_prey - strings
	dupe.unabsorb_messages_prey.Cut()
	for(var/I in unabsorb_messages_prey)
		dupe.unabsorb_messages_prey += I

	//examine_messages - strings
	dupe.examine_messages.Cut()
	for(var/I in examine_messages)
		dupe.examine_messages += I

	//examine_messages_absorbed - strings
	dupe.examine_messages_absorbed.Cut()
	for(var/I in examine_messages_absorbed)
		dupe.examine_messages_absorbed += I

	//emote_lists - index: digest mode, key: list of strings
	dupe.emote_lists.Cut()
	for(var/K in emote_lists)
		dupe.emote_lists[K] = list()
		for(var/I in emote_lists[K])
			dupe.emote_lists[K] += I

	return dupe

/obj/belly/container_resist(mob/M)
	return relay_resist(M)
