/**
 * These are generally sprites ported from other servers, which don't have any unique code.
 * They can be used by mappers for decorating their maps. They're mostly here so people who aren't
 * rummaging around in the sprites can be aware of some neat sprites they can use.
 * 
 * Obviously you can swipe the sprites for real structures and add code, but please don't add any code
 * (beyond decorative things like maybe light) directly to these types or this file!
 * Take the icon and state and make your own type under /obj/structure.
 * 
 * Some of these do have a SMIDGE of code to allow a mapper to twirl them through states/animations without
 * much effort, but beyond 'visuals logic', I'd rather keep all the logic out of here.
 */

/obj/structure/prop
	name = "mysterious structure"
	desc = "A mysterious structure!"
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	density = TRUE
	anchored = TRUE
	var/interaction_message = null
	var/state

/// Used to tell the player that this isn't useful for anything.
/obj/structure/prop/attack_hand(mob/living/user)
	if(!istype(user))
		return FALSE
	if(!interaction_message)
		return ..()
	else
		to_chat(user, interaction_message)

/// Changes the visual state of the machine between icon_states or overlays or whatever
/// the machine needs to look like it's in a different state.
/obj/structure/prop/proc/change_state(state)
	SHOULD_CALL_PARENT(TRUE)
	src.state = state

/// Helper so admins can varedit the state easily.
/obj/structure/prop/vv_edit_var(var_name, var_value)
	if(var_name == "state")
		change_state(var_value)

// bluespace beacon from Eris
/obj/structure/prop/bsb_off
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "bsb_off"
/obj/structure/prop/bsb_on
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "bsb_on"

// bluespace crystal from Eris
/obj/structure/prop/bsc
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "bsc"
/obj/structure/prop/bsc_dust
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "bsc_dust"

// same as state names, from faction items on Eris
/obj/structure/prop/biosyphon
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "biosyphon"
/obj/structure/prop/von_krabin
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "von_krabin"
/obj/structure/prop/last_shelter
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "last_shelter"
/obj/structure/prop/complicator
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "complicator"
/obj/structure/prop/random_radio
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "random_radio"
/obj/structure/prop/nt_pedestal0_old
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_pedestal0_old"
/obj/structure/prop/nt_pedestal1_old
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_pedestal1_old"

// statues from Eris
/obj/structure/prop/statue1
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "artwork_statue_1"
/obj/structure/prop/statue2
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "artwork_statue_2"
/obj/structure/prop/statue3
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "artwork_statue_3"
/obj/structure/prop/statue4
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "artwork_statue_4"
/obj/structure/prop/statue5
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "artwork_statue_5"
/obj/structure/prop/statue6
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "artwork_statue_6"

// ship mast from TGMC
/obj/structure/prop/stump_plaque
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "stump"

// vatgrowing thing from /tg/
/obj/structure/prop/green_egg
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "gel_cocoon"

// eye of the protector from Eris
/obj/structure/prop/eotp
	icon = 'icons/obj/structures/decor32x64.dmi'
	icon_state = "eotp"

// gravity generator from Eris
/obj/structure/prop/gravygen
	icon = 'icons/obj/structures/decor64x64.dmi'
	icon_state = "bigdice"
	bound_width = 64
	bound_height = 64

// dna vault from /tg/
/obj/structure/prop/dna_vault
	icon = 'icons/obj/structures/decor96x96.dmi'
	icon_state = "vault"

// fences from TGMC
// You'll need to 'create instances from icon_states' in an editor to use these well
/obj/structure/prop/fence
	name = "fence"
	desc = "It's a fence! Not much else to say about it."
	icon = 'icons/obj/structures/decor_fences.dmi'

/**
 * 
 * tl;dr "You can varedit 'state' on these to the things in the comments below to get cool animations"
 * 
 * These items have some logic to handle some fun animations on them. Mappers can call the 'change_state(state)' proc
 * while referring to the comments here for what states they can use. You'll notice some crazy overlay handling,
 * and that's because I don't want to add any vars to these mappers think they can fiddle with, which requires
 * more logic than I'm willing to do at the moment. So we get crazy cut/add operations instead.
 * 
 * There's also a VV helper so if you varedit 'state' to these during the game, you can get that to work.
 * 
 * Like, I don't want to add a state machine to decorative objects. You can if you want.
 * 
 */

/**
 * Possible 'state' options for change_state(state) are:
 * off: Looks boring and off
 * on: candles lit and stuff
 * no_cruciform: No cruciform (the little triangle thing) inserted
 * red_cruciform: Red light cruciform inserted
 * green_cruciform: Green light cruciform inserted
 * panel_open: The panel is open (wiring)
 * panel_closed: The panel is closed
 */
// neotheology cruciform reader from Eris
/obj/structure/prop/nt_reader
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_reader_off"

/obj/structure/prop/nt_reader/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "nt_reader_off"
		if("on")
			icon_state = "nt_reader_on"
		if("no_cruciform")
			cut_overlay("nt_reader_c_green")
			cut_overlay("nt_reader_c_red")
		if("red_cruciform")
			cut_overlay("nt_reader_c_green")
			cut_overlay("nt_reader_c_red")
			add_overlay("nt_reader_c_red")
		if("green_cruciform")
			cut_overlay("nt_reader_c_red")
			cut_overlay("nt_reader_c_green")
			add_overlay("nt_reader_c_green")
		if("panel_open")
			cut_overlay("nt_reader_panel")
			add_overlay("nt_reader_panel")
		if("panel_closed")
			cut_overlay("nt_reader_panel")

/**
 * Possible 'state' options for change_state(state) are:
 * panel_open: The panel is opened
 * panel_closed: The panel is closed
 */
// neotheology cloning biocan from Eris
/obj/structure/prop/nt_biocan
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_biocan"

/obj/structure/prop/nt_biocan/change_state(state)
	. = ..()
	switch(state)
		if("panel_open")
			cut_overlay("nt_biocan_panel")
			add_overlay("nt_biocan_panel")
		if("panel_closed")
			cut_overlay("nt_biocan_panel")

/**
 * Possible 'state' options for change_state(state) are:
 * blue, red, orange, yellow, green, purple: Set that color
 * damaged: add damage overlay
 * undamaged: remove damage overlay
 * broken: become damaged
 * plain: undamaged white version, otherwise use a color
 */
// dominator console from /tg/
/obj/structure/prop/dominator
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "dominator"

/obj/structure/prop/dominator/change_state(state)
	. = ..()
	switch(state)
		if("blue")
			icon_state = "dominator-blue"
		if("red")
			icon_state = "dominator-red"
		if("orange")
			icon_state = "dominator-orange"
		if("yellow")
			icon_state = "dominator-yellow"
		if("green")
			icon_state = "dominator-green"
		if("purple")
			icon_state = "dominator-purple"
		if("damaged")
			add_overlay("dom_damage")
		if("undamaged")
			cut_overlay("dom_damage")
		if("broken")
			icon_state = "dominator-broken"
		if("plain")
			icon_state = "dominator"

/obj/structure/prop/dominator/blue
	icon_state = "dominator-blue"
/obj/structure/prop/dominator/red
	icon_state = "dominator-red"
/obj/structure/prop/dominator/orange
	icon_state = "dominator-orange"
/obj/structure/prop/dominator/yellow
	icon_state = "dominator-yellow"
/obj/structure/prop/dominator/green
	icon_state = "dominator-green"
/obj/structure/prop/dominator/purple
	icon_state = "dominator-purple"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Default, boring
 * on: Pumping or something
 */
// some neotheology thing from Eris
/obj/structure/prop/nt_solifier
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_solidifier"

/obj/structure/prop/nt_solifier/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "nt_solidifier"
		if("on")
			icon_state = "nt_solidifier_on"

/obj/structure/prop/nt_solifier/starts_on
	icon_state = "nt_solidifier_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Boring, round
 * on: Spinny glowy
 */
// conduit of soul from Eris
/obj/structure/prop/conduit
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "conduit_off"

/obj/structure/prop/conduit/change_state(state)
	. = ..()
	switch(state)
		if("on")
			icon_state = "conduit_spin"
			flick("conduit_starting", src)
		if("off")
			icon_state = "conduit_off"
			flick("conduit_stopping", src)

/obj/structure/prop/conduit/starts_on
	icon_state = "conduit_spin"

/**
 * Possible 'state' options for change_state(state) are:
 * on: Doing some kinda worky thing
 * off: Not doing much of anything
 * empty: No blue crystal thingy
 * loaded: off but without the animation
 */
// some kinda NT thing from Eris
/obj/structure/prop/core
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "core_inactive"

/obj/structure/prop/core/change_state(state)
	. = ..()
	switch(state)
		if("on")
			icon_state = "core_active"
			flick("core_warmup", src)
		if("off")
			icon_state = "core_inactive"
			flick("core_shutdown", src)
		if("empty")
			icon_state = "core_empty"
		if("loaded")
			icon_state = "core_inactive"

/obj/structure/prop/core/starts_on
	icon_state = "core_active"

/**
 * Possible 'state' options for change_state(state) are:
 * down: In the ground, glowing
 * up: Out of the ground, open
 */
// experimental science destructor from /tg/
/obj/structure/prop/tube
	icon = 'icons/obj/structures/decor32x64.dmi'
	icon_state = "tube_open"

/obj/structure/prop/tube/change_state(state)
	. = ..()
	switch(state)
		if("down")
			icon_state = "tube_on"
			flick("tube_down", src)
		if("up")
			icon_state = "tube_open"
			flick("tube_up", src)

/obj/structure/prop/tube/starts_down
	icon_state = "tube_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Boring, static
 * on: Turny and blinky
 */
// experimental science destructor from /tg/
/obj/structure/prop/comm_tower
	icon = 'icons/obj/structures/decor.dmi'
	icon = 'icons/obj/structures/decor96x96.dmi'
	icon_state = "comm_tower"

/obj/structure/prop/comm_tower/change_state(state)
	. = ..()
	switch(state)
		if("on")
			icon_state = "comm_tower_on"
		if("off")
			icon_state = "comm_tower"

/obj/structure/prop/comm_tower/starts_on
	icon_state = "comm_tower_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Not doing much
 * on: Stamping mysterious substances
 */
// sheetizer from /tg/
/obj/structure/prop/stamper
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "stamper"

/obj/structure/prop/stamper/change_state(state)
	. = ..()
	switch(state)
		if("off")
			cut_overlays()
		if("on")
			add_overlay("stamper_proc")
			add_overlay("stamper_but")

/obj/structure/prop/stamper/starts_on
	icon_state = "stamper_on"

/obj/structure/prop/stamper/starts_on/Initialize()
	add_overlay("stamper_proc")
	add_overlay("stamper_but")


/**
 * Possible 'state' options for change_state(state) are:
 * whole: Not doing much
 * broken: Stamping mysterious substances
 */
// alien autopsy thing from TGMC
/obj/structure/prop/alien_tank
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "tank_larva"

/obj/structure/prop/alien_tank/change_state(state)
	. = ..()
	switch(state)
		if("whole")
			icon_state = "tank_larva"
		if("broken")
			icon_state = "tank_broken"

/obj/structure/prop/alien_tank/starts_broken
	icon_state = "tank_broken"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: The default look
 * active: Glowy lights underneath
 * panel_open: Opened panel (wiring)
 * panel_closed: Closed panel
 */
// neotheology optable from Eris
/obj/structure/prop/nt_optable
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_optable-idle"

/obj/structure/prop/nt_optable/change_state(state)
	. = ..()
	switch(state)
		if("idle")
			icon_state = "nt_optable-idle"
		if("active")
			icon_state = "nt_optable-active"
		if("panel_open")
			cut_overlay("nt_optable_panel")
			add_overlay("nt_optable_panel")
		if("panel_closed")
			cut_overlay("nt_optable_panel")

/obj/structure/prop/nt_optable/starts_active
	icon_state = "nt_optable-active"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: The default look
 * active: Glowy lights in the center
 * panel_open: Opened panel (wiring)
 * panel_closed: Closed panel
 */
// trade beacon from Eris
/obj/structure/prop/tradebeacon
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "tradebeacon"

/obj/structure/prop/tradebeacon/change_state(state)
	. = ..()
	switch(state)
		if("idle")
			icon_state = "tradebeacon"
		if("active")
			icon_state = "tradebeacon_active"
		if("panel_open")
			cut_overlay("tradebeacon_panel")
			add_overlay("tradebeacon_panel")
		if("panel_closed")
			cut_overlay("tradebeacon_panel")

/obj/structure/prop/tradebeacon/starts_active
	icon_state = "tradebeacon_active"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: The default look
 * active: Glowy lights in the center
 * panel_open: Opened panel (wiring)
 * panel_closed: Closed panel
 */
// another trade beacon from Eris
/obj/structure/prop/tradebeacon2
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "tradebeacon"

/obj/structure/prop/tradebeacon2/change_state(state)
	. = ..()
	switch(state)
		if("idle")
			icon_state = "tradebeacon_sending"
		if("active")
			icon_state = "tradebeacon_sending_active"
		if("panel_open")
			cut_overlay("tradebeacon_sending_panel")
			add_overlay("tradebeacon_sending_panel")
		if("panel_closed")
			cut_overlay("tradebeacon_sending_panel")

/obj/structure/prop/tradebeacon2/starts_active
	icon_state = "tradebeacon_sending_active"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Non-spinny
 * on: Spinny and floaty
 */
// neotheology decorative(?) obelisk from Eris
/obj/structure/prop/nt_obelisk
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_obelisk"

/obj/structure/prop/nt_obelisk/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "nt_obelisk"
		if("on")
			icon_state = "nt_obelisk_on"

/obj/structure/prop/nt_obelisk/starts_on
	icon_state = "nt_obelisk_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Inert
 * on: Hand destroying machinery
 */
// 'sorter' from Eris
/obj/structure/prop/sorter
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "sorter"

/obj/structure/prop/sorter/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "sorter"
		if("on")
			icon_state = "sorter-process"

/obj/structure/prop/sorter/starts_on
	icon_state = "sorter-process"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Inert
 * on: Hand destroying machinery
 */
// 'smelter' from Eris
/obj/structure/prop/smelter
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "smelter"

/obj/structure/prop/smelter/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "smelter"
		if("on")
			icon_state = "smelter-process"

/obj/structure/prop/smelter/starts_on
	icon_state = "smelter-process"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: Not doing anything, with yellow template exposed
 * work: busy doing work
 * pause: paused work
 */
// cruciform forge from Eris
/obj/structure/prop/nt_cruciforge
	icon = 'icons/obj/structures/decor.dmi'
	icon_state = "nt_cruciforge"

/obj/structure/prop/nt_cruciforge/change_state(state)
	. = ..()
	switch(state)
		if("idle")
			icon_state = "nt_cruciforge"
			flick("nt_cruciforge_finish", src) // 8ds
		if("work")
			icon_state = "nt_cruciforge_work"
			flick("nt_cruciforge_start", src) // 8ds
		if("pause")
			icon_state = "nt_cruciforge_pause"
			
/obj/structure/prop/nt_cruciforge/starts_working
	icon_state = "nt_cruciforge_work"

/**
 * This one is a bit more fancy than others. Anything in the contents (PLEASE LIMIT TO ONE THING)
 * will show up inside it! Also if you map in an item on it, it will grab that at mapload and start
 * in the 'closed, full of fluid' state, so you can put a body on it or whatever.
 * 
 * As an aghost you can also dragdrop something into it (you have to be ghosted next to it)
 * 
 * Possible 'state' options for change_state(state) are:
 * open: Open, no fluid or anything. At the end the contents are ejected.
 * closed: Closed, full of liquid
 * panel_open: Shows panel
 * panel_closed: Unshows panel
 */
// neotheology cloning pod from Eris
/obj/structure/prop/nt_pod
	icon = 'icons/obj/structures/decor.dmi'
	icon = 'icons/obj/structures/decor32x64.dmi'
	icon_state = "nt_pod_mappreview"
	bound_height = 64

	var/obj/effect/overlay/vis/outside
	var/obj/effect/overlay/vis/door
	var/obj/effect/overlay/vis/fluid

	var/contents_vis_flags = NONE
	var/contents_original_pixel_y = 0

/obj/structure/prop/nt_pod/Initialize(mapload)
	// Our non-map-preview state
	icon_state = "nt_pod"
	
	// Alpha mask to make sure things don't sneak out
	var/obj/effect/overlay/vis/mask = new
	mask.icon = icon
	mask.icon_state = "nt_pod_mask"
	mask.render_target = "*nt_podmask[REF(src)]"
	mask.vis_flags = VIS_INHERIT_ID
	vis_contents += mask

	outside = add_vis_overlay(icon, "nt_pod_over", ABOVE_MOB_LAYER, MOB_PLANE, unique = TRUE)
	door = add_vis_overlay(icon, "nothing", ABOVE_MOB_LAYER, MOB_PLANE, unique = TRUE)
	fluid = add_vis_overlay(icon, "nothing", ABOVE_MOB_LAYER, MOB_PLANE, unique = TRUE)

	// Gather up our friends
	if(mapload)
		var/atom/movable/AM = locate() in loc
		AM?.forceMove(src)

/obj/structure/prop/nt_pod/Entered(atom/movable/mover)
	abduct(mover)

/obj/structure/prop/nt_pod/proc/abduct(var/atom/movable/AM)
	// Save old settings
	contents_vis_flags = AM.vis_flags
	contents_original_pixel_y = AM.pixel_y
	
	// Arrange
	AM.add_filter("podmask", 1, alpha_mask_filter(render_source = "nt_podmask[REF(src)]", flags = MASK_INVERSE))
	AM.pixel_y = 12
	AM.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR
	vis_contents += AM
	if(ismob(AM))
		var/mob/M = AM
		buckle_mob(M, TRUE, FALSE)
	
	// TRAP THEM
	change_state("closed")

/obj/structure/prop/nt_pod/proc/unduct(var/atom/movable/AM)
	// Geddout
	vis_contents -= AM
	if(ismob(AM))
		var/mob/M = AM
		unbuckle_mob(M, TRUE)
	// Cleanup
	AM.remove_filter("podmask")
	AM.forceMove(drop_location())
	AM.vis_flags = contents_vis_flags
	AM.pixel_y = contents_original_pixel_y

/obj/structure/prop/nt_pod/MouseDrop_T(var/atom/movable/AM, var/mob/user)
	if(contents.len)
		return
	if(!ismovable(AM))
		return
	if(!user.client?.holder)
		return
	
	AM.forceMove(src)

/obj/structure/prop/nt_pod/change_state(state)
	. = ..()
	switch(state)
		if("open")
			cut_overlay("nt_pod_top_on")
			cut_overlay("nt_pod_under")
			
			// Fluid drains
			fluid.icon_state = "nothing"
			flick("nt_pod_emptying", fluid) // 8ds
			sleep(8)
			
			// Door opens
			door.icon_state = "nothing"
			flick("nt_pod_opening", door) // 9ds
			sleep(9)
			
			// GET OUT
			outside.layer = BELOW_MOB_LAYER
			if(contents.len)
				for(var/atom/movable/AM as anything in contents)
					unduct(AM)

		if("closed")
			outside.layer = ABOVE_MOB_LAYER
			cut_overlay("nt_pod_top_on")
			add_overlay("nt_pod_top_on")
			add_overlay("nt_pod_under")
			
			// Door closes
			door.icon_state = "nt_pod_glass"
			flick("nt_pod_closing", door) // 9ds
			sleep(9)
			// Fluid fills
			fluid.icon_state = "nt_pod_liquid"
			flick("nt_pod_filling", fluid) // 8ds

		if("panel_open")
			cut_overlay("nt_pod_panel")
			add_overlay("nt_pod_panel")
		if("panel_closed")
			cut_overlay("nt_pod_panel")

/**
 * Possible 'state' options for change_state(state) are:
 */