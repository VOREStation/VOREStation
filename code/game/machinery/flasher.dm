// It is a gizmo that flashes a small area
/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	layer = ABOVE_WINDOW_LAYER
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = FALSE
	base_state = "pflash"
	density = TRUE

/obj/machinery/flasher/power_change()
	..()
	if(!(stat & NOPOWER))
		icon_state = "[base_state]1"
//		sd_SetLuminosity(2)
	else
		icon_state = "[base_state]1-p"
//		sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WIRECUTTER))
		add_fingerprint(user)
		disable = !disable
		if(disable)
			user.visible_message(span_warning("[user] has disconnected the [src]'s flashbulb!"), span_warning("You disconnect the [src]'s flashbulb!"))
		if(!disable)
			user.visible_message(span_warning("[user] has connected the [src]'s flashbulb!"), span_warning("You connect the [src]'s flashbulb!"))

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if(anchored)
		return flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if(!(powered()))
		return

	if((disable) || (last_flash && world.time < last_flash + 150))
		return

	playsound(src, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	last_flash = world.time
	use_power(1500)

	for (var/mob/O in viewers(src, null))
		if(get_dist(src, O) > range)
			continue

		var/flash_time = strength
		if(ishuman(O))
			var/mob/living/carbon/human/H = O
			if(H.nif && H.nif.flag_check(NIF_V_FLASHPROT,NIF_FLAGS_VISION))
				H.nif.notify("High intensity light detected, and blocked!",TRUE)
				continue
			if(FLASHPROOF in H.mutations)
				continue
			if(!H.eyecheck() <= 0)
				continue
			flash_time *= H.species.flash_mod
			var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
			if(!E)
				return
			if(E.is_bruised() && prob(E.damage + 50))
				H.flash_eyes()
				E.damage += rand(1, 5)
		else
			if(!O.blinded && isliving(O))
				var/mob/living/L = O
				L.flash_eyes()
		O.Weaken(flash_time)

/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(turf/T, datum/weakref/WF, oldloc)
	SIGNAL_HANDLER
	if(isnull(WF))
		return

	var/atom/movable/AM = WF.resolve()
	if(isnull(AM))
		log_debug("DEBUG: HasProximity called without reference on [src].")
		return
	if(disable || !anchored || (last_flash && world.time < last_flash + 150))
		return

	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if(M.m_intent != I_WALK)
			flash()

/obj/machinery/flasher/portable/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		add_fingerprint(user)
		anchored = !anchored

		if(!anchored)
			user.show_message(span_warning("[src] can now be moved."))
			cut_overlays()
			unsense_proximity(callback = /atom/proc/HasProximity)

		else if(anchored)
			user.show_message(span_warning("[src] is now secured."))
			add_overlay("[base_state]-s")
			sense_proximity(callback = /atom/proc/HasProximity)

/obj/machinery/button/flasher
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."

/obj/machinery/button/flasher/attack_hand(mob/user as mob)

	if(..())
		return

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/machinery/flasher/M in GLOB.machines)
		if(M.id == id)
			spawn()
				M.flash()

	sleep(50)

	icon_state = "launcherbtt"
	active = 0

	return
