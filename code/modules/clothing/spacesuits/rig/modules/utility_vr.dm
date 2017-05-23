/obj/item/rig_module/pat_module
	name = "\improper P.A.T. module"
	desc = "A \'Pre-emptive Access Tunneling\' module, for opening every door in a hurry."
	icon_state = "cloak"

	var/range = 3

	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 50
	active_power_cost = 25
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable P.A.T."
	deactivate_string = "Disable P.A.T."

	interface_name = "PAT system"
	interface_desc = "For use in emergencies only. Will notify command staff when activated."

/obj/item/rig_module/pat_module/activate()
	if(!..())
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
		if(!A) continue

		A.open()
