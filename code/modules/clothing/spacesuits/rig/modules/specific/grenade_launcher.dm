/obj/item/rig_module/grenade_launcher

	name = "mounted grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser."
	selectable = 1
	icon_state = "grenadelauncher"

	interface_name = "integrated grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/grenade/flashbang,  3),
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/smokebomb,  3),
		list("EMP grenade", "EMP grenade", /obj/item/grenade/empgrenade, 3),
		)

/obj/item/rig_module/grenade_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(!istype(input_device) || !istype(user))
		return 0

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return 0

	if(accepted_item.charges >= 5)
		to_chat(user, "<span class='danger'>Another grenade of that type will not fit into the module.</span>")
		return 0

	to_chat(user, span_blue("<b>You slot \the [input_device] into the suit module.</b>"))
	user.drop_from_inventory(input_device)
	qdel(input_device)
	accepted_item.charges++
	return 1

/obj/item/rig_module/grenade_launcher/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a grenade type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient grenades!</span>")
		return 0

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message("<span class='danger'>[H] launches \a [new_grenade]!</span>")
	new_grenade.activate(H)
	new_grenade.throw_at(target,fire_force,fire_distance)

/obj/item/rig_module/grenade_launcher/smoke
	name = "mounted smoke-bomb launcher"
	desc = "A shoulder-mounted smoke-bomb dispenser."

	interface_name = "integrated smoke-bomb launcher"
	interface_desc = "Discharges loaded smoke-bombs against the wearer's location."

	fire_force = 15

	charges = list(
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/smokebomb,  6)
		)

/obj/item/rig_module/grenade_launcher/flash
	name = "mounted flashbang launcher"
	desc = "A shoulder-mounted flashbang dispenser."
	selectable = 1
	icon_state = "grenadelauncher"

	interface_name = "integrated flashbang launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/grenade/flashbang,  3)
		)
