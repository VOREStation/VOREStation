/obj/item/rig_module/mounted

	name = "mounted laser cannon"
	desc = "A shoulder-mounted battery-powered laser cannon mount."
	selectable = 1
	usable = 1
	module_cooldown = 0
	icon_state = "lcannon"

	engage_string = "Configure"

	interface_name = "mounted laser cannon"
	interface_desc = "A shoulder-mounted cell-powered laser cannon."

	var/gun_type = /obj/item/weapon/gun/energy/lasercannon/mounted
	var/obj/item/weapon/gun/gun

/obj/item/rig_module/mounted/Initialize()
	. = ..()
	gun = new gun_type(src)

/obj/item/rig_module/mounted/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		gun.attack_self(holder.wearer)
		return

	gun.Fire(target,holder.wearer)
	return 1

/obj/item/rig_module/mounted/egun

	name = "mounted energy gun"
	desc = "A forearm-mounted energy projector."
	icon_state = "egun"

	interface_name = "mounted energy gun"
	interface_desc = "A forearm-mounted suit-powered energy gun."

	gun_type = /obj/item/weapon/gun/energy/gun/mounted

/obj/item/rig_module/mounted/taser

	name = "mounted taser"
	desc = "A palm-mounted nonlethal energy projector."
	icon_state = "taser"

	usable = 0

	suit_overlay_active = "mounted-taser"
	suit_overlay_inactive = "mounted-taser"

	interface_name = "mounted taser"
	interface_desc = "A shoulder-mounted cell-powered taser."

	gun_type = /obj/item/weapon/gun/energy/taser/mounted

/obj/item/rig_module/mounted/energy_blade

	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0

	gun_type = /obj/item/weapon/gun/energy/crossbow/ninja

/obj/item/rig_module/mounted/energy_blade/process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/weapon/melee/energy/blade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/energy_blade/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return

	var/obj/item/weapon/melee/energy/blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/mounted/energy_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/weapon/melee/energy/blade/blade in M.contents)
		M.drop_from_inventory(blade)
		qdel(blade)

/obj/item/rig_module/mounted/mop

	name = "mop projector"
	desc = "A powerful mop projector."
	icon_state = "mop"

	activate_string = "Project Mop"
	deactivate_string = "Cancel Mop"

	interface_name = "mop projector"
	interface_desc = "A mop that can be deployed from the hand of the wearer."

	usable = 1
	selectable = 1
	toggleable = 1
	use_power_cost = 5
	active_power_cost = 0
	passive_power_cost = 0

	gun_type = /obj/item/weapon/gun/energy/temperature/mounted

/obj/item/rig_module/mounted/mop/process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/weapon/mop_deploy) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/mop/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return

	var/obj/item/weapon/mop_deploy/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/mounted/mop/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/weapon/mop_deploy/blade in M.contents)
		M.drop_from_inventory(blade)
		qdel(blade)
