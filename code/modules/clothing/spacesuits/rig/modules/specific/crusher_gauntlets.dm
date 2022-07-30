/obj/item/rig_module/gauntlets

	name = "proto-kinetic gear unit"
	desc = "A set of paired proto-kinetic gauntlets and greaves. There's no way this is actually usable. Right?"
	icon_state = "module"

	interface_name = "proto-kinetic gear unit"
	interface_desc = "A set of paired proto-kinetic gauntlets and greaves. For disrupting rocks and creatures' innards."

	activate_string = "Deploy Gauntlets"
	deactivate_string = "Undeploy Gauntlets"

	usable = 0
	toggleable = 1
	use_power_cost = 0
	active_power_cost = 0
	passive_power_cost = 0
	var/obj/item/kinetic_crusher/machete/gauntlets/rig/stored_gauntlets

/obj/item/rig_module/gauntlets/Initialize()
	. = ..()
	stored_gauntlets = new /obj/item/kinetic_crusher/machete/gauntlets/rig(src)
	stored_gauntlets.storing_module = src

/obj/item/rig_module/gauntlets/activate()
	..()
	var/mob/living/M = holder.wearer
	var/datum/gender/TU = gender_datums[M.get_visible_gender()]

	if(M.l_hand && M.r_hand)
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return
	if(M.a_intent == I_HURT)
		M.visible_message(
			"<span class='danger'>[M] throws [TU.his] arms out, extending [stored_gauntlets] from \the [holder] with a click!</span>",
			"<span class='danger'>You throw your arms out, extending [stored_gauntlets] from \the [holder] with a click!</span>",
			"<span class='notice'>You hear a threatening hiss and a click.</span>"
			)
	else
		M.visible_message(
			"<span class='notice'>[M] extends [stored_gauntlets] from \the [holder] with a click!</span>",
			"<span class='notice'>You extend  [stored_gauntlets] from \the [holder] with a click!</span>",
			"<span class='notice'>You hear a hiss and a click.</span>")

	playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)
	M.put_in_hands(stored_gauntlets)

/obj/item/rig_module/gauntlets/deactivate()
	..()
	var/mob/living/M = holder.wearer
	if(!M)
		return
	for(var/obj/item/kinetic_crusher/machete/gauntlets/gaming in M.contents)
		M.drop_from_inventory(gaming, src)
