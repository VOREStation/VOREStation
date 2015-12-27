/obj/item/weapon/rig/light/technomancer
	name = "technomancer control module"
	suit_type = "technomancer"
	desc = "An advanced powered armour suit with technology that allows the user to manipulate space around them."
	icon_state = "hacker_rig"

	req_access = list(access_syndicate)

	airtight = 0
	seal_delay = 5 //not being vaccum-proof has an upside I guess

	helm_type = /obj/item/clothing/head/lightrig/technomancer
	chest_type = /obj/item/clothing/suit/lightrig/technomancer
	glove_type = /obj/item/clothing/gloves/lightrig/technomancer
	boot_type = /obj/item/clothing/shoes/lightrig/technomancer

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/technomancer_core,
		/obj/item/rig_module/energy_relay,
		/obj/item/rig_module/self_destruct
		)

//The technomancer suit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/lightrig/technomancer
	name = "HUD"
	siemens_coefficient = 0.4
	flags = 0

/obj/item/clothing/suit/lightrig/technomancer
	siemens_coefficient = 0.4

/obj/item/clothing/shoes/lightrig/technomancer
	siemens_coefficient = 0.4
	flags = NOSLIP //All the other rigs have magboots anyways, hopefully gives the technomancer suit something more going for it.

/obj/item/clothing/gloves/lightrig/technomancer
	siemens_coefficient = 0

//This is required for spells (aka Functions) to, well, function.
/obj/item/rig_module/technomancer_core

	name = "manipulation core"
	desc = "A bewilderingly complex 'black box' that allows the wearer of the RIG to accomplish amazing feats."
	icon_state = "enet"

	interface_name = "manipulation core"
	interface_desc = "A black box device that allows the user to use functions to alter the enviroment significantly."
	permanent = 1

//Supplies power to the technomage's rig, similar to the mech relay, just less shitty.
/obj/item/rig_module/energy_relay

	name = "hardsuit power relay"
	desc = "A very advanced device that allows the user to effortlessly drain power wirelessly."
	icon_state = "powersink"
	toggleable = 1
	disruptive = 0
	active = 1

	activate_string = "Enable Power Relay"
	deactivate_string = "Disable Power Relay"

	interface_name = "tesla energy relay"
	interface_desc = "This advanced module drains power wirelessly from dedicated power storage units straight into the suit's internal battery."

/obj/item/rig_module/energy_relay/deactivate()
	if(holder && holder.wearer)
		holder.wearer << "<span class = 'warning'>Your power relay deactivates.</span>"
	active = 0
	return ..()

/obj/item/rig_module/power_sink/activate()
	if(holder && holder.wearer)
		holder.wearer << "<span class = 'warning'>Your power relay activates.</span>"
	active = 1
	return ..()

//This is a lot of copypasta from the powersink, I'm sorry.
/obj/item/rig_module/energy_relay/process()
	if(!holder)
		return 0
	if(!active)
		return 0
	var/area/my_area = get_area(holder)

	var/mob/living/carbon/human/H
	if(holder && holder.wearer)
		H = holder.wearer

	if(!H || !istype(H))
		return 0

	if(!holder.cell)
		H << "<span class = 'danger'>Your power relay flashes an error; there is no cell in your rig.</span>"
		deactivate()
		return

	if(!my_area.apc)
		return

	if(holder.cell.fully_charged())
		return

	// Attempts to drain up to 40kW, determines this value from remaining cell capacity to ensure we don't drain too much..
	var/to_drain = min(40000, ((holder.cell.maxcharge - holder.cell.charge) / CELLRATE))
	var/target_drained = my_area.apc.drain_power(0,0,to_drain)
	if(target_drained <= 0)
		H << "<span class = 'danger'>Your power relay flashes a red light; there is no power left in \the [my_area.apc].</span>"
		return

	holder.cell.give(max(target_drained * CELLRATE), 0)

	return 1

