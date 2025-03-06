/obj/structure/prop/machine
	name = "doodad"
	desc = "Some kind of machine."
	icon = 'icons/obj/props/decor.dmi'

//Eris Bluespace Beacon

/obj/structure/prop/machine/bsb_off
	name = "beacon"
	icon_state = "bsb_off"

/obj/structure/prop/machine/bsb_on
	name = "beacon"
	icon_state = "bsb_on"

/obj/structure/prop/machine/biosyphon
	icon_state = "biosyphon"

/obj/structure/prop/machine/von_krabin
	icon_state = "von_krabin"

/obj/structure/prop/machine/last_shelter
	icon_state = "last_shelter"

/obj/structure/prop/machine/complicator
	icon_state = "complicator"

/obj/structure/prop/machine/random_radio
	name = "radio"
	icon_state = "random_radio"

// vatgrowing thing from /tg/
/obj/structure/prop/machine/green_egg
	icon_state = "gel_cocoon"

// gravity generator from Eris
/obj/structure/prop/machine/gravygen
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "bigdice"
	bound_width = 64
	bound_height = 64

// dna vault from /tg/
/obj/structure/prop/dna_vault
	icon = 'icons/obj/props/decor96x96.dmi'
	icon_state = "vault"

/**
 * Possible 'state' options for change_state(state) are:
 * panel_open: The panel is opened
 * panel_closed: The panel is closed
 */
// neotheology cloning biocan from Eris
/obj/structure/prop/machine/nt_biocan
	icon = 'icons/obj/props/decor.dmi'
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
	icon = 'icons/obj/props/decor.dmi'
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
/obj/structure/prop/machine/solifier
	icon_state = "nt_solidifier"

/obj/structure/prop/machine/solifier/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "nt_solidifier"
		if("on")
			icon_state = "nt_solidifier_on"

/obj/structure/prop/machine/solifier/starts_on
	icon_state = "nt_solidifier_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Boring, round
 * on: Spinny glowy
 */
// conduit of soul from Eris
/obj/structure/prop/machine/conduit
	icon_state = "conduit_off"

/obj/structure/prop/machine/conduit/change_state(state)
	. = ..()
	switch(state)
		if("on")
			icon_state = "conduit_spin"
			flick("conduit_starting", src)
		if("off")
			icon_state = "conduit_off"
			flick("conduit_stopping", src)

/obj/structure/prop/machine/conduit/starts_on
	icon_state = "conduit_spin"

/**
 * Possible 'state' options for change_state(state) are:
 * on: Doing some kinda worky thing
 * off: Not doing much of anything
 * empty: No blue crystal thingy
 * loaded: off but without the animation
 */
// some kinda NT thing from Eris
/obj/structure/prop/machine/core
	icon_state = "core_inactive"

/obj/structure/prop/machine/core/change_state(state)
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

/obj/structure/prop/machine/core/starts_on
	icon_state = "core_active"

/**
 * Possible 'state' options for change_state(state) are:
 * down: In the ground, glowing
 * up: Out of the ground, open
 */
// experimental science destructor from /tg/
/obj/structure/prop/machine/tube
	icon = 'icons/obj/props/decor32x64.dmi'
	icon_state = "tube_open"

/obj/structure/prop/machine/tube/change_state(state)
	. = ..()
	switch(state)
		if("down")
			icon_state = "tube_on"
			flick("tube_down", src)
		if("up")
			icon_state = "tube_open"
			flick("tube_up", src)

/obj/structure/prop/machine/tube/starts_down
	icon_state = "tube_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Boring, static
 * on: Turny and blinky
 */
// experimental science destructor from /tg/
/obj/structure/prop/machine/comm_tower
	icon = 'icons/obj/props/decor.dmi'
	icon = 'icons/obj/props/decor96x96.dmi'
	icon_state = "comm_tower"

/obj/structure/prop/machine/comm_tower/change_state(state)
	. = ..()
	switch(state)
		if("on")
			icon_state = "comm_tower_on"
		if("off")
			icon_state = "comm_tower"

/obj/structure/prop/machine/comm_tower/starts_on
	icon_state = "comm_tower_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Not doing much
 * on: Stamping mysterious substances
 */
// sheetizer from /tg/
/obj/structure/prop/machine/stamper
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "stamper"

/obj/structure/prop/machine/stamper/change_state(state)
	. = ..()
	switch(state)
		if("off")
			cut_overlays()
		if("on")
			add_overlay("stamper_proc")
			add_overlay("stamper_but")

/obj/structure/prop/machine/stamper/starts_on
	icon_state = "stamper_on"

/obj/structure/prop/machine/stamper/starts_on/Initialize()
	. = ..()
	add_overlay("stamper_proc")
	add_overlay("stamper_but")


/**
 * Possible 'state' options for change_state(state) are:
 * whole: Not doing much
 * broken: Stamping mysterious substances
 */
// alien autopsy thing from TGMC
/obj/structure/prop/machine/alien_tank
	icon_state = "tank_larva"

/obj/structure/prop/machine/alien_tank/change_state(state)
	. = ..()
	switch(state)
		if("whole")
			icon_state = "tank_larva"
		if("broken")
			icon_state = "tank_broken"

/obj/structure/prop/machine/alien_tank/starts_broken
	icon_state = "tank_broken"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: The default look
 * active: Glowy lights underneath
 * panel_open: Opened panel (wiring)
 * panel_closed: Closed panel
 */
// neotheology optable from Eris
/obj/structure/prop/machine/nt_optable
	icon_state = "nt_optable-idle"

/obj/structure/prop/machine/nt_optable/change_state(state)
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
/obj/structure/prop/machine/tradebeacon
	icon_state = "tradebeacon"

/obj/structure/prop/machine/tradebeacon/change_state(state)
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

/obj/structure/prop/machine/tradebeacon/starts_active
	icon_state = "tradebeacon_active"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: The default look
 * active: Glowy lights in the center
 * panel_open: Opened panel (wiring)
 * panel_closed: Closed panel
 */
// another trade beacon from Eris
/obj/structure/prop/machine/tradebeacon2
	icon_state = "tradebeacon"

/obj/structure/prop/machine/tradebeacon2/change_state(state)
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

/obj/structure/prop/machine/tradebeacon2/starts_active
	icon_state = "tradebeacon_sending_active"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Non-spinny
 * on: Spinny and floaty
 */
// neotheology decorative(?) obelisk from Eris
/obj/structure/prop/machine/nt_obelisk
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "nt_obelisk"

/obj/structure/prop/machine/nt_obelisk/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "nt_obelisk"
		if("on")
			icon_state = "nt_obelisk_on"

/obj/structure/prop/machine/nt_obelisk/starts_on
	icon_state = "nt_obelisk_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Inert
 * on: Hand destroying machinery
 */
// 'sorter' from Eris
/obj/structure/prop/machine/sorter
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "sorter"

/obj/structure/prop/machine/sorter/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "sorter"
		if("on")
			icon_state = "sorter-process"

/obj/structure/prop/machine/sorter/starts_on
	icon_state = "sorter-process"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Inert
 * on: Hand destroying machinery
 */
// 'smelter' from Eris
/obj/structure/prop/machine/smelter
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "smelter"

/obj/structure/prop/machine/smelter/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "smelter"
		if("on")
			icon_state = "smelter-process"

/obj/structure/prop/machine/smelter/starts_on
	icon_state = "smelter-process"

/**
 * Possible 'state' options for change_state(state) are:
 * idle: Not doing anything, with yellow template exposed
 * work: busy doing work
 * pause: paused work
 */
// cruciform forge from Eris
/obj/structure/prop/machine/nt_cruciforge
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "nt_cruciforge"

/obj/structure/prop/machine/nt_cruciforge/change_state(state)
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

/obj/structure/prop/machine/nt_cruciforge/starts_working
	icon_state = "nt_cruciforge_work"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Default, boring
 * on: Showing a display/powered up
 */
// A console from TGMC
/obj/structure/prop/machine/tgmc_console1
	name = "console"
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "tgmc_console1"

/obj/structure/prop/machine/tgmc_console1/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "tgmc_console1"
		if("on")
			icon_state = "tgmc_console1_on"

/obj/structure/prop/machine/tgmc_console1/starts_on
	icon_state = "tgmc_console1_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Default, boring
 * on: Showing a display/powered up
 */
// A console from TGMC
/obj/structure/prop/machine/tgmc_console2
	name = "console"
	icon_state = "tgmc_console2"

/obj/structure/prop/machine/tgmc_console2/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "tgmc_console2"
		if("on")
			icon_state = "tgmc_console2_on"

/obj/structure/prop/machine/tgmc_console2/starts_on
	icon_state = "tgmc_console2_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Default, boring
 * on: Showing a display/powered up
 */
// A console from TGMC
/obj/structure/prop/machine/tgmc_console3
	name = "console"
	icon_state = "tgmc_console3"

/obj/structure/prop/machine/tgmc_console3/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "tgmc_console3"
		if("on")
			icon_state = "tgmc_console3_on"

/obj/structure/prop/machine/tgmc_console3/starts_on
	icon_state = "tgmc_console3_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Default, boring
 * on: Showing a display/powered up
 */
// A console from TGMC
/obj/structure/prop/machine/tgmc_console4
	name = "console"
	icon_state = "tgmc_console4"

/obj/structure/prop/machine/tgmc_console4/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "tgmc_console4"
		if("on")
			icon_state = "tgmc_console4_on"

/obj/structure/prop/machine/tgmc_console4/starts_on
	icon_state = "tgmc_console4_on"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Default, boring
 * on: Showing a display/powered up
 */
// A console from TGMC
/obj/structure/prop/machine/tgmc_console5
	name = "console"
	icon_state = "tgmc_console5"

/obj/structure/prop/machine/tgmc_console5/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "tgmc_console5"
		if("on")
			icon_state = "tgmc_console5_on"

/obj/structure/prop/machine/tgmc_console5/starts_on
	icon_state = "tgmc_console5_on"

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
/obj/structure/prop/machine/nt_pod
	icon = 'icons/obj/props/decor.dmi'
	icon = 'icons/obj/props/decor32x64.dmi'
	icon_state = "nt_pod_mappreview"
	bound_height = 64

	var/obj/effect/overlay/vis/outside
	var/obj/effect/overlay/vis/door
	var/obj/effect/overlay/vis/fluid

	var/contents_vis_flags = NONE
	var/contents_original_pixel_y = 0
	var/changing_state = FALSE

/obj/structure/prop/machine/nt_pod/Initialize(mapload)
	. = ..()
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

/obj/structure/prop/machine/nt_pod/Entered(atom/movable/mover)
	abduct(mover)

/obj/structure/prop/machine/nt_pod/proc/abduct(var/atom/movable/AM)
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

/obj/structure/prop/machine/nt_pod/proc/unduct(var/atom/movable/AM)
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

/obj/structure/prop/machine/nt_pod/MouseDrop_T(var/atom/movable/AM, var/mob/user)
	if(contents.len)
		return
	if(!ismovable(AM))
		return
	if(!user.client?.holder)
		return
	if(changing_state)
		return

	AM.forceMove(src)

/obj/structure/prop/machine/nt_pod/change_state(state)
	. = ..()
	if(changing_state)
		return
	switch(state)
		if("open")
			changing_state = TRUE
			cut_overlay("nt_pod_top_on")
			cut_overlay("nt_pod_under")

			// Fluid drains
			fluid.icon_state = "nothing"
			flick("nt_pod_emptying", fluid) // 8ds

			// Door opens
			addtimer(CALLBACK(src, PROC_REF(delayed_flick), door, "nothing", "nt_pod_opening", 0.9 SECONDS), 0.8 SECONDS) // 9ds

		if("closed")
			changing_state = TRUE
			outside.layer = ABOVE_MOB_LAYER
			cut_overlay("nt_pod_top_on")
			add_overlay("nt_pod_top_on")
			add_overlay("nt_pod_under")

			// Door closes
			door.icon_state = "nt_pod_glass"
			flick("nt_pod_closing", door) // 9ds
			// Fluid fills
			addtimer(CALLBACK(src, PROC_REF(delayed_flick), fluid, "nt_pod_liquid", "nt_pod_filling"), 0.9 SECONDS) // 8ds

		if("panel_open")
			cut_overlay("nt_pod_panel")
			add_overlay("nt_pod_panel")
		if("panel_closed")
			cut_overlay("nt_pod_panel")

// Old Virology stuff

/obj/structure/prop/machine/nt_pod/proc/delayed_flick(var/obj/effect/overlay/ovrl, var/icon_state, var/flicked, var/get_out_time)
	ovrl.icon_state = icon_state
	flick(flicked, ovrl)
	// GET OUT
	if(get_out_time)
		addtimer(CALLBACK(src, PROC_REF(get_out)), get_out_time)
		return
	changing_state = FALSE

/obj/structure/prop/machine/nt_pod/proc/get_out()
	outside.layer = BELOW_MOB_LAYER
	if(contents.len)
		for(var/atom/movable/AM as anything in contents)
			unduct(AM)
	changing_state = FALSE

/obj/structure/prop/machine/centrifuge
	name = "centrifuge"
	desc = "Used to separate things with different weight. Spin 'em round, round, right round."
	icon = 'icons/obj/virology_vr.dmi'
	icon_state = "centrifuge"
	var/on = FALSE

/obj/structure/prop/machine/centrifuge/attack_hand(mob/user as mob)
	..()

	if(!on)
		on = TRUE
		user.visible_message("\The [user] turns on \the [src].")
		icon_state = "centrifuge_moving"
	else
		on = FALSE
		user.visible_message("\The [user] turns off \the [src].")
		icon_state = "centrifuge"

	update_icon()

/obj/structure/prop/machine/incubator
	name = "incubator"
	desc = "Encourages the growth of diseases. This model comes with a dispenser system and a small radiation generator."
	icon = 'icons/obj/virology_vr.dmi'
	icon_state = "incubator"
	var/on = FALSE

/obj/structure/prop/machine/incubator/attack_hand(mob/user as mob)
	..()

	if(!on)
		on = TRUE
		user.visible_message("\The [user] turns on \the [src].")
		icon_state = "incubator_on"
	else
		on = FALSE
		user.visible_message("\The [user] turns off \the [src].")
		icon_state = "incubator"

	update_icon()

/obj/structure/prop/machine/disease_analyser
	name = "disease analyser"
	desc = "Analyzes diseases to find out information about them!"
	icon = 'icons/obj/virology_vr.dmi'
	icon_state = "analyser"
	var/on = FALSE

/obj/structure/prop/machine/disease_analyser/attack_hand(mob/user as mob)
	..()

	if(!on)
		on = TRUE
		user.visible_message("\The [user] turns on \the [src].")
		icon_state = "analyser_"
	else
		on = FALSE
		user.visible_message("\The [user] turns off \the [src].")
		icon_state = "analyser"

	update_icon()

/obj/structure/prop/machine/isolator
	name = "disease isolator"
	desc = "Used to isolate and identify diseases, allowing for comparison with a remote database."
	icon = 'icons/obj/virology_vr.dmi'
	icon_state = "isolator_in"
	var/on = FALSE

/obj/structure/prop/machine/isolator/attack_hand(mob/user as mob)
	..()

	if(!on)
		on = TRUE
		user.visible_message("\The [user] turns on \the [src].")
		icon_state = "isolator_"
	else
		on = FALSE
		user.visible_message("\The [user] turns off \the [src].")
		icon_state = "isolator_in"

	update_icon()
