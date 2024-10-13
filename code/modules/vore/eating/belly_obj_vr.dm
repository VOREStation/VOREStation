//
//  Belly system 2.0, now using objects instead of datums because EH at datums.
//	How many times have I rewritten bellies and vore now? -Aro
//

// If you change what variables are on this, then you need to update the copy() proc.

//
// Parent type of all the various "belly" varieties.
//

#define DM_FLAG_VORESPRITE_TAIL     0x2
#define DM_FLAG_VORESPRITE_MARKING  0x4
#define DM_FLAG_VORESPRITE_ARTICLE	0x8


/obj/belly
	name = "belly"							// Name of this location
	desc = "It's a belly! You're in it!"	// Flavor text description of inside sight/sound/smells/feels.
	var/message_mode = FALSE				// If all options for messages are shown
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
	var/selectchance = 0					// % Chance of stomach switching to selective mode if prey struggles
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
	var/transferlocation_absorb				// Location that prey is moved to if they get absorbed.
	var/release_sound = "Splatter"			// Sound for letting someone out. Replaced from True/false
	var/mode_flags = 0						// Stripping, numbing, etc.
	var/fancy_vore = FALSE					// Using the new sounds?
	var/is_wet = TRUE						// Is this belly's insides made of slimy parts?
	var/wet_loop = TRUE						// Does the belly have a fleshy loop playing?
	var/obj/item/storage/vore_egg/ownegg	// Is this belly creating an egg?
	var/egg_type = "Egg"					// Default egg type and path.
	var/egg_path = /obj/item/storage/vore_egg
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


	var/vore_sprite_flags = DM_FLAG_VORESPRITE_ARTICLE
	var/tmp/static/list/vore_sprite_flag_list= list(
		"Normal Belly Sprite" = DM_FLAG_VORESPRITE_ARTICLE,
		//"Tail adjustment" = DM_FLAG_VORESPRITE_TAIL,
		//"Marking addition" = DM_FLAG_VORESPRITE_MARKING
		)
	var/affects_vore_sprites = FALSE
	var/count_absorbed_prey_for_sprite = TRUE
	var/absorbed_multiplier = 1
	var/count_liquid_for_sprite = FALSE
	var/liquid_multiplier = 1
	var/count_items_for_sprite = FALSE
	var/item_multiplier = 1
	var/health_impacts_size = TRUE
	var/resist_triggers_animation = TRUE
	var/size_factor_for_sprite = 1
	var/belly_sprite_to_affect = "stomach"
	var/datum/sprite_accessory/tail/tail_to_change_to = FALSE
	var/tail_colouration = FALSE
	var/tail_extra_overlay = FALSE
	var/tail_extra_overlay2 = FALSE
	var/undergarment_chosen = "Underwear, bottom"

	// Generally just used by AI
	var/autotransferchance = 0 				// % Chance of prey being autotransferred to transfer location
	var/autotransferwait = 10 				// Time between trying to transfer.
	var/autotransferlocation				// Place to send them

	//I don't think we've ever altered these lists. making them static until someone actually overrides them somewhere.
	//Actual full digest modes
	var/tmp/static/list/digest_modes = list(DM_HOLD,DM_DIGEST,DM_ABSORB,DM_DRAIN,DM_SELECT,DM_UNABSORB,DM_HEAL,DM_SHRINK,DM_GROW,DM_SIZE_STEAL,DM_EGG)
	//Digest mode addon flags
	var/tmp/static/list/mode_flag_list = list("Numbing" = DM_FLAG_NUMBING, "Stripping" = DM_FLAG_STRIPPING, "Leave Remains" = DM_FLAG_LEAVEREMAINS, "Muffles" = DM_FLAG_THICKBELLY, "Affect Worn Items" = DM_FLAG_AFFECTWORN, "Jams Sensors" = DM_FLAG_JAMSENSORS, "Complete Absorb" = DM_FLAG_FORCEPSAY, "Spare Prosthetics" = DM_FLAG_SPARELIMB)
	//Item related modes
	var/tmp/static/list/item_digest_modes = list(IM_HOLD,IM_DIGEST_FOOD,IM_DIGEST)
	//drain modes
	var/tmp/static/list/drainmodes = list(DR_NORMAL,DR_SLEEP,DR_FAKE,DR_WEIGHT)

	//List of slots that stripping handles strips
	var/tmp/static/list/slots = list(slot_back,slot_handcuffed,slot_l_store,slot_r_store,slot_wear_mask,slot_l_hand,slot_r_hand,slot_wear_id,slot_glasses,slot_gloves,slot_head,slot_shoes,slot_belt,slot_wear_suit,slot_w_uniform,slot_s_store,slot_l_ear,slot_r_ear)

	var/tmp/mob/living/owner					// The mob whose belly this is.
	var/tmp/digest_mode = DM_HOLD				// Current mode the belly is set to from digest_modes (+transform_modes if human)
	var/tmp/list/items_preserved = list()		// Stuff that wont digest so we shouldn't process it again.
	var/tmp/recent_sound = FALSE				// Prevent audio spam
	var/tmp/drainmode = DR_NORMAL				// Simply drains the prey then does nothing.
	var/tmp/digested_prey_count = 0				// Amount of prey that have been digested

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
	"message_mode",
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
	"drainmode",
	"vore_sprite_flags",
	"affects_vore_sprites",
	"count_absorbed_prey_for_sprite",
	"resist_triggers_animation",
	"size_factor_for_sprite",
	"belly_sprite_to_affect",
	"health_impacts_size",
	"count_items_for_sprite",
	"item_multiplier"
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
	for(var/mob/observer/G in src)
		G.forceMove(get_turf(src)) //ported from CHOMPStation PR#7132
	return ..()

// Called whenever an atom enters this belly
/obj/belly/Entered(atom/movable/thing, atom/OldLoc)

	if(istype(thing, /mob/observer)) //Ports CHOMPStation PR#3072
		if(desc) //Ports CHOMPStation PR#4772
			//Allow ghosts see where they are if they're still getting squished along inside.
			to_chat(thing, span_vnotice(span_bold("[belly_format_string(desc, thing)]")))

	if(OldLoc in contents)
		return //Someone dropping something (or being stripdigested)

	//Generic entered message
	if(!istype(thing, /mob/observer))	//Don't have ghosts announce they're reentering the belly on death
		to_chat(owner,span_vnotice("[thing] slides into your [lowertext(name)]."))

	//Sound w/ antispam flag setting
	if(vore_sound && !recent_sound && !istype(thing, /mob/observer))
		var/soundfile
		if(!fancy_vore)
			soundfile = classic_vore_sounds[vore_sound]
		else
			soundfile = fancy_vore_sounds[vore_sound]
		if(soundfile)
			playsound(src, soundfile, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
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
			to_chat(M, span_vnotice(span_bold("[belly_format_string(raw_desc, M)]")))

		var/taste
		if(can_taste && (taste = M.get_taste_message(FALSE)))
			to_chat(owner, span_vnotice("[M] tastes of [taste]."))
		vore_fx(M)
		//Stop AI processing in bellies
		if(M.ai_holder)
			M.ai_holder.handle_eaten()

		if (istype(owner, /mob/living/carbon/human))
			var/mob/living/carbon/human/hum = owner
			hum.update_fullness()

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
	if (istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/hum = owner
		hum.update_fullness()


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
			to_chat(L, span_vnotice("((Your pred has disabled huds in their belly. Turn off vore FX and hit F12 to get it back; or relax, and enjoy the serenity.))"))
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
			if(L.stat)
				L.SetSleeping(min(L.sleeping,20))
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
		owner.visible_message(span_vnotice(span_green(span_bold("[owner] [release_verb] everything from their [lowertext(name)]!"))), range = privacy_range)
		var/soundfile
		if(!fancy_vore)
			soundfile = classic_release_sounds[release_sound]
		else
			soundfile = fancy_release_sounds[release_sound]
		if(soundfile)
			playsound(src, soundfile, vol = privacy_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)

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

	for(var/obj/item/holder/H in M.contents)
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

	//Makes it so that if prey are heavily asleep, they will wake up shortly after release
	if(isliving(M))
		var/mob/living/ML = M
		if(ML.stat)
			ML.SetSleeping(min(ML.sleeping,20))

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
	if(!silent && !isobserver(M))
		owner.visible_message(span_vnotice(span_green(span_bold("[owner] [release_verb] [M] from their [lowertext(name)]!"))),range = privacy_range)
		var/soundfile
		if(!fancy_vore)
			soundfile = classic_release_sounds[release_sound]
		else
			soundfile = fancy_release_sounds[release_sound]
		if(soundfile)
			playsound(src, soundfile, vol = privacy_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
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

// Handle the death of a mob via digestion.
// Called from the process_Life() methods of bellies that digest prey.
// Default implementation calls M.death() and removes from internal contents.
// Indigestable items are removed, and M is deleted.
/obj/belly/proc/digestion_death(mob/living/M)
	digested_prey_count++
	add_attack_logs(owner, M, "Digested in [lowertext(name)]")

	// If digested prey is also a pred... anyone inside their bellies gets moved up.
	if(is_vore_predator(M))
		M.release_vore_contents(include_absorbed = TRUE, silent = TRUE)

	//Drop all items into the belly.
	if(config.items_survive_digestion)
		for(var/obj/item/W in M)
			if(istype(W, /obj/item/organ/internal/mmi_holder/posibrain))
				var/obj/item/organ/internal/mmi_holder/MMI = W
				var/obj/item/mmi/brainbox = MMI.removed()
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
					else if(item_digest_mode == IM_DIGEST_FOOD && !(istype(I,/obj/item/reagent_containers/food) || istype(I,/obj/item/organ)))
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
	var/mob/observer/G = M.ghostize() //Ports CHOMPStation PR#3074 Make sure they're out, so we can copy attack logs and such.
	if(G)
		G.forceMove(src)
	qdel(M)

// Handle a mob being absorbed
/obj/belly/proc/absorb_living(mob/living/M)
	M.absorbed = TRUE
	if(M.ckey)
		handle_absorb_langs(M, owner)
		GLOB.prey_absorbed_roundstat++

	to_chat(M, span_vnotice("[belly_format_string(absorb_messages_prey, M, use_absorbed_count = TRUE)]"))
	to_chat(owner, span_vnotice("[belly_format_string(absorb_messages_owner, M, use_absorbed_count = TRUE)]"))
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
		to_chat(M, span_vnotice(span_bold("[belly_format_string(absorbed_desc, M)]")))

	//Update owner
	owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()
	// Finally, if they're to be sent to a special pudge belly, send them there
	if(transferlocation_absorb)
		var/obj/belly/dest_belly
		for(var/obj/belly/B as anything in owner.vore_organs)
			if(B.name == transferlocation_absorb)
				dest_belly = B
				break
		if(!dest_belly)
			to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had its transfer location cleared as a precaution."))
			transferlocation_absorb = null
			return

		transfer_contents(M, dest_belly)

// Handle a mob being unabsorbed
/obj/belly/proc/unabsorb_living(mob/living/M)
	M.absorbed = FALSE
	handle_absorb_langs(M, owner)
	to_chat(M, span_vnotice(belly_format_string(unabsorb_messages_prey, M, use_absorbed_count = TRUE)))
	to_chat(owner, span_vnotice(belly_format_string(unabsorb_messages_owner, M, use_absorbed_count = TRUE)))

	if(desc)
		to_chat(M, span_vnotice(span_bold("[belly_format_string(desc, M)]")))

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

	var/escape_attempt_owner_message = span_vwarning(belly_format_string(escape_attempt_messages_owner, R))
	var/escape_attempt_prey_message = span_vwarning(belly_format_string(escape_attempt_messages_prey, R))
	var/escape_fail_owner_message = span_vwarning(belly_format_string(escape_fail_messages_owner, R))
	var/escape_fail_prey_message = span_vnotice(belly_format_string(escape_fail_messages_prey, R))

	if(owner.stat) //If owner is stat (dead, KO) we can actually escape
		escape_attempt_prey_message = span_vwarning("[escape_attempt_prey_message] (will take around [escapetime/10] seconds.)")
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

	var/struggle_outer_message = span_valert(belly_format_string(struggle_messages_outside, R))
	var/struggle_user_message = span_valert(belly_format_string(struggle_messages_inside, R))

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

	var/sound/struggle_snuggle
	var/sound/struggle_rustle = sound(get_sfx("rustle"))

	if(resist_triggers_animation && affects_vore_sprites)
		var/mob/living/carbon/human/O = owner
		if(istype(O))
			O.vore_belly_animation()

	if(is_wet)
		if(!fancy_vore)
			struggle_snuggle = sound(get_sfx("classic_struggle_sounds"))
		else
			struggle_snuggle = sound(get_sfx("fancy_prey_struggle"))
		playsound(src, struggle_snuggle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)
	else
		playsound(src, struggle_rustle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)

	if(escapable) //If the stomach has escapable enabled.
		if(prob(escapechance)) //Let's have it check to see if the prey escapes first.
			to_chat(R, escape_attempt_prey_message)
			to_chat(owner, escape_attempt_owner_message)
			if(do_after(R, escapetime))
				if(escapable && C)
					var/escape_item_owner_message = span_vwarning(belly_format_string(escape_item_messages_owner, R, item = C))
					var/escape_item_prey_message = span_vwarning(belly_format_string(escape_item_messages_prey, R, item = C))
					var/escape_item_outside_message = span_vwarning(belly_format_string(escape_item_messages_outside, R, item = C))

					release_specific_contents(C)
					to_chat(R, escape_item_prey_message)
					to_chat(owner, escape_item_owner_message)
					for(var/mob/M in hearers(4, owner))
						M.show_message(escape_item_outside_message, 2)
					return
				if(escapable && (R.loc == src) && !R.absorbed) //Does the owner still have escapable enabled?
					var/escape_owner_message = span_vwarning(belly_format_string(escape_messages_owner, R))
					var/escape_prey_message = span_vwarning(belly_format_string(escape_messages_prey, R))
					var/escape_outside_message = span_vwarning(belly_format_string(escape_messages_outside, R))

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
				to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution."))
				transferchance = 0
				transferlocation = null
				return
			var/primary_transfer_owner_message = span_vwarning(belly_format_string(primary_transfer_messages_owner, R, dest = transferlocation))
			var/primary_transfer_prey_message = span_vwarning(belly_format_string(primary_transfer_messages_prey, R, dest = transferlocation))

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
				to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution."))
				transferchance_secondary = 0
				transferlocation_secondary = null
				return

			var/secondary_transfer_owner_message = span_vwarning(belly_format_string(secondary_transfer_messages_owner, R, dest = transferlocation_secondary))
			var/secondary_transfer_prey_message = span_vwarning(belly_format_string(secondary_transfer_messages_prey, R, dest = transferlocation_secondary))

			to_chat(R, secondary_transfer_prey_message)
			to_chat(owner, secondary_transfer_owner_message)
			if(C)
				transfer_contents(C, dest_belly)
				return
			transfer_contents(R, dest_belly)
			return

		else if(prob(absorbchance) && digest_mode != DM_ABSORB) //After that, let's have it run the absorb chance.
			var/absorb_chance_owner_message = span_vwarning(belly_format_string(absorb_chance_messages_owner, R))
			var/absorb_chance_prey_message = span_vwarning(belly_format_string(absorb_chance_messages_prey, R))

			to_chat(R, absorb_chance_prey_message)
			to_chat(owner, absorb_chance_owner_message)
			digest_mode = DM_ABSORB
			return

		else if(prob(digestchance) && digest_mode != DM_DIGEST) //Then, let's see if it should run the digest chance.
			var/digest_chance_owner_message = span_vwarning(belly_format_string(digest_chance_messages_owner, R))
			var/digest_chance_prey_message = span_vwarning(belly_format_string(digest_chance_messages_prey, R))

			to_chat(R, digest_chance_prey_message)
			to_chat(owner, digest_chance_owner_message)
			digest_mode = DM_DIGEST
			return
		else if(prob(selectchance) && digest_mode != DM_SELECT) //Finally, let's see if it should run the selective mode chance.
			var/select_chance_owner_message = span_vwarning(belly_format_string(select_chance_messages_owner, R))
			var/select_chance_prey_message = span_vwarning(belly_format_string(select_chance_messages_prey, R))

			to_chat(R, select_chance_prey_message)
			to_chat(owner, select_chance_owner_message)
			digest_mode = DM_SELECT

		else //Nothing interesting happened.
			to_chat(R, struggle_user_message)
			to_chat(owner, span_vwarning("Your prey appears to be unable to make any progress in escaping your [lowertext(name)]."))
			return
	to_chat(R, struggle_user_message)

/obj/belly/proc/relay_absorbed_resist(mob/living/R)
	if (!(R in contents) || !R.absorbed)
		return  // User is not in this belly or isn't actually absorbed

	R.setClickCooldown(50)

	var/struggle_outer_message = span_valert(belly_format_string(absorbed_struggle_messages_outside, R, use_absorbed_count = TRUE))
	var/struggle_user_message = span_valert(belly_format_string(absorbed_struggle_messages_inside, R, use_absorbed_count = TRUE))

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

	var/sound/struggle_snuggle
	var/sound/struggle_rustle = sound(get_sfx("rustle"))

	if(is_wet)
		if(!fancy_vore)
			struggle_snuggle = sound(get_sfx("classic_struggle_sounds"))
		else
			struggle_snuggle = sound(get_sfx("fancy_prey_struggle"))
		playsound(src, struggle_snuggle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)
	else
		playsound(src, struggle_rustle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, preference = /datum/preference/toggle/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)

	//absorb resists
	if(escapable || owner.stat) //If the stomach has escapable enabled or the owner is dead/unconscious
		if(prob(escapechance) || owner.stat) //Let's have it check to see if the prey's escape attempt starts.
			var/escape_attempt_absorbed_owner_message = span_vwarning(belly_format_string(escape_attempt_absorbed_messages_owner, R))
			var/escape_attempt_absorbed_prey_message = span_vwarning(belly_format_string(escape_attempt_absorbed_messages_prey, R))

			to_chat(R, escape_attempt_absorbed_prey_message)
			to_chat(owner, escape_attempt_absorbed_owner_message)
			if(do_after(R, escapetime))
				if((escapable || owner.stat) && (R.loc == src) && prob(escapechance_absorbed)) //Does the escape attempt succeed?
					var/escape_absorbed_owner_message = span_vwarning(belly_format_string(escape_absorbed_messages_owner, R))
					var/escape_absorbed_prey_message = span_vwarning(belly_format_string(escape_absorbed_messages_prey, R))
					var/escape_absorbed_outside_message = span_vwarning(belly_format_string(escape_absorbed_messages_outside, R))

					release_specific_contents(R)
					to_chat(R, escape_absorbed_prey_message)
					to_chat(owner, escape_absorbed_owner_message)
					for(var/mob/M in hearers(4, owner))
						M.show_message(escape_absorbed_outside_message, 2)
					return
				else if(!(R.loc == src)) //Aren't even in the belly. Quietly fail.
					return
				else //Belly became inescapable or you failed your roll.
					var/escape_fail_absorbed_owner_message = span_vwarning(belly_format_string(escape_fail_absorbed_messages_owner, R))
					var/escape_fail_absorbed_prey_message = span_vnotice(belly_format_string(escape_fail_absorbed_messages_prey, R))

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
	if(ismob(content) && !isobserver(content))
		var/mob/ourmob = content
		ourmob.reset_view(owner)
	if(isitem(content))
		var/obj/item/I = content
		if(istype(I,/obj/item/card/id))
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
	dupe.message_mode = message_mode
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
	dupe.vore_sprite_flags = vore_sprite_flags
	dupe.affects_vore_sprites = affects_vore_sprites
	dupe.count_absorbed_prey_for_sprite = count_absorbed_prey_for_sprite
	dupe.resist_triggers_animation = resist_triggers_animation
	dupe.size_factor_for_sprite = size_factor_for_sprite
	dupe.belly_sprite_to_affect = belly_sprite_to_affect
	dupe.health_impacts_size = health_impacts_size
	dupe.count_items_for_sprite = count_items_for_sprite
	dupe.item_multiplier = item_multiplier

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

/obj/belly/proc/GetFullnessFromBelly()
	if(!affects_vore_sprites)
		return 0
	var/belly_fullness = 0
	for(var/mob/living/M in src)
		if(count_absorbed_prey_for_sprite || !M.absorbed)
			var/fullness_to_add = M.size_multiplier
			fullness_to_add *= M.mob_size / 20
			if(M.absorbed)
				fullness_to_add *= absorbed_multiplier
			if(health_impacts_size)
				fullness_to_add *= M.health / M.getMaxHealth()
			belly_fullness += fullness_to_add
	if(count_liquid_for_sprite)
		belly_fullness += (reagents.total_volume / 100) * liquid_multiplier
	if(count_items_for_sprite)
		for(var/obj/item/I in src)
			var/fullness_to_add = 0
			if(I.w_class == ITEMSIZE_TINY)
				fullness_to_add = ITEMSIZE_COST_TINY
			else if(I.w_class == ITEMSIZE_SMALL)
				fullness_to_add = ITEMSIZE_COST_SMALL
			else if(I.w_class == ITEMSIZE_NORMAL)
				fullness_to_add = ITEMSIZE_COST_NORMAL
			else if(I.w_class == ITEMSIZE_LARGE)
				fullness_to_add = ITEMSIZE_COST_LARGE
			else if(I.w_class == ITEMSIZE_HUGE)
				fullness_to_add = ITEMSIZE_COST_HUGE
			else
				fullness_to_add = ITEMSIZE_COST_NO_CONTAINER
			fullness_to_add /= 32
			belly_fullness += fullness_to_add * item_multiplier
	belly_fullness *= size_factor_for_sprite
	return belly_fullness
