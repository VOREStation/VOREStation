/obj/item/weapon/robot_module/robot/platform

	hide_on_manifest = TRUE

	var/pupil_color =     COLOR_CYAN
	var/base_color =      COLOR_WHITE
	var/eye_color =       COLOR_BEIGE
	var/armor_color =    "#68a2f2"
	var/user_icon =       'icons/mob/robots_thinktank.dmi'
	var/user_icon_state = "tachi"

	var/list/decals
	var/list/available_decals = list(
		"Stripe" = "stripe",
		"Vertical Stripe" = "stripe_vertical"
	)

// Only show on manifest if they have a player.
/obj/item/weapon/robot_module/robot/platform/hide_on_manifest()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		return !R.key
	return ..()

/obj/item/weapon/robot_module/robot/platform/verb/set_eye_colour()
	set name = "Set Eye Colour"
	set desc = "Select an eye colour to use."
	set category = "Robot Commands"
	set src in usr

	var/new_pupil_color = input(usr, "Select a pupil colour.", "Pupil Colour Selection") as color|null
	if(usr.incapacitated() || QDELETED(usr) || QDELETED(src) || loc != usr)
		return

	pupil_color = new_pupil_color || initial(pupil_color)
	usr.update_icon()

/obj/item/weapon/robot_module/robot/platform/explorer
	armor_color = "#528052"
	eye_color =   "#7b7b46"
	decals = list(
		"stripe_vertical" = "#52b8b8",
		"stripe" =          "#52b8b8"
	)
	channels = list(
		"Science" = 1,
		"Away Team" = 1
	)

/obj/item/weapon/robot_module/robot/platform/explorer/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	modules += new /obj/item/weapon/pickaxe/plasmacutter(src)
	modules += new /obj/item/weapon/material/knife/machete/cyborg(src)

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(7500)
	var/obj/item/stack/medical/bruise_pack/bandaid = new(src)
	bandaid.uses_charge = 1
	bandaid.charge_costs = list(1000)
	bandaid.synths = list(medicine)
	modules += bandaid
	synths += medicine

	var/obj/item/weapon/gun/energy/phasegun/mounted/cyborg/phasegun = new(src)
	modules += phasegun

	emag += new /obj/item/weapon/chainsaw(src)

/obj/item/weapon/robot_module/robot/platform/explorer/respawn_consumable(var/mob/living/silicon/robot/R, rate)
	. = ..()
	for(var/obj/item/weapon/gun/energy/pew in modules)
		if(pew.power_supply && pew.power_supply.charge < pew.power_supply.maxcharge)
			pew.power_supply.give(pew.charge_cost * rate)
			pew.update_icon()
		else
			pew.charge_tick = 0

/obj/item/weapon/robot_module/robot/platform/cargo
	armor_color = "#d5b222"
	eye_color =   "#686846"
	decals = list(
		"stripe_vertical" = "#bfbfa1",
		"stripe" =          "#bfbfa1"
	)
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)

/obj/item/weapon/robot_module/robot/platform/cargo/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	modules += new /obj/item/weapon/packageWrap(src)
	modules += new /obj/item/weapon/pen/multi(src)
	modules += new /obj/item/device/destTagger(src)
	emag += new /obj/item/weapon/stamp/denied

/obj/item/weapon/robot_module/robot/platform/cargo/respawn_consumable(mob/living/silicon/robot/R, rate)
	. = ..()
	var/obj/item/weapon/packageWrap/wrapper = locate() in modules
	if(wrapper.amount < initial(wrapper.amount))
		wrapper.amount++
