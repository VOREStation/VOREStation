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
	var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset/heads/captain(null)
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
	moved_event.register(H, src, /obj/item/rig_module/pat_module/proc/boop)

/obj/item/rig_module/pat_module/deactivate()
	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H,"<span class='notice'>Your disable the P.A.T. module.</span>")
	moved_event.unregister(H, src)

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
	var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset/heads/captain(null)
	a.icon = icon
	a.icon_state = icon_state
	a.autosay(message, "Security Subsystem", "Command")
	a.autosay(message, "Security Subsystem", "Security")
	qdel(a)
	return 1

/obj/item/rig_module/rescue_pharm
	name = "micro-pharmacy"
	desc = "A small chemical dispenser with integrated micro cartridges."
	usable = 0
	selectable = 1
	disruptive = 1
	toggleable = 1

	use_power_cost = 0
	active_power_cost = 5

	activate_string = "Enable Regen"
	deactivate_string = "Disable Regen"

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

	var/max_reagent_volume = 10 //Regen to this volume
	var/chems_to_use = 5 //Per injection

	charges = list(
		list("inaprovaline",  "inaprovaline",  0, 10),
		list("tricordrazine", "tricordrazine", 0, 10),
		list("tramadol",      "tramadol",      0, 10),
		list("dexalin plus",  "dexalinp",      0, 10)
		)

/obj/item/rig_module/rescue_pharm/process()
	. = ..()
	if(active)
		var/did_work = 0

		for(var/charge in charges)
			var/datum/rig_charge/C = charges[charge]

			//Found one that isn't full
			if(C.charges < max_reagent_volume)
				did_work = 1
				C.charges += 1
				break

		if (!did_work)
			deactivate() //All done

/obj/item/rig_module/rescue_pharm/engage(atom/target)
	if(!target)
		return 1 //You're just toggling the module on, not clicking someone.

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H,"<span class='danger'>You have not selected a chemical type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H,"<span class='danger'>Insufficient chems!</span>")
		return 0

	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(istype(target,/mob/living/carbon))
		target_mob = target
	else
		return 0

	to_chat(H,"<span class='notice'>You inject [target_mob == H ? "yourself" : target_mob] with [chems_to_use] unit\s of [charge.short_name].</span>")
	to_chat(target_mob,"<span class='notice'>You feel a rushing in your veins as you're injected by \the [src].</span>")
	target_mob.reagents.add_reagent(charge.display_name, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return 1
