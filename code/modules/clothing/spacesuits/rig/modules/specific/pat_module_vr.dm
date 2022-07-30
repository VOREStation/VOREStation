/obj/item/rig_module/pat_module
	name = "\improper P.A.T. module"
	desc = "A \'Pre-emptive Access Tunneling\' module, for opening every door in a hurry."
	icon_state = "cloak"

	var/range = 3

	usable = 1
	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 100
	active_power_cost = 1
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable P.A.T."
	deactivate_string = "Disable P.A.T."
	engage_string = "Override Airlock"

	interface_name = "PAT system"
	interface_desc = "For opening doors ahead of you, in advance. Override notifies command staff."

/*
	var/message = "[H] has activated \a [src] in [get_area(T)] at position [T.x],[T.y],[T.z], giving them full access for medical rescue."
	var/obj/item/radio/headset/a = new /obj/item/radio/headset/heads/captain(null)
	a.icon = icon
	a.icon_state = icon_state
	a.autosay(message, "Security Subsystem", "Command")
	a.autosay(message, "Security Subsystem", "Security")
	qdel(a)
*/

/obj/item/rig_module/pat_module/activate()
	if(!..(TRUE)) //Skip the engage() call, that's for the override and is 'spensive.
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H,"<span class='notice'>You activate the P.A.T. module.</span>")
	GLOB.moved_event.register(H, src, /obj/item/rig_module/pat_module/proc/boop)

/obj/item/rig_module/pat_module/deactivate()
	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H,"<span class='notice'>Your disable the P.A.T. module.</span>")
	GLOB.moved_event.unregister(H, src)

/obj/item/rig_module/pat_module/proc/boop(var/mob/living/carbon/human/user,var/turf/To,var/turf/Tn)
	if(!istype(user) || !istype(To) || !istype(Tn))
		deactivate() //They were picked up or something, or put themselves in a locker, who knows. Just turn off.
		return

	var/direction = user.dir
	var/turf/current = Tn
	for(var/i = 0; i < range; i++)
		current = get_step(current,direction)
		if(!current) break

		var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in current
		if(!A || !A.density) continue

		if(A.allowed(user) && A.operable())
			A.open()

/obj/item/rig_module/pat_module/engage()
	var/mob/living/carbon/human/H = holder.wearer
	if(!istype(H))
		return 0

	var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in get_step(H,H.dir)

	//Okay, we either found an airlock or we're about to give up.
	if(!A || !A.density || !A.can_open() || !..())
		to_chat(H,"<span class='warning'>Unable to comply! Energy too low, or not facing a working airlock!</span>")
		return 0

	H.visible_message("<span class='warning'>[H] begins overriding the airlock!</span>","<span class='notice'>You begin overriding the airlock!</span>")
	if(do_after(H,6 SECONDS,A) && A.density)
		A.open()

	var/username = FindNameFromID(H) || "Unknown"
	var/message = "[username] has overridden [A] (airlock) in \the [get_area(A)] at [A.x],[A.y],[A.z] with \the [src]."
	global_announcer.autosay(message, "Security Subsystem", "Command")
	global_announcer.autosay(message, "Security Subsystem", "Security")
	return 1
